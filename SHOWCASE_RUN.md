# Showcase batch — 12 tiles for show-and-tell

_Authored 2026-05-12 by Cowork. Updated when the run completes._

## What this is

12 SDXL-rendered Gallowfell tiles for showing people the visual direction. Mix:
- 5 free Warlord anchors (Vyrrun / Sieren / Eddra / Veska / Mhar)
- 5 faction-hero commons (one canonical card per faction)
- 2 environment wides (The Black Bell, Banner of the Last Hour)

**Not** the canonical D-VALIDATE-1 anchor pass — that runs the full 10-LoRA stack
once you've signed off on smoke aesthetics. This batch is base juggernautXL + heavy
prompt-side targeting. Cheaper, faster, good enough to show people.

## Cost expectation

| Item | Estimate |
|---|---|
| Pod cold-start + checkpoint download | ~7 min one-time |
| Per-tile generation on RTX 4090 | ~1.5 min |
| Total pod uptime | ~25 min |
| Cost @ £0.39/hr | **~£0.16** |
| Hard cap (auto-terminate) | 75 min / £0.49 |

The pod auto-terminates the moment the batch finishes (or hits the cap). No risk of
a forgotten pod burning credit overnight.

## What you do (one command)

Open Claude Code on your laptop, then in the project folder run:

```
python3 pipeline_setup/runpod_showcase_batch.py
```

Tail the log in a second terminal if you want to watch progress:

```
tail -f pipeline_setup/.showcase_batch_status.log
```

The script:
1. Reads `secrets/runpod_api_key.txt`
2. Deploys an RTX 4090 community pod (falls back to A5000 / A4000 if no capacity)
3. Waits for ComfyUI to boot
4. Loops through `pipeline_setup/showcase_manifest.json` — 12 tiles
5. Saves PNGs to `art_iterations/_showcase/{warlords,commons,environments}/`
6. Terminates the pod

If any single tile fails, the rest of the batch still runs. Failures print at the
bottom of the log so you can re-queue them alone.

## Output layout (after a successful run)

```
art_iterations/_showcase/
├── warlords/
│   ├── w1_penance_captain_vyrrun_seed14242.png
│   ├── w2_court_necromant_sieren_seed24242.png
│   ├── w3_marsh_mother_eddra_seed34242.png
│   ├── w4_forge_marshal_veska_seed44242.png
│   └── w5_tree_walker_mhar_seed54242.png
├── commons/
│   ├── p1_nail_choir_flagellant_seed40101.png
│   ├── m1_mourning_acolyte_seed50101.png
│   ├── c1_bog_spawn_seed60101.png
│   ├── l1_forge_spark_skirmisher_seed70101.png
│   └── w1_pelt_gathered_hunter_seed80101.png
└── environments/
    ├── m39_the_black_bell_seed53939.png         (landscape 1216×832)
    └── l40_banner_of_the_last_hour_seed74040.png (landscape 1216×832)
```

All tiles are 832×1216 portrait except the two environments which are 1216×832
landscape (better for slide decks / cover-art use).

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `FATAL: API key not found` | secrets/ folder not synced | Verify `secrets/runpod_api_key.txt` exists |
| `No capacity for NVIDIA GeForce RTX 4090` | Community 4090s busy | Script auto-falls back — wait through the messages |
| `Pod did not reach RUNNING` | Pod stuck or template changed | Visit https://console.runpod.io/pods, terminate manually, retry script |
| `ComfyUI did not respond` | First-boot delay | Re-run — sometimes the proxy takes 30s longer than expected |
| Single tile fails mid-batch | Transient | Script logs the failure + keeps going. Re-run the script after — it'll regenerate everything, or you can edit `pipeline_setup/showcase_manifest.json` down to just the failed tile_id |

## After it runs

When the log says `=== Batch complete: 12 ok, 0 failed ===`, the PNGs are on your
laptop. Send them, pitch them, or kick a heartbeat my way and I'll do a Cowork-side
review pass (faction palette, body-horror tolerance, brushwork) before any tile goes
into a deck.

## Why no LoRA stack on this batch

The single existing smoke tile (Iron Penitent, 2026-05-10) was generated on base
juggernautXL with a short prompt and looked good. The 10-LoRA pipeline_spec stack
adds aesthetic specificity (faction-coded palettes, painter-style targeting) but
costs ~20-50 min of LoRA download time per fresh pod. That uplift belongs to the
canonical D-VALIDATE-1 pass, not a "show people something today" batch.

If the output here is muted compared to what you want, the next step is:
1. Sign off on base aesthetic (`# Phase 2 sign-off — base SDXL look approved`)
2. Cowork wires the LoRA-loader chain into the workflow + adds an install-LoRAs step
3. D-VALIDATE-1 Stage A fires the canonical 5-Warlord anchor pass

Until then, this batch is the cheap fast win.
