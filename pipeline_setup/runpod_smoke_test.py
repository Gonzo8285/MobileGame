#!/usr/bin/env python3
"""
RunPod cloud smoke test — Gallowfell first-image automation.

Deploys an RTX A5000 community pod running the official RunPod ComfyUI template,
generates one painterly-grimdark SDXL render to validate the visual direction,
saves the result to art_iterations/_smoke/, terminates the pod.

Authored 2026-05-10 to retire MORNING_PLAYBOOK.md (manual procedure).
Tightly cost-bounded — full run ~£0.10-0.15 of GPU.

Prereqs:
  - secrets/runpod_api_key.txt populated (read-write key)
  - Internet from wherever this runs

Usage (from project folder):
  python3 pipeline_setup/runpod_smoke_test.py

Status writes to: pipeline_setup/.smoke_test_status.log (tail -f to follow)
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

# ---------- Config ----------
PROJECT_ROOT = Path(__file__).resolve().parent.parent
KEY_PATH = PROJECT_ROOT / "secrets" / "runpod_api_key.txt"
LOG_PATH = PROJECT_ROOT / "pipeline_setup" / ".smoke_test_status.log"
OUTPUT_DIR = PROJECT_ROOT / "art_iterations" / "_smoke"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

GQL_URL = "https://api.runpod.io/graphql"
COMFYUI_TEMPLATE_ID = "cw3nka7d08"  # Official "ComfyUI" template, runpod/comfyui:latest
GPU_TYPE_ID = "NVIDIA RTX A5000"      # 24GB VRAM, ~$0.16/hr community
CONTAINER_DISK_GB = 25
VOLUME_DISK_GB = 30
POD_NAME = f"gallowfell-smoke-{int(time.time())}"

POD_BOOT_TIMEOUT_SEC = 480       # 8 min — pod must reach RUNNING
COMFYUI_READY_TIMEOUT_SEC = 360  # 6 min — proxy URL must respond 200
GENERATION_TIMEOUT_SEC = 600     # 10 min — generation must finish (incl. potential model download)
TOTAL_BUDGET_SEC = 1800          # 30 min hard cap — auto-terminate pod beyond this

POSITIVE_PROMPT = (
    "masterpiece, magic the gathering card art, oil painting, painterly, "
    "dark fantasy, single hooded figure in brass execution mask, scarred bare back, "
    "iron chains dragging from wrists, candle-yellow glow on rust-red robes, "
    "upper body portrait, atmospheric blurred cathedral background, "
    "elden ring grandeur, phyrexian body-horror undertone, 8k, dramatic chiaroscuro"
)
NEGATIVE_PROMPT = (
    "anime, cartoon, modern clothing, text, watermark, deformed, low quality, "
    "blurry, jpeg artifacts, extra limbs, bad anatomy, signature, username, logo"
)

# ---------- Logging ----------
def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    with LOG_PATH.open("a", encoding="utf-8") as f:
        f.write(line + "\n")

# ---------- HTTP helpers ----------
def http_request(url, method="GET", data=None, headers=None, timeout=30):
    req_headers = headers or {}
    if data is not None and not isinstance(data, (bytes, bytearray)):
        data = json.dumps(data).encode("utf-8")
        req_headers.setdefault("Content-Type", "application/json")
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

# ---------- Lifecycle ----------
def deploy_pod(api_key):
    log(f"Deploying pod: {POD_NAME} on {GPU_TYPE_ID} (community, ~$0.16/hr)")
    mutation = """
    mutation DeployPod($input: PodFindAndDeployOnDemandInput) {
      podFindAndDeployOnDemand(input: $input) {
        id
        machineId
        imageName
        env
        machine { podHostId }
      }
    }
    """
    variables = {
        "input": {
            "cloudType": "COMMUNITY",
            "gpuCount": 1,
            "gpuTypeId": GPU_TYPE_ID,
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
        raise RuntimeError("Deploy returned null. Likely no community capacity for that GPU. Try RTX_A4000 or wait.")
    pod_id = pod["id"]
    log(f"Pod deployed: id={pod_id}")
    return pod_id

def get_pod(api_key, pod_id):
    query = """
    query GetPod($input: PodFilter!) {
      pod(input: $input) {
        id
        name
        desiredStatus
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
    log(f"Waiting for ComfyUI to respond at {url} (up to 6 min)...")
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
        except (TimeoutError, ConnectionError) as e:
            last_err = str(e)
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

def build_workflow(checkpoint_name):
    # Minimal valid SDXL workflow — 7 nodes
    return {
        "3": {
            "class_type": "KSampler",
            "inputs": {
                "seed": 4242, "steps": 30, "cfg": 6.5,
                "sampler_name": "dpmpp_2m", "scheduler": "karras", "denoise": 1.0,
                "model": ["4", 0], "positive": ["6", 0], "negative": ["7", 0], "latent_image": ["5", 0]
            }
        },
        "4": {
            "class_type": "CheckpointLoaderSimple",
            "inputs": {"ckpt_name": checkpoint_name}
        },
        "5": {
            "class_type": "EmptyLatentImage",
            "inputs": {"width": 832, "height": 1216, "batch_size": 1}
        },
        "6": {
            "class_type": "CLIPTextEncode",
            "inputs": {"text": POSITIVE_PROMPT, "clip": ["4", 1]}
        },
        "7": {
            "class_type": "CLIPTextEncode",
            "inputs": {"text": NEGATIVE_PROMPT, "clip": ["4", 1]}
        },
        "8": {
            "class_type": "VAEDecode",
            "inputs": {"samples": ["3", 0], "vae": ["4", 2]}
        },
        "9": {
            "class_type": "SaveImage",
            "inputs": {"filename_prefix": "gallowfell_smoke", "images": ["8", 0]}
        },
    }

def submit_prompt(pod_id, workflow):
    url = comfyui_proxy_url(pod_id) + "/prompt"
    client_id = str(uuid.uuid4())
    payload = {"prompt": workflow, "client_id": client_id}
    status, body = http_request(url, method="POST", data=payload, timeout=30)
    data = json.loads(body)
    return data["prompt_id"]

def wait_for_history(pod_id, prompt_id):
    log(f"Polling for generation result (prompt_id={prompt_id})...")
    deadline = time.time() + GENERATION_TIMEOUT_SEC
    while time.time() < deadline:
        try:
            url = comfyui_proxy_url(pod_id) + f"/history/{prompt_id}"
            status, body = http_request(url, timeout=15)
            data = json.loads(body)
            if data and prompt_id in data:
                outputs = data[prompt_id].get("outputs", {})
                images = outputs.get("9", {}).get("images", [])
                if images:
                    log(f"  generation complete, {len(images)} image(s)")
                    return images
        except Exception as e:
            log(f"  poll error (continuing): {e}")
        time.sleep(8)
    raise TimeoutError("Generation did not complete in time")

def download_image(pod_id, image_meta, dest_path):
    params = urllib.parse.urlencode({
        "filename": image_meta["filename"],
        "subfolder": image_meta.get("subfolder", ""),
        "type": image_meta.get("type", "output"),
    })
    url = comfyui_proxy_url(pod_id) + "/view?" + params
    status, body = http_request(url, timeout=60)
    dest_path.write_bytes(body)
    log(f"  saved {len(body)//1024} KB → {dest_path}")

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

# ---------- Main ----------
def main():
    if not KEY_PATH.exists():
        sys.exit(f"FATAL: API key not found at {KEY_PATH}")
    api_key = KEY_PATH.read_text().strip()

    LOG_PATH.unlink(missing_ok=True)
    log("=== Gallowfell smoke test — start ===")
    log(f"Output dir: {OUTPUT_DIR}")
    overall_deadline = time.time() + TOTAL_BUDGET_SEC

    pod_id = None
    try:
        pod_id = deploy_pod(api_key)
        wait_for_running(api_key, pod_id)
        wait_for_comfyui(api_key, pod_id)

        ckpts = list_checkpoints(pod_id)
        log(f"Available checkpoints: {ckpts[:5]}{'...' if len(ckpts)>5 else ''}")
        if not ckpts:
            raise RuntimeError("No checkpoints available on pod. Template may have changed.")

        # Prefer juggernaut/SDXL > anything containing 'xl' > first available
        preferred = None
        for needle in ["juggernaut", "sd_xl_base", "sdxl"]:
            for c in ckpts:
                if needle.lower() in c.lower():
                    preferred = c
                    break
            if preferred:
                break
        if not preferred:
            preferred = ckpts[0]
        log(f"Using checkpoint: {preferred}")

        workflow = build_workflow(preferred)
        prompt_id = submit_prompt(pod_id, workflow)
        images = wait_for_history(pod_id, prompt_id)

        for i, img in enumerate(images):
            dest = OUTPUT_DIR / f"smoke_test_{int(time.time())}_{i:02d}_{img['filename']}"
            download_image(pod_id, img, dest)

        log("=== SMOKE TEST PASSED ===")

    except Exception as e:
        log(f"!!! ERROR: {e}")
        raise
    finally:
        if pod_id:
            terminate_pod(api_key, pod_id)
        log("=== run end ===")

if __name__ == "__main__":
    main()
