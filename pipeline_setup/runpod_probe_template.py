#!/usr/bin/env python3
"""
RunPod template probe — figure out what's actually inside the ComfyUI template
before we commit to the 12-tile batch.

Boots one pod on the cheapest fallback GPU, waits for ComfyUI, then asks:
  - which checkpoints / loras / vaes are preinstalled?
  - is ComfyUI-Manager available? (i.e. can we self-install models?)
  - what custom nodes ship?
Then terminates the pod and prints findings.

Reuses gql / pod-lifecycle helpers from runpod_showcase_batch.py so the
Cloudflare User-Agent fix and the existing GraphQL plumbing apply automatically.

Cost: ~3-5 min on RTX A4000 community @ ~$0.17/hr ≈ £0.01-0.02.
"""
import json
import sys
import time
from pathlib import Path

# Import shared helpers from the batch script (same dir).
sys.path.insert(0, str(Path(__file__).resolve().parent))
import runpod_showcase_batch as rsb  # noqa: E402
from runpod_showcase_batch import (  # noqa: E402
    KEY_PATH,
    deploy_with_fallback,
    wait_for_running,
    wait_for_comfyui,
    comfyui_proxy_url,
    http_request,
    terminate_pod,
    log,
)

# Probe only needs ComfyUI to boot — no model loading — so widen the GPU
# fallback list to whatever has community capacity right now. Doesn't touch
# the batch script's own defaults (we're monkey-patching the imported module).
rsb.GPU_TYPE_ID = "NVIDIA GeForce RTX 4090"
rsb.GPU_FALLBACKS = [
    "NVIDIA GeForce RTX 3090",
    "NVIDIA RTX A5000",
    "NVIDIA RTX A4000",
    "NVIDIA L4",
    "NVIDIA A30",
    "NVIDIA A40",
    "NVIDIA L40",
    "NVIDIA L40S",
    "NVIDIA RTX 6000 Ada Generation",
    "NVIDIA RTX A4500",
    "NVIDIA RTX A6000",
]

import urllib.error  # noqa: E402


def safe_get(pod_id, path, timeout=15):
    """GET against the pod's ComfyUI proxy. Returns (status, body|None, err|None)."""
    url = comfyui_proxy_url(pod_id) + path
    try:
        status, body = http_request(url, timeout=timeout)
        return status, body, None
    except urllib.error.HTTPError as e:
        # Capture error body too — that's where Manager often tells us what
        # field it actually wanted.
        try:
            body = e.read()
        except Exception:
            body = None
        return e.code, body, f"HTTP {e.code} {e.reason}"
    except Exception as e:
        return None, None, f"{type(e).__name__}: {e}"


def safe_request(pod_id, path, method="GET", data=None, timeout=15):
    """Generic request helper — captures both success body and error body so
    we can read 4xx/5xx hints (e.g. 'missing field foo')."""
    url = comfyui_proxy_url(pod_id) + path
    try:
        status, body = http_request(url, method=method, data=data, timeout=timeout)
        return status, body, None
    except urllib.error.HTTPError as e:
        try:
            body = e.read()
        except Exception:
            body = None
        return e.code, body, f"HTTP {e.code} {e.reason}"
    except Exception as e:
        return None, None, f"{type(e).__name__}: {e}"


def list_models_via_object_info(pod_id, node_class, input_name):
    """Read the dropdown options ComfyUI exposes for a loader node — that's
    the authoritative list of files in the corresponding models/<dir>."""
    status, body, err = safe_get(pod_id, f"/object_info/{node_class}")
    if err or status != 200 or not body:
        return None, err or f"status {status}"
    try:
        data = json.loads(body)
        opts = data[node_class]["input"]["required"][input_name][0]
        return opts, None
    except (KeyError, IndexError, TypeError) as e:
        return None, f"parse: {e}"


def probe_manager(pod_id):
    """Try a handful of ComfyUI-Manager endpoints. Any 200 means Manager is in."""
    candidates = [
        "/manager/version",
        "/customnode/getlist",
        "/manager/customnode/getlist",
        "/manager/queue/status",
    ]
    findings = []
    for p in candidates:
        status, body, err = safe_get(pod_id, p, timeout=10)
        snippet = ""
        if body:
            try:
                snippet = body.decode("utf-8", "replace")[:160].replace("\n", " ")
            except Exception:
                snippet = "<binary>"
        findings.append((p, status, err, snippet))
    return findings


