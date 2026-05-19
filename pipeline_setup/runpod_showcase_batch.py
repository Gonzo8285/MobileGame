#!/usr/bin/env python3
"""
RunPod cloud showcase batch — Gallowfell 12-tile show-and-tell.

Deploys an RTX 4090 community pod with the official RunPod ComfyUI template,
reads pipeline_setup/showcase_manifest.json, generates all 12 tiles back-to-back
on the same warm pod, saves each result to art_iterations/_showcase/<subdir>/,
terminates the pod.

Authored 2026-05-12 (B3.0b follow-up). Inherits structure from the 2026-05-10
runpod_smoke_test.py — same RunPod GraphQL + ComfyUI HTTP API plumbing, but
loops over a manifest instead of a single hardcoded prompt.

Prereqs:
  - secrets/runpod_api_key.txt populated (read-write key)
  - pipeline_setup/showcase_manifest.json built by build_showcase_manifest.py
  - Internet from wherever this runs

Usage (from project folder):
  python3 pipeline_setup/runpod_showcase_batch.py

Cost expectation (12 tiles on RTX 4090 @ $0.39/hr):
  - Pod cold-start + checkpoint download: ~7 min one-time
  - Per-tile generation: ~1.5 min on 4090 at 30 steps SDXL
  - Total: ~25-35 min pod uptime = ~£0.16-0.23 GPU
  - Hard cap: 75 min auto-terminate

Status writes to: pipeline_setup/.showcase_batch_status.log (tail -f to follow).
"""
import json
import os
import sys
import time
import urllib.request
import urllib.error
import urllib.parse
import uuid
from pathlib import Path

# Windows consoles default to cp1252; log lines with non-cp1252 glyphs
# (e.g. '->' arrows, em-dashes) otherwise raise UnicodeEncodeError mid-tile.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# ---------- Config ----------
PROJECT_ROOT = Path(__file__).resolve().parent.parent
KEY_PATH = PROJECT_ROOT / "secrets" / "runpod_api_key.txt"
MANIFEST_PATH = PROJECT_ROOT / "pipeline_setup" / "showcase_manifest.json"
# Fix #2: log path moved to /tmp on non-Windows to avoid OneDrive sync churn.
# Falls back to project folder if /tmp not writeable (Windows runners on Paul's laptop).
LOG_PATH = Path("/tmp/showcase_batch_status.log") if os.name != "nt" else (
    PROJECT_ROOT / "pipeline_setup" / ".showcase_batch_status.log"
)
OUTPUT_ROOT = PROJECT_ROOT / "art_iterations" / "_showcase"
OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

GQL_URL = "https://api.runpod.io/graphql"
COMFYUI_TEMPLATE_ID = "cw3nka7d08"   # Official "ComfyUI" template, runpod/comfyui:latest
GPU_TYPE_ID = "NVIDIA GeForce RTX 4090"   # 24GB VRAM, ~$0.39/hr community
GPU_FALLBACKS = [  # 4090/A5000/A4000 routinely out of community capacity;
    "NVIDIA GeForce RTX 3090",          # 24GB — probes consistently land here
    "NVIDIA RTX A5000",                 # 24GB
    "NVIDIA RTX A4000",                 # 16GB (SDXL still fits)
    "NVIDIA L4",
    "NVIDIA A30",
    "NVIDIA A40",
    "NVIDIA L40",
    "NVIDIA L40S",
    "NVIDIA RTX 6000 Ada Generation",
    "NVIDIA RTX A4500",
    "NVIDIA RTX A6000",
]
CONTAINER_DISK_GB = 25
VOLUME_DISK_GB = 30
POD_NAME = f"gallowfell-showcase-{int(time.time())}"

POD_BOOT_TIMEOUT_SEC = 480           # 8 min to RUNNING
COMFYUI_READY_TIMEOUT_SEC = 360      # 6 min to /system_stats
GENERATION_TIMEOUT_SEC = 480         # 8 min per tile (first tile = +checkpoint download)
TOTAL_BUDGET_SEC = 4500              # 75 min hard cap for whole batch

