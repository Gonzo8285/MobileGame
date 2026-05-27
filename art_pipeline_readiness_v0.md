# Art Pipeline Readiness — v0

_Authored 2026-05-22 by Controller (round-4 readiness agent). Specs the "ready for real-world graphic testing" state — the runnable build with placeholder OR generated art in every slot — and the three milestones M1 → M2 → M3 that get us there. Source-of-truth references: `IMAGE-GEN-SHOTLIST.md`, `ART_INTEGRATION.md`, `art_direction.md`, `art_specs/`, `tokens_v0.md`, `ui_shotlist_v0.md`._

**Status:** v0. Authored to unblock Paul's "real-world graphic testing soon" pressure.

---

## 1. The asset slot inventory — what the game actually needs

Every slot the game must render in a soft-launch-grade build, counted.

### 1.1 Cards

Per the canonical 5 × 40 = **200 cards** + specials (`internal_mvp_scope.md`, `cards_*_v1.md`).

| Faction | Count | Source doc |
|---|---|---|
| Iron Penitents (P1-P40 + P41 Last Vows) | 41 | `cards_iron_penitents_v1.md` |
| Ash-Mourners (M1-M40) | 40 | `cards_ash_mourners_v1.md` |
| Coven of the Black Mire (C1-C40 + C41 Bog-Bargain Recall + C42 Black Mire Pact) | 42 | `cards_coven_v1.md` |
| The Last Legion (L1-L40) | 40 | `cards_last_legion_v1.md` |
| Skinward Pact (W1-W40) | 40 | `cards_skinward_pact_v1.md` |
| **Subtotal — card heroes** | **203** | |

### 1.2 Bosses

8 chapter bosses (`bosses_v0.md` + `bosses_chapters_2_3_v0.md` + `bosses_chapters_4_to_8_v0.md`):

| Ch | Boss | Notes |
|---|---|---|
| 1 | Black-Bell Choir | spec-complete, art slot owed |
| 2 | Iron Communion | spec-complete |
| 3 | The Saint That Hangs | spec-complete, multi-lane visual |
| 4 | Coven mirror — Mother of Mothers | spec-complete |
| 5 | Inverted Warden (faction-mirrored 5 variants → but 1 art slot, the inversion is mechanical) | 1 slot |
| 6 | Vilrek the Mana-Choked | spec-complete |
| 7 | Court of Twelve Hands (12 sub-figures sharing 1 composition) | 1 slot (group composition) |
| 8 | The Curse-As-Three-Forms (3 phases — 1 composition with 3 stages) | 1 slot (multi-phase frame, art per phase = 3 = treat as 1 slot for M1, 3 for M3) |
| **Subtotal — bosses** | **8 (M1 minimum) — 10 (M3 multi-phase split)** | |

### 1.3 Warlords

**11 Warlord portraits** (10 playable + W11 lore-locked) per `warlords_v1.md` and `IMAGE-GEN-SHOTLIST.md` §4. Already prompt-ready.

### 1.4 Tokens

11 canonical tokens per `tokens_v0.md` §2.1:
- TKN-1 Bog-Spawn, TKN-2 Familiar, TKN-3 Withered Servant, TKN-4 Cub, TKN-5 Wolf, TKN-6 Banner, TKN-7 Brass Hound, TKN-8 Confessor-Familiar, TKN-9 Hempen Witness, TKN-10 Demon-Familiar, TKN-11 Beast.
- **Subtotal — tokens: 11** (some share frames with existing cards — e.g. C1 Bog-Spawn already has art; net new owed = ~7 per `tokens_v0.md` §5).

### 1.5 Status icons / keyword icons

Per `ART_INTEGRATION.md` §2 and `keywords/`:
- 16 keyword icons (Cleave, Pierce, Bleed, Poison, Root, Fear, Shield, Resurrect, Summon, Sacrifice, Penance, Dread, Smoke, Slow, Persist, Taunt)
- 5 stat icons (cost, hp, attack, range, cooldown)
- **Subtotal — icons: 21** (DONE — sourced from game-icons.net CC-BY 3.0, recoloured Gallowfell brass `#c9a24b`, saved as SVG at `game/assets/icons/`)

### 1.6 Faction sigils + faction frames