def probe_manager_api_surface(pod_id):
    """Deep-scan likely Manager V3 endpoints. For each path:
      1. GET → captures existence (404 = doesn't exist; 405 = exists but wrong
         method; 400/500 = exists, needs payload; 200 = works)
      2. POST {} → captures the payload-shape hint from the error body
    Returns a list of dicts.
    """
    # Mix of historical V1/V2 paths and newer V3-style; the diff between 404
    # and 405/400 tells us which are live.
    candidates = [
        # status / control
        "/manager/queue/start",
        "/manager/queue/reset",
        # install — checkpoints / models
        "/manager/queue/install",
        "/manager/install/model",
        "/manager/install/customnode",
        "/model/install",
        "/customnode/install",
        # listings (model index — tells us valid model names)
        "/manager/model_list",
        "/manager/model/list",
        "/manager/customnode/list",
        "/manager/customnode/getmappings",
        "/manager/extension/list",
        "/manager/db_mode",
        "/model/getlist",
        "/externalmodel/getlist",
        "/snapshot/getlist",
        # parameterised model listing — what the UI uses to populate the
        # "Install Models" dialog
        "/manager/model_list?mode=remote",
        "/manager/model_list?mode=cache",
        "/externalmodel/getlist?mode=remote",
    ]
    findings = []
    for p in candidates:
        # GET
        get_status, get_body, get_err = safe_request(pod_id, p, method="GET", timeout=20)
        get_snippet = ""
        if get_body:
            try:
                get_snippet = get_body.decode("utf-8", "replace")[:240].replace("\n", " ")
            except Exception:
                get_snippet = "<binary>"

        # POST {} — only if GET didn't already return 200 with useful content
        # (avoids wasting time on obvious read-only endpoints)
        post_status = post_err = post_snippet = None
        if get_status in (400, 405, 500) or (get_status == 404 and "install" in p):
            # Path that looks alive (or install-shaped) — try POST to learn payload
            post_status, post_body, post_err_inner = safe_request(
                pod_id, p.split("?")[0], method="POST", data={}, timeout=20
            )
            post_err = post_err_inner
            if post_body:
                try:
                    post_snippet = post_body.decode("utf-8", "replace")[:240].replace("\n", " ")
                except Exception:
                    post_snippet = "<binary>"

        findings.append({
            "path": p,
            "get_status": get_status,
            "get_err": get_err,
            "get_snippet": get_snippet,
            "post_status": post_status,
            "post_err": post_err,
            "post_snippet": post_snippet,
        })
    return findings