# ---------- Logging ----------
def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    try:
        print(line, flush=True)
    except UnicodeEncodeError:
        # Last-resort guard if stdout reconfigure didn't take: never let a
        # log glyph kill a tile.
        print(line.encode("ascii", "replace").decode("ascii"), flush=True)
    try:
        with LOG_PATH.open("a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass  # non-fatal if log dir is read-only

# ---------- HTTP helpers ----------
def http_request(url, method="GET", data=None, headers=None, timeout=30):
    req_headers = headers or {}
    if data is not None and not isinstance(data, (bytes, bytearray)):
        data = json.dumps(data).encode("utf-8")
        req_headers.setdefault("Content-Type", "application/json")
    # Cloudflare in front of api.runpod.io and *.proxy.runpod.net rejects
    # Python-urllib's default UA with HTTP 403 (CF error 1010).
    req_headers.setdefault("User-Agent", "Mozilla/5.0 gallowfell-batch/1.0")
    req = urllib.request.Request(url, data=data, headers=req_headers, method=method)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.status, resp.read()

def gql(query, variables=None, api_key=None, timeout=30):
    payload = {"query": query}
    if variables:
        payload["variables"] = variables
    headers = {"Authorization": f"Bearer {api_key}"}
    status, body = http_request(GQL_URL, method="POST", data=payload, headers=headers, timeout=timeout)
    data = json.loads(body)
    if "errors" in data and data["errors"]:
        raise RuntimeError(f"GraphQL error: {data['errors']}")
    return data.get("data", {})

# ---------- Pod lifecycle ----------
def deploy_pod(api_key, gpu_type=None):
    gpu = gpu_type or GPU_TYPE_ID
    log(f"Deploying pod: {POD_NAME} on {gpu}")
    mutation = """
    mutation DeployPod($input: PodFindAndDeployOnDemandInput) {
      podFindAndDeployOnDemand(input: $input) {
        id machineId imageName env machine { podHostId }
      }
    }
    """
    variables = {
        "input": {
            "cloudType": "ALL",  # community when free, else Secure Cloud (~2x)
            "gpuCount": 1,
            "gpuTypeId": gpu,
            "name": POD_NAME,
            "templateId": COMFYUI_TEMPLATE_ID,
            "containerDiskInGb": CONTAINER_DISK_GB,
            "volumeInGb": VOLUME_DISK_GB,
            "volumeMountPath": "/workspace",
            "ports": "8188/http,22/tcp",
            "minVcpuCount": 4,
            "minMemoryInGb": 16,
        }
    }
    data = gql(mutation, variables, api_key)
    pod = data.get("podFindAndDeployOnDemand")
    if not pod:
        raise RuntimeError(f"No capacity for {gpu}")
    pod_id = pod["id"]
    log(f"Pod deployed: id={pod_id}")
    return pod_id

def deploy_with_fallback(api_key):
    """Try preferred GPU then fall back through cheaper options."""
    for gpu in [GPU_TYPE_ID] + GPU_FALLBACKS:
        try:
            return deploy_pod(api_key, gpu)
        except RuntimeError as e:
            log(f"  no capacity for {gpu}: {e}")
            continue
    raise RuntimeError("All GPU types exhausted with no community capacity")

def get_pod(api_key, pod_id):
    query = """
    query GetPod($input: PodFilter!) {
      pod(input: $input) {
        id name desiredStatus
        runtime { uptimeInSeconds ports { ip privatePort publicPort isIpPublic type } }
      }
    }
    """
    data = gql(query, {"input": {"podId": pod_id}}, api_key)
    return data.get("pod")

def wait_for_running(api_key, pod_id):
    log("Waiting for pod to reach RUNNING (up to 8 min)...")
    deadline = time.time() + POD_BOOT_TIMEOUT_SEC
    last_status = None
    while time.time() < deadline:
        try:
            pod = get_pod(api_key, pod_id)
        except Exception as e:
            log(f"  poll error (continuing): {e}")
            time.sleep(10)
            continue
        status = pod.get("desiredStatus")
        if status != last_status:
            log(f"  pod status: {status}")
            last_status = status
        if status == "RUNNING" and pod.get("runtime"):
            uptime = pod["runtime"].get("uptimeInSeconds", 0)
            if uptime >= 5:
                log(f"  pod RUNNING (uptime {uptime}s)")
                return pod
        time.sleep(8)
    raise TimeoutError(f"Pod did not reach RUNNING within {POD_BOOT_TIMEOUT_SEC}s")

def comfyui_proxy_url(pod_id):
    return f"https://{pod_id}-8188.proxy.runpod.net"

def wait_for_comfyui(api_key, pod_id):
    url = comfyui_proxy_url(pod_id) + "/system_stats"
    log(f"Waiting for ComfyUI at {url} ...")
    deadline = time.time() + COMFYUI_READY_TIMEOUT_SEC
    last_err = None
    while time.time() < deadline:
        try:
            status, body = http_request(url, timeout=10)
            if status == 200:
                stats = json.loads(body)
                vram = stats.get("devices", [{}])[0].get("vram_total", 0)
                log(f"  ComfyUI alive — VRAM total {vram//(1024**3)} GB")
                return
        except urllib.error.HTTPError as e:
            last_err = f"HTTP {e.code}"
        except urllib.error.URLError as e:
            last_err = f"URL {e.reason}"
        except Exception as e:
            last_err = str(e)
        time.sleep(10)
    raise TimeoutError(f"ComfyUI did not respond. Last error: {last_err}")

def list_checkpoints(pod_id):
    url = comfyui_proxy_url(pod_id) + "/object_info/CheckpointLoaderSimple"
    status, body = http_request(url, timeout=15)
    if status != 200:
        return []
    data = json.loads(body)
    try:
        return data["CheckpointLoaderSimple"]["input"]["required"]["ckpt_name"][0]
    except (KeyError, IndexError, TypeError):
        return []

def pick_checkpoint(available, preferences):
    """Pick first matching preference from available list."""
    for needle in preferences:
        for c in available:
            if needle.lower() in c.lower():
                return c
    return available[0] if available else None

# ---------- ComfyUI-Manager checkpoint provisioning ----------
# The official RunPod ComfyUI template (cw3nka7d08) ships ZERO checkpoints.
# ComfyUI-Manager V3.40 is preinstalled though, so we self-install an SDXL
# checkpoint from its model catalogue. Endpoint shapes verified against
# Comfy-Org/ComfyUI-Manager glob/manager_server.py:
#   GET  /externalmodel/getlist?mode=remote  -> {"models":[ {entry}, ... ]}
#   POST /manager/queue/install_model        <- the entry dict (+ optional ui_id)
#   POST /manager/queue/start                <- fires the worker thread
#   GET  /manager/queue/status               -> {total_count,done_count,
#                                                 in_progress_count,is_processing}
# install_model whitelist check matches on (save_path, base, filename), so we
# must POST back the catalogue entry unmodified.
MODEL_INSTALL_TIMEOUT_SEC = 900   # ~7 GB checkpoint; generous for slow pods

# ---- Quality stack -------------------------------------------------------
# ComfyUI-Manager's catalogue has NO SDXL community finetunes, but
# install_model's whitelist only checks (save_path, base, filename) — not the
# URL. So we piggyback sd_xl_base_1.0's whitelisted triple and swap the URL to
# a HF-hosted finetune (verified accepted by runpod_probe_quality.py). The file
# lands on disk *named* sd_xl_base_1.0.safetensors but is actually the finetune
# — fine, pods are ephemeral (one model per run). Set FINETUNE_URL = None to
# fall back to plain sd_xl_base.
FINETUNE_LABEL = "Juggernaut-XL-v9"
FINETUNE_URL = ("https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/"
                "resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors")
# Hires-fix 2nd pass: base latent -> upscale -> low-denoise resample. Targets
# unclean edges / mushy props / soft detail. Nodes verified present on template.
HIRES_ENABLED = True
HIRES_SCALE = 1.5            # 832x1216 -> ~1248x1824 (fits 24GB+ easily)
HIRES_DENOISE = 0.45         # enough to sharpen/repair, not recompose
HIRES_STEPS = 20             # 2nd-pass steps (base pass uses tile['steps'])
HIRES_UPSCALE_METHOD = "bicubic"

def fetch_model_catalogue(pod_id):
    url = comfyui_proxy_url(pod_id) + "/externalmodel/getlist?mode=remote"
    status, body = http_request(url, timeout=30)
    if status != 200:
        raise RuntimeError(f"catalogue fetch failed: HTTP {status}")
    return json.loads(body).get("models", [])

def pick_catalogue_entry(models, preferences):
    """Find the best checkpoint catalogue entry for the manifest preference.
    Skips 'turbo' variants (they need turbo-specific sampler settings the
    manifest doesn't use). Prefers the shortest filename on a needle match so
    'sd_xl_base_1.0.safetensors' wins over 'sd_xl_base_1.0_0.9vae.safetensors'."""
    ckpts = [
        m for m in models
        if m.get("type", "").lower() == "checkpoint"
        and m.get("filename", "").endswith(".safetensors")
        and "turbo" not in json.dumps(m).lower()
    ]
    for needle in preferences:
        matches = [m for m in ckpts if needle.lower() in m.get("filename", "").lower()]
        if matches:
            return sorted(matches, key=lambda m: len(m["filename"]))[0]
    return None

def queue_status(pod_id):
    try:
        url = comfyui_proxy_url(pod_id) + "/manager/queue/status"
        status, body = http_request(url, timeout=10)
        if status == 200:
            return json.loads(body)
    except Exception:
        pass
    return {}

def ensure_checkpoint(pod_id, manifest):
    """Return a usable checkpoint name, installing one via ComfyUI-Manager if
    the pod has none. Raises if it can't get one."""
    prefs = manifest.get("checkpoint_preference", ["sdxl"])
    have = list_checkpoints(pod_id)
    if have:
        picked = pick_checkpoint(have, prefs)
        if picked:
            log(f"Checkpoint already present: {picked}")
            return picked

    log("No checkpoint on pod — provisioning via ComfyUI-Manager...")
    catalogue = fetch_model_catalogue(pod_id)
    log(f"  catalogue: {len(catalogue)} models")
    entry = pick_catalogue_entry(catalogue, prefs)
    if entry is None:
        raise RuntimeError(f"No catalogue checkpoint matches preference {prefs}")
    payload = dict(entry)
    payload["ui_id"] = "gallowfell-batch"
    if FINETUNE_URL:
        # Whitelist-piggyback: keep entry's (save_path, base, filename) so the
        # whitelist passes, but download the finetune instead.
        payload["url"] = FINETUNE_URL
        payload["name"] = f"{FINETUNE_LABEL} (piggyback via {entry['filename']})"
        log(f"  installing: {FINETUNE_LABEL} (~7GB) via piggyback slot "
            f"'{entry['filename']}' -> {entry.get('save_path')}")
        log(f"    NOTE: on-disk filename will be {entry['filename']} but the "
            f"weights are {FINETUNE_LABEL}")
    else:
        log(f"  installing: {entry['filename']} ({entry.get('size','?')}) "
            f"-> {entry.get('save_path')}")
    s, b = http_request(comfyui_proxy_url(pod_id) + "/manager/queue/install_model",
                         method="POST", data=payload, timeout=30)
    if s != 200:
        raise RuntimeError(f"install_model rejected: HTTP {s} {b[:200]!r}")
    s, b = http_request(comfyui_proxy_url(pod_id) + "/manager/queue/start",
                         method="POST", data={}, timeout=30)
    if s not in (200, 201):
        raise RuntimeError(f"queue/start failed: HTTP {s} {b[:200]!r}")
    log("  install queued + worker started; waiting for download...")

    # CRITICAL: ComfyUI lists the checkpoint filename the instant Manager
    # *creates* the file, long before the 6.94GB download finishes. Trusting
    # that early sighting makes tile 1 run against a half-written model and
    # hang until timeout. So gate on Manager's queue actually reporting the
    # install complete (worker stopped + a task done) BEFORE we trust the
    # filename. (queue/status done_count = len(nodepack_result)+len(model_result),
    # incremented on completion regardless of success — a failed download still
    # increments it, so a missing checkpoint after "done" is a real failure.)
    deadline = time.time() + MODEL_INSTALL_TIMEOUT_SEC
    last_log = 0
    seen_processing = False
    while time.time() < deadline:
        time.sleep(10)
        qs = queue_status(pod_id)
        is_proc = bool(qs.get("is_processing"))
        done = qs.get("done_count", 0) or 0
        if is_proc:
            seen_processing = True

        install_done = (seen_processing or done >= 1) and not is_proc and done >= 1
        if install_done:
            # Bytes fully written. Now confirm ComfyUI exposes a usable ckpt,
            # allowing a brief rescan grace (folder mtime cache refresh).
            for _ in range(8):
                picked = pick_checkpoint(list_checkpoints(pod_id) or [], prefs)
                if picked:
                    log(f"  checkpoint ready (install complete): {picked}")
                    return picked
                time.sleep(5)
            raise RuntimeError(
                f"Manager reported install done but no checkpoint visible. queue={qs}")

        if time.time() - last_log >= 30:
            log(f"  ...installing (queue: done={done} "
                f"in_progress={qs.get('in_progress_count')} processing={is_proc})")
            last_log = time.time()
    raise TimeoutError(
        f"Checkpoint did not install within {MODEL_INSTALL_TIMEOUT_SEC}s")

def terminate_pod(api_key, pod_id):
    log(f"Terminating pod {pod_id}...")
    mutation = """
    mutation TerminatePod($input: PodTerminateInput!) {
      podTerminate(input: $input)
    }
    """
    try:
        gql(mutation, {"input": {"podId": pod_id}}, api_key, timeout=20)
        log("  pod terminated")
    except Exception as e:
        log(f"  WARNING: terminate failed: {e}. CHECK https://console.runpod.io/pods MANUALLY.")

# ---------- ComfyUI workflow ----------
def clean_prompt(text):
    """Conservative, reversible (build-time only) prompt hygiene: collapse
    whitespace and drop duplicate comma-separated clauses (case-insensitive,
    first occurrence kept). The manifest prompts are heavily self-repetitive,
    which dilutes SDXL's CLIP conditioning and worsens feature merging. This
    does NOT rewrite wording or reorder — just removes redundant repeats.
    """
    if not text:
        return text
    parts = [p.strip() for p in str(text).replace("\n", " ").split(",")]
    seen, out = set(), []
    for p in parts:
        if not p:
            continue
        key = " ".join(p.lower().split())
        if key in seen:
            continue
        seen.add(key)
        out.append(" ".join(p.split()))
    return ", ".join(out)


def build_workflow(checkpoint_name, tile):
    """Workflow for a single tile: base sample -> (optional) hires-fix 2nd
    pass (latent upscale + low-denoise resample) -> decode -> save.
    Prompts pass through clean_prompt() to cut self-repetition."""
    pos = clean_prompt(tile["positive_prompt"])
    neg = clean_prompt(tile["negative_prompt"])
    wf = {
        "3": {
            "class_type": "KSampler",
            "inputs": {
                "seed": tile["seed"],
                "steps": tile["steps"],
                "cfg": tile["cfg"],
                "sampler_name": tile["sampler"],
                "scheduler": tile["scheduler"],
                "denoise": 1.0,
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0],
            }
        },
        "4": {"class_type": "CheckpointLoaderSimple", "inputs": {"ckpt_name": checkpoint_name}},
        "5": {"class_type": "EmptyLatentImage", "inputs": {
            "width": tile["width"], "height": tile["height"], "batch_size": 1
        }},
        "6": {"class_type": "CLIPTextEncode", "inputs": {"text": pos, "clip": ["4", 1]}},
        "7": {"class_type": "CLIPTextEncode", "inputs": {"text": neg, "clip": ["4", 1]}},
        "8": {"class_type": "VAEDecode", "inputs": {"samples": ["3", 0], "vae": ["4", 2]}},
        "9": {"class_type": "SaveImage", "inputs": {
            "filename_prefix": f"gallowfell_showcase/{tile['tile_id']}", "images": ["8", 0]
        }},
    }
    if HIRES_ENABLED:
        # Upscale the base latent, then a short low-denoise resample on the
        # same model/prompt for crisp edges + repaired detail.
        wf["10"] = {"class_type": "LatentUpscaleBy", "inputs": {
            "samples": ["3", 0],
            "upscale_method": HIRES_UPSCALE_METHOD,
            "scale_by": HIRES_SCALE,
        }}
        wf["11"] = {"class_type": "KSampler", "inputs": {
            "seed": tile["seed"],
            "steps": HIRES_STEPS,
            "cfg": tile["cfg"],
            "sampler_name": tile["sampler"],
            "scheduler": tile["scheduler"],
            "denoise": HIRES_DENOISE,
            "model": ["4", 0],
            "positive": ["6", 0],
            "negative": ["7", 0],
            "latent_image": ["10", 0],
        }}
        wf["8"]["inputs"]["samples"] = ["11", 0]
    return wf

