# AI art pipeline spec — The Curse of Gallowfell

_Authored 2026-05-02 by Cowork. The single source of truth for how Gallowfell art is generated. Locks the pipeline so every image — past, present, future — is reproducible from a card's design-spec file alone. Drives B3 art generation. Lives next to `art_direction.md` (the visual taste lock-in)._

> **Reproducibility rule** (the whole point): given the card-spec file (`art_specs/<faction>/<card_id>.md`) and the pipeline as defined in this document, anyone (or any heartbeat, or any future me) must be able to regenerate the exact same image. **No exceptions, no off-pipeline tweaks.** If a card needs a different prompt, change the spec file. If a faction needs a different style, change this doc. Single source of truth.

---

## 1. Architecture — local + cloud, two-tier

**Tier 1 — local iteration (Paul's RTX 2050, 4GB VRAM).** ComfyUI on his laptop. Free, instant, used for: concept exploration, prompt iteration, A/B testing, idle-loop frame variation. Slow but zero-cost-per-image.

**Tier 2 — cloud finals (RunPod or Replicate).** Same ComfyUI workflow, run on a beefier GPU (24GB A5000 or H100). Used for: final card art at full resolution, batch generation of the ~500-card library, alt-art variants. Pay-per-second.

**Why both:** local iteration loop is critical for taste (instant feedback), but local 4GB VRAM caps quality at SDXL-medvram or SD 1.5 native. Cloud unlocks SDXL-full / Flux Dev for the finals. Same ComfyUI workflow JSON runs on both — the only difference is which checkpoint loads.

**Cost model (estimated):**
- Local: ~30-60s per image at SD1.5, ~90-120s at SDXL-medvram. Free.
- Cloud (RunPod RTX A5000 24GB at $0.34/hr): ~5s per SDXL image = ~$0.0005/image. 500-card batch ≈ **$2.50 total**.
- Cloud (Replicate FLUX Dev): $0.025/image. 500-card batch ≈ **$12.50**.

Pipeline cost is essentially zero. The expensive thing is taste iteration time, which is why local Tier 1 matters.

---

## 2. Model + LoRA stack — locked

### 2.1 Base checkpoint

**Primary: `juggernautXL_v9` (SDXL fine-tune)**. Best painterly fantasy output among the open-weight SDXL family. Strong at MTG-painterly oil-paint aesthetics, dark moods, atmospheric backgrounds.
- Civitai: https://civitai.com/models/133005
- Local: SDXL-medvram on 4GB → slow but works. Use Q5 GGUF quant if the base FP16 weights blow VRAM.
- Cloud: full FP16 on A5000+.

**Fallback: `realisticVisionV60_v60B1` (SD 1.5)**. Used only when Juggernaut OOMs on Paul's GPU during iteration. Lower quality but ~3× faster. Same prompt language transfers cleanly.

### 2.2 LoRA stack (resolved 2026-05-04 by heartbeat D-LORA-1 — see `pipeline_setup/loras_resolved.md` for substitution rationale)

**Style LoRAs (apply to ALL Gallowfell art):**
- `ClassipeintXL` v2.1 @ 0.8 — oil-paint style with painter-name-mixing support; substitutes the original `mtg-style-sdxl` slot (no MTG-named SDXL LoRA exists publicly — WotC IP). Civitai 127139.
- `Dark Fantasy LORA` v1 @ 0.8 — explicit dark-fantasy-oil-paintings training. Trigger phrase `Dark Fantasy`. Civitai 932379.
- `Elden Ring Style` v1.0 @ 0.5 — exact match to original spec. Civitai 457103. **Cap at 0.5; don't overdrive.**

**Faction-specific LoRAs (optional, layer at 0.4-0.6 on top of style LoRAs):**
- Iron Penitents: `RPGNightmareXL` v1.0 @ 0.4 — body-horror RPG aesthetic. Civitai 182002. **Cap at 0.4 for PEGI 12.**
- Ash-Mourners: `gothic cathedral interior` v1.0 @ 0.6 (Civitai 1904235) + `Dark Gothic Fantasy` 3.01 @ 0.5 (Civitai 293532). The Halloween-Victorian-Gothic-Horror LoRA is Flux-only — rejected.
- Coven of the Black Mire: `Swamp people` @ 0.5 (Civitai 2134348) + `Mythical Forest Style [SDXL]` @ 0.5 (Civitai 303030, trigger `ral-mytfrst`). Lorwyn-named LoRAs do not exist publicly — substituted Mythical Forest. Optional `Witch Style` @ 0.4 (Civitai 262925, trigger `ral-wtchz`).
- The Last Legion: `ArmorSentinel medieval armor style` v2 @ 0.6 (Civitai 643451). Elden-Ring-knight axis covered by Style #3 already in the stack.
- Skinward Pact: `Mythical Forest Style [SDXL]` @ 0.5 (shared with Coven, Civitai 303030) + `Mythical Creatures` SDXL @ 0.5 (Civitai 218327). No clean nordic/pagan SDXL LoRA exists — antler-crown / hide-cloak look driven prompt-side via §3.2.

**Open follow-ups** (deferred to next heartbeats / Phase 4 legal pass): per-LoRA license audit, trigger-word capture, exact-version pinning, backup-LoRA verification. See `pipeline_setup/loras_resolved.md` §"Next heartbeat".

### 2.3 Sampler + steps + CFG (locked, never deviate)

| Parameter | Value | Rationale |
|---|---|---|
| Sampler | DPM++ 2M Karras | Cleanest detail at moderate step counts |
| Steps | 30 | Sweet spot quality/time for SDXL |
| CFG | 6.5 | High enough for prompt adherence, low enough to avoid burn |
| Width × Height | 832 × 1216 | 0.685 ratio (matches our card portrait) |
| Refiner | none | Adds time without meaningful improvement on this LoRA stack |
| Clip skip | 2 | Standard for fine-tuned SDXL anime/fantasy checkpoints |

These are LOCKED. Changing them = changing the look = breaking reproducibility for every prior card. If we need to deviate, the deviation goes on the per-card spec file, not the master pipeline.

---

## 3. Prompt template — master architecture

Every Gallowfell card prompt is composed of FIVE concatenated layers, in fixed order:

```
{global_style} + {faction_style} + {subject_description} + {composition} + {quality_tags}
```

### 3.1 Global style (same for every card)

```
masterpiece, magic the gathering card art, oil painting, painterly,
photographic depth, low-key lighting, cinematic, atmospheric,
dark fantasy, grimdark, gallows-haunted mood, doomed grandeur,
muted earth-tone palette, single accent colour focal,
in the style of Steve Argyle and Volkan Baga
```

### 3.2 Faction style (one of five, fixed per card faction)

**Iron Penitents:**
```
brass execution-mask iconography, hooded zealot, flagellant chains,
phyrexian-adjacent body-horror (implied not explicit), rust-red accent,
hammer and rope motif, religious dread, ash-and-cinder background
```

**Ash-Mourners:**
```
gothic-cathedral funerary aesthetic, court-shroud robes, ink-stained hands,
raven-quill flourishes, no-shadow figures, dusk-purple accent,
catacomb-vault background, Victorian mourning sensibility
```

**Coven of the Black Mire:**
```
swamp-witch silhouette, demon-coin wreaths, three-shadows-cast,
green pyre eyes, briar-tangled cloak, lorwyn-folkloric grotesque,
bog-green accent, fungal-grove background
```

**The Last Legion:**
```
soot-blackened cuirass, brass officer gorget, ironwood baton,
chain-bound hair, foundry-rivet armour, decayed-knight elden-ring scale,
brass accent, smoke-and-coal background
```

**Skinward Pact:**
```
antler-crown sprouting through bone, hide cloak layered, mismatched eyes,
smoke-trailing fingers, druidic shaman with phyrexian undertones,
bark-brown accent, cinderwood-grove background
```

### 3.3 Subject description (per card — lives in the card's spec file)

Free-text card-specific anchor, max ~30 words. Pulls from the existing `cards_<faction>_v1.md` files where each card has a description. Examples:

- Vyrrun: `"led a flagellant column from cathedral ruins, believing he bleeds answers from the gallows-tree, monarchy-era execution mask in tarnished brass, hooded, flayed back showing scar-runes"`
- Sieren: `"last court mage of the dying Monarchy, signs death-warrants in her own blood for forty years, the warrants now sign back, ink-stained fingers, raven quill, no shadow"`
- Eddra: `"bartered her firstborn for the swamp's name, thirteenth body wears all the others, hunched, wreath of demon-coins, three teeth, three shadows"`

### 3.4 Composition (locked, same for every unit/character card)

```
upper body portrait, three-quarter pose, looking-into-camera,
single focal figure dominating frame, atmospheric blurred background,
volumetric haze, no text overlay, no logo, no watermark
```

For BACKGROUND/landscape/event cards, swap with:
```
wide establishing shot, no central figure, environment-led,
moody composition, painterly atmospheric perspective
```

### 3.5 Quality tags (always last)

```
extremely detailed, sharp focus, professional, intricate brushwork,
volumetric lighting, oil-paint texture visible in highlights,
8k, hyper-detailed, masterpiece quality
```

### 3.6 Negative prompt (locked baseline — never deviate)

```
anime, cartoon, cel shaded, disney, pixar, chibi, kawaii,
clean fantasy, bright saturated colours, oversaturated,
modern clothing, modern weapons, anachronisms,
text, watermark, signature, logo, frame, border, UI elements,
3d render, plastic, smooth skin, airbrushed, photoreal-realistic,
explicit gore, severed limbs, exposed organs, blood pools,
deformed hands, extra fingers, extra limbs, malformed face,
blurry, low quality, jpeg artifacts, low resolution
```

PEGI-12 cap is enforced through the negative prompt (`explicit gore, severed limbs, exposed organs, blood pools`). Body horror (Phyrexian-style implication) survives because it's textually framed as "implied not explicit" in faction styles.

---

## 4. Per-card spec format

Every card / character / boss has ONE markdown spec file: `art_specs/<faction>/<card_id>.md`. The file is the single thing that drives generation — it pins prompt, seed, model, output. Reproducible forever from that spec alone.

See `art_specs/_template.md` for the format. Worked example: `art_specs/iron_penitents/example_vyrrun.md` (heartbeat populates).

---

## 5. Reference-sheet validation — two-stage commit point

Before generating ANY production art, run this two-stage validation. Stage A locks **faction-aesthetic anchors** via the 5 free Warlords — these become the reference points every subsequent batch (commons, tokens, spells, alt-art treatments, future Warlords, future bosses) is judged against. Stage B then confirms the locked anchors hold up at the composition + thumbnail + atmospheric-spell axes the Warlord portraits don't exercise.

Total GPU time across both stages: ~25-35 min. Stage A is the cheaper commit (5 tiles, ~15 min) — if Stage A fails the validation checklist, regenerate the failing Warlord(s) BEFORE running Stage B. Don't burn pod time on commons against an unlocked anchor.

### Stage A — Warlord-anchor sheet (5 tiles, faction reference lock)

| Tile | Card | Faction | What this anchor locks |
|---|---|---|---|
| A1 | Penance-Captain Vyrrun (W1) | Iron Penitents | Rust-red palette, brass execution-mask top-arch motif, flagellant/MTG-painterly readability |
| A2 | Court-Necromant Sieren (W2) | Ash-Mourners | Dusk-purple palette, Liliana-of-the-Veil tone, court-shroud + raven-quill motif, atmospheric haze |
| A3 | Marsh-Mother Eddra (W3) | Coven of the Black Mire | Bog-green palette, Lorwyn folkloric-grotesque without crossing cute, three-shadows-cast motif |
| A4 | Forge-Marshal Veska (W4) | The Last Legion | Brass palette, Elden Ring decayed-knight scale, foundry-rivet armour, smoke-and-coal background |
| A5 | Tree-Walker Mhar (W5) | Skinward Pact | Bark-brown palette, druidic-with-phyrexian-undertones, antler-crown-through-bone, cinderwood-grove |

**Anchor validation checklist** (Paul + Cowork co-review when Stage A renders):

- [ ] Do all 5 read as the same game? (Cross-faction coherence: same brushwork era, same painterly density, same atmospheric depth)
- [ ] Do faction palettes separate cleanly? Rust-red ≠ brass ≠ bark-brown without bleed; dusk-purple ≠ bog-green even at thumbnail.
- [ ] Does each Warlord lock the faction's visual vocabulary clearly enough that a future common can be judged against it? (The test: could you describe "looks like a Vyrrun-faction card" to a contractor and they'd know what palette + motif + tone to hit?)
- [ ] Body-horror tolerance — does Phyrexian undertone (Mhar, Eddra) and rope-mark-as-iconography (future W11) hold without crossing PEGI 12?
- [ ] Composition tier — does the focal figure dominate? Painterly oil texture readable as oil, NOT as 3D render or anime.
- [ ] Brushwork — visible brush strokes, MTG-painterly density, NOT smooth gradient-render.