- 5 faction sigils (S1-S5) + 1 neutral sigil = **6 sigils**. (S1 Iron Penitents authored; S2-S5 owed.)
- 5 faction frames (composite PSD-built) = **5 frames**
- 4 corner-accent sprites per frame × 5 = **20 corner accents** (often reused/symmetric, count as 5-10 unique)
- **Subtotal — faction art: 16-21**

### 1.7 UI icons + buttons (non-keyword)

Per `ui_shotlist_v0.md` + `collection_ui_v0.md`:
- ~30 button/HUD/menu icons (settings, shop, deck, collection, run-end, etc.) — **30 slots**.
- Currency icons (gold, gems, marrow shards, souls, bones) — **5 slots**.
- Battle pass / season pass icons — **8 slots**.
- **Subtotal — UI icons: ~43**

### 1.8 Board / lane backgrounds

5 chapter biome backgrounds per `art_direction.md` §"Biome backgrounds":
- Cathedral Ruins, Catacombs, Bog of Bargains, The Foundry, Cinderwood + Gallows Hill (boss biome) = **6 slots**.
- **Subtotal — board backgrounds: 6**

### 1.9 Event illustrations

Per `events_v0.md`: ~15 event encounters (Shrine of Gallows, Mourner Court, etc.) — **15 slots**.

### 1.10 Splash / title / store screenshots

Per `marketing_screenshots_brief_v0.md`:
- Splash screen / title art — **1 slot**
- Store screenshots (App Store + Play Store) — 5-10 final composites — **10 slots**
- App icon (3 sizes per platform) — **1 source art slot**
- **Subtotal — marketing: 12 slots**

### 1.11 GRAND TOTAL

| Category | Slots |
|---|---|
| Card heroes | 203 |
| Bosses | 8-10 |
| Warlords | 11 |
| Tokens (net new) | 7 |
| Keyword + stat icons | 21 (DONE) |
| Faction sigils + frames | 16-21 |
| UI icons | ~43 |
| Board backgrounds | 6 |
| Event illustrations | 15 |
| Marketing | 12 |
| **TOTAL** | **~342-349 art slots** |

Of which: **~21 done** (icons), **~5 in flight** (faction sigil S1, 11 Warlord prompts authored), **~320 owed**.

---

## 2. Art generation pipeline — what's in flight, what's blocked

### 2.1 What's already in flight

- **RunPod SDXL smoke test (B3.0a)** — single Iron-Penitent flagellant render. Per memory `GFX-1/2 D-VALIDATE-1` this is the gating render before any batch spend. Cost: ~£0.15, ~15-25 min. **STATUS: blocker — has not yet returned a confirmed PEGI-12-clean on-style render to my knowledge.**
- **Card art batch — 200 portraits already staged** at `game/assets/cards/<faction>/<ID>.webp` per `ART_INTEGRATION.md` §1. 512×768 webp q82, ~7.9 MB total. **DONE for 200 of 203 cards.** Missing 3: C41 Bog-Bargain Recall, C42 Black Mire Pact, P41 Last Vows.
- **Icon set — 21 of 27** sourced from game-icons.net (CC-BY 3.0), recoloured Gallowfell brass, saved as SVG.
- **Warlord prompts — 11 authored** in `IMAGE-GEN-SHOTLIST.md` §4 (none yet rendered).

### 2.2 What's blocked, and why

| Asset class | Blocker | What unblocks it |
|---|---|---|
| All batch SDXL renders | B3.0a smoke test acceptance | Paul (or .151 / Cowork) runs the prompt on RunPod and reviews against the 6-point acceptance checklist in `IMAGE-GEN-SHOTLIST.md` §3 |
| Faction sigils S2-S5 | Heartbeat queue (per `ART_INTEGRATION.md` §2) | Bespoke SDXL flat-vector pipeline per `art_specs/_sigils.md`. One sigil per heartbeat cycle. 4 sigils outstanding = 4 heartbeats. |
| C41/C42/P41 card art | Specs not yet authored | Author 3 art specs in `art_specs/coven/` and `art_specs/iron_penitents/` → drop into SDXL batch |
| Boss portraits | Art specs not yet authored | Author 8 boss art specs (currently only prose in `bosses_*.md`) |
| Token portraits (7 owed) | Token .tres files exist for some, art specs absent | Author 7 token art specs |
| Event illustrations | Art specs not yet authored | Author 15 event illustration specs (events_v0.md has prose only) |
| Board backgrounds | `art_direction.md` says "no background art needed for MVP" but soft-launch needs them | Author 6 background specs OR commit to coloured-tinted-tilemap placeholder approach |
| UI icons (~43) | Mixed — some can pull from game-icons.net, custom button shapes need bespoke | Audit: which 30% need bespoke vs which 70% can fetch + recolour |
| Marketing splash / store screenshots | Marketing pipeline runs AFTER game art lands; specs ready in `marketing_screenshots_brief_v0.md` | Lands at M3 — composite of finalised in-game shots |