def submit_prompt(pod_id, workflow):
    url = comfyui_proxy_url(pod_id) + "/prompt"
    client_id = str(uuid.uuid4())
    payload = {"prompt": workflow, "client_id": client_id}
    status, body = http_request(url, method="POST", data=payload, timeout=30)
    data = json.loads(body)
    return data["prompt_id"]

def wait_for_history(pod_id, prompt_id, timeout_sec):
    deadline = time.time() + timeout_sec
    while time.time() < deadline:
        try:
            url = comfyui_proxy_url(pod_id) + f"/history/{prompt_id}"
            status, body = http_request(url, timeout=15)
            data = json.loads(body)
            if data and prompt_id in data:
                outputs = data[prompt_id].get("outputs", {})
                images = outputs.get("9", {}).get("images", [])
                if images:
                    return images
        except Exception as e:
            log(f"    poll error (continuing): {e}")
        time.sleep(6)
    raise TimeoutError(f"Generation did not complete in {timeout_sec}s")

def download_image(pod_id, image_meta, dest_path):
    params = urllib.parse.urlencode({
        "filename": image_meta["filename"],
        "subfolder": image_meta.get("subfolder", ""),
        "type": image_meta.get("type", "output"),
    })
    url = comfyui_proxy_url(pod_id) + "/view?" + params
    status, body = http_request(url, timeout=60)
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    dest_path.write_bytes(body)
    log(f"    saved {len(body)//1024} KB -> {dest_path.relative_to(PROJECT_ROOT)}")