**If yes to all → lock the 5 anchors. Save them to `art/warlords/` AND copy to `art_specs/_anchors/` as the canonical faction reference. Proceed to Stage B.**
**If no to any → identify which Warlord (or axis) failed, modify the relevant section of THIS doc, regenerate the failing tile only. Do NOT proceed to Stage B until all 5 anchors are signed off.**

### Stage B — Common-card supporting sheet (4 tiles, post-anchor validation)

Runs ONLY after Stage A anchors are locked. Tests whether the pipeline produces commons / spells / tokens that look like they belong in the world the anchors established.

| Tile | Card | Faction | What this tile tests against anchors |
|---|---|---|---|
| B1 | Cathedral Brother (P1 unit) | Iron Penitents | Lowest-cost common — does it read at 200×280 thumbnail size AND look like it belongs to Vyrrun's faction? |
| B2 | Self-Scourge (P spell) | Iron Penitents | Spell-card composition (environment-led, no central figure) — does the Penitents palette still anchor it? |
| B3 | Pall-Bearer (M unit) | Ash-Mourners | Smoke-leaving unit — does the atmospheric haze read against Sieren's locked tone? |
| B4 | Bog-Spawn (C1 token) | Coven | Lowest-tier 0-cost token — "ugly little creature" without making it cute, against Eddra's grotesque vocabulary |

