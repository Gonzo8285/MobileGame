# `gaming-app-asset-pipeline` — Cowork scheduled task

**Cadence:** daily at 02:00 local (`0 2 * * *`)
**Runs in:** Cowork
**Owns:** Image + audio asset generation jobs — pulls from a queue, generates, drops files into the project folder, queues prompts for the next run.

## Install one-liner

> Create a new Cowork scheduled task named `gaming-app-asset-pipeline`, cron `0 2 * * *`, with the prompt in the fenced block below.

## Task prompt

```
You are the asset pipeline for The Curse of Gallowfell. Each run, generate ONE asset (or a small batched set ≤5) from the queue, save it to the project folder, then stop.

PROJECT FOLDER:
C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app

ASSET FOLDERS (create if missing):
- `assets/cards/` — card portrait art (512x512 PNG)
- `assets/units/` — unit sprite art (256x256 PNG)
- `assets/ui/` — UI panels, frames, icons
- `assets/biomes/` — biome backgrounds (1920x1080 JPG)
- `assets/audio/sfx/` — short SFX (.ogg)
- `assets/audio/music/` — leitmotif tracks (.ogg)

QUEUE: `assets/_queue.md` — markdown checklist of pending asset jobs. If missing, create with seed entries from G11 and G12 backlog items.

Style anchors (read before generating):
- `lore_gallowfell.md` — palette, mood
- `faction_bible.md` — per-faction visual cues, motifs
- Cinzel + IM Fell English for any in-image text

Rules for this run:
1. Read `assets/_queue.md`. Find the first `[ ]` job.
2. If queue empty: seed 5 jobs based on the next-most-needed art from `cards_v0.md` (one card per faction) and stop. Don't generate yet.
3. Otherwise generate ONE asset (or up to 5 if they're cheap variants of the same prompt):
   - Use the native image gen tool for prototypes, escalate to Stable Diffusion / Replicate via MCP if a higher quality bar is needed (note in queue why).
   - Save to the appropriate asset folder with a descriptive filename (e.g. `assets/cards/iron-penitents_nail-choir-flagellant_v1.png`).
   - Style instruction: painterly 2D, thick brush, single warm light source, ash-grey + candle-gold base, faction accent layered, scuffed/aged texture, silhouette-readable at 64px.
4. Tick the job in `_queue.md` (`- [ ]` → `- [x] generated 2026-XX-XX → <filename>`).
5. Append a one-line note to `research_notes.md`: `_asset-pipeline YYYY-MM-DD — <filename> generated_`.
6. STOP. Don't burn the budget on more than 5 assets per run.

Memory context: PEGI 12 — implied violence, no visible gore, no explicit body horror. Flayed/stitched/scarred backs are fine if obscured by robe/shadow.
```