# ---------- Batch driver ----------
def run_batch(api_key, manifest, pod_id, overall_deadline):
    preferred = ensure_checkpoint(pod_id, manifest)
    log(f"Selected checkpoint: {preferred}")

    results = []
    failures = []
    for idx, tile in enumerate(manifest["tiles"], start=1):
        if time.time() > overall_deadline:
            log(f"!!! Budget exhausted before tile {idx}. Stopping.")
            break

        # First tile gets longer timeout — pod may still be downloading the checkpoint.
        tile_timeout = GENERATION_TIMEOUT_SEC if idx == 1 else 240
        log(f"[{idx:02d}/{len(manifest['tiles'])}] {tile['tile_id']:4s} "
            f"{tile['display_name']} (seed={tile['seed']}, {tile['width']}x{tile['height']})")
        try:
            workflow = build_workflow(preferred, tile)
            t0 = time.time()
            prompt_id = submit_prompt(pod_id, workflow)
            images = wait_for_history(pod_id, prompt_id, tile_timeout)
            elapsed = time.time() - t0
            for img in images:
                dest = OUTPUT_ROOT / tile["output_subdir"].split("/", 1)[-1] / tile["output_filename"]
                download_image(pod_id, img, dest)
                results.append({"tile_id": tile["tile_id"], "path": str(dest), "elapsed_sec": round(elapsed, 1)})
            log(f"    OK in {elapsed:.0f}s")
        except Exception as e:
            log(f"    FAIL: {e}")
            failures.append({"tile_id": tile["tile_id"], "error": str(e)})
            # Keep going — one bad tile shouldn't kill the batch.

    log("")
    log(f"=== Batch complete: {len(results)} ok, {len(failures)} failed ===")
    for r in results:
        log(f"  OK   {r['tile_id']:4s} {r['elapsed_sec']:5.0f}s  {r['path']}")
    for f in failures:
        log(f"  FAIL {f['tile_id']:4s} {f['error']}")
    return results, failures