**Stage-B validation checklist:**

- [ ] Does each tile sit inside its faction's locked anchor vocabulary? (Hold the anchor PNG next to the new tile — same palette, same brushwork, same atmospheric density.)
- [ ] At thumbnail size (200×280 px), are commons distinguishable from each other AND from their faction's Warlord?
- [ ] Does the spell-card composition (no central figure) hold the faction palette as authoritatively as a unit composition does?
- [ ] Does the token-tier "ugly creature" register as ugly without crossing cute or crossing the PEGI 12 line?

**If yes to all → pipeline is locked, both Resource-shape and aesthetic. Batch-generate the full faction pools.**
**If no to any → the anchor and the common DISAGREE. Identify whether the anchor needs tightening (re-run Stage A for that faction) or the prompt scaffold for commons needs adjusting (modify §3.3 / §3.4 of this doc).**

### Why two stages, not nine tiles in one batch

Pulled forward by Paul 2026-05-11: Warlord-anchor priority. Reasoning: in MTG / Hearthstone / League, the legendary/hero art is the visual vocabulary the rest of the set is judged against. If we render 9 mixed tiles and the Warlords land soft, the commons land harder — and we've burned the validation pass on a sheet that can't tell us "fix the Warlord" vs "fix the common pipeline". Two-stage forces the question into the right order: lock the anchor first, then judge the common against it.

