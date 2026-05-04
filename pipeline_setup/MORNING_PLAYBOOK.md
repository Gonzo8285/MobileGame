# Gallowfell — Morning Playbook (first cloud render)

**Goal:** generate your first AI Gallowfell-style card art on RunPod cloud, end-to-end, in under 30 minutes from coffee.

**Cost:** ~£0.15-0.30 of GPU + tiny storage. Well inside your £30 RunPod credit.

**Prerequisites already done (don't repeat):**
- RunPod account created, £30 credit on file ✓
- API key saved to `secrets/runpod_api_key.txt` ✓ (not used in this manual procedure but useful for the future automation in B3.0d)

---

## Why this playbook exists

Cowork's sandbox can't reach `api.runpod.io` or `huggingface.co` from inside the box (proxy blocks them — see B3.0 in research_notes.md). Until that's fixed at the Cowork-allowlist level, the first smoke test runs from your browser using RunPod's web console. Once it works once, automation follows in B3.0d.

**This is a one-time manual run.** After this proves the pipeline works, Cowork heartbeats author the Python automation script and you never click through this UI again.

---

## Step 1 — Deploy the pod (3 min, mostly clicking)

1. Open https://console.runpod.io and sign in.
2. Left sidebar → **Pods** → **+ Deploy** (top right).
3. **GPU type:** select **RTX 4090** (24 GB VRAM).
4. **Cloud type:** select **Community Cloud** (cheaper, fine for prototyping). It'll show ~$0.39/hr.
5. **Pod template:** click the template dropdown and search for `ComfyUI`. Pick the one labelled **"RunPod ComfyUI"** or **"ComfyUI - Manager"** (whichever has the most recent update timestamp). If neither exists, pick **"RunPod Pytorch 2.x"** as a fallback — we'll install ComfyUI in step 4 below.
6. **Volume disk:** set to **30 GB**. (Default is often 20; juggernaut is 7 GB and we want headroom for LoRAs later.)
7. **Container disk:** leave default (50 GB usually).
8. Optional: set a **pod name** like `gallowfell-smoke-1` so it's recognisable in your pod list.
9. Click **Deploy On-Demand** at the bottom.

The pod takes 1-3 min to provision. Status goes from `EXITED` → `STARTING` → `RUNNING`. Wait for `RUNNING` before step 2.

---

## Step 2 — Open ComfyUI in your browser (30 sec)

1. From the pod's row in the Pods list, click **Connect**.
2. In the popup: under "HTTP Service", click **"Connect to HTTP Service [Port 8188]"**. This opens a new browser tab at a URL like `https://abc123def456-8188.proxy.runpod.net/`.
3. ComfyUI loads. You'll see a graph of nodes (the default workflow).

**If the connection times out or 404s:** ComfyUI may not be running yet. Skip ahead to step 4 (install ComfyUI manually) and come back.

---

## Step 3 — Download juggernautXL onto the pod (5-10 min)

The ComfyUI templates ship with a few sample models but not juggernautXL. We need to wget it from Hugging Face onto the pod.

1. Back on the pod's Connect popup → click **"Start Web Terminal"** (or "Connect to Web Terminal"). A terminal tab opens in your browser, shell already inside the pod's container.
2. Paste this single command and press Enter:

```bash
cd /workspace/ComfyUI/models/checkpoints && wget -q --show-progress "https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_RunDiffusion.safetensors" && echo "DOWNLOAD COMPLETE" && ls -lh
```

(If the path `/workspace/ComfyUI/` doesn't exist, the template installed ComfyUI elsewhere. Try `find / -name "checkpoints" -type d 2>/dev/null` to locate it, then `cd` there. Common alternatives: `/ComfyUI/models/checkpoints/`, `/root/ComfyUI/models/checkpoints/`.)

3. Wait for the wget to finish (~3-5 min on a cloud uplink). Last line should print "DOWNLOAD COMPLETE" and an `ls -lh` showing a ~7 GB `.safetensors` file.

4. Back in the ComfyUI browser tab → click **Refresh** (top right of the canvas) to reload the model list.

---

## Step 4 — (Skip if step 2 worked) Install ComfyUI manually

Only do this if step 2 failed because the template was Pytorch-only without ComfyUI pre-installed.

In the web terminal:

```bash
cd /workspace
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt
python main.py --listen 0.0.0.0 --port 8188 &
```

Wait ~30 sec, then re-do step 2 (Connect → HTTP Service Port 8188).

---

## Step 5 — Run the smoke test prompt (1-2 min)

In ComfyUI in your browser:

1. **Right-click** the empty canvas → **"Load Default"**. This gives you the standard 7-node SDXL workflow.
2. Find the **"Load Checkpoint"** node (top-left usually). In the dropdown, select the juggernaut filename you just downloaded. (If it's not in the list, click Refresh again, or restart ComfyUI from the web terminal: `pkill -f main.py && cd /workspace/ComfyUI && python main.py --listen 0.0.0.0 --port 8188 &`).
3. Find the **"CLIP Text Encode (Prompt)"** node — there are two, one positive (top), one negative (bottom). Paste these:

   **Positive prompt** (top node):
   ```
   masterpiece, magic the gathering card art, oil painting, painterly,
   dark fantasy, single hooded figure in brass execution mask,
   upper body portrait, atmospheric blurred background, 8k
   ```

   **Negative prompt** (bottom node):
   ```
   anime, cartoon, modern clothing, text, watermark, deformed
   ```

4. Find the **"Empty Latent Image"** node. Set **width = 1024**, **height = 1024**, **batch_size = 1**. (24 GB of VRAM = no `--lowvram` gymnastics, full SDXL native res.)
5. Right sidebar → click **Queue Prompt**.
6. First generation: 60-90 sec (model loads to VRAM). Watch the canvas — nodes light up in execution order. Result appears in the **"Save Image"** node when done.

---

## Step 6 — Pull the image back to your laptop (30 sec)

1. **Right-click the generated image** in the Save Image node → **Save Image As** → save to:
   ```
   C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\art_outputs\smoke_test_01.png
   ```
   (Create the `art_outputs` folder if it doesn't exist — File Explorer → New Folder.)

2. Open the file. If you see a recognisable painterly hooded figure with brass mask, **the pipeline works**. Ping Cowork in chat with: `smoke test passed, here's the image: [drag the file in]`.

3. If the image is anime, malformed, or wrong style — that's a workflow tuning issue, not a pipeline failure. Save it anyway and ping me; we iterate from there.

---

## Step 7 — Stop the pod (10 sec — DO NOT SKIP)

**The pod meter is running until you stop it.** £0.39/hr × 24 hr = £9.36 if you forget overnight.

1. Back at https://console.runpod.io/pods.
2. Find your pod row → click the **⋮ (three dots)** menu → **Stop**.
3. Confirm. Status changes to `EXITED`. **Compute billing stops immediately.** Storage billing continues at ~£0.10/GB/mo (≈£3/mo for the 30 GB volume holding juggernaut warm).

> If you want to also reclaim the storage cost, click **Terminate** instead of Stop. That deletes the volume and the juggernaut download — you'll re-wget next time. For now, **Stop** (not Terminate) is right — keeps juggernaut on disk for the next session.

---

## What success looks like

- One PNG in `art_outputs/smoke_test_01.png` showing painterly hooded figure with brass mask.
- Pod stopped, RunPod credit balance shows ~£29.70-29.85 remaining.
- You ping me with the image attached.

## What I do once you confirm success

- Author `workflow_gallowfell_card.json` with the locked sampler/CFG/steps + LoRA loader chain (B3.0c)
- Author `runpod_smoke_test.py` — the Python automation script that replaces this manual procedure (B3.0d)
- Run B3.0b — scan all 10 LoRAs for HF mirrors, append results to `loras_resolved.md`
- Schedule the first batch art-gen heartbeat: pick 3 cards from `cards_iron_penitents_v1.md`, generate 4 variants each, you pick favourites, we iterate

## Failure modes and what to do

| Symptom | What it means | Fix |
|---|---|---|
| Pod stuck on `STARTING` >5 min | Community Cloud capacity tight | Stop & re-deploy, or switch to Secure Cloud (~$0.69/hr, faster boot) |
| `Connect to HTTP Service` 404s | ComfyUI not running | Step 4 — install manually in web terminal |
| `wget` returns 404 on the HF URL | Filename changed on HF | Browse https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/tree/main, find the largest .safetensors, copy its "raw download" URL, retry wget |
| ComfyUI dropdown doesn't show juggernaut | Refresh button didn't pick it up | Restart ComfyUI: `pkill -f main.py && cd /workspace/ComfyUI && python main.py --listen 0.0.0.0 --port 8188 &` |
| OOM during generation | Other workflow eating VRAM | Restart ComfyUI per above |
| Image is anime / wrong style | Workflow tuning, not pipeline failure | Save image, ping me, we adjust prompts/sampler |
| Generation taking >5 min | Wrong GPU type or `--cpu` flag set somewhere | Check ComfyUI launch args; should be `--listen 0.0.0.0 --port 8188`, no `--cpu` |

---

_Authored 2026-05-02 by Cowork (live session). Once B3.0a (this) passes, B3.0c + B3.0d retire this doc — you'll never need to click through it again._