### 2.3 What Paul needs to do to unblock

**This week (M1 target):**
1. **Run B3.0a smoke test on RunPod** (~£0.15, ~25 min). Approve or kick back per the 6-point checklist.
2. **If approved:** queue the Warlord-portrait batch (11 prompts already authored) as the next batch. ~£3-4 total.
3. **If kicked back:** decide whether to adjust the universal prefix in `IMAGE-GEN-SHOTLIST.md` §2 or swap the JuggernautXL checkpoint (cheap iteration).

**Next 2 weeks (M2 target):**
4. Author 3 missing card art specs (C41/C42/P41) — half a Cowork heartbeat
5. Author 8 boss art specs + 7 token art specs + 6 background specs — 1-2 Cowork heartbeats
6. Run the Warlord + card-heroes + boss + token batch (~225 images) — cost estimate ~£35-50 GPU + ~6 hours wall-time

**Before soft launch (M3 target):**
7. Final QA pass: every slot has a final-quality asset; lighting + palette consistent across factions; passes the 5-point quality bar in §6 below.

### 2.4 Concrete unblock — what Paul should do this week

> **Step 1.** Open RunPod. Spin up the SDXL pod per `pipeline_setup/` README. Use the prompt from `art_specs/iron_penitents/p1_nail_choir_flagellant.md` verbatim. Render 4 seeds. Pick best.
>
> **Step 2.** Open `IMAGE-GEN-SHOTLIST.md` §3 "Acceptance checklist" (6 items). Tick each. If all 6 pass: **post the rendered image to a comms file confirming B3.0a passed**. Cowork picks up the unblock and queues the next batch.
>
> **Step 3.** If any item fails — paste the failing image + the failed item into a comms file. Cowork will adjust prompt / LoRA / checkpoint and retry.
>
> **Expected effort: 1 hour total this week.** Everything else flows from this.

---

## 3. Placeholder strategy — if real art is delayed

**Chosen approach: solid-colour cards with text + faction-frame variant.** This is what's live today (per `ART_INTEGRATION.md` §1's "faction-tint placeholder" fallback in `card_view.gd`).

**Rationale (vs alternatives):**

| Approach | Pros | Cons | Verdict |
|---|---|---|---|
| **Solid-colour faction-tinted card + text** (chosen) | Already in code as fallback. Instant. Free. Reads at-a-glance via faction colour. | Looks "alpha-build". Won't impress in a graphic-test demo to a publisher. | **Chosen for M1.** |
| Stock public-domain images | Free, varied | Aesthetic-inconsistent. Off-brand. Mostly Victorian woodcuts which don't read on a small screen. | Reject. |
| Procedural pixel-art / generative shape | Free, on-brand if styled right | Engineering effort to author a procedural placeholder generator; that's code work, not art | Reject — too much eng cost for a placeholder. |
| AI-generated rough placeholders (FLUX-schnell, 4 sec per image, free local) | Looks like "real" art, even if rough | Risk of slop look. Worse than honest faction-tint. | Reject — confuses what's "real" vs "placeholder". |

**Specification of the chosen placeholder:**
- Card background = solid faction colour from `art_direction.md` palette (oxblood / bruise-purple / bog-green / soot-black / bark-brown for the 5 factions; grave-grey for neutral).
- Card name + cost + stats text rendered in white at the same z-layer as final card-view will use.
- A small monogram glyph (e.g. **P** / **M** / **C** / **L** / **W** / **N** for the 6 categories) where the portrait should be.
- The existing fallback in `card_view.gd` already does this. **No new code needed for M1.**

