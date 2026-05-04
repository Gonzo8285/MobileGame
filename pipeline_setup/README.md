# Gallowfell AI art pipeline — local setup (one-time)

_This is the one-time install for ComfyUI + the Gallowfell-locked model and LoRA stack. Runs on Paul's RTX 2050 laptop. After it's done, you can generate Gallowfell art from any spec file in `../art_specs/` by loading the workflow + the spec's prompt._

> **⚠ READ FIRST — this local-install path has two known constraints (2026-05-02):**
>
> 1. **Civitai is geo-blocked in the UK.** The Online Safety Act took effect in July 2025 and Civitai withdrew UK access. The model + LoRA download links in this doc that still point to civitai.com **will not work from a UK consumer connection**. juggernautXL has been remapped to its Hugging Face mirror (`RunDiffusion/Juggernaut-XL-v9`) below; the 10 LoRAs need per-LoRA HF mirror lookup (tracked as backlog item B3.0b).
> 2. **The RTX 2050 has ~4 GB VRAM**, below SDXL's typical 8-10 GB requirement. juggernautXL will run only with `--lowvram` flag and image size dropped to 768×768. Quality is fine; per-image generation drops to ~3-5 min.
>
> **Cloud alternative (recommended):** see `MORNING_PLAYBOOK.md` for the RunPod cloud path. Cloud GPUs aren't UK-IP'd (Civitai works), have 24 GB VRAM (no `--lowvram` gymnastics), cost ~£0.39/hr only when generating, dormant cost ~£2/mo. Decision logged in research_notes.md "B3.0 — Cloud GPU vendor selection".

> **Single rule before you start:** if any step asks you to install a different Python version, a different ComfyUI version, or a different model than the ones listed below — DON'T. The pipeline is locked. Substitutions break reproducibility. If something fails, ping Cowork in chat with the exact error message and we'll patch this doc.

---

## Prerequisites

- **OS:** Windows (these scripts are Windows; equivalent .sh exists for Linux/Mac if needed later).
- **Python 3.11.x** — NOT 3.12. ComfyUI's compatibility matrix is finicky. Download from python.org/downloads/release/python-3119/. Tick "Add to PATH" during install.
- **Git** — for cloning ComfyUI. If not installed: git-scm.com/download/win.
- **~30 GB free disk** — model checkpoint is ~7GB, LoRAs another ~5GB total, plus working space for outputs.
- **NVIDIA driver ≥ 535** — newer than that is fine. Check with `nvidia-smi` in cmd. Driver auto-updates if you have GeForce Experience.

If anything's missing, install first, retry the script.

---

## Install (run once)

> **All commands below use full absolute paths.** Open a fresh PowerShell window — you do NOT need to `cd` anywhere first. Just copy-paste each command directly.

### Step 1 — Open PowerShell as Administrator

Press **Start** → type `powershell` → right-click **Windows PowerShell** → **Run as administrator**. Click Yes on the UAC prompt.

### Step 2 — Run the installer

Copy-paste this single line into PowerShell and press Enter:

```
& "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\pipeline_setup\install_comfyui_windows.bat"
```

(The `&` and the surrounding double-quotes are required — the path contains spaces and dashes which PowerShell needs quoted. The leading `&` is PowerShell's "call operator" — it tells PowerShell "run this as a command, not a string.")

The script will:
- Clone ComfyUI to `C:\ComfyUI\` (location fixed for reproducibility).
- Create a Python virtual environment at `C:\ComfyUI\venv`.
- Install all Python dependencies (torch with CUDA, transformers, etc.) — this is the slow step, 5–15 min.
- Wire the workflow file into ComfyUI's user folder.
- Pause and prompt you to do the manual model downloads.

### Step 3 — Manual model download (script will pause + tell you)

Civitai login is free; sign up at https://civitai.com if you don't have an account.

**Checkpoint** (~7GB) — UK users **must** use the Hugging Face mirror; the original Civitai page is geo-blocked:

> https://huggingface.co/RunDiffusion/Juggernaut-XL-v9
>
> Direct download (click the "Files and versions" tab, then click the `.safetensors` file with the largest size — typically `juggernautXL_v9Rundiffusionphoto2.safetensors`).

…and save the `.safetensors` file to **exactly** this folder:

```
C:\ComfyUI\models\checkpoints\
```

_(Original Civitai page (non-UK only): https://civitai.com/models/133005 — kept here for reference only. Don't try this URL from a UK consumer connection; it returns the OSA geo-block notice.)_

**LoRAs** (~1–5GB each) — save all of them to **exactly** this folder:

```
C:\ComfyUI\models\loras\
```

LoRA list (resolved by heartbeat task **D-LORA-1**, 2026-05-04 — full mapping + substitution rationale in `loras_resolved.md`):

> **⚠ UK users — these Civitai URLs are geo-blocked.** Hugging Face mirror lookup is queued as backlog item **B3.0b**. Until that scan is done, two options: (1) download from a non-UK network (cloud pod side, VPN), (2) wait for B3.0b heartbeat to substitute each URL with its HF equivalent. The smoke test in `MORNING_PLAYBOOK.md` works with juggernautXL alone, no LoRAs — start there.

**Style LoRAs** (apply to all Gallowfell art):

- ClassipeintXL — https://civitai.com/models/127139/classipeintxl-oil-paint-oil-painting-style
- Dark Fantasy LORA — https://civitai.com/models/932379/dark-fantasy-lora
- Elden Ring Style — https://civitai.com/models/457103/elden-ring-style

**Faction-specific LoRAs** (apply per-card based on faction tag):

- RPGNightmareXL (Iron Penitents) — https://civitai.com/models/182002/rpgnightmarexl
- gothic cathedral interior (Ash-Mourners env) — https://civitai.com/models/1904235/gothic-cathedral-interior
- Dark Gothic Fantasy (Ash-Mourners figures) — https://civitai.com/models/293532/dark-gothic-fantasy
- Swamp people (Coven) — https://civitai.com/models/2134348/swamp-people-sdxlillustrious
- Mythical Forest Style (Coven + Skinward Pact env) — https://civitai.com/models/303030/mythical-forest-style-sdxl
- ArmorSentinel medieval armor style (Last Legion) — https://civitai.com/models/643451/armorsentinel-medieval-armor-style-lora
- Mythical Creatures (Skinward Pact) — https://civitai.com/models/218327/mythical-creatures-lora-15sdxl

Each Civitai page has a "Download" button — log in, click it, drop the `.safetensors` file into `C:\ComfyUI\models\loras\`. Total download ≈ 1.5-2 GB.

**Don't run Step 4 below until all LoRAs are downloaded** — ComfyUI will start fine but generation will fail with "missing LoRA" errors if any are absent.

### Step 4 — Launch ComfyUI

After all downloads finish, copy-paste these three commands one at a time into the same PowerShell window:

```
cd C:\ComfyUI
```

```
C:\ComfyUI\venv\Scripts\Activate.ps1
```

(If PowerShell complains about execution policy when running the activate script, run this once first: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`. Then retry the activate line.)

