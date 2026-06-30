# ULTRACODE WORK ORDER — Gallowfell mobile card game

**Issued:** 2026-06-25 by Controller, on Paul McCann's direct authority.
**Executor:** Claude Code ("Ultracode") on the persistent shell that owns `Gonzo8285/MobileGame`.
**Mode:** Unattended, autonomous, full-permissions. Run the whole queue to completion. Do not wait for Paul.

---

## 0. AUTONOMY MANDATE — read this first

Paul has authorised this run to execute **without seeking approval for any step**. Specifically:

- **You have full permission to act.** Author code, create branches, commit, open and **merge your own PRs**, run tests, run the GPU render pipeline, restructure files, and push to `Gonzo8285/MobileGame` — all without checking in first. Reversible work never needs a sign-off.
- **Never idle waiting for Paul.** If the item you're on stalls, is blocked, or needs a decision Paul hasn't given, **do not stop** — drop it, log the blocker (see §8), and pull the next item from the queue. There is always more backlog to work. The only acceptable reason to be idle is the entire queue is genuinely complete.
- **Pick a sensible default and proceed.** Where a spec leaves a small choice open, choose the option most consistent with the existing code and the design docs, note the choice in the commit body, and move on. Don't manufacture a blocker out of a decision you can reasonably make yourself.
- **Scope of this run (Paul's call, 2026-06-25): EVERYTHING in the backlog.** Player-facing screens, engine fixes, balance sim, the GPU art track, the commercial-loop P0 specs (Shop / Season Pass / Upgrade / Variants), and the remaining design infill. Work the priority order in §6 top-down.
- **GPU spend is authorised.** You may spin up RunPod pods to render the owed art and run the validation pass (~£0.25–0.50 per run). See Track D.

The hard limits that still apply: don't move money beyond the authorised GPU compute, don't change access/permissions on the repo or anyone's accounts, don't hard-delete history, and keep secrets out of git and off the Drive (see §5). Everything else: go.

---

## 1. What this project is

**Gallowfell** (working title "The Curse of Gallowfell") — a **Godot 4** grimdark-fantasy **roguelite tower-defence deckbuilder** for mobile (iOS + Android), original IP. Portrait 1080×1920, 540×960 dev window. PvE-primary with opt-in cosmetic-only PvP.

Core loop: pick a **Warlord** → build a **20-card singleton deck** (faction-locked + Neutral) → run a **branching map** of combat/event/shop/rest nodes → lane-based tower-defence combat where you play cards to spawn/buff units → rewards between nodes → boss → meta-progression (currencies, mastery, season pass, shop).

Five factions, ~207 cards authored as `.tres` resources: **Iron Penitents** (bleed/sacrifice/cleave), **Ash-Mourners** (fear/resurrect/trap-control), **Coven of the Black Mire** (poison/swarm/sacrifice), **The Last Legion** (rally/echo/banner), **Skinward Pact** (big-monster/transform/beast). 11 Warlords designed (5 free, 6 paid).

---

## 2. Where everything lives

| Thing | Location |
|---|---|
| **Live repo (source of truth)** | `https://github.com/Gonzo8285/MobileGame.git` — branch `main` |
| **Local Godot working tree** | `…\Documents\Claude\Projects\Gaming app\game\` (project root with `project.godot`) |
| **Design docs / specs / backlog** | `…\Documents\Claude\Projects\Gaming app\` (root + `docs/`) |
| **The four screen specs (build-ready)** | repo/project root: `DECKBUILDER_SPEC_2026-06-01.md`, `WARLORDSELECT_SPEC_2026-06-01.md`, `COLLECTION_SPEC_2026-06-01.md`, `BRANCHING_MAP_SPEC_2026-06-01.md` |
| **Master backlog (live checklist)** | `Gaming app\backlog.md` — heartbeat reads top-most `[ ]` |
| **Full outstanding-work inventory** | `Gaming app\GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` — the 96-item categorised inventory incl. all P0 commercial-loop detail |
| **Decisions of record** | `Gallowfell_DECISIONS-RESOLVED_2026-06-01.md`, `Gallowfell_WORKORDER_2026-06-01.md` |
| **GitHub PAT** | `Gaming app\secrets\github_pat.txt` (read with the file tool; never commit) |
| **RunPod API key** | `Gaming app\secrets\runpod_api_key.txt` (valid; `api.runpod.io` reachable) |
| **Art render pipeline** | `Gaming app\pipeline_setup\runpod_showcase_batch.py` + workflow JSONs; 4-owed manifest at `pipeline_setup\_owed4_manifest.json` |
| **Card data** | `game\data\cards\<faction>\*.tres` (ash_mourners 41, coven 42, iron_penitents 41, last_legion 41, skinward_pact 42) |
| **Read-only cross-Claude mirror** | `G:\My Drive\ClaudeBridge\projects\gaming-app\` — context only, **do not edit; never push secrets or `.git` here** |

**Git is the source of truth, not the local folder.** Pull `main` before starting; if the local tree diverges from `origin/main`, trust origin.

---

## 3. Current verified state (checked 2026-06-25, not memory)

**Engine — working and progressing.** Combat loop, lanes, turn engine, waves, map (linear), rewards, run controller, and a real headless dev-test suite are all in place under `game\src\`. Recent commits: VICTORY/DEFEAT banner, lane power totals + spawn telegraph, hand fly-in + attack arrows, Snap-style reward reveal, pipeline manifests. Combat-UI polish has been the active track.

**Autoloads:** only `GameState` is registered in `project.godot`. **`CardDatabase` and `WarlordDatabase` do NOT exist yet** — they are the first dependencies the new screens need (DB-1, WL-2).

**The player can't yet get from Title into a run through real screens.** `title.gd` currently hard-codes a Warlord dict and auto-builds a random deck. The four front-of-game screens — **Warlord Select, Deck Builder, Collection/Codex, Branching Map** — are fully spec'd but **not wired**. This is the biggest gap to a demoable internal build.

**Cards:** ~207 faction `.tres` authored + tokens. Per-card **art spec files** complete for all 5 factions + 11 Warlords + 5 enemies (216 specs).

**Art:** **219 / 223 rendered.** Four still owed (no image on disk): `M41` Wraith Caller of the Dirge, `L41` Banner Bearer of the Crowned Anvil, `W41` Pack Caller Initiate, `W42` Den Mother of the Cinderwood. Their `.tres` exist — only the art is missing.

**Warlord data:** `game\data\warlords\` holds only stale `vey.tres` / `quag.tres` / `vyrrun.tres`. The 5 canonical free Warlords (vyrrun, sieren, eddra, veska, mhar) need authoring (WL-1).

**Decisions already locked (don't re-litigate):** C8 sim Option β endorsed (sim is ungated). W3 Cinderwood Stalker → LIFESTEAL keyword. Relic-slot system = non-draftable, faction-mastery unlock, 1 Warlord-bound slot (not pay-to-win). PvP = opt-in, cosmetic-only rewards.

---

## 4. Engine / file conventions (match these)

- `game\src\runtime\` — game logic (`combat.gd`, `turn_engine.gd`, `card_play.gd`, `run_controller.gd`, `map_*.gd`, `game_state.gd`, `wave_generator.gd`, …) + their `*_test.gd` headless tests.
- `game\src\data\` — Resource classes (`card.gd`, `warlord.gd`, `enemy.gd`, `enums.gd`, `wave.gd`, …).
- `game\src\ui\` — view scripts (`title.gd`, `map_view.gd`, `card_view.gd`, `reward_view.gd`, …). New screens follow the **programmatic-UI** convention used by `title.gd` / `map_view.gd` (build the tree in code; reuse `scenes\card_view.tscn` for card tiles).
- `game\scenes\` — `.tscn` files.
- **Dev tests** run headless via `main.gd` under the `RUN_DEV_TESTS=true` block. Every new system ships a matching `*_test.gd` and is wired into that runner.
- New autoloads register in `project.godot` `[autoload]` in dependency order: `GameState` → `CardDatabase` → `WarlordDatabase`.

---

## 5. Operating rules (non-negotiable)

1. **All software to Git.** Every change ships via the repo. No work lives only on disk.
2. **Git discipline = the gate.** Conventional Commits (`feat:`, `fix:`, `chore:`, `test:`, `docs:`). One feature branch per work item (e.g. `feat/deckbuilder-DB-1`). Open a PR, let CI/tests pass, **merge it yourself**, delete the branch. Small, reviewable, per-feature diffs — never one giant commit.
3. **Test discipline.** Nothing is "done" with a failing or absent test. Each engine/system item carries a headless `*_test.gd` wired into the `main.gd` dev-test runner. Run the full suite before merging.
4. **Verify against reality, not the checklist.** Phantom `[x]` ticks have happened before. Before claiming an item done, confirm the actual file/function exists and the test passes. Tick `backlog.md` only after that.
5. **Secrets stay out of git and off the Drive.** `secrets/` is git-ignored. Never commit `github_pat.txt` or `runpod_api_key.txt`; never copy them to `G:\My Drive\…`.
6. **Data + backups to G drive** where applicable (render outputs, large artefacts). Code and history live on GitHub. The Drive `gaming-app` folder is a read-only mirror — don't treat it as a working tree.
7. **Industry-standard, ship-grade.** This is heading to live app stores. Write code that will export cleanly to iOS + Android and connect to real ad/IAP/analytics SDKs later. No throwaway hacks on the critical path.

---

## 6. THE WORK — prioritised queue (work top-down)

Each item already has a build-ready spec; the spec section refs (§3, §4…) point inside the named SPEC file. Do them in order within a track; tracks A–C are the playable-build critical path, D is art, E–F are the wider backlog Paul put in scope.

### TRACK A — Player-facing screens (critical path to a demoable build)

Dependency spine: **DB-1 (CardDatabase) → everything**. Build order: Deck Builder → Warlord Select → Collection → Branching Map. (Collection only hard-depends on DB-1 and can run in parallel.)

**A1 · Deck Builder** — spec: `DECKBUILDER_SPEC_2026-06-01.md`
- `DB-1` CardDatabase autoload (`src/runtime/card_database.gd`; scan `res://data/cards/**`, index by id+faction; `draftable_for()`, `get_by_id()`, `resolve_deck()`; register after `GameState`). Smoke: print per-faction pool counts at boot.
- `DB-2` GameState deck persistence (`last_deck_ids`, `set_last_deck()`, `start_run_from_ids()`; leave existing `start_run(Array[Card])` untouched).
- `DB-3` `deck_builder.gd` core logic (DECK_SIZE=20, MAX_COPIES=1, add/remove, filters, `_on_start`, Auto-fill, Clear).
- `DB-4` `deck_builder.tscn` + programmatic UI (collection grid, deck list, `%CountLabel` N/20, filter chips, search, Back/Auto-fill/Clear/Start disabled until 20/20; reuse `card_view.tscn` with placeholder-art fallback).
- `DB-5` Wire `title.gd` → deck builder (instantiate with `setup(warlord_id, faction)`; old random deck moves behind Auto-fill; add `_faction_for_warlord()` helper).
- `DB-6` `deck_builder_test.gd` headless (non-draftables excluded, size + singleton enforced, `resolve_deck` round-trips).
- `DB-7` Polish (mana-curve histogram, validation text, long-press card zoom, "Use last deck").

**A2 · Warlord Select** — spec: `WARLORDSELECT_SPEC_2026-06-01.md` (do after the DB chunks)
- `WL-1` Author the 5 free Warlord `.tres` (vyrrun, sieren, eddra, veska, mhar) from `warlords_v1.md` §Free roster; supersede stale `vey.tres`/`quag.tres`; `is_free=true`.
- `WL-2` `WarlordDatabase` autoload (register after `CardDatabase`).
- `WL-3` `warlord_select.gd` + `.tscn` — roster grid (5 free selectable + paid tiles locked w/ cost) → detail panel → Select/Back.
- `WL-4` Wire Title → Warlord Select → Deck Builder; delete the hardcoded warlord dict + auto-deck.
- `WL-5` Replace `run_controller._get_active_warlord_faction()` with `WarlordDatabase.faction_of(...)`.
- `WL-6` `warlord_select_test.gd` headless (≥5 free, `faction_of` correct, `free_warlords().size()==5`).

**A3 · Collection / Codex** — spec: `COLLECTION_SPEC_2026-06-01.md` (parallel-safe; only needs DB-1)
- `CO-1` CardDatabase accessors `all_cards()`, `by_faction()`, `counts_by_faction()` (codex includes tokens/relics).
- `CO-2` `collection.gd` + `.tscn` — faction tabs + scrollable `card_view` grid + per-tab collected count.
- `CO-3` Shared `card_detail.tscn` overlay (big art, stats, keyword chips + blurbs, effect/flavour) — reusable, also serves DB-7's zoom.
- `CO-4` Filters + search + locked rendering (tokens/relics badged; `unlock_tag` greyed w/ lock glyph, still openable).
- `CO-5` Title wiring ("Collection" entry → `collection.tscn`, Back → Title).
- `CO-6` `collection_test.gd` headless.

**A4 · Branching map + encounter variance** — spec: `BRANCHING_MAP_SPEC_2026-06-01.md`
- `BM-1` `EncounterArchetype` + 7-archetype catalog (swarm/bruisers/plague/volley/ambush/summoners/dread); add `encounter_id` to `MapNode`.
- `BM-2` `MapGenerator.generate_branching(chapter, seed)` — layered DAG (12 depths, 2–4 wide, converge to BOSS); make `generate()` default to branching, keep `generate_linear()` for tests; `map_graph.validate()` passes.
- `BM-3` `WaveGenerator.for_node(node, run_seed)` — apply archetype biases over round scaling; keep `for_round` as shim.
- `BM-4` `map_view` branching layout (depth-columns + edges, current/visited/reachable, encounter symbols on combat nodes, tap-locked to reachable children, legend).
- `BM-5` `run_controller` traversal (pick among `get_children(current)`; non-combat nodes auto-resolve).
- `BM-6` Tests — extend `map_test.gd` (reachability, boss-terminal, per-path REST+SHOP guarantee, no back-to-back archetype repeats) + new `encounter_test.gd`.

### TRACK B — Engine fixes / hardening (interleave with Track A; some are `engine-hot`)

- `AC4` Add `is_token: bool` to `card.gd`; flag token/spawn cards; tighten `turn_engine.gd::_friendly_on_tile` TAUNT branch to `is_token==false AND is_draftable AND has_keyword(TAUNT)`; extend `turn_engine_test.gd` Scene D. *(engine-hot — touches turn_engine.)*
- `AC5` `card_data_validation_test.gd` — walk CardDatabase, call `Card.validate()` on every card, wire into `main.gd` dev-tests. *(depends on DB-1; cold/new file.)*
- `AC6` Audio stubs for IMV-1 — source 3 CC0/CC-BY ≤2s clips (card-play, hit, defeat) from freesound.org → `game/assets/audio/sfx/`, author `CREDITS.md`, wire 3 `AudioStreamPlayer` nodes with null-stream fallback. *(engine-hot for the wiring.)*
- `AC10` Fear-Caller (`M14.tres`) TAUNT-conditional `effect_text` rewrite + engine wiring (stack 1→2 when in-lane TAUNT present); add test covering both branches. *(engine-hot.)*
- `AC12` PvP-canon doc edits — make `GDD_v1.md`, `shop_economy_*.md`, `monetisation_map.md` consistent with "PvE primary + cosmetic-only PvP"; remove any "PvE only" claim. *(cold; idempotent.)*

### TRACK C — Balance sim (ungated — Option β endorsed)

- `C8.D3b` `outputs/c8_sim_runner.py` — 105-matchup × 30-game loop per `c8_playtest_sim_charter.md` §2.4/§2.5 Route A; consumes `build_deck()` + the D2 AI policy; produces win-rate matrix. Built against the v0.2.1 matrix (β applied).
- `C8.D4` `c8_results_v0.md` — post-run results doc.
- `C8.D5` Tuning recommendations per matchup with >5pp delta from C7-v0.2 expected.

### TRACK D — GPU art (AUTHORISED — small paid spend)

You're on the persistent shell, so the pod won't get reaped mid-render the way the Cowork seat does. Spend authorised (~£0.25–0.50/run).

- **D·owed-4** Render the 4 owed cards: `python3 pipeline_setup/runpod_showcase_batch.py pipeline_setup/_owed4_manifest.json` (seeds 54141/74141/84141/84242). Then re-run `scripts/art_inventory.py` → `_owed.md` should hit 0. Commit the new art. **Confirm the pod self-terminates** (cost guard).
- `D-VALIDATE-1` Anchor pass per `pipeline_spec.md` §5. **Stage A:** render the 5 free Warlords (Vyrrun/Sieren/Eddra/Veska/Mhar) → `art_iterations/_anchors/`; auto-validate against the §5 Stage-A checklist, regenerate any failing tile, then copy approved anchors to `art/warlords/` + `art_specs/_anchors/`. **Stage B:** render the 4 common test tiles (P1/Self-Scourge/Pall-Bearer/C1 Bog-Spawn) → `art_iterations/_commons_validation/` and check against the locked anchors. Log results; flag any tile that fails consistency for Paul's eye but **keep moving** — don't block the run on it.
- After the renders land, reconcile the stale `IMAGE-GEN-SHOTLIST.md` ("236 owed") so it stops misreporting.

### TRACK E — Commercial-loop P0s (Paul-named; full detail in `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md`)

These are mostly **design-doc deliverables** (single canonical spec per track), several with downstream engine wiring. Work them after the playable build (Tracks A–C) so there's a real loop to hang economy on. Consolidate each into the named doc:

- **Shop** (`SHOP-1..6` → `shop_economy_v0.md`): currency model (Gold/Bones/Souls/Marrow Shards/Gems), permanent storefront screen, in-run shop node catalogue + pricing + rarity weights, IAP price ladder + bundle SKUs, live-ops bundle templates, anti-P2W audit + spend caps.
- **Season Pass** (`BP-1..` → `season_pass_v0.md`): 50-tier free+premium reward inventory, XP curve + earn-rate (~25 days @ 1hr/day), season cadence/theming/archive, and the remaining BP items in the inventory.
- **Upgrade** (5× P0 → upgrade/progression spec): card/Warlord upgrade economy, costs, anti-P2W invariants — see inventory "Upgrade" section.
- **Variants** (6× P0 → card-treatment/variant spec): cosmetic card treatments + variant economy — see inventory "Variants" section and `Phase 2.10` card-treatment economy.

For each: author the canonical design doc first (no engine code needed to unblock), then queue any engine wiring as new `INV-`/`AC-` items in `backlog.md`.

### TRACK F — Design infill + remaining backlog (P2/P3)

Everything else still `[ ]` in `backlog.md` and the inventory: events/shrines/rests, bosses (chapters 2–3), keyword/synergy passes, audio beyond stubs, tooling/build-pipeline, and the deferred art-pipeline items. Work them in inventory priority order once E is moving. Each is heartbeat-sized; one branch + test + tick per item.

---

## 7. Definition of done (per item)

An item is done only when **all** of these hold: code authored to convention; a headless test exists and **passes** in the `main.gd` dev-test run (where applicable); the change is on its own branch, committed Conventional-style, PR merged to `main`, branch deleted; the real file/function is verified to exist (no phantom tick); and `backlog.md` is ticked with a one-line note of what shipped. A playable milestone (end of Track A) means: Title → Warlord Select → Deck Builder → start run → branching map → combat → reward → boss, all reachable through real screens with no hardcoded shortcuts, full dev-test suite green.

---

## 8. When you're blocked or need a decision Paul hasn't made

1. **Don't stop.** Make the most reasonable default choice consistent with the specs and existing code, record it in the commit body, and continue.
2. If it's a genuine external blocker (missing credential, an API down, a decision only Paul can make — e.g. final title-trademark sign-off, a paid-Warlord pricing call), write a **`decision-request`** note into the bridge at `G:\My Drive\ClaudeBridge\nodes\controller\inbox\` (filename `YYYYMMDDThhmmZ_ultracode_to_controller_DECISION_<topic>.md`) with the question, the options, and your recommended default — **then move to the next queue item.** Controller will surface it to Paul.
3. Never let a single blocked item halt the run. There is always another backlog item.

Known standing blockers you can route but should work around: USPTO/EUIPO/UKIPO trademark confirmation on "Gallowfell" needs Paul's manual login (title not locked — proceed under the working title); paid-Warlord unlock pricing is Paul's call (default to the costs in `warlords_v1.md`).

## 9. Reporting

- Tick `backlog.md` as you complete items (with verification, §5.4).
- Write a short status note each working session to `G:\My Drive\ClaudeBridge\nodes\controller\inbox\` so Controller can roll it into Paul's 20:00 UK digest: what shipped (commits/PRs), what's next, any decision-requests raised, GPU spend if any.
- Keep the 4-hour git heartbeat alive — quiet progress notes still count.

---

## 10. Quick start

```bash
# 1. Get the token, clone/pull main
TOKEN=$(cat "<…>/Gaming app/secrets/github_pat.txt")
git clone https://x-access-token:$TOKEN@github.com/Gonzo8285/MobileGame.git   # or: git -C game pull origin main

# 2. Sanity-run the headless dev tests (expect green) before you touch anything
godot --headless --path game -- --run-dev-tests        # RUN_DEV_TESTS path in main.gd

# 3. Start Track A: branch, build DB-1, test, PR, merge
git checkout -b feat/deckbuilder-DB-1
# …author src/runtime/card_database.gd per DECKBUILDER_SPEC §3, register autoload, add smoke print…
godot --headless --path game -- --run-dev-tests
git add -A && git commit -m "feat(deck): CardDatabase autoload (DB-1)"
# open PR, confirm tests, merge, delete branch, tick DB-1 in backlog.md

# 4. GPU art (Track D), when you reach it — confirm pod self-terminates after
python3 pipeline_setup/runpod_showcase_batch.py pipeline_setup/_owed4_manifest.json
python3 scripts/art_inventory.py   # _owed.md should read 0
```

Work the queue top to bottom. Default, decide, ship, verify, tick, next. Don't wait for Paul.

— Controller, 2026-06-25