**Migration path from placeholder → real art:** when a final webp lands in `game/assets/cards/<faction>/<ID>.webp` and Godot imports it, `card_view.gd` automatically reads the `art_path` field. The placeholder shows when `art_path` is empty OR the texture isn't imported yet. **Zero migration effort** per card.

---

## 4. Engine integration — file formats + project tree + tagging

### 4.1 File formats per asset type

| Asset class | Source format (authored) | Engine format (imported) | Sized |
|---|---|---|---|
| Card hero art | PNG-24 RGBA @ 832×1166 | WebP q82 @ 512×768 (already converted, `game/assets/cards/<faction>/<ID>.webp`) | ~38 KB each |
| Faction frame composites | PSD (built from sigil+corner+border) | PNG-24 RGBA @ 832×1166 | per-frame |
| Faction sigils | PNG-24 RGBA @ 96×96 | PNG-24 (Godot 4 imports PNG natively) | ~5 KB each |
| Warlord portraits | PNG-24 RGBA @ 768×768 → 600×600 final | PNG-24 or WebP | ~30 KB each |
| Token portraits | PNG-24 @ 512×768 | WebP q82 | ~25 KB each |
| Keyword + stat icons | SVG (already done) | SVG (Godot 4 native import, rasterises crisp at any size) | ~2 KB each |
| Boss portraits | PNG-24 @ 1024×1024 | WebP q90 | ~60 KB each |
| Board backgrounds | PNG-24 @ 1080×1920 (mobile portrait) | WebP q85 | ~150 KB each |
| Event illustrations | PNG-24 @ 1024×1024 | WebP q85 | ~80 KB each |
| Marketing splash/store | PNG-24 @ platform-specific sizes | PNG-24 (no engine cost — these are external) | platform-dependent |

### 4.2 Project tree

```
game/
├─ assets/
│  ├─ cards/                          # per-faction card heroes
│  │  ├─ iron_penitents/             # P1.webp ... P41.webp
│  │  ├─ ash_mourners/               # M1.webp ... M40.webp
│  │  ├─ coven/                      # C1.webp ... C42.webp
│  │  ├─ last_legion/                # L1.webp ... L40.webp
│  │  └─ skinward_pact/              # W1.webp ... W40.webp
│  ├─ tokens/                        # TKN-2_familiar.webp ... TKN-11_beast.webp
│  ├─ warlords/                      # W1_vyrrun.png ... W11_saint.png
│  ├─ bosses/                        # boss_ch1_black_bell_choir.webp ...
│  ├─ icons/                         # keyword + stat icons (SVG)
│  ├─ frames/                        # faction_iron_penitents.png ...
│  ├─ sigils/                        # sigil_iron_penitents.png ...
│  ├─ ui/                            # button + HUD icons
│  ├─ backgrounds/                   # board_cathedral_ruins.webp ...
│  ├─ events/                        # event_shrine_of_gallows.webp ...
│  └─ marketing/                     # splash.png, store_*.png
└─ data/
   └─ cards/
      ├─ iron_penitents/             # .tres resource files (P1.tres, etc.)
      ├─ ash_mourners/
      ├─ coven/
      ├─ last_legion/
      └─ skinward_pact/
```

### 4.3 Tagging — art file ↔ .tres mapping

Existing pattern (per `ART_INTEGRATION.md` and `pipeline_setup/populate_art_path.py`):

```
# In each card .tres file:
art_path = "res://assets/cards/iron_penitents/P1.webp"
```

The populate script is idempotent. For new art slots:
1. Drop the webp into the correct folder
2. Run `python pipeline_setup/populate_art_path.py`
3. Open Godot once (manual step — generates `.import` sidecars)
4. Commit both `.webp` and `.import` files via courier

For non-card assets (Warlord, boss, background, event), the equivalent fields on the relevant `.tres` resources need authoring — recommend extending the existing pipeline_setup script to handle:
- `warlord.tres` → `portrait_path`
- `boss.tres` → `art_path` + `phase_art_paths: Array[String]` for multi-phase bosses
- `event.tres` → `illustration_path`
- `chapter.tres` → `background_path`