def main():
    if not KEY_PATH.exists():
        sys.exit(f"FATAL: API key not found at {KEY_PATH}")
    api_key = KEY_PATH.read_text().strip()

    log("=== Template probe — start ===")
    pod_id = None
    try:
        pod_id = deploy_with_fallback(api_key)
        wait_for_running(api_key, pod_id)
        wait_for_comfyui(api_key, pod_id)

        log("")
        log("--- Preinstalled models ---")
        for cls, inp, label in [
            ("CheckpointLoaderSimple", "ckpt_name", "checkpoints"),
            ("LoraLoader",             "lora_name", "loras"),
            ("VAELoader",              "vae_name",  "vaes"),
            ("UpscaleModelLoader",     "model_name","upscalers"),
            ("CLIPVisionLoader",       "clip_name", "clip_vision"),
            ("ControlNetLoader",       "control_net_name", "controlnets"),
        ]:
            items, err = list_models_via_object_info(pod_id, cls, inp)
            if err:
                log(f"  {label:12s} ERROR: {err}")
            else:
                log(f"  {label:12s} ({len(items)}): {items[:8]}{' …' if len(items) > 8 else ''}")

        log("")
        log("--- ComfyUI-Manager probe ---")
        for path, status, err, snippet in probe_manager(pod_id):
            tag = "OK " if status == 200 else "no "
            log(f"  {tag} {path:38s} status={status} err={err or '-'}")
            if status == 200 and snippet:
                log(f"        body[:160]: {snippet}")

        log("")
        log("--- Manager API deep-scan (GET, then POST {} for likely install paths) ---")
        for f in probe_manager_api_surface(pod_id):
            log(f"  {f['path']}")
            log(f"    GET  status={f['get_status']}  err={f['get_err'] or '-'}")
            if f['get_snippet']:
                log(f"      body: {f['get_snippet']}")
            if f['post_status'] is not None:
                log(f"    POST status={f['post_status']}  err={f['post_err'] or '-'}")
                if f['post_snippet']:
                    log(f"      body: {f['post_snippet']}")

        log("")
        log("--- Catalogue scan: SDXL / Juggernaut entries from /externalmodel/getlist?mode=remote ---")
        status, body, err = safe_request(pod_id, "/externalmodel/getlist?mode=remote", method="GET", timeout=30)
        catalogue_entries = []
        if err or status != 200 or not body:
            log(f"  GET failed: status={status} err={err}")
        else:
            try:
                data = json.loads(body)
                all_models = data.get("models", [])
                log(f"  total catalogue size: {len(all_models)} models")
                needles = ["sd_xl_base", "sdxl", "juggernaut", "sd_xl"]
                for m in all_models:
                    blob = json.dumps(m).lower()
                    if any(n in blob for n in needles):
                        catalogue_entries.append(m)
                log(f"  matched entries: {len(catalogue_entries)}")
                for m in catalogue_entries[:6]:
                    log(f"    {json.dumps(m)}")
            except Exception as e:
                log(f"  parse failed: {e}")

        log("")
        log("--- Install POST trial: POST /manager/queue/install with candidate payloads ---")
        # Pick the smallest plausible entry to minimise download time if it
        # actually triggers a real install. Prefer sd_xl_base_1.0, else first match.
        trial_entry = None
        for m in catalogue_entries:
            if "sd_xl_base" in json.dumps(m).lower():
                trial_entry = m
                break
        if trial_entry is None and catalogue_entries:
            trial_entry = catalogue_entries[0]

        if trial_entry is None:
            log("  no catalogue entry to test with — skipping install POST")
        else:
            log(f"  trial entry: {json.dumps(trial_entry)[:280]}")
            for label, payload in [
                ("entry-as-body", trial_entry),
                ('{"item": entry}', {"item": trial_entry}),
                ('{"item": entry, "ui_id": "probe"}', {"item": trial_entry, "ui_id": "probe"}),
            ]:
                status, body, err = safe_request(
                    pod_id, "/manager/queue/install", method="POST", data=payload, timeout=20
                )
                snippet = ""
                if body:
                    try:
                        snippet = body.decode("utf-8", "replace")[:240].replace("\n", " ")
                    except Exception:
                        snippet = "<binary>"
                log(f"  payload={label}  status={status}  err={err or '-'}")
                if snippet:
                    log(f"    body: {snippet}")
                # If we got a 200, the install request was accepted — note the
                # queue status to confirm something actually queued, then bail
                # (we don't want to wait for a real download in a probe).
                if status in (200, 201, 202):
                    qs_status, qs_body, _ = safe_request(pod_id, "/manager/queue/status", method="GET", timeout=10)
                    if qs_body:
                        log(f"    queue/status after: {qs_body.decode('utf-8','replace')[:200]}")
                    break

        log("")
        log("--- Custom nodes (first 20 keys from /object_info) ---")
        status, body, err = safe_get(pod_id, "/object_info", timeout=30)
        if err or status != 200:
            log(f"  /object_info failed: {err or status}")
        else:
            try:
                data = json.loads(body)
                keys = sorted(data.keys())
                manager_like = [k for k in keys if "manager" in k.lower() or "download" in k.lower() or "huggingface" in k.lower() or "civitai" in k.lower()]
                log(f"  total node classes: {len(keys)}")
                log(f"  first 20: {keys[:20]}")
                log(f"  manager/download-ish nodes: {manager_like}")
            except Exception as e:
                log(f"  parse /object_info failed: {e}")

        log("")
        log("=== Probe complete ===")
    except Exception as e:
        log(f"!!! FATAL: {e}")
        raise
    finally:
        if pod_id:
            terminate_pod(api_key, pod_id)
        log("=== probe run end ===")


if __name__ == "__main__":
    main()