---

## 6. Output naming + storage

```
art/                                # final card art lives here
  iron_penitents/
    P1_cathedral_brother.png
    P25_penance_captain_vyrrun.png
  ash_mourners/
    M5_pall_bearer.png
    sieren_court_necromant.png
  ...

art_iterations/                     # iteration outputs, one folder per spec
  P25_penance_captain_vyrrun/
    seed4242_v1.png
    seed4242_v2_rerolled.png
    seed8989_v1.png

art_specs/                          # the source-of-truth spec files
  iron_penitents/
    P25_penance_captain_vyrrun.md
  ...
```

Convention: `<card_id>_<lower_snake_card_name>.png`. Card-id-first means alphabetical sort = faction-grouped.

---

## 7. Reproducibility rules — DO NOT BREAK

1. **No off-pipeline tweaks.** If the in-engine art needs a change, change the spec file and regenerate. Never paint over an output, never crop, never colour-correct manually. (Exception: B3.3 "polish pass" if/when we hire a human artist for boss-tier cards. Their work is one-off and lives in `art_overrides/`, never in `art/`.)

2. **Pin every parameter.** Every spec file lists: prompt, negative prompt overrides, seed, sampler, steps, CFG, model checkpoint version, every LoRA name + weight. If ComfyUI updates a LoRA, we either pin to the old version OR regenerate every card that used the old weights AND log it.