**Engine field additions needed on `.gd` resource scripts:** trivial, ~10 lines total. Out of this session's design-only scope; flagged as engine-team work.

---

## 5. Naming + ID convention — locked

### 5.1 Card art files

`<FACTION>/<ID>.webp` where `<ID>` matches the card's canonical ID (P1, M5, C42, L34, W27). Already locked and live.

### 5.2 Warlord portraits

`warlords/W<n>_<lower_snake_name>.png` — e.g. `W1_vyrrun.png`, `W11_saint.png`. ID matches `warlords_v1.md` numbering.

### 5.3 Boss art

`bosses/boss_ch<n>_<lower_snake_name>.webp` — e.g. `boss_ch1_black_bell_choir.webp`. Multi-phase bosses get `boss_ch8_curse_phase1.webp`, `boss_ch8_curse_phase2.webp`, `boss_ch8_curse_phase3.webp`.

### 5.4 Tokens

`tokens/TKN-<n>_<lower_snake_name>.webp` — e.g. `TKN-2_familiar.webp`. Matches `tokens_v0.md` registry IDs.

### 5.5 Backgrounds

`backgrounds/board_<biome_lower_snake>.webp` — e.g. `board_cathedral_ruins.webp`, `board_gallows_hill.webp`.

### 5.6 Events

`events/event_<lower_snake_name>.webp` — e.g. `event_shrine_of_gallows.webp`.

### 5.7 UI icons

`ui/icon_<purpose>.svg` (or `.png` if rasterised) — e.g. `icon_settings.svg`, `icon_currency_gold.svg`.

### 5.8 Faction frames + sigils

`frames/faction_<faction_lower_snake>.png` and `sigils/sigil_<faction_lower_snake>.png`.

### 5.9 Marketing

`marketing/splash_<platform>.png` (`splash_ios.png`, `splash_android.png`), `marketing/store_<platform>_<n>.png` (`store_ios_1.png` ... `store_ios_6.png`).

**Lock:** all naming locked in this doc. Any future asset that doesn't fit one of these patterns → flag for a naming-convention extension before authoring.

---

## 6. QA process — 5-point quality bar

A generated/placeholder art slot is "good enough to ship" if it passes **all 5** of the following:

| # | Check | Method |
|---|---|---|
| 1 | **On-style** — recognisably MTG-painterly oil, low-key lighting, doomed-grandeur aesthetic per `art_direction.md`. Not anime, not cartoon, not cel-shaded. | Visual side-by-side vs anchor reference (P1 Nail-Choir Flagellant once B3.0a passes). 2/3 reviewer consensus. |
| 2 | **On-palette** — uses the faction palette (oxblood + dull iron + candle-yellow for Penitents, etc. per `faction_bible.md`). No off-palette colour-dominance. | Eyedropper check on 3 areas of the image; >70% pixels fall in the faction palette. |
| 3 | **PEGI-12 clean** — no fresh blood, no exposed organs, no children, no sexual content, no NSFW. Per `IMAGE-GEN-SHOTLIST.md` §3 negative prompt. | Manual review against the negative prompt list. Single blocker = redo. |
| 4 | **Readable at thumbnail size** — recognisable subject + faction silhouette at 100×150 px (the gameplay thumbnail size). | Resize to 100×150, view at 100% zoom. If subject indistinguishable from a Coven card vs a Penitents card at thumbnail, fail. |
| 5 | **Frame-fit** — composition leaves the subject inside the centre rectangle (56, 220, 720, 800) where the frame won't overlay it. | Overlay the faction frame PSD on top. Subject not occluded by frame elements. |

**Process:**
- Per-batch QA review at the end of each render batch (~50 renders).
- 2 reviewers sign off (Paul + Cowork-as-reviewer is fine for now; eventually a real artist-pass).
- Fail = redo with adjusted seed or prompt. Cap 3 redos per slot before escalating to "needs manual art" status.

---

## 7. Three acceptance milestones

### M1 — Placeholder ship (target: this week)

**Definition:** every slot has at least a coloured-block-with-text placeholder; the game is fully playable end-to-end with no missing-asset errors.