# ---------- Main ----------
def main():
    if not KEY_PATH.exists():
        sys.exit(f"FATAL: API key not found at {KEY_PATH}")
    # Optional manifest override (argv[1]) so we can run a subset (e.g. a
    # single missing tile) without disturbing the canonical 12-tile manifest.
    manifest_path = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else MANIFEST_PATH
    if not manifest_path.exists():
        sys.exit(f"FATAL: manifest not found at {manifest_path}. Run build_showcase_manifest.py first.")
    api_key = KEY_PATH.read_text().strip()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    log(f"Manifest source: {manifest_path}")

    try:
        LOG_PATH.unlink(missing_ok=True)
    except Exception:
        pass
    log("=== Gallowfell showcase batch — start ===")
    log(f"Manifest: {len(manifest['tiles'])} tiles")
    log(f"Output:   {OUTPUT_ROOT}")
    log(f"Budget:   {TOTAL_BUDGET_SEC // 60} min hard cap")

    overall_deadline = time.time() + TOTAL_BUDGET_SEC
    pod_id = None
    try:
        pod_id = deploy_with_fallback(api_key)
        wait_for_running(api_key, pod_id)
        wait_for_comfyui(api_key, pod_id)
        results, failures = run_batch(api_key, manifest, pod_id, overall_deadline)
    except Exception as e:
        log(f"!!! FATAL: {e}")
        raise
    finally:
        if pod_id:
            terminate_pod(api_key, pod_id)
        log("=== run end ===")

    # Honest exit code: a run that produced zero images is a failure, even
    # though per-tile errors are caught so the pod still gets terminated.
    # This lets the retry wrapper actually retry instead of seeing exit 0.
    if not results:
        sys.exit(f"FATAL: batch produced 0 images ({len(failures)} tiles failed)")
    if failures:
        log(f"NOTE: {len(results)} ok, {len(failures)} failed "
            f"(partial success — exiting 0)")

if __name__ == "__main__":
    main()