3. **Log all generation runs.** ComfyUI auto-saves a metadata JSON next to every PNG. Keep it. Never delete iteration outputs without confirming the spec file captures everything needed to recreate.

4. **One change at a time.** When iterating, change ONE thing per generation (one prompt phrase, one LoRA weight, one seed). Anything else makes regression analysis impossible.

5. **Heartbeat must follow this doc.** No autonomous deviation. If the heartbeat thinks the pipeline needs to change, it adds a flagged proposal to `pipeline_spec_proposals.md` (creating it if needed) and waits for Paul to approve before editing this doc.

---

## 8. Setup kit (one-time, Paul executes)

Concrete install instructions live at `pipeline_setup/README.md`. Steps Paul runs once on his laptop:

1. Install Python 3.11 (NOT 3.12 — ComfyUI is finicky).
2. Run `pipeline_setup/install_comfyui_windows.bat`.
3. Download `juggernautXL_v9` checkpoint from Civitai (URL in README).
4. Download the LoRA stack (URLs in README).
5. Drop the workflow JSON into ComfyUI's `user/default/workflows/`.
6. Test: load workflow → set prompt to test text → queue prompt. If image generates, pipeline is live.

Heartbeat task: keep the README up to date, verify URLs still work, escalate if Civitai changes API or models get yanked.

---

## 9. Heartbeat task plan (autonomous setup + per-card spec population)

The heartbeat sandbox can't actually RUN ComfyUI (no GPU). What it CAN do:

- **Verify model + LoRA URLs work** — quick HTTP HEAD on each Civitai URL. If 404, search for replacement, document.
- **Author the per-card spec files** — one heartbeat per faction. Reads `cards_<faction>_v1.md` + `warlords_v1.md` + `lore_gallowfell.md`, generates one `art_specs/<faction>/<card_id>.md` per card following the template. ~40 cards per faction × 5 factions = ~200 specs total. Plus 11 Warlords + ~5 enemies + bosses = ~220 specs total.
- **Cross-check every spec against this pipeline doc** — confirm prompts use the locked prefix/postfix layers, confirm faction style strings match exactly, confirm seeds are deterministic.
- **Author one ComfyUI workflow JSON variant** — base card, alt-art, idle-loop frame variant, treatment-shader compatibility. JSON is structured, sandbox can author.

Backlog Phase 2.11 captures these as discrete heartbeat-sized chunks (see `backlog.md` after this doc commits).

---

## 10. Open questions (Paul resolves before first generation run)

1. **Cloud provider for Tier-2 finals** — RunPod (cheapest, requires Linux comfort) vs Replicate (most expensive but zero-config). Defer until Tier-1 local works. Recommend: RunPod ($2.50 per full batch vs Replicate's $12.50).
2. **Boss-tier override budget** — bosses like the Saint That Should Not Hang would benefit from human-illustrator commission rather than pipeline output. ~$50-150 per illustration on ArtStation. Five bosses = ~$500. Include in launch budget? Defer.
3. **Idle-loop frame variation method** — controlled-variation through ComfyUI (re-roll same seed +1 with small prompt tweak) OR post-process via Photoshop ribbon-tool? Recommend: ComfyUI controlled-variation. Reproducible.
4. **License audit on LoRAs** — most Civitai LoRAs are CC-BY-NC or worse for commercial work. Need to vet license per LoRA before commercial release. Deferred to Phase 4 legal pass.