**Status today:**
- ✅ 200/203 card slots have placeholder (faction-tint fallback in `card_view.gd`)
- ✅ 21/27 icons done
- ⚠️ Warlord portraits — currently missing. Placeholder = faction-tinted square with Warlord initial. Need 1 line of code-change to ensure Warlord views also fall through to a placeholder. **BLOCKER for M1.**
- ⚠️ Boss portraits — currently missing. Same placeholder pattern needed. **BLOCKER for M1.**
- ⚠️ Backgrounds — currently a flat gradient. Acceptable for M1.
- ⚠️ Event illustrations — currently missing. Placeholder = solid colour with text title. **BLOCKER for M1.**
- ✅ UI icons — partially done

**Acceptance test:** play a full run from Warlord-select → 8 combats → boss → victory screen. **No "?" or "missing texture" errors anywhere.**

**Effort to hit M1:** 1 Cowork heartbeat (extend `card_view.gd` placeholder pattern to Warlord/Boss/Event views) + Paul running B3.0a smoke. ~2 days wall-time.

### M2 — Generated art ship (target: 3-4 weeks from now)

**Definition:** ≥80% of slots have generated art that passes the 5-point bar. Remaining ≤20% may still be placeholder but visually compatible (same palette, same dimensions).

**Acceptance test:**
- All 203 cards: ≥162 with generated art (80% of 203)
- All 11 Warlords: 11 with generated art (100%)
- All 8 bosses: ≥6 with generated art (75%, rounded down — bosses are higher-stakes; allow 2 placeholder)
- All 7 owed tokens: ≥5 with generated art
- All 6 backgrounds: ≥4 with generated art OR all 6 with a procedural tinted-tilemap fallback
- All 15 events: ≥10 with generated art

**Effort to hit M2:** 2-3 Cowork heartbeats authoring missing specs + 1 RunPod session (~£40-50 spend) + 1 QA pass.

### M3 — Polished ship (target: soft launch -2 weeks)

**Definition:** 100% slots covered; lighting/colour consistent across factions; passes the 5-point bar everywhere.

**Acceptance test:**
- Every slot in §1.11 has a final asset
- A "thumbnail-sheet review" — every card thumbnail tiled at 100×150 → no jarring outliers
- A "palette-sheet review" — every faction's cards together → palette holds
- Marketing splash + store screenshots composited from final game art

**Effort to hit M3:** 1 final RunPod top-up render for misses + 1-2 days of asset polish + marketing composite.

---

## 8. What Paul needs to do this week to hit M1

1. **Run the B3.0a smoke test on RunPod.** Use `art_specs/iron_penitents/p1_nail_choir_flagellant.md` verbatim. ~25 min, ~£0.15. Tick the 6-point acceptance checklist in `IMAGE-GEN-SHOTLIST.md` §3.
2. **Post the result** (image + checklist result) to the comms folder. If pass → Cowork queues the next batch. If fail → paste the failing item; Cowork tunes and re-prompts.
3. **Authorise Cowork to extend the placeholder pattern** in `card_view.gd` to Warlord / Boss / Event views (1 heartbeat of work via `.151` or Claude Code). This closes M1.

**That's it.** ~1 hour of Paul time. Everything else is Cowork/.151 throughput.

**If Paul can't run B3.0a personally this week:** hand it to `.151` via the heartbeat queue. The smoke test is in the FF lock-released non-FF backlog per `feedback_controller_lane.md` — fair game for the interactive seat once FF is on cruise.

---

## 9. Cross-references

- `IMAGE-GEN-SHOTLIST.md` — full shotlist + prompts + B3.0a acceptance
- `ART_INTEGRATION.md` — current integration state (200 cards staged, 21 icons done)
- `art_direction.md` — visual style bible
- `art_specs/_template.md` — per-asset spec template
- `art_specs/iron_penitents/p1_nail_choir_flagellant.md` — B3.0a subject
- `tokens_v0.md` — token registry (sources the 11 token slots)
- `bosses_*.md` — boss content (sources the 8 boss slots)
- `events_v0.md` — event content (sources the 15 event slots)
- `marketing_screenshots_brief_v0.md` — marketing-side asset spec
- `CANON_PATCHES_APPLIED_2026-05-22.md` — recent canon stabilisation; no art impact

— Controller round-4, 2026-05-22