```
python C:\ComfyUI\main.py --lowvram
```

> **`--lowvram` is required on the RTX 2050.** Standard mode tries to keep the SDXL model resident in VRAM (~8 GB) and will OOM on a 4 GB card. Low-vram mode swaps model layers in and out as needed — slower (~3-5 min/image vs ~60s on a 4090) but functional. If even `--lowvram` OOMs, drop to `--novram` which forces CPU offload of every layer (very slow, last resort). On a beefier laptop, omit the flag.

ComfyUI starts in the terminal and prints `To see the GUI go to: http://127.0.0.1:8188`. Open that URL in your browser.

### Step 5 — Load the Gallowfell workflow

In the ComfyUI browser UI:

1. Click the **Load** button in the right sidebar.
2. Navigate to:
   ```
   C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\pipeline_setup\workflow_gallowfell_card.json
   ```
   …and double-click it.

   _(Alternative: the installer copied this same file to `C:\ComfyUI\user\default\workflows\workflow_gallowfell_card.json` — load from there if browsing through OneDrive paths is awkward in the file picker.)_

3. The workflow loads with our locked sampler / CFG / steps. **Don't change them.**

4. Find the **prompt node** (a yellow rectangle labeled "CLIP Text Encode (Prompt)") — paste the resolved prompt from any spec file in:
   ```
   C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app\art_specs\
   ```

5. Click **Queue Prompt** at the bottom of the right sidebar.

6. First generation takes ~3–5 min (model loads to VRAM). Subsequent ones ~60–90s on your RTX 2050.

---

## Smoke test (verify the install worked)

After ComfyUI launches and you load the workflow, paste this throwaway test prompt:

```
masterpiece, magic the gathering card art, oil painting, painterly,
dark fantasy, single hooded figure in brass execution mask,
upper body portrait, atmospheric blurred background, 8k
```

Negative prompt (the one in the workflow's negative node):

```
anime, cartoon, modern clothing, text, watermark, deformed
```

Queue. If you get a recognisable painterly hooded figure with brass mask — pipeline works. If you get anime, garbage geometry, or it OOMs — paste the error in chat and we'll fix.

---

## What's reproducible from this setup

Once installed, ANYONE who:
1. Has this same install (Juggernaut v9 + the locked LoRA versions),
2. Loads a card's `art_specs/<faction>/<card>.md` file,
3. Uses the workflow JSON in this folder,

…will produce **the exact same image**. That's the whole point. The spec file pins seed + prompt + settings; the workflow pins sampler/CFG/steps; this install pins models + LoRAs.

If we ever change models (e.g. when Juggernaut v10 lands), it's a deliberate choice, logged in `pipeline_spec.md`, and we EITHER pin to v9 forever OR regenerate every existing card with v10 in a coordinated batch. Never silently.

---

## Troubleshooting

**"Out of memory" / OOM during generation:**
- Drop image size to 768×1024 in the workflow (down from 832×1216). Document the override in any spec file you generate at the smaller size.
- Or use the SD 1.5 fallback workflow (`workflow_gallowfell_card_sd15.json`, heartbeat will author once Juggernaut works).

**"Model not found" error:**
- Check the model is in `C:\ComfyUI\models\checkpoints\` with the exact filename listed above.
- Restart ComfyUI after dropping new files into the models folder.

**"CUDA out of date":**
- Update NVIDIA driver via GeForce Experience. Restart laptop. Retry.

**Anything else:**
- Paste the error in chat. Cowork or the heartbeat will diagnose.
