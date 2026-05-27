#!/usr/bin/env python3
"""
runpod_probe_lora.py — feasibility probe for the Stage-A LoRA install.

Stage A (D-VALIDATE-1 anchor brief) needs ~9 Civitai-hosted LoRAs installed
on the ephemeral pod for every run. Civitai is NOT in ComfyUI-Manager's
catalogue, so we need to confirm a working install pathway BEFORE writing
the LoRA-stack workflow + paying for the real run.

Three questions answered cheaply (~£0.005, ~90s):

  Q1. Is Civitai's public API reachable from the pod, and does it return a
      direct .safetensors download URL for the first LoRA (ClassipeintXL,
      modelId 127139)?

  Q2. Does the Manager catalogue contain a LoRA-shaped whitelisted entry we
      can piggyback (save_path containing 'loras', filename .safetensors)?
      If so, what's its (save_path, base, filename) triple?

  Q3. Does `/manager/queue/install_model` accept a LoRA-piggyback payload
      (whitelisted triple + Civitai URL swapped in)? Status 200 + worker
      starts = green light. We DO NOT wait for the ~150MB download — kill
      the pod immediately.

If all three are green -> we can proceed to the real Stage-A build cheaply.
If any is red -> we surface the blocker before sinking time/spend.
"""
import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import runpod_showcase_batch as rsb  # noqa: E402
from runpod_showcase_batch import (  # noqa: E402
    KEY_PATH, deploy_with_fallback, wait_for_running, wait_for_comfyui,
    comfyui_proxy_url, http_request, terminate_pod, queue_status, log,
)
import urllib.error  # noqa: E402

# First LoRA from pipeline_spec.md §2.2 — Civitai modelId 127139.
CIVITAI_MODEL_ID = 127139
CIVITAI_LABEL = "ClassipeintXL v2.1"


def safe(pod_id, path, method="GET", data=None, t=20):
    url = comfyui_proxy_url(pod_id) + path
    try:
        s, b = http_request(url, method=method, data=data, timeout=t)
        return s, b, None
    except urllib.error.HTTPError as e:
        try:
            b = e.read()
        except Exception:
            b = None
        return e.code, b, f"HTTP {e.code} {e.reason}"
    except Exception as e:
        return None, None, f"{type(e).__name__}: {e}"


def fetch_external(url, timeout=20):
    """GET an arbitrary external URL FROM THE POD — using ComfyUI's host?
    No: we proxy via the pod's ComfyUI for ComfyUI APIs only. For pure
    reachability checks (Civitai API) we hit them from this machine first
    (here in Cowork). The pod's own internet access we verify indirectly by
    feeding the Civitai URL into Manager's install_model and watching it
    start the download (Q3)."""
    import urllib.request
    r = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    return urllib.request.urlopen(r, timeout=timeout)


def main():
    api_key = KEY_PATH.read_text().strip()
    log("=== LoRA-install feasibility probe — start ===")

    # ---------- Q1: Civitai API reachable from THIS machine? ----------
    log("")
    log("--- Q1. Civitai API: model 127139 (ClassipeintXL) download URL ---")
    civitai_dl_url = None
    civitai_filename = None
    try:
        with fetch_external(
                f"https://civitai.com/api/v1/models/{CIVITAI_MODEL_ID}") as r:
            data = json.loads(r.read())
        mv = (data.get("modelVersions") or [None])[0]
        if mv:
            f0 = (mv.get("files") or [None])[0]
            if f0:
                civitai_dl_url = f0.get("downloadUrl")
                civitai_filename = f0.get("name")
        log(f"  modelVersion id={mv.get('id') if mv else '?'} "
            f"file={civitai_filename}")
        log(f"  downloadUrl={civitai_dl_url}")
    except Exception as e:
        log(f"  Civitai API FAIL: {type(e).__name__}: {e}")

    # Probe whether the download URL is publicly fetchable (HEAD).
    if civitai_dl_url:
        try:
            import urllib.request
            req = urllib.request.Request(civitai_dl_url, method="HEAD",
                                         headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=20) as r:
                size = r.headers.get("Content-Length")
                ctype = r.headers.get("Content-Type")
                log(f"  HEAD -> {r.status} size={size} type={ctype}")
        except urllib.error.HTTPError as e:
            log(f"  HEAD -> HTTP {e.code} (may need login token)")
        except Exception as e:
            log(f"  HEAD -> {type(e).__name__}: {e}")

    # ---------- Deploy pod for Q2/Q3 ----------
    pod_id = None
    try:
        pod_id = deploy_with_fallback(api_key)
        wait_for_running(api_key, pod_id)
        wait_for_comfyui(api_key, pod_id)

        # ---------- Q2: a piggybackable LoRA slot in Manager catalogue ----
        log("")
        log("--- Q2. Manager catalogue: a whitelisted LoRA-shaped slot ---")
        s, b, err = safe(pod_id, "/externalmodel/getlist?mode=remote", t=30)
        triple = None
        if s == 200 and b:
            cat = json.loads(b).get("models", [])
            lora_entries = [m for m in cat
                            if (m.get("save_path") or "").lower().startswith("loras")
                            and (m.get("filename") or "").endswith(".safetensors")]
            log(f"  catalogue total: {len(cat)} | lora-shaped entries: "
                f"{len(lora_entries)}")
            # Pick the simplest plausible piggyback target.
            for m in lora_entries[:6]:
                log(f"    sample: base={m.get('base')!r:20s} "
                    f"save_path={m.get('save_path')!r:24s} "
                    f"file={m.get('filename')}")
            if lora_entries:
                triple = lora_entries[0]
        else:
            log(f"  catalogue fetch failed: {err or s}")

        # ---------- Q3: install_model piggyback test ----------
        log("")
        log("--- Q3. install_model piggyback for Civitai LoRA ---")
        if triple is None or not civitai_dl_url:
            log("  skipped — Q1 or Q2 did not produce a viable input")
        else:
            payload = {
                "name": f"{CIVITAI_LABEL} (piggyback test)",
                "type": "lora",
                "base": triple["base"],
                "save_path": triple["save_path"],
                "filename": triple["filename"],
                "url": civitai_dl_url,
                "ui_id": "lora-probe",
            }
            s, b, err = safe(pod_id, "/manager/queue/install_model",
                             method="POST", data=payload, t=30)
            body = (b.decode("utf-8", "replace")[:200] if b else "")
            log(f"  install_model POST -> status={s} err={err or '-'} "
                f"body={body!r}")
            if s == 200:
                s2, _, _ = safe(pod_id, "/manager/queue/start",
                                method="POST", data={}, t=20)
                log(f"  queue/start -> status={s2}")
                # Watch for ~20s for processing=True (= download started).
                accepted = False
                for _ in range(4):
                    time.sleep(5)
                    qs = queue_status(pod_id)
                    log(f"    queue: done={qs.get('done_count')} "
                        f"in_progress={qs.get('in_progress_count')} "
                        f"processing={qs.get('is_processing')}")
                    if qs.get("is_processing") or \
                       (qs.get("in_progress_count") or 0) >= 1 or \
                       (qs.get("done_count") or 0) >= 1:
                        accepted = True
                        break
                log(f"  => piggyback ACCEPTED + worker started: {accepted} "
                    "(NOT waiting for the ~150MB DL — terminating now)")

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
