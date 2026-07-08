# Research notes — Gaming app

## B3.0f (4/5) — The Last Legion sigil prompt authored (heartbeat 2026-05-15)

- Appended **S4 — The Last Legion** section to `art_specs/_sigils.md` (replaced the pending stub).
- Subject: two ironwood batons crossed in saltire over a half-moon brass officer's gorget, single foundry-rivet stamped at the gorget centre. Distinct silhouette read vs S1 (mask-profile) / S2 (quills-over-skull) / S3 (coin-in-wreath).
- Resolved positive prompt: same flat-vector / silhouette-logo / heraldic-emblem stack as S1–S3 — smoke-blackened-brass-on-coal-grey accent locked, "thick clean silhouette readable at 96 pixels". Baton-tips upward-outward with brass ferrules, butt-ends downward-inward (heraldic standard, mirrors S2 quill-saltire orientation).
- Resolved negative prompt: S1–S3 painterly/3d/photoreal/anime/cartoon/text/PEGI override stack PLUS **`modern military insignia, nazi iconography, real-world military rank symbols, swastika, iron cross, real-world flags, real-world unit patches`** — keeps the gorget grimdark-fantasy command-cadre, NOT 20th-century military. Legion lore is decayed-knight foundry-order, not historical-military — this guard keeps SDXL from drifting toward the wrong reference cluster (military-emblem-tagged training data) and keeps PEGI-12 clean of real-world-controversy flags. Same protective-negative pattern as S3 used against pentagram/satanic drift.
- Single-rivet-at-gorget-centre design choice over multi-rivet row to keep silhouette legible at 96×96 — a rivet row would compete with the baton-crossing line-weight and muddy the thumbnail. Mirrors S2's "two folds, not many" and S3's "three thorn points, not many" minimal-detail discipline.
- Decayed-knight motif intentionally restrained at sigil tier — soot-blackened cuirass / chain-bound hair / smoke-and-coal background that defines Legion card-hero art don't survive 96×96 downscale. Sigil is command/officer iconography, NOT battle-trauma vignette.
- LoRA stack: none (prompt-only first pass; flat-icon LoRA route still flagged as Open Q1 from S1).
- Seed: 200700 (clean from S1's 200400, S2's 200500, S3's 200600; sigil range 200400–200800; final slot S5 Skinward Pact = 200800).
- Validation checklist: 9 items including baton-crossing-not-parallel, gorget-half-moon-not-breastplate, single-rivet-not-row, brass-not-gold-or-copper palette guard (echoes A-SPEC-4 Legion palette guard), decayed-knight restraint at sigil tier, real-world-military IP-clean guard, 96×96 thumbnail test.
- Backlog item B3.0f stays UNCHECKED — S5 (Skinward Pact) still pending; next heartbeat closes the cycle. Progress field in backlog updated S1✅ S2✅ S3✅ S4✅.
- Time spent: ≈1 read of `_sigils.md` + ≈1 read of `IMAGE-GEN-SHOTLIST.md` §F4 + ≈1 grep of research_notes + 2 edits. No GPU, no network. Heartbeat budget honoured.

## B3.0f (3/5) — Coven of the Black Mire sigil prompt authored (heartbeat 2026-05-15)

- Appended **S3 — Coven of the Black Mire** section to `art_specs/_sigils.md` (replaced the stub).
- Subject: demon-coin disc with hex-sign stamp at centre, encircled by a closed briar wreath with three thorn points. Distinct silhouette read vs S1 (mask-profile) and S2 (skull-and-quills).
- Resolved positive prompt: same flat-vector / silhouette-logo / heraldic-emblem stack as S1/S2 — bog-green-on-bone-white accent locked, "thick clean silhouette readable at 96 pixels".
- Resolved negative prompt: S1/S2 painterly/3d/photoreal/anime/cartoon/text/PEGI override stack PLUS **`pentagram, satanic imagery, inverted cross, occult symbols of real-world religion`** — keeps the hex-sign folkloric-grotesque, NOT modern-occult. Coven lore is swamp-witch / pact-magic / three-shadows-cast, not satanic — this guard keeps SDXL from drifting toward the wrong cluster and keeps PEGI-12 clean of religious-controversy flags.
- Threes motif: three thorn points spaced around the wreath perimeter ties to Coven's three-shadows-cast lore beat (per `pipeline_spec.md` §3.2).
- LoRA stack: none (prompt-only first pass; flat-icon LoRA route still flagged as Open Q1 from S1).
- Seed: 200600 (clean from S1's 200400 + S2's 200500; sigil range 200400–200800).
- Validation checklist: 8 items including coin-vs-shield read, hex-sign-NOT-pentagram guard, three-thorn-point count, bog-green palette guard (echoes A-SPEC-3 Coven palette guard: "bog-green accent, not lime green or neon"), body-horror restraint (no fungal/eye/ichor — symbol, not illustration), 96×96 thumbnail test.
- Backlog item B3.0f stays UNCHECKED — S4 (Last Legion) and S5 (Skinward Pact) still pending; next 2 heartbeats cycle them per the queued plan. Progress field in backlog updated S1✅ S2✅ S3✅.
- Time spent: ≈1 read of `_sigils.md` + ≈1 read of `IMAGE-GEN-SHOTLIST.md` §F3 + 1 edit. No GPU, no network. Heartbeat budget honoured.

## B3.0f (2/5) — Ash-Mourners sigil prompt authored (heartbeat 2026-05-14)

- Appended **S2 — Ash-Mourners** section to `art_specs/_sigils.md` (replaced the stub).
- Subject: two raven-quills crossed in saltire over a hooded shrouded skull; shroud-pleat in two clean folds beneath the chin. Distinct from S1 execution-mask (different silhouette read at 96×96).
- Resolved positive prompt: flat-vector / silhouette-logo / heraldic-emblem stack (mirrors S1 conventions) — dusk-purple-on-parchment-cream accent locked, woodcut-clarity, "thick clean silhouette readable at 96 pixels".
- Resolved negative prompt: S1's painterly/3d/photoreal/anime/cartoon/text/PEGI override stack PLUS `exposed brain, screaming skull, jaw agape` — keeps the skull motif iconographic, not horror-tier (PEGI-12 guard).
- LoRA stack: none (prompt-only first pass, same convention as S1; LoRA route + flat-icon fallback still flagged as Open Q1+Q2 from S1).
- Seed: 200500 (clean from S1's 200400; sigil range 200400–200800).
- 8-point S2-specific validation checklist authored (saltire-cross orientation, feather-tip-up / nib-down heraldic standard, skull-not-helmet read, two-fold shroud, monochrome silhouette, dusk-purple accent guardrail, PEGI restraint, 96×96 thumbnail legibility).
- Deviation notes: same `pipeline_spec.md` §3.1 / §3.4 divergence as S1; sigil-specific composition tier `sigil_glyph` applies; painterly card-hero motifs (censer-smoke, catacomb-vault, raven-drift) deliberately NOT used — they don't survive 96×96 downscale.
- B3.0f backlog item still NOT ticked (3 of 5 still pending — S3 Coven / S4 Legion / S5 Pact). Inline progress note updated in backlog.md to reflect S2 done.
- Next heartbeat: S3 Coven of the Black Mire (seed 200600, accent bog-green-on-bone-white, prose stub = "demon-coin disc inside a hex-sign briar wreath").

## B3.0f (1/5) — Iron Penitents sigil prompt authored (heartbeat 2026-05-14 09:17 UTC)

- New file: `art_specs/_sigils.md` — header + S1 fully authored + S2–S5 stubbed with seed + accent + prose-stub source line for next 4 heartbeats.
- S1 spec includes: positive prompt (flat-vector/silhouette/heraldic emblem stack, no painterly tags, rust-red on tarnished brass), negative prompt (overrides §3.6 painterly defaults — explicitly negates `oil paint, brushwork, painterly, gradient, 3d render`), LoRA stack = none (prompt-only), seed = 200400 (sigil range 200400–200800, clear of all existing seed ranges), output path `art/sigils/iron_penitents_sigil.png` + iteration archive at `art_iterations/_sigils/`, 7-point validation checklist, deviation notes against `pipeline_spec.md` §3.1 + §3.4.
- New composition tier introduced: `sigil_glyph` — bypasses §3.4 portrait/landscape entirely. Documented as sigils-file-only convention for now (Open Q 4 asks Paul whether to promote into §3.4).
- Workflow file reuse: existing `pipeline_setup/workflow_gallowfell_card.json` runs unchanged BUT every LoraLoader weight zeroed per its `lora_weight_protocol` field. EmptyLatentImage swapped 832×1216 → 1024×1024.
- 4 open Qs for Paul logged in the file (LoRA route vs hand-author fallback vs queue D-LORA-SIGIL; crop method LANCZOS vs centre-crop; composition tier promotion). None block S2–S5 next-heartbeat authoring.
- B3.0f backlog item NOT ticked this run (4 of 5 still pending). Next heartbeat picks up S2 — Ash-Mourners.

## T4 — Collection screen UI mock landed (heartbeat 2026-05-13)

- **Brief:** Phase 2.10 closing item. Placeholder wireframe for the per-card treatment chooser. Mirrors W4's `warlord_select_ui_v0.md` format so both UI specs feel like one app.
- **File authored:** `collection_ui_v0.md` (~7 KB, 5 ASCII screens + display-string conventions + engine-handoff sketch + 5 open Qs).
- **Screens spec'd:**
  - **A — Roster grid:** owned/locked tile grid, faction sections, ✦-pip treatment count, NEW corner badge for ≤24 h acquisitions, filter bar (faction / treated-only / sort). Unowned cards remain visible as silhouettes (collection-completion retention hook).
  - **B — Card detail panel:** big-art preview rendered through the live T2 shader stack (proves the stack survives a full screen-redraw + frame-change + combine-resolution on the real scene), read-only rules text, owned/locked treatment counts, acquired_via + serial metadata.
  - **C — Treatment chooser modal:** 7-tier grid (Default · Faction Frame · Foil · Gold · Ink · Prism · Cursed · Ultimate), live-preview-before-Apply, locked tiles show acquisition badges (💎 IAP / 🎟 Season Pass / 🎲 Gacha / 🏆 Loyalty / ⏳ Event), Ultimate prereq tile surfaces missing combines inline.
  - **D — Unlock detail panel:** single-source-of-truth for storefront / season-pass / gacha / event-window routing; Cursed gets the countdown-clock variant; Ultimate's prereq pair tap through to their own Screen D until both owned then collapses to a single buy row.
  - **Anti-P2W banner** (single-line, every chooser/unlock screen): "Cosmetic only. Treatments never change card stats or rules."
- **Display-string conventions locked:** owned = solid border, locked = dashed + 🔒, NEW = corner pip on tiles acquired in last 24 h, tier ordering matches `GFEnums.TreatmentTier` enum order (0→7).
- **Engine handoff sketch:** `GameState` gains a `collection: CardCollection` field + 3 signals (`treatment_applied / treatment_acquired / collection_filter_changed`). `CollectionView` pushes Apply → `CardCollection.set_treatment(instance, treatment_id)`. Storefront routing on Buy is out of scope — T4 hands the SKU id off and gets back a confirm-with-acquired-via callback.
- **Anti-P2W invariants restated for the implementing engineer:**
  1. Combat code (`combat.gd`, `turn_engine.gd`, `card_play.gd`, `reward_generator.gd`) never queries `CardInstance.treatment_id`. Stays on `card` only.
  2. `set_treatment` writes to `CardInstance`, never to `Card`. Shared gameplay resource untouched.
  3. Combo-treatment ownership is computed on-the-fly from `CardInstance` ownership — never persisted, never authoritative. Closes the save-edit Ultimate-mint exploit-path.
- **Pure spec; no .gd / .tres / enum edits this run.** Real scenes (`collection_view.tscn`, `treatment_chooser.tscn`, `unlock_detail.tscn`) authored in B3.x once cards have real art to render through. Storefront wireframe deferred per Paul's IMV-1 trim (real ad/IAP SDK is IMV-2 work).
- **5 open Qs for Paul** (none block downstream work — sensible defaults shipped in the doc): filter precedence (AND vs OR), silhouette acquisition-hint loudness, storefront route style (modal-over vs scene swap), Cursed serial visibility default, multi-faction frame UX branch retention.
- **Backlog impact:** Phase 2.10 now complete — T1 ✅ T2 ✅ T3 ✅ T4 ✅. No new tasks queued.

## B2.9 — Map screen branching node graph landed (heartbeat 2026-05-12)

- **Brief:** Branching node graph data spine for the run map. 1 chapter / 5 nodes / seeds for testing. Logic-only landing (UI deferred to B2.10 smoke-test work), mirrors the B2.8 pattern.
- **Chapter 1 shape (5 nodes, 1 branch, 1 merge):** `c1_start (COMBAT, d0) → [c1_left, c1_right] (d1, one EVENT + one COMBAT, order coin-flipped per seed) → c1_mid (ELITE or SHOP, d2) → c1_boss (BOSS, d3, terminal)`. Deliberately minimal — proves the branching mechanic without committing to a full STS 16-node chapter layout until UI lands.
- **Files authored:**
  - `game/src/runtime/map_node.gd` — RefCounted; `id / kind / depth / children: Array[StringName] / seed_offset` + `make_rng(run_seed)` using `seed ^ (seed_offset * 2654435761)` Knuth multiplicative hash. Per-node sub-RNG means combat/event/shop scenes reproduce deterministically on save/load without sibling nodes colliding.
  - `game/src/runtime/map_graph.gd` — RefCounted holding `Dictionary<StringName, MapNode>` + `start_id / boss_id / max_depth / chapter / seed_value`. Public surface: `get_node_by_id / get_children / is_child_of / nodes_at_depth / size / validate`. `validate()` enforces 4 invariants: start+boss present, boss terminal (zero children), all child refs resolve, boss reachable + no orphans (BFS from start).
  - `game/src/runtime/map_generator.gd` — pure-static `generate(chapter, seed) → MapGraph`. Mixes `seed ^ (chapter * MULT_KNUTH)` so chapter 1 and chapter 2 don't collide on identical run-seeds. Chapter 1 generator is the only real path today; chapters 2+ clone the prototype until per-chapter generators land.
  - `game/src/runtime/map_test.gd` — 22-ish assertions across structural contracts (node count, kind/depth invariants, branch + merge children counts), determinism (same seed → byte-identical kinds + children + seed_offset across all 5 nodes), RNG variance (≥2 distinct graphs over 10 seeds; statistical floor since 2 binary decisions = 4 possible shapes, P(all-tie) ≈ 4e-6), per-node make_rng determinism + sibling distinctness, and GameState integration (enter_chapter signals, legal child-jump accepted, illegal start→boss skip rejected, unknown node id rejected, full legal walk start→left→mid→boss fires map_node_entered exactly 3×).
- **Files modified:**
  - `game/src/data/enums.gd` — added `NodeKind { COMBAT, ELITE, EVENT, SHOP, SHRINE, REST, BOSS }`. Distinct from `RunPhase` — phase tracks "which screen is up", NodeKind tracks "what kind of encounter this tile represents".
  - `game/src/runtime/game_state.gd` — added `current_map_graph: MapGraph` + `current_node_id: StringName` fields, `chapter_started(chapter_num, graph)` + `map_node_entered(node)` signals, `enter_chapter(chapter_num = 0) → MapGraph` lifecycle method (builds graph from run_seed, seats player at start, emits chapter_started), `choose_next_node(node_id) → bool` (validates child-of relationship, returns false + no signal on illegal jumps / unknown ids — caller shows toast). Phase transition decision deliberately NOT made here — that's the map-screen controller's job, keeps "what scene runs next" out of GameState. Legacy `advance_node()` + `current_node: int` + `node_advanced` signal preserved for pre-B2.9 callers (B2.5 combat_test).
  - `game/src/main.gd` — wired `map_test.gd` into the dev-test runner after `warlord_test`.
- **Anti-P2W audit:** Generator reads zero monetisation state — pure (chapter, run_seed). No IAP path can bias which node kind appears where. Per-node sub-RNG (Knuth hash mix of run_seed + seed_offset) means even shop inventory rolls trace back to the run-seed alone.
- **Sandbox limitation:** Godot syntax untestable in sandbox. Python mirror at `outputs/map_mirror.py` validates the structural graph contracts (BFS reachability + boss terminal + child-of legality rules) — PASSES. Godot's RNG sequence is xoshiro256** so the exact `randi()` output can't be mirrored in Python, but the SHAPE contracts are independent of RNG.
- **Open questions for Paul (none block B2.10):**
  - Chapter 1 sticking with 5 nodes for the prototype, or should the smoke test exercise a richer 7-9 node layout sooner? (Current call: keep minimal, expand when UI lands.)
  - Should `c1_mid` ever be a SHRINE or REST tile, or are those reserved for later chapters? (Current call: ELITE/SHOP only at chapter 1 — they're the highest-information tiles for early playtesting.)
  - When the player picks an EVENT or SHOP tile, should `choose_next_node` auto-transition phase to `EVENT` / `SHOP` for them, or stay phase-passive? (Current call: phase-passive — caller decides, keeps GameState clean.)
- **Paul to confirm in editor:** `[map_test] PASS` line appears in Godot console on next launch (alongside the 7 existing `[*_test] PASS` lines).
- **B2.9 UI scene (map_view.tscn):** Deliberately deferred. B2.10 end-to-end smoke test ("start run → play 1 combat → take reward → next node → die") needs the visual map screen — UI work folds into B2.10 rather than dragging B2.9 into its own UI heartbeat.

## B2.8 — Reward screen logic landed (heartbeat 2026-05-11)

- **Brief:** Reward screen — pick 1 of 3 cards from a weighted faction pool. Logic-only this run (UI is later — full-art picker after B3.x; functional mock can layer on top of these signals when B2.10 smoke test needs it).
- **Files authored:**
  - `game/src/runtime/reward_offer.gd` — RefCounted; holds `cards: Array[Card]` + `chosen_index` + `skipped`. Single-fire `resolved(Card)` signal (null on skip). Double-`choose`/`skip` is a no-op so a buggy UI can't double-grant.
  - `game/src/runtime/reward_generator.gd` — pure-static module. `generate(pool, faction_bias, rng, count=3) → Array[Card]` + `generate_offer(...) → RewardOffer`. Weights: faction bias `BIAS=4.0 / OTHER=1.0 / NEUTRAL=2.0`, rarity `COMMON=10 / UNCOMMON=5 / RARE=2 / EPIC=0 / LEGENDARY=0`. EPIC + LEGENDARY excluded via zero-weight, not an explicit filter — keeps the "single contract" property. De-dups by `card.id` so an accidentally-double-loaded pool can't smuggle dupes. Tiny-pool fallback returns `min(count, |pool|)` rather than crashing. Includes `load_pool(roots)` convenience walker for the standard `res://data/cards/*` dirs.
  - `game/src/runtime/reward_test.gd` — 14-ish assertions covering pool-load, distinct-3 contract, EPIC/LEGENDARY exclusion, determinism (same seed → same offer), faction-bias distribution floor (≥40% Penitents share across 200 rolls with 4× bias), tiny-pool fallback, LEGENDARY-only-pool returns empty, `choose()` + `skip()` signal semantics, double-resolve no-op, and full GameState integration (start_reward → choose grows deck by 1; start_reward → skip leaves deck unchanged).
- **Files modified:**
  - `game/src/runtime/game_state.gd` — added `reward_offered(offer)` + `reward_resolved(card)` signals, `start_reward(offer) → RewardOffer` lifecycle method (sets phase to REWARD, emits signal, connects to `offer.resolved` with `CONNECT_ONE_SHOT`), and `_on_reward_resolved(card)` handler that duplicates the chosen card via `Card.duplicate_card()` before adding to `deck.add_to_top()`. Deck mutation is in-place; next combat's `start_combat()` does the reshuffle.
  - `game/src/main.gd` — wired `reward_test.gd` into the dev-test runner between `turn_engine_test` and `warlord_test`.
- **Anti-P2W audit:**
  - Generator never reads monetisation state (no XP boosters / no BP tier / no whale flag). Reward rolls are pure RNG + design weights.
  - Generator never grants the card itself — it returns 3 candidates; the player's `choose()` is what mutates the deck.
  - GameState duplicates the card before adding it, so the shared pool resource can never be mutated through a reward path.
- **Python-mirror validation:** `outputs/reward_mirror.py` re-implements the weighting math in plain Python against a synthetic 100-card pool with the real faction/rarity shape. Run output: `Penitents share with 4x bias: 0.634` (test floor 0.40 — generous envelope leaves room for run-to-run variance). Determinism + exclusion + duplicate-prevention + tiny-pool + LEGENDARY-only-pool all pass. Logic is sound before Paul opens Godot.
- **Engine-side untested in sandbox.** Paul to confirm `[reward_test] PASS` line appears in editor console on next launch (with the existing `RUN_DEV_TESTS=true` flag — same path as B2.3/B2.4/B2.5/B2.6/B2.7/W5).
- **Deferred to later items:**
  - **UI scene** — picker visual + tap-to-choose lives in B2.10 smoke test (rough mock) or later art-pass (final art). Logic exposes everything that scene needs: read `offer.cards`, call `offer.choose(idx)` on tap, listen to `GameState.reward_resolved` for post-pick navigation.
  - **Reward-node integration** — B2.9 map screen will be the caller that builds the offer (via `RewardGenerator.generate_offer`) and calls `GameState.start_reward(offer)`.
  - **Special-rarity / event rewards** — Hanging Hour curse-tier cards, Skin-stitcher pulls, etc. all bolt on as new weight tables in this module; the spine is in place.
  - **Skip compensation** — a future "skip the reward for some ash" hook can read `offer.skipped` and award ash before the run continues. Not in MVP.
- **Files modified this run:** `game/src/runtime/game_state.gd`, `game/src/main.gd`, `backlog.md` (B2.8 ticked), `research_notes.md` (this entry).
- **Files written this run:** `game/src/runtime/reward_offer.gd`, `game/src/runtime/reward_generator.gd`, `game/src/runtime/reward_test.gd`.
- **Phase 3 progress:** B1 ✅, B2.1 ✅, B2.2 ✅, B2.3 ✅, B2.4 ✅, B2.5 ✅, B2.6 ✅, B2.7 ✅, **B2.8 ✅** (this run), B2.9 next (map screen), B2.10 after (E2E smoke).
- **Open Qs for Paul (non-blocking — none of these block B2.9):**
  1. Faction-bias multiplier (4.0×) — feels right for a 5-faction roster but Slay-the-Spire-style games tend to use 3.0-3.5×. Easy single-constant tweak in `reward_generator.gd` if A/B tells us 4× over-concentrates.
  2. Rarity curve — `10/5/2` produces ~75% commons / ~20% uncommons / ~5% rares in offers (rough math against the current pool). Soft-launch KPI will tell us if commons feel too dominant; defer the call until we have data.
  3. Skip path — currently the player can `skip()` and lose the reward outright. StS-style "skip for relic" or "skip for ash" can layer on later — flagged as future work above.

## L3 — Pitch .docx Track-A audit (heartbeat 2026-05-11 14:25 UTC)

- **Brief:** Phase 2.8's last open item — re-export `The Curse of Gallowfell - Pitch.docx` after the Track-B → Track-A faction rename (L2) so the public-facing brief matches.
- **Audit:** unzipped the docx's `word/document.xml` and grep'd for both naming tracks.
  - Track-B mentions (Withered Court / Hollow Pact / Ferrum Host / Sable Wilds): **0**.
  - Track-A mentions (Ash-Mourners / Coven of the Black Mire / The Last Legion / Skinward Pact): **18**, distributed across the faction list, the chapter-unlock paragraph, the sample-cards block, and the curse-mechanics paragraph. Spot-checked the §1 faction roster, §3 MVP scope paragraph, and §6 lore — all read clean.
  - Docx mtime: 2026-04-30 18:28 UTC. That's the same day Paul locked Track-A names (L1, 2026-04-30) and predates L2's `.md` batch-rename (2026-05-01) — meaning whoever exported the docx in that 2026-04-30 live session was already working off the locked Track-A names. L2's sed pass cleaned the older `.md` files retroactively; the docx was authored clean to start.
- **Build-script status:** the L3 line points at `…\local_96bb105c-…\outputs\build_pitch_doc.js`, an archived prior-session outputs folder. Not reachable from this sandbox. No in-repo copy archived either (`find` returns nothing). Not blocking — the docx is already current, so no re-export needed.
- **Conclusion:** L3 is effectively no-op; tick it. If a *future* doc edit re-introduces faction churn, archive `build_pitch_doc.js` to the project folder first so the next re-export isn't bottlenecked on a vanished session.
- **Files modified this run:** `backlog.md` — L3 ticked. `research_notes.md` — this entry.
- **Phase 2.8 status: COMPLETE.** L1 ✅ L2 ✅ L3 ✅. Next eligible item: Phase 3 `B2.8` (reward screen — pick 1 of 3 cards from weighted faction pool), then `B3.0a` (first-pod smoke test, Paul-runnable).

## D-VALIDATE-1 reframed — Warlord-anchor first (Paul direction 2026-05-11)

- **Paul's call:** "Warlords thematically will be the reference points for their factions and once we have a solid design for each, we can lock that in as reference for any further build or dev around aesthetics." Pull-forward request, approved in chat.
- **Edits made:**
  - `pipeline_spec.md` §5 rewritten — was a single 9-tile sheet (5 Warlords + 4 commons mixed), now two-stage:
    - **Stage A** = 5-tile Warlord-anchor sheet (W1 Vyrrun / W2 Sieren / W3 Eddra / W4 Veska / W5 Mhar). Locks faction palette + motif + brushwork + atmospheric density. Outputs canonical reference to `art/warlords/` + `art_specs/_anchors/`.
    - **Stage B** = 4-tile common-card supporting sheet (P1 Cathedral Brother / Self-Scourge / M Pall-Bearer / C1 Bog-Spawn). Only fires AFTER Stage A signoff — tests whether commons read as belonging to the world the anchors locked.
  - `backlog.md` D-VALIDATE-1 reworded to reflect the two-stage flow + the "anchors land in `art/warlords/` + `art_specs/_anchors/` as canonical reference" piece.
- **Why this matters:** in MTG / Hearthstone / League, the legendary/hero art is the visual vocabulary the rest of the set is judged against. Mixing Warlords with commons in one validation sheet meant we couldn't tell "fix the Warlord" vs "fix the common pipeline" if the sheet landed soft. Two-stage forces the question into the right order: lock the anchor first, then judge the common against it. Total GPU spend roughly the same (~£0.25, ~30 min); validation framework dramatically cleaner.
- **Still gated on:** B3.0a first-pod smoke test (Paul-runnable from `MORNING_PLAYBOOK.md`, ~£0.15, ~15-25 min). D-VALIDATE-1 cannot fire until a RunPod pod has confirmed it can wget juggernautXL + run the default workflow end-to-end.
- **Files written this run:** none new. **Files modified:** `pipeline_spec.md`, `backlog.md`, `research_notes.md`.

## W5 — Warlord tier engine wiring closed out (heartbeat 2026-05-11)

- **Brief:** Phase 2.7's last open item — extend `Warlord` Resource with `tier_unlocks: Array[Resource]`; add XP store + tier machinery to `GameState`. Already partially-implemented across prior heartbeats; this run closed the last loose wire.
- **Audit of pre-existing state on entry:**
  - `game/src/data/warlord.gd` — `tier_unlocks: Array[Resource] = []` already exported, `get_tier_content(tier)` accessor present, `validate()` covers the 0-or-4-entries contract + per-TierContent sub-validation. ✅ done.
  - `game/src/data/tier_content.gd` — full T1/T2/T3/T4 shape (variant_passives / alt_fire_spell / mastery_skin_id / mastery_lore_string / mastery_title / ascension_mod_id) + tier-relative `validate()`. ✅ done.
  - `game/src/runtime/game_state.gd` — `TIER_THRESHOLDS = [0, 1800, 4800, 10800]`, `XP_MULTIPLIER_CAP = 3.0`, `warlord_xp` Dictionary, `xp_multiplier_sources` Dictionary, `_xp_pending_consume` queue, 4 signals (warlord_xp_gained / warlord_tier_changed / xp_multiplier_changed / xp_multiplier_consumed), plus `gain_warlord_xp` / `set_xp_multiplier_source` / `clear_xp_multiplier_source` / `mark_one_shot_for_consume` / `get_effective_xp_multiplier` / `get_warlord_tier` / `get_warlord_xp` / `get_xp_to_next_tier` / `_tier_for_xp` / `_drain_pending_consumes`. Anti-P2W guards: rejects zero/negative/empty-id grants; multiplier clamped server-side at gain time; no public set_tier API. ✅ done.
  - `game/src/runtime/warlord_test.gd` — 30+ assertions covering tier-boundary math at all 4 thresholds, empty-registry / single-source / stacked / clamped / cleared / one-shot-consume flows, tier-cross signal emission (single fire on cross), skip-tier (T1→T4 in one massive gain → one signal with final tier in payload), get_xp_to_next_tier at all bands, anti-P2W invariants, TierContent.validate shape checks across all 4 tiers, Warlord.validate shape checks (free-no-tiers ✅, paid-no-unlock-path fails). ✅ done.
- **Gap this run closed:** `warlord_test.gd` existed but was NOT wired into the dev-test runner. Added one line to `game/src/main.gd` after the B2.7 turn_engine_test line: `_run_dev_test("res://src/runtime/warlord_test.gd")   # W5`. Now `RUN_DEV_TESTS=true` exercises the full Warlord tier suite on every editor launch.
- **What W5 is NOT:** authoring actual Warlord .tres files (none exist under `game/data/warlords/` — IMV-1 trim in `internal_mvp_scope.md` defers per-Warlord content authoring to a later heartbeat batch). The W5 contract is *engine wiring* — the Resource shape, the XP machinery, the signals, the tests. All present. .tres authoring is a separate IMV-1 task pulling from `warlord_tiers_full.md`.
- **Sandbox cannot run Godot syntax;** Paul to confirm `[warlord_test] PASS` line appears in the editor console alongside the four B2.x suites on next launch. If FAIL fires, the assertion line + expected/actual values print to stderr — debuggable in place.
- **Files modified this run:** `game/src/main.gd` (one line added). `research_notes.md` (this entry). `backlog.md` — W5 ticked.
- **Phase 2.7 status: COMPLETE.** W1 ✅ W2 ✅ W3 ✅ W4 ✅ W5 ✅. Next eligible Phase-2 item is `L3` (Phase 2.8 — re-export pitch .docx after Track-A rename). After that, Phase 3 build resumes at `B2.8` (reward screen).

## W4 — Warlord-select UI mock (heartbeat 2026-05-11)

- **Brief:** wireframe the Warlord-select screen + tier ladder + variant/alt-fire pickers + mastery payoff + XP-booster surface, so an engineer can build against a single layout and the W3 open Qs (display string, cap clamp surfacing) can be closed at the UI layer.
- **Output:** `warlord_select_ui_v0.md` — 6 screens (A roster grid, B detail panel, C T2 variant picker, D T3 alt-fire picker, E T4 mastery one-shot, F XP-booster drawer), engine-signal handoff for W5, full anti-P2W audit at the UI layer, 5 open Qs.
- **Display-string locked: `+X% XP`** (additive-percentage form), with `×N` multiplier notation only appearing in a small "math" explainer footer on Screen F. Closes W1 Q5 + W3 §13 Q3 *pending Paul's explicit sign-off* — flagged as Open Q5 in the spec because the call propagates to W3 doc + W5 engine + B4 SDK, so worth confirming before W5 wires it up. Reasoning: Slay-the-Spire / Marvel-Snap / Hearthstone all surface percentage uplift; multiplier notation reads as "math" to the casual end of the audience.
- **Cap-clamp surface designed** (closes W3 §13 Q1): when stacked multipliers exceed ×3.0, Screen F shows `+200% XP (max)` at the top and tags the overflow rows with a `— capped —` chip. Stack-overflow contribution sources stay visible-but-greyed, not hidden — the player can see *what* they lost to the cap. Anti-frustration design: the cap exists; we don't pretend it doesn't.
- **Anti-P2W audit re-applied at the UI layer** (the doc has a dedicated §9): tier ladder is dots, not stats; T2 picker shows default + A/B side-by-side with same-cost on every row; T3 alt-fire shows mana cost in equal type weight on both rows; T4 mastery headline is cosmetic + *harder* Ascension slot, never a stat boost; locked paid Warlords show price chips never stat previews; booster cap is visible to all players. UI is where players *feel* P2W — passing data-layer audit isn't enough.
- **Engine handoff for W5 (no Resource shape changes):** 4 signals on `GameState` — `warlord_xp_gained(warlord_id, amount, multiplier_applied)`, `warlord_tier_changed(warlord_id, new_tier)`, `xp_multiplier_changed(source_id, value)`, `xp_multiplier_consumed(source_id)`. State the UI reads on-mount: `warlord_xp` Dictionary, `xp_multiplier_sources` Dictionary (per W3), `warlord_loadout` Dictionary, `Warlord.tier_unlocks` Array. The W1 §5 Resource shape is unchanged — wireframe slots into it 1:1.
- **W11 secret-Warlord lore-lock surface:** Screen A shows `???` text + heavy-veil silhouette + unlock hint phrase ("Beat all 10"). No price, no tier, no stat preview. Keeps the lore-locked W11 alluring without leaking the curse-mechanics reveal that lives in `art_specs/warlords/w11_…`'s PEGI-12 guard.
- **Scope discipline:** the doc is wireframes + signals + rules. Colour, fonts, motion, faction skinning of the panels, real card art, accessibility audit — all explicitly deferred to B3.x art pass + B5 device-test pass. This avoids the trap where a "UI mock" doc spirals into a B3-tier asset specification before the art pipeline (D-VALIDATE-1) is even hot.
- **Files written this run:** `warlord_select_ui_v0.md`.
- **Files modified this run:** `backlog.md` — W4 ticked. `research_notes.md` — this entry.
- **Open Qs for Paul (logged in spec §10):**
  1. T2 variant picker (Screen C) as radio-list cards vs. dedicated full-screen variant-comparison view. Lean: cards for v0, full-screen at B3.x if needed.
  2. Mastery payoff (Screen E) — all four blocks land at once vs. 3-second staggered reveal sequence. Lean: stagger, defer timing tuning to B3.x.
  3. Booster strip on in-run HUD vs. meta-screens only. Lean: meta-only (HUD clutter risk).
  4. W10 silhouette-lock-or-standard on Screen A. Lean: standard locked-paid card (W10 is paid-but-not-lore-locked).
  5. **Display-string lock confirmation** — `+X% XP` form. Carries propagation cost to W3 doc + W5 engine + B4 SDK, so confirm before W5 wires it.
- **None block** W5 (engine wiring is the next eligible Phase 2.7 item; signal list above is the contract). Phase 2.7 now sits at W1 ✅ / W2 ✅ / W3 ✅ / W4 ✅ / W5 open.

## W3 — XP-booster economy integration (heartbeat 2026-05-11)

- **Brief:** wire battle-pass and daily-quest XP boosters into the Warlord-tier system per `warlord_tiers_v0.md` §2.3. Reflect in `monetisation_map.md` so the engine-side multiplier registry has a single source of truth before W4 UI mock and W5 engine wiring start.
- **Output:** edits to `monetisation_map.md` only. No new files. Pure integration / bookkeeping pass — the booster mechanics themselves were locked in W1.
- **Edits made:**
  - **§2 Starter bundle** — clarified the 7-day +50% Warlord-XP booster is a *multiplier*, counted toward the ×3.0 cap. Reframed why it's the cheapest legitimate "feels like progress" hook (mastery cosmetics, never raw power).
  - **§6 Battle Pass** — added free-track ×1.10 multiplier from level 25 onwards + premium-track ×1.25 for the season; locked the booster mechanics (multiplier-only, ×3.0 cap, server-side enforcement); added engine note that BP claim must call `GameState.set_xp_multiplier_source("battle_pass_premium", 1.25)` once at unlock.
  - **§11 Daily reward calendar** — expanded into "Daily reward calendar + daily quests"; spec'd 3 quest slots (generic-win, win-with-Warlord-X with one-shot ×1.5 multiplier, faction-objective); explained why one-shot ×1.5 is new-player-friendly (stacks with BP +25% to ×1.875 without hitting the cap).
  - **§13 Warlord-XP booster economy** — new section. Master registry table (BP premium / BP free past lvl 25 / daily quest / starter bundle / event weekend / equipped skin) with multiplier, duration, stack-toward-cap flag, MVP flag, doc cross-ref. Worked stack examples for F2P / standard payer / whale (whale ceiling holds at ~25 wins to T4 per the W1 audit, ×3.0 cap clamps a raw ×5.91). Engine handoff sketch for B4 + W5: `xp_multiplier_sources: Dictionary[StringName, float]`, `min(3.0, prod(values))` computed at run-end (not cached, sources expire mid-run), one-shot sources self-unregister + `xp_multiplier_consumed(source_id)` signal.
  - **Anti-P2W guardrails** — added rule 6 explicitly naming the multiplier-only / no-flat-XP / no-tier-skip / ×3.0 cap constraint with cross-refs to `warlord_tiers_v0.md` §6 + this doc §13.
  - **MVP-vs-later table** — new row for Warlord XP boosters (post-soft-launch, alongside BP + quests).
- **Anti-P2W audit (re-applied):** registry is multiplier-only across every source; cap is server-enforced (not client-trusted); no IAP grants flat XP; no IAP tier-skips. Whale ceiling ~25 wins to T4 vs free floor ~72 — same destination, different speed. Passes the W1 §6 audit clean.
- **Engine handoff sketched (no .gd / .tres edits this run):** the multiplier registry pattern (Dictionary keyed by source ID, computed not cached, signal-emitting on one-shot consume) is the contract B4 SDK wiring + W5 tier engine should build against.
- **Files written this run:** none.
- **Files modified this run:**
  - `monetisation_map.md` — §2, §6, §11 edits + new §13 + new anti-P2W rule 6 + MVP table row.
  - `backlog.md` — W3 ticked.
  - `research_notes.md` — this entry.
- **Open Qs for Paul (logged in `monetisation_map.md` §13):**
  1. Daily-quest booster stacking with equipped-skin booster — keep stacking and surface the cap visually (greyed-out source row) when stack overflows? Lean yes.
  2. Free-track booster threshold — locked at lvl 25; push to lvl 30 to give premium more daylight at the early-mid-season conversion window?
  3. Multiplier display — `+25% XP` or `×1.25 XP`? (Carries from `warlord_tiers_v0.md` Open Q5; locking the answer here unblocks W4.)
- **None block** W4 (Warlord-select UI mock — wireframe-only, can use either display string and update once Q3 lands) or W5 (engine wiring after C1 — registry contract is stable). Phase 2.7 now sits at W1 ✅ / W2 ✅ / W3 ✅ / W4 W5 open.

## W2 — Warlord tier content for all 11 (heartbeat 2026-05-11)

- **Brief:** author Tier 2 variant passives (×2 each), Tier 3 signature alt-fires, Tier 4 mastery payoffs for the full 11-Warlord roster, applying the `warlord_tiers_v0.md` template. Anti-P2W invariant must hold — no raw stat unlocks; A/B variants are sidegrades; T3 alt-fires same-cost shape-rotations; T4 is cosmetic + lore + harder-challenge-slot only.
- **Output:** `warlord_tiers_full.md` — ~210 lines. Full content for all 11 Warlords across the 4 tiers, plus anti-P2W audit, MVP-slice trim recommendation, and 6 open Qs.
- **Per-Warlord pattern applied:** Default re-stated → T2 Variant A (offence-leaning, pays a cost — HP / hand-size / draw / scope) → T2 Variant B (defence/utility, drops a feature for a different feature) → T3 alt-fire (same mana cost, one design axis rotated: dmg→buff, single→AoE, immediate→delayed, offence→debuff, lane-control→resource conversion) → T4 mastery (skin name + 1-line visual cue, ≤30-word in-fiction lore reveal, mastery title string, Ascension modifier as 1-line mechanical text).
- **Pre-existing spec reuses (no double-authoring):**
  - **Sieren T3 alt-fire = Glean** (per M3; spec lives in `sieren_t3_glean_v0.md`).
  - **Pall Writ reassigned from Sieren to Saint of Gallowsmoke (W8) T3** (per M3 thematic-fit call; canon spell, kept at original 3-mana cost).
- **Campaign-tier Ascension slots:** per W1 Open Q4 lean, only W10 (Last Confessor) + W11 (Saint That Should Not Hang) get campaign-tier slots instead of standard A11. W6–W9 hybrids stay on A11. Flagged for confirmation in spec Open Q3.
- **MVP-slice trim recommendation drafted:** Internal MVP-1 ships Vyrrun + Sieren + Mhar — recommend full T1+T2 authored, T3 .tres written-but-locked, T4 deferred to IMV-2 after B3.x cosmetic-skin pipeline lands. Trims engine-wiring scope from ~66 pieces to ~9 for IMV-1. Slots cleanly into `internal_mvp_scope.md`'s Tier-system-deferred line.
- **Engine handoff (for W5):** none this run. The W1 spec §5 Resource shape (`tier_unlocks: Array[Resource]` with TierContent sub-Resource holding variant_passives / alt_fire_spell / mastery_skin_id / mastery_lore_string / mastery_title / ascension_mod_id) is unchanged. W2's content slots into it 1:1 — no new fields required.
- **Anti-P2W audit re-applied:** all T2 variants are real-cost sidegrades; all T3 alt-fires are same-mana rotations; all T4 mastery is cosmetic + lore + harder-challenge. Spec passes the W1 §6 audit clean.
- **Files written this run:**
  - `warlord_tiers_full.md`
- **Files modified this run:**
  - `backlog.md` — W2 ticked.
- **Open Qs for Paul (logged in spec §"Open questions"):**
  1. Sieren T2 Variant A (`Sworn in Ink`) HP cost — does the 2-HP-per-raise stack within a wave? Lean yes.
  2. Whelp T2 Variant A — Bleed-2 stack risk on Iron-Penitents Bleed-stack archetype. Flag for C7-redux balance pass, non-blocking.
  3. W10/W11-only campaign-tier slots, or do W6–W9 paid hybrids also get them? Lean no (keep hybrids on A11).
  4. Vyrrun T3 (`Bone-Pageant`) forces a Persist trigger — does it consume the once-per-combat lock (read a) or run as parallel pathway (read b)? Lean (a).
  5. Variant-passive names ("Flagellant Rite," "Twelvebirth," etc.) — first-pass; flag any that don't earn their slot before W4 UI work.
  6. Tier-3 unlock UX — togglable button on Warlord card vs separate spell-variant sub-screen? Decision lives with W4 UI mock.
- **None block** W3 (XP-booster economy integration into `monetisation_map.md`), W4 (Warlord-select UI mock), or W5 (engine wiring after C1 lands). Phase 2.7 now sits at W1 ✅ / W2 ✅ / W3 W4 W5 open.

## M4 — Hanging Hour × Persist interaction (heartbeat 2026-05-10)

- **Brief:** spec the Hanging Hour override on Persist — at midnight, every PERSIST-tagged unit that died this combat returns at full stats, ignoring -1 ATK and the once-per-combat lock. Boss-escalation made even more terrifying.
- **Spec authored:** `keywords/hanging_hour_persist_v0.md` — full M4 deliverable. Mirrors `persist_v0.md` format.
- **One-line:** at the Hanging Hour turn (default 5 standard combat, 4 boss combat), TURN-START phase drains a `hanging_hour_persist_queue` built from `Combat.corpses`. Filtered to PERSIST + non-token + dedup-by-instance-id-latest-death. Resolves to full base ATK (no -1 floor) and bypasses `has_persisted` lock once; sets the lock true after.
- **Symmetry call:** applies to friendlies AND enemies. Combined with persist_v0 Q2 (PERSIST allowed on chapter bosses), this is the design's terror moment — a near-killed PERSIST boss returns to full HP at midnight. Standard enemies still don't carry PERSIST, so it's a boss-encounter escalator, not a wave-grind hostility multiplier.
- **W11 Saint × Hanging Hour ordering locked:** Persist drain runs at TURN-START *before* Speak the Name's freeze takes effect. Without this, W11's lore-payoff turn would brick. Critical ordering note.
- **Anti-P2W bound restated:** Hanging Hour Persist override is gameplay-only. Cursed treatment (animated green-pyre overlay, IAP) shares the curse flavour but is **visual only** — combat code MUST NOT branch on `treatment_id == CURSED`.
- **Engine wiring:** no changes this run. Sketch'd in spec §"Engine wiring" — adds `hanging_hour_turn` + `hanging_hour_fired` + `corpses` + `hanging_hour_struck` signal to `Combat.gd`, plus a new `TurnEngine.drain_hanging_hour_persists` static method. Defer to B2.7+ balance pass and B2.9 boss-encounter spec.
- **Files written this run:**
  - `keywords/hanging_hour_persist_v0.md`
- **Open Qs for Paul (logged in spec §"Open questions"):**
  1. Default trigger turn = 5/4 — ship as-is or pull tighter to 4/3?
  2. Reuse `has_persisted` lock vs add separate `hanging_hour_persist_used` flag (matters only if a future relic ever needs to reset the locks selectively)?
  3. Boss with PERSIST: returns at base stats — confirm phase-state (phase-1 vs phase-2 enrage) is tracked separately from `CardInstance` so this works cleanly. Will revisit in B2.9 boss-encounter design.
  4. VFX / SFX budget for the Hanging Hour beat — rope creak + screen-pulse + corpse-light flicker. Owned by B3.2 frame-pass; non-blocking.
- **None block** the next mechanical-mining pass or any Phase 3 build item. M4 is the last item in Phase 2.9.

---

## M3 — Graveyard-as-resource Warlord (heartbeat 2026-05-10 14:18 UTC)

- **Brief:** design 1 new Warlord *or* repurpose an existing one's Tier-3 alt-fire so the discard pile is a usable resource. "Deathrite Shaman energy."
- **Decision:** **repurpose**, don't add new Warlord. Roster locked at 11 in `warlords_v1.md`. Sieren (W2, Ash-Mourners, Control) is the canonical graveyard-recursion Warlord — faction-coherent fit.
- **Spec authored:** `sieren_t3_glean_v0.md` — full Tier-3 alt-fire spec for **Glean**.
- **Glean (one-line):** 3 mana + exhaust 2 discard cards + consume the targeted unit's discard entry → summon a copy of any UNIT in your discard to a friendly tile at -1 ATK (floor 0). Tokens excluded. Already-Persisted units excluded (snowball block).
- **Anti-P2W bound:** same mana cost as Funeral Writ (3), same cooldown band (once/wave), opposite-axis effect (lane-control DoT → resource conversion). Locked-pattern compliant per `warlord_tiers_v0.md` §3.3. Not strictly better — Funeral Writ wins vs swarm pressure, Glean wins vs attrition with discard depth.
- **Persist + Glean interaction (M1 hook):** Glean'd copy does NOT inherit Persist's once-per-combat lock. If the base card has PERSIST, the Glean'd copy can Persist normally on death. Already-Persisted bodies are excluded from Glean targeting — prevents perpetual recur.
- **Sacrifice loop interaction (M2 hook):** Glean'd unit is a normal sacrifice target for Last Vows / Black Mire Pact. Combos intentional, contained by the 3-cards-per-Glean opportunity cost.
- **W1 worked-example diff:** repurposes Sieren's illustrative "Pall Writ" alt-fire. Pall Writ flagged for reassignment to **Saint of Gallowsmoke (W8)** when W2 runs — better thematic fit (W8's faction is Coven × Court, Smoke pillar). M3 spec §6 Q3 details the swap.
- **Files written this run:**
  - `sieren_t3_glean_v0.md` — full M3 deliverable spec (decision, full Glean spec, anti-P2W audit, snowball checks, engine handoff, open Qs, W1 diff).
- **Open Qs for Paul (logged in spec §6):**
  1. Discard cost — 2 cards or 1? Currently 2. Tunable for soft-launch.
  2. Glean'd copy consumes its discard entry? Currently yes (anti-perpetual-chain).
  3. Pall Writ → W8 reassignment — confirm before W2 authors W8's T3.
  4. MVP slice (Sieren ships in IMV-1) — Tier 3 deferred to IMV-2 per `internal_mvp_scope.md`. Glean is a v0 spec for IMV-2 build, not IMV-1. Authoring early is fine; engine wiring waits.
  5. Naming — "Glean" vs "Reckoning"/"Recompense"/"Harvest the Dead"/"Cull the Mourners". Lock at W2 sign-off.
- **Engine notes for W5:** new `Glean` resolver needs `discard_pile` filter (UNIT && !is_token && !persisted_this_combat), two-step UI picker (target tile → discard browser; discard browser is new — flag for B2.10 follow-up if Sieren is in MVP slice). Encoded as a non-draftable LEGENDARY SPELL .tres with `unlock_tag=&"warlord_t3_sieren"`. Full encoding in spec §5.
- **Backlog status:** ticking M3. M4 (Hanging Hour × Persist) still queued — landed-cleanly hand-off for next heartbeat.

## M2 — Sacrifice-and-return loop hardening (heartbeat 2026-05-10)

- **Brief:** review Iron Penitents (self-damage = soft-sacrifice) + Coven (explicit sacrifice combos), identify 2–3 missing combo enablers (sacrifice outlet, return-to-hand, sacrifice-payoff), author them. Mechanically completes M1's Persist keyword by giving Persist somewhere to feed into and out of.
- **Gap audit:**
  - **Sacrifice outlet** — existing outlets (P22 Sin-Eater 2c, P25 Vow of Ash 2c, P26 Long Confession 4c) all charge mana on top of the unit cost. M1 Persist + a return-to-hand chain wants a tempo-neutral 0-cost outlet so the loop runs at break-even. Hole confirmed.
  - **Return-to-hand (blink)** — pool had nothing. MTG canonical "blink" is the load-bearing piece of every Persist deck Paul referenced. Hole confirmed.
  - **Sacrifice-payoff trap** — existing on-death effects all live ON the dying unit (M19/M20/etc.). No decoupled trigger that pays out per-death regardless of the corpse. Hole confirmed.
- **Cards authored (3 total — one per gap):**
  - **P41 Last Vows** (Iron Penitents, 0c C SPELL) — sacrifice outlet. `keywords=[SACRIFICE, BLEED]`. Sac a Penitent, Bleed-2 to up to 2 enemies. Mandatory sac means it does nothing without a body — strict combat-only utility, no hand-as-storage abuse. Up-to-2 cap stops one-button board-wipes on packed lanes.
  - **C41 Bog-Bargain Recall** (Coven, 2c U SPELL) — return-to-hand. `keywords=[]` (no formal keyword; impl deferred to B2.7+). Choose a friendly unit, return to hand, **Persist marker resets**. The reset clause is the load-bearing rule — without it this is a vanilla blink; with it, the explicit Persist-recursion enabler. 2c (not 0c) keeps each loop turn a real mana commitment.
  - **C42 Black Mire Pact** (Coven, 2c C TRAP, lane-wide) — sacrifice payoff. `keywords=[SUMMON]`. Each friendly death in lane spawns a 0/1 Bog-Spawn. 3 charges then expires. Decouples payoff from corpse so Penitent sacs / Coven trades / Mourner Resurrects all feed it.
- **Files written this run:**
  - `cards_iron_penitents_v1.md` — appended "M2 addition" §  (P41 + rationale + combo lines + anti-stack guard)
  - `cards_coven_v1.md` — appended "M2 additions" § (C41 + C42 + rationale + combo lines + B2.7+ engine implication)
  - `game/data/cards/iron_penitents/P41.tres` — authored
  - `game/data/cards/coven/C41.tres` — authored
  - `game/data/cards/coven/C42.tres` — authored
- **Engine flag for B2.7+ (NOT a blocker, log only):** C42 is the first **lane-wide passive trap** in the pool. Existing trap pattern is "first enemy steps on tile" — single-trigger, tile-bound. C42 needs a new activation pattern: lane-bound, event-listening, charge-counted. Implement as a `LaneEffect` Resource separate from per-tile `Trap` instances when the trap engine lands. Already noted in `cards_coven_v1.md` §M2-additions; flagged here too so the B2.7+ heartbeat sees it without re-deriving.
- **Anti-P2W invariant restated:** all 3 cards are gameplay cards with normal craft/draft availability. No IAP gate, no whale-only variant. Same rule as every M1/M2 design pass.
- **Combo lines this opens (sample, not exhaustive):**
  - Persist-tagged Mourner dies → Persists at end of turn → Recall to hand → replay → dies again → C42 fires → Bog-Spawn → Bog-Spawn dies → C42 fires again. Within C42's 3-charge window the lane never empties.
  - P26 Long Confession (sac up to 3 → mana+draw) → P41 Last Vows on the 4th body if drawn → triple-sac into draw + Bleed clear is now a real Iron Penitent finisher pattern.
  - Two-faction Penitent + Coven deck gets the strongest version of the loop: Penance feeds off the deaths, Black Mire pays Bog-Spawns, Recall + Last Vows keeps the engine ticking. Anti-synergy grid (Penance vs Sacrifice-Combo) becomes engine fuel rather than a soft conflict.
- **Open Qs queued for Paul (none block M3):** (Q1) C41 Recall on a Persist-already-fired unit — should it un-flip `has_persisted` even if the unit hasn't died yet, or only restore it for re-death? Default: always reset on Recall (cleanest rule). (Q2) C42 lane-wide trap visual — how do we surface "3 charges left" in UI? Probably a small counter on the trap chrome; defer to B3.2 frame pass. (Q3) Last Vows + Persist combo: when the Persisted body is sacrificed by Last Vows, does it Persist again? Per M1 spec: no — `has_persisted=true` already, second death is normal death. Confirms M1's once-per-combat lock is the right shape.
- **Next M-track hop:** M3 (Graveyard-as-resource Warlord — design 1 new Warlord or repurpose an existing Tier-3 alt-fire so the discard pile is a usable resource).

## T3 — Faction-frame author spec (heartbeat 2026-05-09 23:19 UTC)

- **Output:** `faction_frames_v0.md` (~180 lines) — PSD-template authoring spec for the 5 free faction-themed card frames. T3's contract is "B3.2 frame author can execute against this without re-deriving anything"; actual PNG authoring is downstream.
- **Approach locked:** master `frame_master.psd` template + 5 swappable border-asset packs. 90% of frame structure (UI chrome anchors, transparent windows, name plate region) shared across factions; only border decoration / top arch / corner motifs swap. Cuts authoring divergence risk.
- **Canvas locked:** 832 × 1166 px, 2:3-ish aspect (≈5:7 to match CardView 200×280). PNG-24 with alpha, sRGB, 8-bit. Filenames `iron_penitents.png` / `ash_mourners.png` / `coven.png` / `last_legion.png` / `skinward_pact.png` (Track-A names) → `res://game/art/frames/`. Already wired by T1's `treatment_definitions.tres` per-faction `frame_path` fields.
- **Slot map locked (10 zones, absolute px anchors):** ART_WINDOW (full bleed, frame must NOT cover) / TOP_ARCH 220px tall / LEFT+RIGHT_BORDER 56px wide / BOTTOM_PLATE 146px tall (faction-tinted translucent name+desc bar) / COST_BADGE_HOLE 128px transparent cutout / STATS_BADGE_HOLE 128px cutout / FACTION_SIGIL_NICHE 96px / 4× corner accents 80px. Centre 720×800 region MUST stay clean — treatment shaders (Foil/Gold/Prism/Ultimate) operate on the art layer below it. Coven granted the only exception: thorns may project ≤6px into art region.
- **PSD layer structure:** smart-object slots for the 7 swappable PNGs + 2 vector-mask hole groups + guides/preview layers (export-hidden). Smart objects mean swapping a faction = 7 PNG drops + bottom-plate re-tint, ≤5 min/faction once the pack is drawn.
- **Per-faction packs spec'd to motif level for all 5:** Iron Penitents (brass exec-mask arch + rope-twist borders + hammer-spike corners + warrant-vellum bottom plate), Ash-Mourners (shroud-pleat asymmetric arch + corroded silver chain + ink-stain bleeding bottom plate + raven-quill nibs), Coven (briar-tangle arch with 3 demon coins + briar+bog-iron borders + 3-shadow-cast bottom plate + thorned-root corners), Last Legion (foundry-rivet plate arch + chain-link borders with engraved sigils + scorch-marked bottom plate + crossed-baton/broken-chain corners), Skinward Pact (antler-arch with bone shards + bark-grain+bone-sliver borders + smoke-trail bottom plate + ivy/bone-shard corners). Each gets a locked accent hex pulled from `art_direction.md` §0 palette.
- **Tooling note:** Paul has no Photoshop; all 3 free alternatives (Photopea browser-based, Krita, GIMP) covered with recommended split — Photopea for master template (best smart-object support), Krita for per-faction art passes, Photopea for export. All FOSS / free.
- **Budget honest call:** master template ≈ 2 hrs, per-faction pack ≈ 3-4 hrs × 5 = ~20 hrs total hand-paint art time. Recommendation in Open Q3: defer hand-paint, try AI-assisted frame generation via SDXL ornate-border LoRA after D-VALIDATE-1 ships. Even 30% AI hit-rate would cut ~14 hrs.
- **Shader-stack integration:** FrameDecal at layer 15 per `shader_stack_design.md` §3.6, texture-swap (no material) — CPU+GPU cost ≈ free. Frame artists assume Foil/Prism/Ultimate will sparkle/shimmer/sheen the centre region; visual interest must live in borders + top arch + bottom plate, never in centre.
- **4 open Qs for Paul (none block T4):** (Q1) Aspect ratio: rebase CardView from 200×280 to 200×292 to match SDXL native 832×1216 and skip a crop step? Recommendation YES. (Q2) Stick with PSD master via Photopea or skip indirection and flatten? Recommendation PSD/Photopea. (Q3) Try AI-generated frames via SDXL ornate-border LoRA before hand-paint? Recommendation YES (defer hand-paint pipeline). (Q4) Long-name overflow on BOTTOM_PLATE — flagged for B2.6 UI hardening, not a frame-author concern.

---

## T2 — Shader stack design (heartbeat 2026-05-09 19:17 UTC)

- **Output:** `shader_stack_design.md` (~200 lines) — full shader pipeline spec.
- **Architecture locked:** CardView scene tree gets a fixed slot per layer (Art, FrameDecal, OverlayStatic, OverlayAnimatedA, OverlayHighlight, ChromeUI). Pre-allocated slots; treatments toggle visible + rebind uniforms (no per-card node spawn — collection screen 200 cards would thrash).
- **Layer order locked:** Ink=0 (texture swap, not shader) → Gold=10 (HSV-shift on art) → Frame=15 (faction decal) → Foil=20 (static sparkle) → Prism/Cursed=30 (one slot, mutually exclusive animated overlay) → Ultimate sheen=40 → ChromeUI=100 (always above, stat readability sacred).
- **Per-treatment shader specs:** uniforms + technique + ALU cost + animated flag for all 5 shaders (Gold, Foil, Prism, Cursed, Ultimate-sheen). Faction frames are PNG decals not shaders. Default = all slots off.
- **Combo algo:** `combines: Array[StringName]` expands at apply-time; sorted by `stack_layer` ascending; binds each into its slot. Ultimate = Gold + Prism + own layer-40 sheen, all three render.
- **Low-power downgrade:** animated speed → 0 on `OS.is_in_low_processor_usage_mode()` or player toggle. Shader still binds + visible (paid players still see the cosmetic), just static.
- **Performance budget:** worst case 7× Ultimate visible = ~28 shader passes/frame, ~11M ALU ops, well under mobile GPU envelope. Stress-test gated before B4.
- **Scope deliberately stopped at design:** shader bodies not authored — they need real card-art textures (sparkle density, metallic mask threshold, flame shape) to tune against, which is a B3 dependency. T2.1–T2.9 follow-up tickets enumerated for when art lands.
- **One layer-rebalance flagged for Paul (Open Q1):** swap Frame/Gold layers in the existing `treatment_definitions.tres` so Gold's HSV-shift only touches the art and faction frames stay their native colour. Recommendation: yes, alternative breaks faction identity on Gold cards.
- **Three other open Qs:** (Q2) Cursed × Frame stacking, (Q3) Prism vs Cursed mutual exclusivity policy, (Q4) Ink + Gold combo tint behaviour. None block T3/T4.

---

## T1 — Card treatment data model (heartbeat 2026-05-09)

- **Outputs (5 files):**
  - `game/src/data/card_treatment.gd` — `CardTreatment` Resource class (catalog entry).
  - `game/src/data/treatment_catalog.gd` — `TreatmentCatalog` Resource (holds Array[CardTreatment]; lookup by id / tier / faction; validate hook).
  - `game/src/runtime/card_instance.gd` — `CardInstance` RefCounted runtime concept (`card` ref + `treatment_id` + `alt_art_id` + acquisition metadata + `to_dict()` for save).
  - `game/data/treatments/treatment_definitions.tres` — populated catalog: 12 entries (1 Default + 5 Faction frames + Foil + Gold + Ink + Prism + Cursed + Ultimate).
  - `game/src/data/enums.gd` — added `TreatmentTier` enum (8 values: DEFAULT, FACTION_FRAME, FOIL, GOLD, INK, PRISM, CURSED, ULTIMATE).
- **Anti-P2W invariant preserved:** `Card` Resource (`card.gd`) was NOT touched. Cosmetic state lives on `CardInstance` only. Combat code reads `instance.card`, never `instance.treatment_id`. Whale who owns Ultimate-everything has identical gameplay power to F2P. Matches `art_direction.md` §2 audit.
- **Layer-stack defaults set on each treatment** (revisit in T2 when shaders ship): default 0, ink 5 (alt-art swap, applied early), faction_frame 10, gold 15 (HSV-shift on art), foil 20, prism / cursed 30 (animated overlays), ultimate 40 (top + combines [gold, prism] + own animated highlight).
- **Combo system:** Ultimate uses `combines: [&"gold", &"prism"]` — engine resolves the list against the catalog and stacks layers in `stack_layer` order. `combines` references validated by `TreatmentCatalog.validate()` (catches typos / stale refs). All other treatments have empty combines.
- **Faction-frame routing:** 5 entries with `tier = FACTION_FRAME` differentiated by `faction_filter`. `TreatmentCatalog.get_faction_frame(faction)` does the lookup. Engine constants used (IRON_PENITENTS=0, WITHERED_COURT=1, HOLLOW_PACT=2, FERRUM_HOST=3, SABLE_WILDS=4) — internal-only per L2; player-facing strings use the Track-A names.
- **Cursed-tier:** `is_event_limited=true`, `event_window_days=14`, `serial` field on `CardInstance` ready for limited-run print numbering (collector flex). Validate gates on window_days>0 when event_limited.
- **Save-game ready:** `CardInstance.to_dict()` round-trips `card.id` (not the resource), `treatment_id`, `alt_art_id`, `acquired_at`, `acquired_via`, `serial`. Card resolution on load happens against the global card pool — no gameplay state ever persisted in cosmetic dicts.
- **Validation surface:** `CardTreatment.validate()` checks id/name/price/event-window/faction-frame consistency. `TreatmentCatalog.validate()` adds dup-id detection, missing-default detection, and combo-reference resolution. Both safe to wire into a CI smoke test (cheap, no I/O).
- **Sandbox status:** Godot syntax untestable in the Cowork sandbox (no engine available). Schema mirrors existing `card.gd` style (validate hook, _group exports, GFEnums references). Logic verified via mental walkthrough of validate() against the 12 catalog entries: 0 errors expected. Paul to confirm in editor — open `treatment_definitions.tres` and check resource opens without parse errors, then call `catalog.validate()` from a test scene.
- **Open Q for T2:** `shader_path` left as empty strings on all entries — populated when shader pipeline lands. Layer-stack numerics may shift once Ink's alt-art-swap-vs-frame interaction is shader-tested. No retrofits required to the data shape; only the values change.
- **Open Q for T4:** `acquired_via` enum-of-strings (&"starter", &"reward_pick", &"shop", &"gacha", &"battle_pass", &"event_cursed") set as a documented contract. Worth promoting to a real `GFEnums.AcquisitionSource` enum once T4 collection-screen filtering needs it — deferred to keep this heartbeat small.

## D-WORKFLOW-2 — SD 1.5 fallback ComfyUI workflow (heartbeat 2026-05-09)

- **Output:** `pipeline_setup/workflow_gallowfell_card_sd15.json` — 7 nodes / 9 links.
- **Topology:** Checkpoint → CLIPTextEncode (positive) + CLIPTextEncode (negative, locked) → EmptyLatentImage → KSampler → VAEDecode → SaveImage. LoRA chain removed.
- **Locked params (matched to SDXL workflow for spec portability):** sampler `dpmpp_2m`, scheduler `karras`, steps 30, CFG 6.5, seed 4242, denoise 1.0. Negative prompt verbatim from SDXL workflow.
- **Dimensions:** 512×768 (SD 1.5 native portrait, same 2:3 ratio as SDXL's 832×1216).
- **Checkpoint default:** `v1-5-pruned-emaonly.safetensors`. Operator-swappable finetune list in `extra.expected_checkpoint`: RealisticVision_v51 / DreamShaper_v8 / RevAnimated_v122 / AbsoluteReality_v18 (any of these will outperform base SD 1.5 on Gallowfell-grimdark output).
- **LoRA decision:** dropped entirely. 4 of the 10 SDXL LoRAs are SDXL-explicit by name (ClassipeintXL, RPGNightmareXL, Swamp people SDXL, Mythical Forest [SDXL]); the other 6 have unverified SD 1.5 availability. Cheapest path = run base SD 1.5 + prompt-only style targeting (named-artist + named-aesthetic tags in §3.1/§3.2 carry the load). Don't pre-optimise an unused fallback.
- **Spec-file compatibility:** per-card art specs under `art_specs/<faction>/` paste into node 2 (positive prompt) unchanged. Seeds in spec files honoured the same way at KSampler. Faction LoRA-zeroing protocol from SDXL workflow is N/A here (no LoRAs).
- **One prompt-tag tweak:** `8k` (SDXL-effective tag) → `highres` (SD-1.5-effective). Single-token swap, doesn't affect the 5-layer prompt template.
- **Validation:** subagent confirmed JSON parses, all 9 links cross-reference symmetrically in both directions, KSampler has all 4 required inputs wired, SaveImage receives IMAGE input.
- **Quality expectation:** SD 1.5 + base prompt < SDXL + 10-LoRA stack. This workflow is for hardware that can't run SDXL (Paul's RTX 2050 ~4GB VRAM is borderline). When real output quality matters, SDXL stays the primary; SD 1.5 is an emergency lane.
- **Follow-up to queue only if needed:** `D-LORA-SD15` — research SD 1.5 equivalents for the 10 LoRAs. Trigger condition: a real operator hits this fallback AND base output proves insufficient.


_(False alarm cleared 2026-04-28 — file exists, heartbeat was using a relative path. Fixed: backlog now uses absolute path. Next heartbeat will verify.)_

Heartbeat appends findings here, newest at the bottom.

---

## R1 — Top-grossing & most-downloaded mobile genres (heartbeat 2026-04-28)

**Top-grossing (revenue) — iOS + Google Play:**
- **Strategy / 4X base-building** (Whiteout Survival, Rise of Kingdoms, Clash of Clans) — deep progression + construction timers create compulsive IAP unlocks; whales spend £100s/month
- **RPG / Gacha** (Genshin Impact, Honkai Star Rail, AFK Journey) — randomised pull system drives massive per-player spend; high ARPDAU ($2–8); evergreen if content cadence holds
- **Casino / Slots** (Jackpot Party, Slotomania) — regulatory arbitrage + VIP whales; near-limitless IAP ceiling; legally complex in UK/EU
- **Match-3 Puzzle** (Royal Match, Candy Crush Saga) — enormous DAU, broad demographic, gentle IAP ladder ($0.99–$9.99), strong ad revenue from free players
- **Sports / Sports management** (EA FC Mobile, Golf Clash, Football Manager Mobile) — licensed IP drives installs; season-pass cadence; global audience

**Most downloaded (volume) — both stores:**
- Hyper-casual arcade/puzzle leads on installs (but monetises mostly via ads)
- Match-3 and word games (Wordle-alikes) dominate mid-tier
- Battle royale (PUBG Mobile, Free Fire) massive in SE Asia / LatAm
- Runner / endless games (Subway Surfers category) — evergreen, low-friction

**Take-away:** For a first game, Match-3 or casual strategy offers the best balance of proven revenue model, reachable production budget, and Claude-buildable scope.

---

## R2 — Genre cheat sheet: hyper-casual vs hybrid-casual vs casual vs midcore (heartbeat 2026-04-28)

| Genre | Dev cost | Time-to-ship | ARPDAU | Notes |
|---|---|---|---|---|
| **Hyper-casual** | $5k–50k | 2–8 weeks | $0.01–0.05 | Nearly 100% ad revenue; iOS ATT killed targeting → market contracting hard in 2025-26; avoid unless you have a CPI < $0.10 angle |
| **Hybrid-casual** | $30k–150k | 8–16 weeks | $0.08–0.25 | Casual skin + meta layer (collect/build/story); best CPI + ARPDAU ratio right now; Claude-buildable |
| **Casual** | $100k–500k | 4–12 months | $0.15–0.60 | Match-3, word, puzzle — proven LTV but crowded; needs good IP or hook to break through |
| **Midcore** | $500k–3M+ | 12–24 months | $0.50–2.00 | 4X, RPG, strategy — high whale spend but brutal competition and long runway |

**Take-away:** Hybrid-casual is the correct target for a Claude-built first game — lowest total risk, fastest to testable prototype, growing segment.

---

## Phase 2 unlocked — Paul's references logged 2026-04-28

**Reference games:** Tower Defence, Vampire Survivors, Marvel Snap, Hearthstone, Magic the Gathering, Baldur's Gate 3, D&D, Angry Birds, Temple Run.
**Aesthetic:** grimdark gothic-fantasy / Warhammer-style — but ORIGINAL faction names only (GW + WotC IP locked out).
**Required monetisation pillars:** microtransactions, bundles, time locks, resource locks, short-burst sessions.

**Three concept directions for heartbeat to develop into one-pagers (G2):**
1. Roguelite tower-defence deckbuilder — 10-min runs, deck of unit/spell cards, TD lanes, Warlord meta-progression.
2. 3-min auto-battler card duel — Snap-style PvP, grimdark factions, weekly meta cards.
3. Horde survivor with hero collection — VS-style 5-min runs, gacha heroes/relics, weekly bosses.

Heartbeat: skip ahead to Phase 2 G1+G2 once R3–R8 are done (need core mechanics/monetisation/retention research before pitching concepts properly). Then pause for Paul to pick a winner.

---

## R3 — Top 10 addictive mechanics (heartbeat 2026-04-28)

- **Variable reward / slot-machine loop** — randomise reward timing/size so players can't predict drops; implemented via weighted loot tables on run-end chest
- **Daily streak** — reward N-day login chains with escalating prizes; day 7 = premium currency spike; hard reset on miss to drive guilt-reinstall
- **Energy system** — cap free plays (e.g. 5 lives/hearts); refill 1 per 20 min or pay; creates natural re-engagement windows aligned with push notifications
- **Gacha / card pull** — sell randomised card packs; pity system at N pulls guarantees rare; "sparkle" animation on rare reveal is the dopamine hit
- **Battle pass** — sell 8-week seasonal pass (~£5); free track shows paid rewards just out of reach; XP grind drives daily engagement automatically
- **Loss aversion** — show "you almost won" screen after a close-run defeat; offer a revival gem purchase at the moment of maximum frustration
- **Social proof** — leaderboards, "your friend just unlocked X", "1.2M players online" ticker; makes the game feel alive and competitive
- **FOMO / limited-time offers** — rotating shop with 24h countdown; seasonal events with exclusive cosmetics never returning; creates urgency to spend now
- **Sunk cost escalation** — show cumulative time/gold invested before an optional IAP prompt; "you've built so much — don't lose it" framing
- **Near-miss** — in roguelite TD context: show the boss at 5 HP when the player loses; offer a gem-powered extra 10 seconds; statistically tuned to feel achievable

**For our roguelite TD deckbuilder — priority mechanics to wire in MVP:** Variable rewards (run-end loot), Battle pass, Energy cap on daily runs, Near-miss revival. Gacha on card packs in v1.1.

---

## R4 — Free game engines shortlist (heartbeat 2026-04-29 09:20)

Scored on: **Free?**, **AI/CLI-controllable?** (can Claude drive headless from a repo with no GUI babysitting), **iOS + Android export**, **Asset ecosystem**.

| Engine | Free? | AI / CLI-controllable | iOS + Android export | Asset ecosystem |
|---|---|---|---|---|
| **Unity 6** | Free under Personal tier (rev < $200k/yr); no per-install runtime fee since the 2024 reversal | **Strong.** Pure-text C# scripts, scene/prefab files are YAML-ish, headless batch builds via `-batchmode -executeMethod`, official MCP tooling exists. Editor still helpful but not required. | Best-in-class. Native iOS (Xcode project export) + Android (Gradle). Mature signing pipelines. | Largest of any engine. Asset Store huge (paid + free), great for placeholders → ship. |
| **Godot 4.x** | 100% free, MIT licence, no royalties, no rev cap | **Excellent.** Scenes/scripts are plain text (`.tscn`, `.gd`), git-friendly, headless export from CLI (`godot --export-release`), GDScript is concise and Claude-native. Very LLM-friendly. | Yes both. iOS export is solid in 4.3+; Android export is mature. C# also supported if preferred. | Smaller than Unity but growing fast. Plenty of free CC0 assets via Kenney/OpenGameArt. Fewer paid plugins. |
| **Defold** | Free, no royalties (King-owned, permissive licence) | **Good.** Lua scripts, text-based project files, CLI builds via `bob.jar`, headless CI well-documented. Less mainstream so fewer LLM training examples. | Yes both. Specifically tuned for mobile — small binary sizes, low RAM. | Smaller ecosystem; official asset portal modest. Best when you'll write most assets yourself. |
| **Phaser 3 / 4** | MIT, fully free | **Excellent for code, weak for visual tooling.** Pure JS/TS, no editor required, runs on Node, trivial to drive from Claude. But it's a 2D web framework — you wrap with Capacitor/Cordova for stores. | Indirect: build to web, wrap with **Capacitor** (preferred 2026) for iOS/Android. Extra signing/store steps. Performance fine for 2D card/TD scope. | Web/JS library ecosystem is massive; game-specific assets via Kenney etc. |
| **Cocos Creator 3.x** | Free, no royalties | **Mid.** TypeScript scripting + scene editor. CLI builds exist but the editor is more central than Godot/Unity. Less LLM training data than Unity/Godot. | Yes both, very good mobile perf (huge in CN market). | Decent, China-heavy. English docs improved but still patchier than Unity/Godot. |

**Quick scoring (out of 5):**

| | Free | AI/CLI | iOS+Android | Assets | **Total** |
|---|---|---|---|---|---|
| Unity 6 | 4 | 4 | 5 | 5 | **18** |
| Godot 4 | 5 | 5 | 4 | 3 | **17** |
| Defold | 5 | 4 | 5 | 2 | **16** |
| Phaser + Capacitor | 5 | 5 | 3 | 4 | **17** |
| Cocos Creator | 5 | 3 | 5 | 3 | **16** |

**Take-away for R5 next:** Unity vs Godot is the real fight for our roguelite TD deckbuilder. Unity wins on asset availability and store-tooling maturity; Godot wins on pure-text Claude-driveability and zero licence drama. Phaser+Capacitor is a dark horse if we want web-first iteration speed.

---

## R6 — Free asset pipelines (heartbeat 2026-04-29 09:40)

**2D art / sprites — for painterly grimdark style we need:**
- **Stable Diffusion (SDXL / Flux) — local, free.** Full control of style, runs on Paul's GPU or via Anthropic image gen MCP. Model output licences are permissive for commercial use on most current models (CreativeML Open RAIL-M / Apache 2.0). Primary art workhorse.
- **Kenney.nl** — CC0, fully commercial. Style is cute/clean, not grimdark — useful for placeholder UI tiles, icons, prototyping only.
- **OpenGameArt.org** — mixed CC licences (CC0, CC-BY, GPL). **Must check per-asset** before shipping. Good for ambient props.
- **itch.io free asset packs** — same warning, per-asset licences. Some grimdark packs are excellent.
- **Krita** (free, GPL) — open-source Photoshop-equivalent for hand-touching AI output. Aseprite (£17, one-off) only if we go pixel-art; LibreSprite is the free fork.

**SFX — punchy game sounds:**
- **Sonniss GDC bundles** — annual "GameAudioGDC" CC0 packs, professional studio quality, **fully free + commercial**. Single best free SFX source.
- **Freesound.org** — CC licences (CC0 to CC-BY-NC). Filter for CC0 or CC-BY only; never use NC for commercial.
- **Bfxr / ChipTone / SFXR** — free generative tools for retro/synth SFX. Output is yours to use.

**Music — atmospheric, dread-laden:**
- **Pixabay Music** — own licence, free + commercial, no attribution required. Smaller library; some grimdark-adjacent tracks.
- **Incompetech (Kevin MacLeod)** — CC-BY, free **with attribution** in credits. Massive catalogue, decent dark/cinematic tracks.
- **Suno / Udio (paid tier)** — generative AI music. **Free tier is non-commercial only** — need paid (~$10–20/month) for commercial rights on outputs. Worth budgeting.
- **Bensound** — free with attribution; paid tier removes attribution requirement. Limited grimdark.

**Voice (only if Warlords get VO later):**
- **ElevenLabs paid tier** — 2025 ToS updated, paid plans grant commercial rights to outputs. Free tier is preview-only.
- **Coqui TTS (open source)** — fully free, weaker quality, fine for placeholder.

**Fonts:**
- **Google Fonts** — SIL Open Font Licence, free commercial, no attribution needed. Grimdark-friendly families: **Cormorant, Cinzel, IM Fell English, UnifrakturCook, Pirata One**.
- **The League of Movable Type** — OFL, designer-curated free commercial fonts.
- **Font Squirrel** — curated free-commercial only; safer than Dafont.
- **Avoid:** Dafont (most fonts there are "free for personal use only" — easy licensing trap).

**Recommended stack for our game:**
- **Art:** Stable Diffusion (SDXL or Flux model) + Krita touch-ups → grimdark painterly style.
- **SFX:** Sonniss GDC bundles as base, Freesound CC0 for top-ups, Bfxr for UI blips.
- **Music:** Suno/Udio paid tier (~$15/mo) OR Pixabay Music (free). Recommend paid — music is the cheapest way to make a grimdark game *feel* expensive.
- **Fonts:** Cinzel (display/title) + IM Fell English (body/lore text) — both Google Fonts, OFL.

**Total monthly cost at this tier:** $0–15. The only paid line item I'd recommend is Suno/Udio for music; everything else is genuinely free for commercial use.

---

## R5 — Recommended engine: **Godot 4** (heartbeat 2026-04-29 09:25)

1. **Pure-text project files** — `.tscn`, `.gd`, `.tres` all merge cleanly in git and read like config; Claude can author scenes without a GUI loop.
2. **Headless CLI builds** — `godot --headless --export-release "Android" build.apk` slots straight into GitHub Actions; no editor server, no licence dance.
3. **Zero licence/royalty risk** — MIT, no rev cap, no runtime-fee surprises like Unity's 2023 episode. Matters because we're optimising for "Paul never has to negotiate a contract."
4. **Scope fit** — 2D painterly grimdark, card UI, tower-defence grid: Godot's 2D node system is purpose-built for this; we don't need Unity's 3D firepower or asset-store breadth.
5. **Claude-driveability** — GDScript is concise and well-represented in training data; C# also available if we hit a perf wall.
6. **Trade-off accepted** — smaller paid-asset ecosystem than Unity. Mitigated because our art pipeline is AI-generated (Stable Diffusion / nano-banana / Kenney CC0 fillers), not asset-store-driven anyway.

**Verdict:** Godot 4 for B1 onwards. Phaser+Capacitor stays as the fallback if mobile export ever surprises us.

---

## V1 + V2 — completed 2026-04-29 (real-time with Paul)

- **V1 (PAT verification):** Confirmed via GitHub web UI. PAT is Active, expires 2026-07-27, scoped to `Gonzo8285/MobileGame` only, has Read+Write on code/actions/workflows/secrets/etc, Read on metadata. Direct CLI auth not possible — see network-environment note below.
- **V2 (repo bootstrap):** `.gitignore` + `README.md` authored in project folder, uploaded to repo by Paul via GitHub web UI, committed to main as "chore: bootstrap repo".
- **Network-environment note (important for all future build work):** R.T. Keedwell's corporate network does TLS interception (Schannel curl gets HTTP 000 on github.com, browser works fine because it has the corporate root CA via Group Policy). The Cowork sandbox's outbound proxy blocks github.com via allowlist (`X-Proxy-Error: blocked-by-allowlist`). So **neither Paul's laptop nor the sandbox can reach GitHub directly via CLI right now.** Implication: any future write to the repo from a heartbeat run will need either (a) a Cowork-side allowlist change, (b) a GitHub MCP connector (none in registry as of 2026-04-29), or (c) Paul as the manual courier via web UI. Phase 3 build work needs option (a) or (b) before it's automatable.

---

## V1 attempt — heartbeat 2026-04-29 09:16

- Sandbox is up, but its outbound proxy (`localhost:3128`) blocks `api.github.com` and `github.com` with `X-Proxy-Error: blocked-by-allowlist` (HTTP 403 at CONNECT).
- Result: cannot test the PAT or run `git ls-remote` from this sandbox at all — the request never reaches GitHub, so we can't tell if the token is good or bad.
- **Not a Paul blocker** (no evidence PAT is wrong). Treating this like "sandbox unavailable for V1" per heartbeat rules: V1 left unticked, retry next run in case the allowlist changes.
- If the next 2–3 heartbeats hit the same wall, escalate then — options would be (a) ask Paul to whitelist github.com on the sandbox if he can, or (b) shift V1/V2 verification to an out-of-sandbox path.

---


## R7 — Monetization stack (heartbeat 2026-04-29 18:20)

**Mediation networks (all free SDKs):**
- AdMob (Google): easiest setup, safest for Play Store, lower eCPMs, good fill. Best as a demand source, not as primary mediator in 2026.
- AppLovin MAX: industry-leading mediation in 2025-26, real-time bidding (MAX bidding), highest eCPMs in casual/midcore, engine-agnostic, strong dashboard. Free.
- Unity LevelPlay (ex-ironSource): Unity-native, strong rewarded performance, less relevant since engine = Godot 4.

**Pick:** AppLovin MAX as primary mediator + AdMob as a demand source in the waterfall. Rationale: best eCPMs, engine-agnostic (Godot), no fee.

**Rewarded video best practice:**
- Cap ~5-8 rewards/session to avoid devaluing soft currency.
- Placements: post-defeat continue, 2x end-of-run rewards, free daily chest, gacha bonus pull, energy refill, card-pack reroll.
- Always opt-in ("Watch ad to..."), never forced/interstitial-style block.
- Pre-load on session start; never gate core loop behind an ad load.
- Rewarded reward value ≈ 30-50% of equivalent IAP — preserves IAP funnel.

**IAP price ladder template (USD, store-localized):**
- $0.99 — starter pack (one-time, first 72h only, ~3x value)
- $2.99 — small gem pack / weekly mini-pass
- $4.99 — battle pass tier / small bundle
- $9.99 — medium pack (sweet-spot SKU, target ~40% of IAP revenue)
- $19.99 — large pack
- $49.99 — mega pack (whale tier)
- $99.99 — ultimate (whale ceiling, store max for many regions)
- 70/20/10 rev split typical: ~70% revenue from <5% of payers.
- Bundle > raw currency (perceived value, +Warlord/skin/cosmetic).
- Always run a first-purchase offer; refresh weekly bundles to drive habit.

**Compliance notes (PEGI 12, Apple/Google 2026):**
- Loot box odds must be disclosed in-store + in-game (Apple + Play policy).
- No paid-only gacha for under-12 surfaces; rewarded-video gacha is fine.
- ATT prompt on iOS, GDPR/UMP consent on Android — wire via MAX SDK.

## R8 — Retention systems blueprint (heartbeat 2026-04-29 18:21)

**D1 (target: 35-45% for casual/midcore):**
- Strong FTUE: first run is a guaranteed win (rigged easy), Warlord unlock at end, +1 card pack.
- Push notif at -22h: "Your warband marches at dawn — claim your daily relic."
- Day-1 quest: "Win 1 run" with juicy reward (rare card).
- Limited-time first-purchase offer pinned for 72h.

**D7 (target: 12-18%):**
- Daily login calendar (see template below) with a milestone reward on Day 7.
- Weekly battle pass mini-arc resets — 7-day cycle.
- Faction "favour" meter — pick a faction by D3, hits first reward at D7.
- Friend/clan onboarding nudge by D5 (even if PvE-only, social = guilds for co-op events).
- Push notif cadence: 1/day cap, smart-time, skipped if user already played that day.

**D30 (target: 4-7%):**
- Meta progression unlocks at D14 (e.g. 4th Warlord slot, "ascension" difficulty).
- Monthly battle pass premium track (~$4.99) with cosmetic + Warlord shard drip.
- Live ops calendar: 2 events/month (faction war, boss rush), each 5-7 days long.
- Returner bonus: lapsed >7d gets a "comeback" 3-day buff + free pack.
- Mastery / collection completion (300+ cards target by D30 — "gotta catch 'em all" pull).

**Daily reward calendar template (28-day cycle, monthly rotation):**
| Day | Free | Premium pass |
|-----|------|--------------|
| 1 | 50 gold | 100 gold + 1 common card |
| 2 | 30 gold | 60 gold + dust |
| 3 | 1 common pack | 1 rare pack |
| 4 | 50 gold | 100 gold + cosmetic shard |
| 5 | 30 gold | 60 gold + Warlord shard |
| 6 | 30 gold | 60 gold + dust |
| 7 | **1 rare pack + 200 gold** | **1 epic pack + cosmetic** |
| 14 | **1 epic pack** | **1 legendary card + 5 Warlord shards** |
| 21 | **1 legendary card** | **2 epic packs + skin** |
| 28 | **Warlord unlock token** | **Warlord skin + 1000 gold** |
- Streak preserve: 1 free skip / 14 days. Watch-rewarded-ad to restore streak.
- Reset on month boundary, but cumulative 28-day streak unlocks a permanent cosmetic.

## R9 — Apple Developer Program 2026 (heartbeat 2026-04-29 18:22)

**Cost:** $99/yr individual or organization (Organization needs a D-U-N-S number). Free tier exists but cannot ship to App Store — sideload/TestFlight only on dev's own devices, 7-day expiry.

**Recommended for Paul:** Individual ($99/yr) unless RT Keedwell Group should be the publisher (then Organization + D-U-N-S, +1-2 weeks lead time).

**What ONLY Paul can do (real blockers):**
- Enroll & pay the $99 with his Apple ID + 2FA on his own device.
- Verify identity (passport / driving licence) — Apple's KYC step.
- Sign Paid Apps Agreement + tax & banking forms in App Store Connect.
- Approve / accept any contract updates that pop up later.

**What Claude can prep (no Apple login needed):**
- Bundle ID naming, app metadata draft, store listing copy, screenshots, privacy policy text, age rating questionnaire answers.
- App Privacy "nutrition label" answers based on SDKs we wire (MAX, AdMob, Firebase).
- Export Compliance answers (we ship encryption only via standard HTTPS — exempt).

**Signing requirements (key constraint):**
- Code signing & uploads to App Store Connect REQUIRE macOS + Xcode (or a Mac CI runner).
- Paul has no Mac → use cloud Mac CI: **Codemagic (500 build min/month free)** or **GitHub Actions macOS runners (free for public repos / paid for private)**. Codemagic preferred — Godot 4 export templates supported, headless signing via fastlane match works, Claude can drive it.
- Need: Apple Distribution certificate + provisioning profile + App Store Connect API key (.p8). Claude can generate the .p8 via App Store Connect once Paul logs in once and clicks "create API key".

**Lead time to first TestFlight:** ~3-5 days from enrolment day (24-48h Apple verification + cert/profile setup + first build).

## R10 — Google Play Console 2026 (heartbeat 2026-04-29 18:23)

**Cost:** $25 one-time registration. Plus: identity verification mandatory since 2023 (passport/driving licence), and "developer verification" (D-U-N-S for orgs, gov ID for individuals) is enforced in 2026. Personal accounts must also have ≥12 testers run a closed test for ≥14 days before the first prod release (still in force 2026).

**Account choice:** Personal (Paul) is fine for now — cheaper, faster. Org account if RT Keedwell Group is publisher (D-U-N-S needed). Personal can be migrated to Org later.

**Testing tracks (use in this order):**
1. **Internal testing** — up to 100 testers, available within minutes. No review. Use for Claude's CI builds.
2. **Closed testing** — required: ≥12 opted-in testers actively testing for ≥14 consecutive days. Mandatory for new personal accounts before prod.
3. **Open testing** — public beta, listed on Play if you opt in. Soft-launch lever.
4. **Production** — global or staged country rollout (start 1-5%, ramp).

**Required artefacts (gathered before first upload):**
- Signed AAB (Android App Bundle, NOT APK) — Play App Signing handles key rotation.
- App icon: 512x512 PNG (32-bit). Feature graphic: 1024x500 PNG.
- Screenshots: phone (min 2, max 8), 7" tablet, 10" tablet (all optional but recommended).
- Short description (≤80 chars), full description (≤4000 chars).
- Privacy policy URL (mandatory, public, hosted — Paul needs a URL, can be a free GitHub Pages page).
- Data safety form (declares SDK data collection — Claude can prep based on MAX/AdMob/Firebase).
- Content rating: complete IARC questionnaire (PEGI 12 target).
- Target audience & content + ads declaration.
- Government / pricing / device categories.

**14-day pre-launch checklist:**
- Day -14: closed test launches with ≥12 testers (Paul to recruit — friends/family, or use Google's tester finder).
- Day -10: first crash-free target ≥99%, ANR <0.47%, all required forms green.
- Day -7: data safety, content rating, target-audience, ads declaration all submitted.
- Day -5: final store listing locked (screenshots, descriptions, localized copies).
- Day -3: pre-launch report (auto-run on closed track) reviewed — fix all "high severity" issues.
- Day -1: production release created in draft, country list set, staged rollout % = 5.
- Day 0: submit for review (review usually 1-3 days).

**Lead time:** Personal acct + 14-day closed test rule = realistic minimum 3 weeks from upload-ready to global production.

## R11 — ASO 2026 (heartbeat 2026-04-29 18:24)

**Apple App Store fields (iOS):**
- App Name: 30 chars (most-weighted in search ranking).
- Subtitle: 30 chars (highly weighted).
- Keywords: 100-char comma-separated list, hidden from users (highly weighted).
- Promotional Text: 170 chars, editable without resubmit (NOT indexed for search).
- Description: 4000 chars (NOT indexed by Apple — only first 3 lines visible above fold).
- In-App Events: indexed since iOS 15, drives discovery — use for live ops.

**Google Play fields (Android):**
- Title: 30 chars (heaviest weight).
- Short description: 80 chars (indexed).
- Full description: 4000 chars (FULLY indexed by Play — keyword density matters).
- Tags: pick 5 from Google's preset list (since 2023 — replaces old keyword field).

**Screenshot frame templates (the meta in 2026):**
- Slide 1 = hook ("ROGUELITE TD WITH CARDS" overlay + screenshot).
- Slide 2 = core fantasy ("BUILD YOUR WARBAND").
- Slide 3 = depth ("100+ CARDS, 10 WARLORDS").
- Slide 4 = social proof / award badge if any.
- Slide 5 = call to action ("PLAY FREE").
- Use 9:19.5 portrait, 1290x2796 for iPhone 6.7", 1080x1920 for Play.
- Auto-pipeline: Figma template + Claude generates per-locale variants.

**A/B test tooling:**
- Apple: native "Product Page Optimization" — 3 treatments, up to 90 days, 50% traffic split. Free.
- Google: native "Store Listing Experiments" — up to 5 variants, 90 days. Free.
- Third-party (paid): SplitMetrics, Storemaven — overkill for indie, skip.
- Test order: icon → screenshots 1-2 → subtitle → description. Icon CVR lift is biggest. Run one test at a time, ≥7 days each, need ≥1000 visitors/variant for significance.

**Quick keyword research (free):**
- AppFollow free tier, Sensor Tower free trial, Google Keyword Planner, Apple's own search-suggest.
- Target medium-volume / low-competition long-tails ("grimdark deckbuilder", "tower defense roguelite", "warband card game").

## R12 — Soft-launch playbook (heartbeat 2026-04-29 18:25)

**Soft-launch markets (English-speaking, lower CPI, mature mobile):**
- Tier-1 best for English midcore: **Canada**, **Australia**, **New Zealand**, **Ireland** — high payer behaviour mirrors US/UK, fraction of UA cost. Use these for monetisation tuning.
- Tier-2 for retention/scale tests: **Philippines**, **Malaysia**, **Vietnam** — cheap installs, big volume, but lower ARPDAU; use for retention/funnel debug not LTV.
- Tier-3 EU: **Netherlands**, **Sweden**, **Denmark** — payer behaviour close to UK, helpful for GDPR/UMP testing.

**Recommended 3-market combo for our game:** CA + AU + PH. CA+AU = LTV proxy, PH = retention/scale + cheap UA learning.

**KPI gates to global launch (must hit ALL before opening more markets):**
- D1 retention ≥ 38% (midcore deckbuilder benchmark).
- D7 retention ≥ 14%.
- D30 retention ≥ 5%.
- ARPDAU ≥ $0.18 (CA/AU blended).
- Crash-free sessions ≥ 99.5%.
- Tutorial completion ≥ 75%.
- Day-1 ad eCPM USD ≥ $20 (rewarded), $8 (interstitial).
- Payer conversion (D7) ≥ 2.0%.
- LTV-to-CPI break-even path < 180 days at modest UA spend.

**Soft-launch duration:** 8-12 weeks typical. Run 2-week iterative cycles: ship build → measure → tune → reship.

**UA budget for soft launch:** $500-$2000/month is enough to get statistically meaningful retention/ARPDAU signals in CA+AU+PH. Use Meta + Google App Campaigns. Don't bother with TikTok during soft-launch (noise).

**Decision tree post soft-launch:**
- All KPIs green → ramp to UK + US + DE + JP (top revenue markets).
- ARPDAU green but D7 weak → fix retention before scaling.
- D7 green but ARPDAU weak → tune monetisation surfaces, don't kill the game.
- Both red → pivot or pause; don't burn UA $ on a leaky bucket.

## R13 — CI/CD options Claude can drive headless (heartbeat 2026-04-29 18:26)

**The constraint:** iOS signing/upload requires macOS. Android signing can run anywhere. Claude needs a CI that exposes an API/CLI Claude can drive without Paul logging in for each build.

**Comparison:**

| Option | Free tier | macOS? | Godot 4? | Auth Claude can drive | Notes |
|---|---|---|---|---|---|
| **GitHub Actions** | 2000 min/mo private (Linux), 500 min/mo macOS for paid; free for public | Yes (paid for private repo) | Yes (community templates) | PAT + repo secrets | Strongest option if Paul accepts paid macOS minutes (~$0.08/min). Free for Linux Android builds. |
| **Codemagic** | 500 min/mo free (incl. macOS) | Yes | Yes (official Godot template) | API token | Best free option for iOS. Built for mobile. fastlane match supported. **Recommended for iOS.** |
| **EAS Build (Expo)** | Limited free tier | Yes | No (React Native only) | API token | Skip — wrong engine. |
| **Unity Cloud Build** | Tied to Unity license | Yes | No | API | Skip — wrong engine. |
| **Bitrise** | 200 min/mo free | Yes | Yes (custom) | API token | Decent backup, more complex. |
| **Fastlane (self-hosted)** | Free | Needs Mac | Yes | n/a | Needs a Mac box; not viable for Paul. |

**Recommended stack:**
- **Android builds + tests:** GitHub Actions (Linux, free minutes), godot-headless container, output AAB, upload to Play via `r0adkll/upload-google-play` action.
- **iOS builds:** Codemagic (free 500 min/mo macOS, official Godot 4 export template, fastlane match for cert mgmt, App Store Connect API key for upload).
- **Repo:** Gonzo8285/MobileGame (already created).
- **Secrets needed in CI:**
  - GITHUB_PAT (already have).
  - GOOGLE_PLAY_SERVICE_ACCOUNT_JSON (Paul creates once in Play Console).
  - APP_STORE_CONNECT_API_KEY_ID + ISSUER_ID + .p8 file (Paul creates once in App Store Connect).
  - APPLE_TEAM_ID, MATCH_PASSWORD (Claude generates).

**Auth-flow steps that REQUIRE Paul (one-time each):**
1. Create Play Console service account → download JSON key → paste into a secret.
2. Create App Store Connect API key → download .p8 → paste into a secret.
3. Once those are in repo secrets, Claude drives all subsequent builds & uploads headless.

**Cost reality:** Codemagic free 500 min/mo = ~25-40 iOS builds/month. Enough for soft-launch cadence. If we exceed, $0.038/min macOS (cheaper than GitHub).

## R14 — AI tools / MCPs worth connecting (heartbeat 2026-04-29 18:27)

**Image / sprite gen:**
- **Stable Diffusion (local via ComfyUI / Automatic1111)** — free, fully offline, FLUX & SDXL checkpoints, ControlNet for consistent character poses. Best for painterly grimdark style. Claude can drive via API if exposed. (Paul: free, local.)
- **Leonardo.ai** — generous free tier (150 tokens/day), good game-asset presets, API available on paid plans. Good fallback. (Free tier OK.)
- **Scenario.gg** — built for game art, custom-trained style models, paid only. Skip for now.
- **Krea / Recraft** — quick concept work, free tiers. Useful for moodboards.

**Audio gen:**
- **freesound.org** — CC-licensed SFX library, free, attribution. Workhorse.
- **ElevenLabs** — free tier 10k chars/mo, voice for Warlord barks/UI lines. Paid is fairly cheap.
- **Suno** — free 50 songs/day, AI music for menu/combat/boss themes. Licence permits commercial use on paid tier (~$8/mo). Free tier non-commercial only — must upgrade before launch.
- **Udio** — Suno alternative, similar tier.
- **AudioCraft (Meta, local)** — free, runs locally, lower quality than Suno.

**Analytics:**
- **Firebase Analytics + Crashlytics** — free, Google-owned, baseline. Wire on day 1.
- **GameAnalytics** — free, designed for games (funnels, DAU/MAU, ARPDAU, monetisation). Highly recommended alongside Firebase.
- **AppsFlyer** — paid attribution; defer until soft-launch with paid UA.
- **Adjust** — paid alt; defer.

**Store-listing / ASO tools:**
- **AppTweak / Sensor Tower / data.ai** — paid, free trials. Use during ASO research only.
- **AppFollow** — free tier covers reviews monitoring + basic keywords.
- **Apple's own search-suggest + Play's tag list** — free, surprisingly decent.

**MCPs Claude could plug into right now (priority order):**
1. **GitHub MCP** — unblocks the firewall problem (Paul note in memory: corp net + sandbox both block github.com). Highest leverage.
2. **Filesystem MCP** — already implicit via Cowork.
3. **A web-fetch MCP that bypasses sandbox proxy** — would fix the same firewall gap.
4. **Image gen MCP** (e.g. fal.ai, Replicate, or local ComfyUI bridge) — Claude can drive concept art autonomously.
5. **Codemagic MCP / API wrapper** — trigger iOS builds from chat.
6. **Google Play Publisher API MCP** — upload AABs from CI, manage tracks.
7. **App Store Connect API MCP** — upload IPAs, manage TestFlight.

**All free / freemium:** SD local, Leonardo free, freesound, ElevenLabs free, Suno free (dev only), Firebase, GameAnalytics, AppFollow free, Apple/Play native A/B. Total monthly $ during dev: $0. During launch: ~$8 Suno + ~$5 ElevenLabs + ~$0 everything else = ~$15/mo.

## R15 — 1-page condensed brief (heartbeat 2026-04-29 18:28)

Wrote Phase 1 summary to `phase1_brief.md` in the project folder. Covers R1–R14 in one page: market, engine, monetisation, retention, storefronts, ASO, soft-launch, CI/CD, AI tooling, blockers, what's next (G4 onwards).

**Phase 1 complete.** Heartbeat continues into Phase 2.

## G4 — 1-page GDD (heartbeat 2026-04-29 18:30)

Wrote `gdd_v0.md` in project folder. Covers pitch, core loop, run structure, card types, Warlord classes, 5 factions (placeholder names — formalised in G6), monetisation surfaces, MVP scope, out-of-scope, working titles, risks/open Qs.

**Open Qs for Paul** (flagged in GDD):
- Energy mechanic yes/no for MVP?
- BP at MVP or post-soft-launch?
- Local GPU for ComfyUI or paid Leonardo for art?
- Working title from G5 list?

**Phase 2 still needs Paul sign-off before Phase 3 unlock.** Heartbeat continues working through G5–G9 to give Paul a complete review package.

## G5 — Name candidates (heartbeat 2026-04-29 18:32)

Wrote `g5_names.md`. Findings from 2 web searches:
- **Gallowmarch** — clean, no app-store or trademark collisions found. Heartbeat top pick.
- **Penitent Lane** — clean but reads softer than grimdark mandate.
- **The Last Banner** — clash w/ "Tattered Banners" (Steam) + too generic. Drop.
- **Ashen Tide** — clash w/ "Ashen Legacy" + "Ashen" mobile. Drop.
- **Hollow Crown** — clash w/ "Hollow Knight" audience confusion. Drop.
- **Backups generated:** Carrionfall, Bonewatch, Nightcantor, Veilcleave, Ruinmarch.

**Needs Paul:** pick top 1 (Gallowmarch recommended) so heartbeat can lock it in `project_config.md` and use it for repo/build naming. Full TM filing happens pre-launch, not pre-build.

---

## G6 — Faction bible v0 (heartbeat 2026-04-30 04:17)

Wrote `faction_bible.md` — 5 factions fleshed with vibe, visual cue (silhouette + palette + motif), mechanical role, and a flagship unit each.

- **Iron Penitents** — aggro/sacrifice; oxblood + iron; nail-helms, chains.
- **Ash-Mourners** — control/debuff; charcoal + ember; censers, ash-painted faces.
- **Coven of the Black Mire** — swarm/poison; bog-green + leech-purple; antler crowns, drowned familiars.
- **The Last Legion** — tempo/formation; storm-blue + brass; tattered "Crowned Eagle Sundered" heraldry (original).
- **Skinward Pact** — summoner/monstrous; forest-black + ochre; beastfolk shamans, hide cloaks.

IP-boundary cross-check passed: no GW / WotC / Privateer Press collisions. Names cleared for use in G7 card design unless Paul vetoes.

**Next heartbeat:** G7 — 30-card starter pool across 3 factions (18 units / 8 spells / 4 traps).

---

## G7 — Card design v0 (heartbeat 2026-04-30)

Wrote `cards_v0.md` — 30-card starter pool. MVP factions: Iron Penitents, Ash-Mourners, Coven of the Black Mire. (Last Legion + Skinward Pact held for post-MVP unlocks.)

- **Distribution:** 18 units (6/6/6) + 8 spells (3/2/3) + 4 traps (0/3/1). Mourners hold the trap toolkit because Control wants it most.
- **Rarity skew:** 16 C / 11 U / 3 R / 0 E — accessible starter pool, room to slot Epics in v0.1.
- **Curve:** bottom-heavy by design (1-cost: 7 cards, 2-cost: 8) — TD opening waves need cheap plays.
- **Archetype anchors hit:** Penitent aggro (Hammer-Confessor + Procession of Nails), Mourner control (Last Censer-Bearer + Cinder Tide + 3 traps), Coven swarm (Toad-Caller + Mother Quag).
- **Cross-faction splash cards:** P5 Choir-Master (aggro→swarm bridge), M4 Funeral Drummer (control→aggro), C8 Antler Crown (sacrifice tool that talks to Penitent decks).
- **Keywords used:** Cleave, Pierce-not-yet, Bleed, Poison, Root, Fear, Shield, Resurrect, Summon, Sacrifice, Penance, Dread. Smoke + Slow used as plain status — flagged for promotion to keywords in GDD v0.1.

**Open Qs for Paul** (logged in `cards_v0.md`): rarity mix bump? Mire-Spawn draftable y/n? Promote Smoke/Slow to formal keywords?

**Next heartbeat:** G8 — Monetisation surface map (markdown diagram showing where IAP / bundles / energy / BP / rewarded video slot in).

---

## G7 v0.1 — Paul's resolutions applied (2026-04-30)

Paul answered the three open Qs from `cards_v0.md`. Updates landed:

- **Rarity:** Honest miscount caught — original v0 was 15C/11U/4R (not 16/11/3 as written). Paul asked to bump R, so promoted **M8 Cinder Tide U → R**. Final mix **15 C / 10 U / 5 R**. Slightly Mourner-heavy on Rares — flagged for v0.2 (consider promoting C5 Briar-Hag for symmetry).
- **C1 Mire-Spawn:** Now **draftable** at 0-cost in early Coven decks (was token-only). Plus art hook: ship a unique **"Beta Pull" alt-art skin** for early-access cohort — feeds founder/closed-beta retention narrative and gives a collectible flex item from day one. Action: log on B3 art pipeline backlog when Phase 3 unlocks.
- **Smoke + Slow:** Promoted to **permanent evergreen keywords**. Added formal definitions to `cards_v0.md` keyword block AND updated `gdd_v0.md` Keywords section to v0.1.
  - **Smoke** = zone status, Fear-1 + -1 ATK while inside, stacks with Dread.
  - **Slow-X** = unit movement -X tiles/turn, caps at Slow-3 (= Root), stacks with Poison/Bleed.

Files touched: `cards_v0.md` (now v0.1), `gdd_v0.md` (keyword section v0.1).

**Next heartbeat:** G8 — Monetisation surface map.

---

## G8 — Monetisation surface map (heartbeat 2026-04-30 14:16)

- Created `monetisation_map.md` — Mermaid player-journey diagram + 12 surface-by-surface entries.
- Key choices made (flagged for Paul to override if wanted):
  - Energy: OFF at launch, A/B-test only later.
  - BP price: $4.99 standard / $9.99 Pass+ (industry-standard).
  - Paid Warlords always also reachable via grind (Marrow Shards). No power locked to gacha.
  - Rewarded ads capped at 5/session, 8/day.
  - MVP monetisation = gold IAP + single rewarded daily chest. Everything else post-soft-launch.
- Anti-P2W guardrails restated as design constraints (PvE-only is doing most of the work here).
- 4 open questions appended to file for Paul's call.
- Next eligible item: G9 Warlord roster (10 chars).

---

## G9 — Warlord roster v0 (live session 2026-04-30 ~17:55)

- Created `warlords_v0.md`. 10 Warlords: 5 free spanning all 5 playstyles & all 5 factions, 5 paid as cross-faction/flavour archetypes.
- Free roster: Brother Ardent (aggro, Penitents), Mater Cinderis (control, Mourners), Hag Murielle (swarm, Coven), Magister Vellenne (tempo, Legion), Vren the Stitched (summoner, Pact).
- Paid roster: Marrow-Sage, Old Gaol, Saint of Smoke, Boy-King in Brass, Last Confessor.
- Unlock economy: 12k–25k Marrow Shards OR 1.2k–2.5k gems (maps to G8 IAP ladder, ~$9.99–$19.99 effective).
- MVP playable: 3 free Warlords (Ardent, Cinderis, Vren) — covers 3 most distinct fantasies; Hag + Vellenne in build 2.
- Anti-P2W audit run against G8 guardrails — every paid Warlord reachable via grind, no paid passive is strictly stronger.
- 4 open questions for Paul appended to file.
- **Phase 2 backlog now empty.** Once Paul signs off the GDD + warlords + monetisation map, Phase 3 unlocks.

---

## Workflow note (2026-04-30)

- `.gitignore` patched to also exclude `.secrets/` (legacy hidden dir from older setup) and any `**/github_pat.txt`. Belt-and-braces for the upcoming first push.
- GitHub workflow now lives in memory: Cowork = author, Claude Code (CLI, on Paul's laptop, with the GitHub extension) = git ops. Phase 3 build is unblocked.

Heartbeat 2026-04-30 18:05 — idle, awaiting Paul (Phase 2 complete; Phase 3 gated on Paul's sign-off of GDD)

---

## Phase 3 unlocked — 2026-04-30

Paul confirmed Phase 3 sign-off. Build phase begins. B1 (repo init / engine skeleton / CI) is next.

---

## B1 — Godot 4 skeleton + CI (2026-04-30)

- `game/project.godot` — Godot 4.3 Mobile, 1080×1920, canvas_items stretch, mobile renderer
- `game/icon.svg` — placeholder gallows-skull icon (grimdark, replace in B3)
- `game/scenes/main.tscn` — root Node2D with main.gd attached
- `game/src/main.gd` — hello-world `_ready()` print, entry point for B2 bootstrap
- `.github/workflows/ci.yml` — validates project structure on push/PR to main; no Godot binary needed yet (structure check only)
- **Action for Paul:** commit all new files and push to Gonzo8285/MobileGame main via Claude Code. CI will run automatically and should go green.

---

## G9 round 2 — Warlord roster respun for Gallowfell (live session 2026-04-30 ~18:00)

- Paul wrote `lore_gallowfell.md` — reframes factions: Iron Penitents kept, **Withered Court / Hollow Pact / Ferrum Host / Sable Wilds** replace v0 factions. Adds Hanging Hour and Reanimation curse mechanics. Names "The Curse of Gallowfell" as working title. Reserves an Innocent Saint as Warlord 11.
- Created `warlords_v1.md` — 11-Warlord roster aligned to Gallowfell. v0 deprecated (kept on disk for diff history).
- Free 5: Penance-Captain Vyrrun (aggro/Penitents), Court-Necromant Sieren (control/Court), Marsh-Mother Eddra (swarm/Pact), Forge-Marshal Veska (tempo/Host), Tree-Walker Mhar (summoner/Wilds).
- Paid 5: Vow-Broken Magus, Warden Caspar Voll the Empty Throne, Saint of Gallowsmoke, Brass-Crowned Whelp, Last Confessor.
- Warlord 11: **The Saint That Should Not Hang** — lore-locked secret, no IAP path. Mechanically fuses Hanging Hour + Reanimation. Unlocks on completing campaign with all 10 others.
- Anti-P2W audit re-run vs G8 — passes.
- Backlog reference updated to `warlords_v1.md`.

## Phase 2.5 sync work queued (2026-04-30)

faction_bible.md, gdd_v0.md, cards_v0.md still use the old faction names. Added S1–S4 to backlog as Phase 2.5. Will be picked up by heartbeat in order; Paul can override or do them faster manually.

## Phase 3 status (2026-04-30)

B1 ticked while we were respinning G9 — Claude Code (with the GitHub extension) handled the engine skeleton + CI hello-world push. Phase 3 is live. B2 is next: core loop prototype playable in editor. Will pick up once Phase 2.5 sync clears (or sooner if Paul says go).

---

## S1 — faction_bible.md Gallowfell sync (heartbeat 2026-04-30)

- Verified `faction_bible.md` is already at v1 with correct Gallowfell factions: Iron Penitents, Withered Court (Catacombs), Hollow Pact (Bog of Bargains), Ferrum Host (The Foundry), Sable Wilds (Cinderwood).
- Work was completed in the G9/lore session but the backlog item was not ticked. Ticked now.
- Note: `lore_gallowfell.md` biome section still uses v0 faction names (Ash-Mourners, Coven of the Black Mire, The Last Legion, Skinward Pact) due to its own reconciliation note. This is cosmetic only — `faction_bible.md` v1 is the authoritative source for faction names/vibes going into Phase 3.
- Next: S2 (update `gdd_v0.md`).

---

## Phase 2.5 sync complete (live session 2026-04-30 ~18:25)

### S1 — faction_bible.md
- Full rewrite to v1: Iron Penitents (kept), Withered Court, Hollow Pact, Ferrum Host, Sable Wilds. Each faction now has biome + lore reason to march on Gallowfell + IP-check entry. Carry-over keywords unchanged. Diff vs v0 included in-doc.

### S2 — gdd_v0.md
- Setting paragraph: district names rewired to canonical biomes (Catacombs, Bog of Bargains, Foundry, Cinderwood).
- New "Curse mechanics" section added: Hanging Hour + Reanimation as in-fiction systems.
- Faction list block: 5 new faction names + biome tag + role (one-liner each).
- Warlord classes block: now references `warlords_v1.md` and notes 5+5+1 roster shape including the lore-locked Innocent Saint.
- Title block already locked by Paul earlier; left untouched.

### S3 — cards_v0.md
- Section headers renamed (Ash-Mourners → Withered Court; Coven of the Black Mire → Hollow Pact). Iron Penitents unchanged.
- C1 token name: Mire-Spawn → Bog-Spawn (canonical). All references replaced.
- Cross-faction archetype anchors and rare-pull list updated to faction names.
- Card text untouched — "Mourner" / "Witch" / "Hag" remain valid unit-type tags within the renamed factions. **Phase 2.5 was a name pass, not a balance pass** — no HP/ATK/cost/keyword changed.
- Change log split into v0→v0.1 and v0.1→v1.0 sections.
- Verified: grep for old-faction terms returns only deliberate change-log/diff entries.

### S4 — Gallowfell availability check (surface level)
- WebSearch on "Gallowfell" + game/app/trademark + steam/itch — **no public hits.** No game, app, or trademark matches surface in basic search.
- This is a positive signal but **not legally conclusive.** Formal checks still required:
  - USPTO TESS search (US trademark)
  - EUIPO eSearch (EU trademark)
  - UKIPO trade-mark search (UK)
  - GoDaddy/Namecheap whois on `gallowfell.com`, `.app`, `.io`, `.game`
  - Apple App Store + Google Play search
- These are all reachable from Claude Code on Paul's laptop. Queued: Paul to run a "trademark + domain availability check on Gallowfell" prompt in Claude Code at his convenience. **No blocker** for B2 to proceed in parallel.

### Phase 2.5 outcome
All design docs now consistent with `lore_gallowfell.md`. v0 docs deprecated by content but kept on disk for diff history. No file deletions.

---

## Phase 3 unlocked

Phase 2 sign-off received from Paul 2026-04-30 (option "Approve everything except Warlord names" → resolved with `warlords_v1.md`). Phase 2.5 lore reconciliation completed in same session. **Heartbeat may now pick up Phase 3 items B2 onwards.** B1 already ticked (Claude Code shipped engine skeleton + CI).

---

## B2.1 — Data spine: Card resource + GFEnums (heartbeat 2026-05-01 00:19)

First bite of B2 done. Created two files under `game/src/data/`:

- `enums.gd` — `GFEnums` namespace (extends Object, class_name). Enums: Faction (5 + Neutral), CardType, Rarity (incl. reserved Epic/Legendary), AttackRange, Keyword (14 evergreen — matches cards_v0.md v1.0 incl. Smoke + Slow), RunPhase (7 states for the meta navigator).
- `card.gd` — `Card` Resource (extends Resource, class_name). Exports id, display_name, faction, card_type, rarity, cost, unit-stat group (hp/atk/range/cd), effects group (keywords array + effect/flavour text), presentation group (art/icon/sfx paths), meta group (draftable, starter, unlock_tag). Helpers: `duplicate_card()` for safe deck/hand/discard moves, `has_keyword()` predicate, `validate()` for CI gating.

Rationale: this is the data shape every other B2 sub-task hangs off (deck shuffling, hand UI, combat resolver, reward picker). Authored as Godot 4 `Resource` so designers can edit cards as `.tres` files in the editor without touching code — supports later iteration without code review.

Stable card-id convention recorded in `card.gd` header: `<faction-letter><number>` (P1, M5, C6 …). Never reuse a retired ID across balance passes.

Decomposed B2 into 10 sub-tasks (B2.1 → B2.10) in `backlog.md` so future heartbeats can chip away one bite per run. Next up: B2.2 — author the 30 starter cards from `cards_v0.md` as `.tres` files. That alone will likely take 2-3 heartbeats (10 cards each).

Verification: not run — no Godot in the sandbox. Pure GDScript with no exotic syntax; Claude Code on Paul's laptop (or the Godot editor on first open) will surface any parse errors. Files are isolated under `game/src/data/` so a parse error here doesn't break `main.gd` hello-world.

Push: as before, files are authored locally only. Git push handled by Claude Code on Paul's laptop or by Paul via the GitHub web UI when he next syncs.

## B2.2 — 30 starter cards authored (heartbeat 2026-05-01 09:42)

- Wrote 30 `.tres` files to `game/data/cards/` (P1–P9, M1–M11, C1–C10). Filename == `id`, per convention.
- Format: standard Godot 4 `[gd_resource]` resource referencing `res://src/data/card.gd`. Enums stored as ints (Faction/CardType/Rarity/AttackRange); keywords stored as `Array[int]` (e.g. `Array[int]([10])` for Penance). Empty keyword arrays use `Array[int]([])`.
- Stat data sourced verbatim from `cards_v0.md` v1.0. Counts verified: 18 units / 8 spells / 4 traps; 15 C / 10 U / 5 R; 9 Penitents / 11 Withered Court / 10 Hollow Pact. ID == filename for all 30.
- All marked `is_draftable = true` (incl. C1 Bog-Spawn per v0.1) and `is_starter = true`. `unlock_tag` empty across the board (Warlord-gated cards come later). Art/sfx paths blank — UI must placeholder until B3.
- Flavour text: added 1-liner per card in the gallows-humour register. Mechanically inert; stripped/swapped freely in localisation pass.
- Caveats — Godot will assign `uid://` headers on first editor open; no `uid` field set manually. Typed `Array[int]` should round-trip cleanly into `Array[GFEnums.Keyword]` since enums are ints under the hood — flag for verification when the editor first parses these (next sandbox-with-Godot run, or Paul opens project locally).
- Next eligible item: **B2.3** — Deck/Hand/Discard classes with shuffle, draw, mulligan, mill rules.

## C1 — Per-faction archetype briefs (heartbeat 2026-05-01 09:18)

- Wrote `archetypes_v0.md` — 5 factions × 3 sub-archetypes = 15 archetype spines. Each carries: 4c R identity, 5–6c R payoff, 2–3–4 cost spine, 1c cheap fuel, hard-counter (rival archetype), splash-into hook.
- Faction names: used the **Track A canonical lock** from L1 (Iron Penitents / Ash-Mourners / Coven of the Black Mire / The Last Legion / Skinward Pact). `faction_bible.md` v1 still uses Track B headers — that rename pass is L2 and is queued separately.
- Lore mapping: Track B → Track A is 1:1 (Withered Court → Ash-Mourners, Hollow Pact → Coven of the Black Mire, Ferrum Host → The Last Legion, Sable Wilds → Skinward Pact). Mechanical roles unchanged from `faction_bible.md` v1.
- Anti-synergy grid: full 15×1 in-doc; intentionally uneven so Skinward Pact reads as the wildcard / most-countered (matches the v1 plan to gate Wilds as a 4th-unlock mastery faction).
- Existing card-pool reuse: Penitents/Mourners/Coven archetypes lean heavily on `cards_v0.md` v1.0 cards (P1–P9, M1–M11, C1–C8). Legion/Pact archetypes are net-new — placeholder card names for C5/C6 to author.
- Net-new card stubs flagged for downstream authoring: Hierarch of the Open Wound, Saint of Cinders, Confessor-At-Arms, Procession Bleeds the Lane, Headsman of the Long Aisle, Necrologist of the Catacombs, Funeral Bellringer, Witch of the Bound Coin, Brood-Mother of the Mire, Ferryman of the Drowned Coin, Drowning of the Demon-Coin (Penitents/Mourners/Coven net-new) plus the full Legion/Pact rosters.
- Rarity-skew target per faction: ~24 C / ~12 U / ~4 R; per archetype ~10–12 cards (~1 R / 2–3 U / rest C).
- 4 open questions appended to the file for Paul: Mother Quag split y/n, M5 promotion 3c U → 4c R y/n, Wilds-as-wildcard balance call, identity-card naming veto round.
- Verification: in-doc checks only — anti-synergy grid covers all 15 archetypes (no dangling row), every faction appears as both a "counter" and "countered" at least once (no universal soft target), card-IDs cross-checked against `cards_v0.md` v1.0. No engine wiring this run.
- Next eligible heartbeat item: **C2** (Iron Penitents full ~40-card pool + `.tres` files). Note: C2 is large; expect 3–4 heartbeats to land.

## C1 v0.1 — Paul's resolutions applied (live session 2026-05-01)

Paul answered all 4 open questions; updates landed in `archetypes_v0.md` (v0.1 block at top + targeted edits below):

- **Mother Quag (C6):** stays as single dual-archetype 5c R (no split). C1 Poison-Stack and C2 Bog-Spawn Swarm entries both reference the same card. C4 downstream note updated.
- **M5 Last Censer-Bearer:** promoted 3c U → 4c R as Smoke-Fear identity. Statline reshape: 4/4 / Range-S / CD-2 / Dread-1 to all enemies in 2 tiles each turn. Propagates to `cards_v1.md` (TBD) and to C3 Ash-Mourners full pool.
- **Anti-synergy grid rebalanced:** restructured to symmetric in-degree=1 / out-degree=1 per archetype, 3 deals / 3 receives per faction. Three edges shifted: P-Penance→C-Poison ⟶ M-Trap→C-Poison; P-Cleave→S-Big ⟶ L-Echo→S-Big; L-Rally→C-Swarm ⟶ S-Beast→C-Swarm. Skinward Pact is now a normal participant in the rivalry web (was: most-countered wildcard).
- **New card names:** approved by Paul, no vetoes. Locked for use in C2–C6.

Verification: anti-synergy grid checked — every archetype appears as both dealer and receiver exactly once; per-faction tally is 3/3/3/3/3 deals and 3/3/3/3/3 receives. Mutual rivalries preserved: P-Bleed ↔ L-Banner and P-Penance ↔ C-Sacrifice-Combo.

Open thread: Paul gave "ok go ahead" on names. Asking him directly whether to start C2 in this session or wait for next heartbeat (C2 is ~40 cards + 40 `.tres` files — meaningful spend).

## C2 — Iron Penitents full pool, markdown design (live session 2026-05-01)

Took the "ok go ahead" to mean **proceed with C2**. Wrote `cards_iron_penitents_v1.md` — full 40-card design across the 3 archetypes per `archetypes_v0.md` v0.1.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 cards (60/25/10/5 distribution, hit exactly).
- **Per-archetype split:** 13 / 13 / 13 cards + 1 cross-archetype overlap (P4 Hammer-Confessor sits in both Cleave and Bleed splash).
- **Existing P1–P9 absorbed unchanged** (no stat changes in this pass — flagged as Q4 for Paul if he wants a v0-balance retune folded in).
- **31 net-new cards (P10–P40)** including:
  - Bleed identity P15 Hierarch of the Open Wound (4c R) and payoff P19 Procession Bleeds the Lane (6c U — held at U so Bleed decks see it consistently).
  - Penance identity P23 Saint of Cinders (4c R; payoff is existing P6 Crucified Saint).
  - Cleave identity P30 Confessor-At-Arms (4c R) and payoff P33 Headsman of the Long Aisle (5c R, Cleave-3 row-clearer).
  - 2 relic specials introduced (P39 Reliquary of Wounds, P40 Crown of the Hanged Confessor) — first time the game has run-persistent equippables in design.
- **Rarity skew:** 24 C / 12 U / 4 R = 60/30/10. 3 of 4 Rares are archetype identities; 1 is the Cleave payoff.
- **Splash coverage:** 5 cards splash cleanly into rival faction archetypes (P12, P25, P22, P19, P34) — meets C7's "≥2 splash hooks per faction" target.
- **4 open questions for Paul** appended to file: specials-as-relics model OK, Crucified Saint vs Hierarch tier coexistence, trap distribution, P1–P9 stat retune yes/no.

`.tres` file authoring (P10–P40 in `game/data/cards/iron_penitents/`) deferred to next heartbeat run — that's a 31-file mechanical conversion job, perfect bite-size for unmanned. C2 ticked partially: markdown is done; `.tres` files pending. Will tick C2 fully once `.tres` files land.

Verification: file written; no engine integration this turn (no `.tres` files yet). Card-IDs cross-checked against `cards_v0.md` v1.0 (no collisions: P1-P9 retained, new starts at P10). Faction names use canonical Track A throughout. Anti-synergy and splash hooks reference `archetypes_v0.md` v0.1.

Next eligible heartbeat item: **C2 (.tres authoring)** — 31 files for P10–P40, then optional migration of P1–P9 into the same subfolder. After that, C3 Ash-Mourners full pool.

## C2 — Iron Penitents `.tres` files (heartbeat 2026-05-01 04:30)

Closed out the second half of C2. Generated all 31 new card resources via a Python one-shot in the bash sandbox; wrote them to `game/data/cards/iron_penitents/P10.tres` … `P40.tres`.

- **Schema match:** cards round-trip the `Card` resource exactly (id / display_name / faction=0 / card_type / rarity / cost / hp / atk / range / cd / keywords[] / effect_text / flavour_text / is_draftable / is_starter / unlock_tag). Format mirrors the v0 P1–P9 files byte-for-byte modulo data.
- **Type/rarity tally (matches markdown):** 24 units (ctype=0) + 8 spells (ctype=1) + 4 traps (ctype=2) + 2 relic-flagged spells = 38 in this batch + 9 existing in `cards/` = 47 file presence (note: P10–P40 only authored here; P1–P9 still live one folder up). Net new files: 31.
- **Relic handling (P39, P40):** the `Card` schema has no `RELIC` `CardType`, so per Paul's still-open Q1 in `cards_iron_penitents_v1.md` I tagged them as `card_type=1` (SPELL) with `is_draftable=false` and `unlock_tag=&"relic_iron_penitents"`. Future relic-system work (or Paul's Q1 answer) can branch on `unlock_tag`. No data loss.
- **`is_starter`:** false for all P10–P40 (these are pool-pull cards, not the 30-card MVP starter set; P1–P9 keep `is_starter=true`).
- **Spot-checked** P15 (rare unit, Hierarch), P19 (6c spell payoff), P38 (trap with Root+Bleed keyword array), P40 (relic with `is_draftable=false`+`unlock_tag`). All four serialize cleanly.

Two structural notes for the next heartbeat (or Paul):
1. **Folder layout:** P1–P9 still live at `game/data/cards/*.tres` (alongside Withered Court / Hollow Pact starters), while the new P10–P40 sit in `game/data/cards/iron_penitents/`. This is intentional for now (the MVP loader can pick up either path), but a tidy-up pass could migrate P1–P9 into `iron_penitents/` once the loader is wiring-faction-aware. Flag for B2.x bookkeeping.
2. **Loader gap:** there is no card-registry / autoloader yet (`Deck` / `Hand` are still stubs per backlog B2.3). When B2.3 lands, point the registry at both `cards/*.tres` (existing v0) and `cards/iron_penitents/*.tres` (this batch), or migrate per the previous note.

C2 fully ticked on backlog. Next eligible: **C3 — Ash-Mourners full pool** (~40 cards). C3 has a known up-front design task (M5 Last Censer-Bearer promoted 3c U → 4c R per Paul's S2 lock) plus two new identity cards to author (Necrologist of the Catacombs B2 + Funeral Bellringer B3 + M11 repositioned as B3 payoff). Same 60/25/10/5 split, same 24/12/4 rarity target.

## C3 — Ash-Mourners full pool (live session 2026-05-01)

Closed both halves of C3 in one pass while Paul was in chat (he said "do what else you can just now"). Authored `cards_ash_mourners_v1.md` (40 cards) + generated all 29 new `.tres` files M12–M40 under `game/data/cards/ash_mourners/` + applied the M5 statline reshape in place.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 cards (60/25/10/5, exact). 24 C / 12 U / 4 R rarity skew (exact). Existing 11 v0 cards (M1–M11) absorbed; 29 net-new (M12–M40).
- **M5 statline reshape applied:** 3c U / 3 HP / 1 ATK → 4c R / 4 HP / 2 ATK. Range-S, CD-2, Dread aura unchanged. `M5.tres` edited in place (id stable, no card-ID churn).
- **New identities at U not R:** Necrologist (M12) and Funeral Bellringer (M13) sit at 4c U to keep the 4-R-per-faction budget clean. Existing R count after promotion: M5, M6, M8, M11 = 4. R-budget hit exactly. Flagged in markdown Q2 if Paul wants R-tier identity cards.
- **Per-archetype card density:** B1 Smoke-Fear 16 primary (heavy because of v0 weight), B2 Resurrect-Spam 13 primary, B3 Trap-Control 11 primary. Splash cards count toward both archetypes.
- **Relics M39/M40:** authored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_ash_mourners"`. Same Q1-pending pattern as Iron Penitents.
- **Faction-name reconciliation note:** GFEnums.Faction.WITHERED_COURT remains the engine constant (faction=1) even though the player-facing name is Ash-Mourners per L1. Engine-wide rename queued under L2; no rush since the constant is internal-only.

Verification: 29 files generated, file count confirmed via `ls | wc -l`. Spot-checked M12 (rare-ish identity unit), M38 (multi-keyword trap with Fear+Slow keywords [5,13]), M39 (relic with `is_draftable=false`+`unlock_tag`), M5.tres (new statline). All four serialize cleanly.

C3 fully ticked on backlog. Next eligible: **C4 — Coven of the Black Mire full pool** (~40 cards). C4 has a Paul-locked decision: C6 Mother Quag stays as a single dual-archetype card (no split) per 2026-05-01 lock. New cards to author: Witch of the Bound Coin (C1 identity), Brood-Mother of the Mire (C2 identity), Ferryman of the Drowned Coin (C3 identity), Drowning of the Demon-Coin (C3 payoff spell).

## C4 — Coven of the Black Mire full pool (live session 2026-05-01)

Closed C4 in the same session pass. Authored `cards_coven_v1.md` (40 cards) + generated all 30 new `.tres` files C11–C40 under `game/data/cards/coven/`. Existing C1–C10 untouched — faction=2 already correct on all of them.

- **Pool composition:** 24 units / 10 spells / 4 traps / 2 specials = 40 (exact). 24 C / 12 U / 4 R rarity skew (exact). Existing 10 v0 cards (C1–C10) absorbed; 30 net-new (C11–C40).
- **C6 Mother Quag dual-archetype lock honoured:** single 5c R card serving both A1 Poison-Stack payoff AND A2 Bog-Spawn-Swarm payoff — no split. Documented in markdown's archetype sections; printed once in .tres files (existing C6.tres unchanged).
- **R-budget tuning:** 4 R total = C6 (existing dual payoff) + C11 Witch of the Bound Coin (A1 identity) + C12 Brood-Mother of the Mire (A2 identity) + C29 Drowning of the Demon-Coin (A3 payoff spell). Ferryman (A3 identity) demoted to U to keep budget clean. Same pattern as Iron Penitents' Saint of Cinders + Ash-Mourners' Necrologist/Bellringer — flagged in Q2 if Paul wants R-tier identities.
- **Per-archetype card density:** A1 Poison-Stack 18 primary (heavy because v0 had a poison-trap toolkit), A2 Bog-Spawn-Swarm 15 primary, A3 Sacrifice-Combo 10 primary (deliberately tighter — combo archetype wants pieces, not breadth).
- **Relics C39/C40:** authored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_coven"`. Same Q1-pending pattern as Iron Penitents and Ash-Mourners. Paul's call on the relic-slot system applies uniformly across all three factions.
- **Faction-name reconciliation note:** GFEnums.Faction.HOLLOW_PACT remains the engine constant (faction=2). Player-facing name "Coven of the Black Mire" used throughout markdown + flavour text. L2 cleanup queued for the constants rename.

Verification: 30 files generated, count confirmed via `ls | wc -l`. Existing C1–C10 cards confirmed at faction=2 via `grep "faction = "` (single value across the directory). Spot-checked C11 (rare identity Witch of the Bound Coin) — keywords [3] = POISON, rarity=2=R, faction=2 = HOLLOW_PACT/Coven. Looks clean.

C4 fully ticked on backlog. **Three full faction pools now stand authored: Iron Penitents (P10–P40, 31 cards), Ash-Mourners (M12–M40, 29 cards + M5 reshape), Coven of the Black Mire (C11–C40, 30 cards). 90 net-new card resources in `.tres` form across this multi-task session, plus 3 markdown design docs, plus 1 in-place statline reshape (M5 promotion). MVP scope per C8 = these 3 factions × ~100 cards in playable form.** Next eligible: **C5 — The Last Legion full pool** (~40 cards, all net-new — no v0 base). Then C6 Skinward Pact (also net-new).

## L2 — Track-B faction-name rename pass (live session 2026-05-01)

Closed L2 in same multi-task session. Batch-renamed Track-B leftovers across player-facing docs to canonical Track-A names per L1 lock 2026-04-30.

- **Files touched (5 markdown + 1 .tres):**
  - `cards_v0.md` — 8 lines updated (Withered Court → Ash-Mourners; Hollow Pact → Coven of the Black Mire). Section headers + change log narrative + cross-faction archetype check.
  - `gdd_v0.md` — 6 lines updated (faction list + biome map references).
  - `faction_bible.md` — 4 lines updated (section headers H2 1–5 now match Track-A).
  - `warlords_v1.md` — 20 lines updated (faction tags on each warlord entry + intro paragraph). Plus one mechanical fix: "the Ferrum Host" → "the The Last Legion" produced a double-article that I cleaned to "the Last Legion".
  - `lore_gallowfell.md` — already on Track-A; no replacements needed (verified 0 remaining).
  - `game/data/cards/C1.tres` — 1 line: effect_text "Hollow Pact cards" → "Coven of the Black Mire cards".
- **Engine constants preserved:** `GFEnums.Faction.WITHERED_COURT / HOLLOW_PACT / FERRUM_HOST / SABLE_WILDS` in `enums.gd` are internal-only and were not touched (the regex `Withered Court` etc. didn't match underscore-separated identifiers — verified post-rename via grep on enums.gd). Per the engine rename plan in this same notes file: a follow-up enum-rename pass is queued but non-blocking, since the constant names are internal and don't affect player-facing UI.
- **Historical decision records preserved:** `backlog.md` (3 references in L2 description + S1 description + Track A/B comparison) and `research_notes.md` (7 references in heartbeat narration documenting prior renames + the L1 decision) both retain Track-B mentions intentionally — they explain the rename history, not active usage.
- **Verification:** post-rename grep across the project shows zero Track-B references in any active design, code, or data file. All 5 of those files now use the Track-A names exclusively.

L2 fully ticked on backlog. **Lore is now self-consistent across the entire docs+data stack.** The 3 MVP faction pools (Iron Penitents / Ash-Mourners / Coven of the Black Mire) plus their .tres serializations, plus the warlord roster, plus the GDD, plus the faction bible — all on canonical Track-A naming. Engine constants stay on the historical names until a separate enum-rename pass is run (post-MVP, since it would touch every .tres faction= field and require a code/data lock-step migration).

## Phase 3 unlocked

Paul signed off Phase 3 in chat 2026-05-01. Heartbeats may now pull from the B-series build items in `backlog.md`. B1, B2.1, B2.2 already done. Next eligible: B2.3 (Deck / Hand / Discard runtime classes).

## B2.3 — Deck / Hand / Discard runtime (live session 2026-05-01)

Authored four files under `game/src/runtime/`:
- **`deck.gd`** (126 LoC) — RefCounted draw pile. Typed `Array[Card]` storage, embedded `RandomNumberGenerator` for deterministic shuffles (seed-injectable from `_init`). Fisher-Yates in place. `draw_one(from_discard)` auto-reshuffles when the deck is empty and a discard pile is supplied (caller can pass `null` for "fail silently" semantics). `mill(n, into_discard)` moves n cards from top to discard, returns the milled list (no auto-reshuffle on mill — milling an empty deck is a no-op, by design). Signals: `drew_card`, `reshuffled`, `milled_cards`. `validate()` hook for CI.
- **`hand.gd`** (100 LoC) — RefCounted hand zone. `DEFAULT_CAPACITY=10` (Slay the Spire convention; revisit per W2 Warlord variants). Overflow rule: `add()` returns false + emits `overflowed(card)` so the caller can route to discard. `mulligan(deck)` empties hand into deck, shuffles, redraws the same count. Currently unrestricted — W2 may layer "1/combat" later.
- **`discard.gd`** (67 LoC) — RefCounted discard pile. `clear_all()` returns the cards (used by `Deck.reshuffle_from`). `find_by_id(StringName)` and `remove(card)` for the re-summon design hook from `cards_iron_penitents_v1.md` (P39 Pyre Echo style — "choose a Penitent that died this combat").
- **`card_zones_test.gd`** (153 LoC) — smoke-test runner. Loads the Iron Penitent .tres pool from `res://data/cards/iron_penitents/`, builds a deck, exercises shuffle / draw 5 / play 1 / mill 3 / mulligan / drain-and-reshuffle / overflow / determinism / conservation invariant. 10 distinct assertions. Wired into `main.gd` via `RUN_CARD_ZONES_TEST=true` flag — runs on engine launch.

`main.gd` updated to instantiate the test as a child Node when the flag is on, so the suite fires automatically on F5 in Godot.

**Verification:** No Godot in sandbox. Wrote a Python port of the algorithm (Fisher-Yates with the same loop bounds + same draw/mill/reshuffle/mulligan rules) and ran the same assertion suite against a 31-card mock pool. Initial run caught a real test bug (orphaned trigger card after the reshuffle assertion broke the conservation invariant). Fixed in BOTH the Python and the GDScript test by routing the trigger card to hand. Re-run: 0 errors / PASS. Logic is sound — only Godot-specific GDScript syntax remains untested. Paul to confirm in-engine on next F5.

**Design notes baked into the API:**
- Card resources flow through zones via ownership transfer (one zone holds a given card at a time). No two zones reference the same card concurrently — prevents stale-reference bugs when card resources gain per-instance state in B2.6+.
- Determinism: pass `seed_value != 0` to `Deck.new(pool, seed_value)` to get a reproducible shuffle. Used in tests; will also be useful for replay/seed runs in B2.9.
- Signals are zone-scoped (the deck signals deck events, the hand signals hand events). UI in B2.6 / B2.7 should connect to these directly rather than poll.

B2.3 fully ticked. Next eligible: **B2.4 — `GameState` autoload singleton** (run state: mana, turn, phase; signals for UI). Then B2.5 (combat scene scaffold) and onward through B2.10 end-to-end smoke test.

## B2.4 — GameState autoload (live session 2026-05-01)

Authored `game/src/runtime/game_state.gd` (222 LoC) and registered it as the `GameState` autoload in `project.godot`. Plus `game/src/runtime/game_state_test.gd` (159 LoC) wired into `main.gd` so it fires alongside the B2.3 zones test.

**State surface (3 layers):**
- Run-level: `run_seed`, `active_warlord_id`, `current_phase`, `chapter`, `current_node`, `deck`/`hand`/`discard` (built fresh by `start_run`), `ash`, `keys`, `modifiers`.
- Combat-level: `turn`, `mana`, `max_mana` (currently 3, will scale per-chapter in balance pass).
- Vitals: `base_hp`, `max_base_hp` (default 30 each).

**API surface (8 public methods):**
- `start_run(starter_pool, warlord_id, seed)` — builds zones, resets all state, fires `run_started` + `phase_changed`.
- `end_run(victory)` — terminal phase + `run_ended(bool)`.
- `set_phase(new_phase)` — gated transition (no-op if already in that phase), fires `phase_changed(old, new)`.
- `start_combat()` — refunds hand+discard back into deck, shuffles, advances to turn 1.
- `next_turn()` — fires `turn_ended(prev)` then `turn_started(new)`, refills mana to ceiling.
- `spend_mana(n)` / `gain_mana(n)` — int math with overflow cap (`MANA_OVERFLOW_CAP = 5`). `spend_mana` returns false on insufficient (no deduct).
- `take_damage(n)` / `heal(n)` — clamped, return actual delta, `take_damage` triggers `end_run(false)` on lethal.
- `advance_node()` — bumps map cursor, re-enters MAP phase, fires `node_advanced(node, chapter)`.
- `debug_summary()` — one-line digest for console logging.

**Signals (7):** `run_started`, `run_ended`, `phase_changed`, `turn_started`, `turn_ended`, `mana_changed`, `hp_changed`, `node_advanced`. Designed for B2.6+ UI to bind directly rather than poll.

**Smoke test (`game_state_test.gd`):** 16 explicit assertions covering: run setup → combat start → mana spend (legal + over-budget) → mana gain (incl. cap test) → turn advance → damage → heal (incl. cap test) → lethal damage triggers `run_ended` and GAME_OVER phase. Plus a signal-emission audit (counts each signal type via prefix-match on a captured signal log) to confirm at least the expected number of fires.

**Verification:** No Godot in sandbox. Code reviewed by hand; logic mirrors B2.3 zones test pattern (Node child fires `_ready()`-driven suite). One sandbox quirk noted: bash `cat`/`wc -l` on the OneDrive mount sometimes shows a stale shorter view of recently-edited files; the Read tool (Windows API direct) is authoritative — files on disk are complete. Paul to confirm both B2.3 and B2.4 suites pass on next F5.

B2.4 fully ticked. Next eligible: **B2.5 — combat scene scaffold** (3-lane grid, wave spawner, base HP, defeat/victory conditions). This is where the actual game starts to take visible shape — `main.tscn` becomes the combat scene, GameState owns the run state, lanes spawn enemies, the player drops cards.

**Session totals so far:** 4 backlog items closed before Phase 3 sign-off (C2 .tres, C3, C4, L2) + 2 closed after (B2.3, B2.4). 6 total this session. Engine code: 834 LoC across `src/runtime/` (4 runtime classes + 2 smoke-test runners + 1 main). Project is now at ~90 .tres card resources + a tested data-spine + a testable run-state singleton — ready for combat scaffolding.


## C5 — The Last Legion full pool (heartbeat 2026-05-01 19:23)

- Authored `cards_last_legion_v1.md` (~40 cards, L1–L40) covering Rally-Formation / Tempo-Echo / Banner-Buff archetypes per `archetypes_v0.md` v0.1 D1/D2/D3 spines.
- Generated 40 `.tres` files under `game/data/cards/last_legion/` (faction = `FERRUM_HOST` = 3 in code; engine constant unchanged this pass — L2 cleanup queue still applies).
- Distribution: 24 units / 10 spells / 4 traps / 2 relics (relics stored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_last_legion"` — mirrors Coven C39/C40 pattern).
- Rarity: 24 C / 12 U / 4 R. Rares = L7 Sergeant-Smith Vikar (D1 identity), L18 Echo-Sergeant (D2 identity), L33 Banner-Captain of the Crowned Anvil (D3 identity), L34 Crowned Anvil Standard (D3 payoff — 5c R artifact-unit, 8 HP / 0 ATK / no-attack aura).
- Cost curve bottom-heavy (2c=10, 3c=10) — formation wants bodies in lane every turn; 4-cost is the identity-card cluster (3 of 4 Rares at 4c); single 5c R payoff (L34).
- Splashes (≥2 hooks per faction target): L4 Iron Bayonet Drill → IP Cleave-Melee; L9 Iron Standard Unfurled → SP Big-Monster; L24 Hammer-Cycle → AM Trap-Control; L31 Iron Choir-Standard → AM Smoke-Fear; L34 Crowned Anvil Standard → IP Sacrifice-Penance. Five splashes — meets brief.
- Anti-synergy hard counters wired (D1↔AM Smoke-Fear, D2↔Coven Poison-Stack, D3↔IP Bleed-Stack) per v0.1 grid.
- Naming register: foundry / iron / hammer / anvil / banner / drill cant. Three flagship characters: Vikar, Banner-Captain of the Crowned Anvil, Echo-Sergeant. Lord-Marshal name reserved for future Warlord-tier signature card (not used here).
- Echo flagged as **soft keyword** — used in card text on 9 cards (L9, L14, L16, L17, L19, L21, L22, L23, L24, L25, L26) but NOT in `GFEnums.Keyword` enum. Engine arrays empty for Echo-only cards. Recommend adding `ECHO = 14` to `enums.gd` before B2.5 wave-spawner work — affects on-attack resolution.
- Banner-Token flagged as **new lane-object class** — not modelled in current `GameState`. Needs lightweight HP-less, duration-based, untargetable lane-object system. Smaller scope than Trap/Unit but still needs a class. Flag for B2.6/B2.7 design.
- Open questions for Paul (carried in `cards_last_legion_v1.md` Open questions section): Q1 Echo-as-keyword, Q2 Banner-Token engine class, Q3 demote L34 Crowned Anvil Standard R→U if Rares should all be named-characters, Q4 specials/relic system unification, Q5 Echo-Sergeant 2c-or-less gate vs 1c-or-less.
- Verification: not run — no Godot in the sandbox. Generator script (`outputs/gen_last_legion_tres.py`) ran clean, type/rarity counters validated (24 UNIT / 12 SPELL / 4 TRAP — relics counted as SPELL by design; 24 C / 12 U / 4 R), all 40 IDs present. `.tres` files structurally identical to existing C40 reference.
- Push: as before, files authored locally only. Git push handled by Claude Code on Paul's laptop.
- Next backlog hop: **C6 — Skinward Pact full pool (~40 cards)**. Net-new faction in cards file. Identity/payoff cards from `archetypes_v0.md` (Bear-Skin Hierophant, Wyrd-Shifter of the Cinderwood, Pelt-Bound Shaman, Thrask the Bear-Who-Was-King, etc.) used as the spine. After C6, the C7 cross-faction balance pass + C8 internal-MVP scope update close out Phase 2.6.

---

## C6 — Skinward Pact full pool (heartbeat 2026-05-02 23:24 UTC)

- Authored `cards_skinward_pact_v1.md` (~40 cards, W1–W40) covering Big-Monster / Transformation / Beast-Summon archetypes per `archetypes_v0.md` v0.1 E1/E2/E3 spines.
- Generated 40 `.tres` files under `game/data/cards/skinward_pact/` (faction = `SABLE_WILDS` = 4 in code; engine constant unchanged this pass — L2 cleanup queue still applies).
- Distribution: 24 units / 10 spells / 4 traps / 2 relics (relics stored as `card_type=SPELL`, `is_draftable=false`, `unlock_tag=&"relic_skinward_pact"` — mirrors C5/C4/C3/C2 relic pattern). At engine-level: 24 UNIT / 12 SPELL / 4 TRAP.
- Rarity: 24 C / 12 U / 4 R. Rares = W4 Bear-Skin Hierophant (E1 identity 4c), W8 Thrask the Bear-Who-Was-King (E1 payoff 6c — 8/8 melee, on-summon exile-Wilds-from-hand to absorb keywords), W19 Wyrd-Shifter of the Cinderwood (E2 identity 4c), W31 Pelt-Bound Shaman (E3 identity 4c, summons 1/2 Wolf-Token / turn cap 3).
- Cost curve: 0c=4, 1c=4, 2c=11, 3c=7, 4c=6, 5c=6, 6c=2 = 40 ✓. 2c-heavy bottom-mid (Beast-Summon needs cheap chaff every turn). 4-cost cluster carries 3 of 4 Rares (the identity cards). 4 zero-costs = 2 token-shape draftables (Cub-Token, Wolf-Token) + 2 relics.
- Token-shape cards (W27 Cub-Token 0c 1/1, W28 Wolf-Token 0c 1/2) authored as draftable C — mirrors C1 Bog-Spawn from Coven. Also runtime-summoned by Pelt-Bound Shaman / Pack-Call / Cub-Cry / Den-Mother / Whelp-Caller / Hunter's Snare / Whelping Burrow.
- Splashes (≥2 hooks per faction target): W17 Half-Wolf Initiate → Last Legion Rally-Formation (Pierce); W6 Boneward Behemoth → Last Legion Banner-Buff (Shield-2 stacks with Banner Shield-1); W14 Cub of the Sundered Tree → Coven Sacrifice-Combo; W34 Den-Mother → Coven Bog-Spawn Swarm (token-summoner overlap); W26 Skin-Snare Trap → Ash-Mourners Trap-Control. Five splashes — meets brief.
- Anti-synergy hard counters wired (E1↔Last Legion Tempo-Echo, E2↔Ash-Mourners Resurrect-Spam, E3↔Last Legion Rally-Formation) per v0.1 grid.
- Naming register: bear / wolf / antler / pelt / hide / skin / cinder / wyrd / bone cant. Three flagship characters: Bear-Skin Hierophant, Wyrd-Shifter of the Cinderwood, Pelt-Bound Shaman + 1 named legendary unit (Thrask, the Bear-Who-Was-King). The Antler-King kept as a named-spell payoff (W24, 6c U) — flavour-king of the faction without occupying a 4th-Rare slot.
- Transformation flagged as **soft keyword** — used in card text on 9 cards (W14, W15, W18, W19, W20, W21, W22, W23, W24, W25). Recommend adding `TRANSFORM = 15` to `enums.gd` alongside `ECHO = 14` (C5 Q1) before B2.6 card-play loop work — affects on-play resolution. Engine arrays empty for Transformation-only cards this pass.
- Wilds-tag system flagged for engine work — Wraiths (Ash-Mourners tokens, faction-1) explicitly DON'T count as Wilds for transformation targeting. Smallest-scope option: hard-code "faction == 4 → is_wilds" in card-play loop. Bigger-scope option: add `tags: Array[StringName]` field to Card resource for cross-faction tags (Wilds, Beast, Token, Banner, etc.). Flag carried into Open Questions on `cards_skinward_pact_v1.md`.
- Open questions for Paul (carried in `cards_skinward_pact_v1.md` Open questions section): Q1 Transformation-as-keyword, Q2 Wilds-tag engine field vs faction lookup, Q3 token cards as draftable C vs token-only (would force 24→22 C, need 2× U→C re-promotions), Q4 Thrask exile-Wilds mechanic vs baked-in keywords (flavour vs implementation simplicity), Q5 relic-system unification (carried from C5), Q6 Lifesteal soft-keyword on W3 Cinderwood Stalker (single-card scope, low priority).
- Verification: not run — no Godot in the sandbox. Generator script (`/tmp/gen_skinward.py`) ran clean, type/rarity counters validated (24 UNIT / 12 SPELL / 4 TRAP; 24 C / 12 U / 4 R), all 40 IDs present, cost curve audited. Per-card validation enforces unit-hp>0 and non-unit-no-stray-stats. `.tres` files structurally identical to existing L40 reference.
- Push: as before, files authored locally only. Git push handled by Claude Code on Paul's laptop.
- Phase 2.6 remaining: C7 (cross-faction balance pass — validate v0.1 anti-synergy grid + rarity skew across all 5 factions × ~40 cards = 200 cards) and C8 (internal-MVP scope update — first build = 3 factions × ~100 cards). After C8 the deckbuilder pool is sign-off-ready. Phase 2.7 (Warlord tier system, W1–W5) and Phase 2.8 L3 (re-export pitch .docx after rename) remain open.

---

## C7 — Cross-faction balance pass (heartbeat 2026-05-02 04:17 UTC)

- **Rarity distribution — all 5 factions consistent.** Every faction file declares + counts 24 C / 12 U / 4 R (60/30/10). Penitents/Ash-Mourners/Coven/Last-Legion/Skinward all hit target exactly. Type split also consistent: 24 UNIT / 12 SPELL / 4 TRAP (relics stored as SPELL is_draftable=false everywhere). ✓ no skew.
- **Anti-synergy grid — symmetric, no orphan archetypes.** `archetypes_v0.md` v0.1 grid: 15 archetypes × in-degree 1 / out-degree 1. Per faction: 3 dealt / 3 received. Verified by re-counting deals/receives column-by-column from the v0.1 table. Two intentional mutual rivalries preserved (P-Bleed↔L-Banner, P-Penance↔C-Sacrifice-Combo). No archetype is unanswered. ✓
- **Snowball flags (need rule clarification, not redesign):**
  1. **Aura stacking unspecified.** Multiple +1 ATK auras (Iron Choir-Master P5, Saint of Cinders P23, Banner-Captain L33, Crowned Anvil Standard L34) can co-exist in lane. GDD `core mechanics` glossary covers Smoke/Slow stacking but not ATK auras. Default to MTG-style stacking gives Penitents +2/+3 in lane very fast. Recommend: add to GDD that **named ATK auras don't stack — highest applies; Bleed/Poison/Smoke/Dread continue to stack as written**. One-line rule, unblocks balance assumptions across Penitents Penance + Legion Banner combos.
  2. **Bleed has no per-unit cap (except Stigmata-Bearer's aura cap).** Hierarch (P15) once/turn + Wound-Tender (P11) on-attack + Sanguine Vow (P17) Bleed-3 + Crimson Banner (P20) trap-Bleed-2 + Bone-Lash Whipster (P12) can land 8+ Bleed stacks on a single enemy. Procession Bleeds the Lane (P19, 6c U) then deals row-wide damage = stack-count. Brake exists ("stacks expire on resolve") but pre-resolve burst can be 8+ × row-width = 24+ dmg single-spell. Recommend: cap **Bleed-5 per enemy** (matches Stigmata aura ceiling, signals to player when stacking is wasted).
  3. **Wyrd-Shifter ramp is the only Skinward chain without a hard ceiling.** Once-per-turn 3-mana transform +2 cost. Cub (1c) → 3c → 5c → 7c over 3 turns at constant 3-mana spend. Wyrd-Bind (1c spell) shaves 1 mana off transformation. Brake = once-per-turn cap. Confirms intended power curve (Big-Monster archetype payoff window) but flag for soft-launch tuning: if Wyrd-Bind drops Wyrd-Shifter to 2-mana cadence, the curve is fast. Recommend: **leave as-is for internal MVP playtest, monitor in B2.10 smoke tests.**
- **Splash audit (≥2 splash hooks per faction).** Penitents 3 (Bleed→Coven Poison, Penance→Skinward Beast, Cleave→Legion Rally). Ash-Mourners 3 (Smoke→Legion Banner, Resurrect→Penitents Penance, Trap→Legion Echo). Coven 3 (Poison→Mourners Smoke, Swarm→Skinward Beast, Sac-Combo→Skinward Transform). Last Legion 3 (Rally→Penitents Cleave, Echo→Mourners Trap, Banner→Mourners Smoke). Skinward 5 (Big→Legion Banner, Transform→Coven Sac-Combo, Beast→Coven Swarm, plus W17 Pierce + W26 Trap-splash + W34 Den-Mother token-overlap per C6 notes). ✓ all factions ≥2.
- **Verdict: pool is balance-ship-ready for internal MVP.** No archetype redesigns required. Three rule clarifications needed (aura-stacking, Bleed-cap, Wyrd-Shifter monitoring) — all 1-line GDD edits, no card changes. C7 closed; C8 next.
- **Open Qs for Paul (low-stakes, MVP-deferrable):** Q1 confirm "named auras don't stack" rule for GDD; Q2 confirm Bleed-5 cap; Q3 confirm Wyrd-Shifter monitor-don't-tune yet stance. None of these block C8 or B2.5+.

---

## B3.0 — Cloud GPU vendor selection (live session 2026-05-02)

**Context:** Paul's RTX 2050 has ~4 GB VRAM (memory-flagged). SDXL workloads need 8-10 GB. Civitai geo-blocked in UK since July 2025 (Online Safety Act). Both constraints push to cloud. Web-searched current 2026 prices.

**Lane comparison:**

| Vendor | GPU | $/hr | Setup | Claude-control | Reliability | Verdict |
|---|---|---|---|---|---|---|
| **RunPod Community** | RTX 4090 24GB | **$0.39** | Pre-built ComfyUI templates, 2-min boot | REST + GraphQL API | Datacenter SLA-lite | **PICKED** |
| RunPod Secure | RTX 4090 24GB | $0.69 | Same | Same | Production-grade SLA | Reserve for prod, not prototype |
| Vast.ai | RTX 3090 24GB | $0.17 | Marketplace, varies by host | API | Reliability score 0.95+ filter required | Backup if budget tightens |
| Vast.ai | RTX 4090 24GB | $0.29 | Same | Same | Same | Cheaper than RunPod but flakier |
| fal.ai | Serverless ComfyUI | ~$0.002-0.02/img | None — pay-per-call | API-first | High | Use for rapid prototyping (mood thumbnails) |
| Modal | A10G/A100 | $1.10+/hr | Code-first deploy | Python SDK | High | Overkill for SDXL, better for LLM serving |

**Decision: RunPod Community Cloud, RTX 4090, on-demand pod with 30 GB persistent network volume.** Reasons in order: (1) cheapest 24 GB GPU with managed reliability — Vast.ai is cheaper but reclaim risk kills unattended heartbeat work; (2) ComfyUI templates pre-built, eliminates ~30 min of setup per session; (3) REST/GraphQL API enables full Claude automation; (4) persistent volume keeps juggernautXL + LoRAs warm between sessions ($0.10/GB/mo = ~£2/mo); (5) UK-accessible billing, GBP-friendly currency display.

**Cost projection:**
- Active art-gen month (full 200-card pass + iteration): ~£8-12
- Dormant month (storage only): ~£2
- Per-task heartbeat ceiling: cap pods at 2 hrs auto-stop = max £0.78/task

**Paul's setup completed (live 2026-05-02):**
- RunPod account created, £30 topped up
- API key generated, saved to `secrets/runpod_api_key.txt` (matches existing `github_pat.txt` protocol; gitignored)
- Read/Write scope on the key — sufficient for pod create/start/stop/delete + ComfyUI HTTP proxy access

**Sandbox network constraint discovered:** Cowork bash sandbox proxy returns 403 on outbound HTTPS to api.runpod.io, huggingface.co, and example.com. This matches the V2 finding that github.com was blocked from sandbox. **Implication:** all RunPod + HF interaction must run from Paul's laptop (or his Claude Code), not from heartbeat/Cowork sandbox. Same split-brain pattern as the GitHub workflow. Confirms path forward: Cowork authors scripts/configs, Paul or Claude Code on laptop executes anything network-bound.

**No RunPod MCP** in the registry (closest hits: Google Compute Engine, Cloudflare Developer Platform). Will drive RunPod via curl + bash + Python `requests` from the laptop side. RunPod's GraphQL API is well-documented; no connector needed.

**Civitai → Hugging Face migration plan:** juggernautXL v9 confirmed on HF as `RunDiffusion/Juggernaut-XL-v9`. The 10 LoRAs in `pipeline_setup/loras_resolved.md` need per-LoRA HF mirror research — many SDXL LoRAs cross-mirror to HF, but some are Civitai-only. Heartbeat task to scan all 10 and flag which need substitutes. Note: cloud pod has no UK IP block on Civitai access either, so worst case the LoRAs download directly to the pod from Civitai — no migration strictly required, just a contingency plan if Civitai goes fully offline.

**Phase 3 next steps queued:** B3.0a smoke test, B3.0b LoRA migration scan, B3.0c workflow_gallowfell_card.json authoring, B3.0d Python automation script. See backlog.md.

## C8 — Internal-MVP scope lock (heartbeat 2026-05-02 09:16)

- Wrote `internal_mvp_scope.md`. IMV-1 = 3 factions (Penitents + Mourners + Coven, ~120 cards already on disk) + 3 faction-locked Warlords + B2.5–B2.10 build slice. Last Legion + Skinward Pact card `.tres` files stay on disk but flipped `is_draftable=false` for IMV-1; flip back on for IMV-2.
- Deferred to IMV-2: Warlord tier system (W1–W5), real ad/IAP SDK (B4), AI art pipeline (B3), soft-launch CI (B5–B7), multi-chapter map.
- Validation gate = 5 subjective pass conditions Paul applies after a Godot-editor playthrough (draft-choice matters / sub-archetypes distinct / counter-play exists / death informative / one-more-run pull). All 5 must hit before IMV-2 unlocks.
- Engine impact ≈ zero. `Card.is_draftable` already exists and is already false on L*/W*/relic cards. Deckbuilder UI just needs a faction filter. No `Warlord` schema change in IMV-1.
- Heartbeat queue after this: **B2.5** (combat scene scaffold) → B2.6 (card-play loop) → B2.7 (turn engine) → B2.8 (reward) → B2.9 (map) → B2.10 (smoke test). W1–W5 + L3 + B3.0 can slot in around B2 progress without conflict.
- One open Q for Paul (non-blocking): IMV-1 starter Warlord trio = canonical free-3 from `warlords_v1.md` or bespoke IMV-1 trio? Default if silent = canonical free-3 (cheaper, no throwaway design).
- Verification: in-doc only — file written, no code touched, no enum changes, no .tres edits this run. Counts cross-checked against backlog (P/M/C pools confirmed at 40 each via `ls game/data/cards/{iron_penitents,ash_mourners,coven}/`).
- Next eligible heartbeat item: **B2.5** — Combat scene scaffold (3-lane grid + wave spawner + base HP + win/lose conditions).

## W1 — Warlord tier system design (heartbeat 2026-05-02 14:17 UTC)

Authored `warlord_tiers_v0.md` against the Phase 2.7 W1 spec.

- **XP curve (verified hits target bands):** T1→T2 = 1,800 XP (~12 A0 wins), T2→T3 = 4,800 XP (~32), T3→T4 = 10,800 XP (~72). Increment-per-tier: 1,800 / 3,000 / 6,000.
- **XP per win:** 100 base × (1.5 final-boss bonus stacked additively with Ascension +10%/level, ×2.0 cap at A10). A0 win ≈ 150 XP; A5 ≈ 225; A10 ≈ 300.
- **Tier 2 = variant passive A or B (default stays available)** — both spreadsheet-balanced sidegrades. Worked example: Vyrrun Mortify → Flagellant Rite (aggro twist) / Ash-Vow (defence twist).
- **Tier 3 = signature alt-fire**, same cost / same cooldown / opposite-axis effect. Worked example: Sieren's Funeral Writ (root + DoT) → Pall Writ (Smoke + Fear-1).
- **Tier 4 = mastery skin + lore reveal + title + Warlord-specific Ascension challenge slot.** Per-Warlord template authored; W2 fills the 11 entries.
- **Anti-P2W bound:** boosters multiply only, hard-capped ×3.0 stacked. Whale ceiling ~25 wins to T4; free floor ~72. Same destination.
- **Engine handoff sketched** for W5 — `Warlord.tier_unlocks: Array[TierContent]`, plus `GameState.warlord_xp` dict, multiplier field, and tier-changed signal.
- **6 open questions surfaced for Paul** (XP-on-loss, booster cap exception for live-ops, T2 default passive availability, W10/W11 A-slot difficulty, multiplier-display style, MVP-slice tier coverage).

Doc lands at `warlord_tiers_v0.md`, ~140 lines. Hands cleanly to W2 (per-Warlord content), W3 (XP-booster economy reflection in `monetisation_map.md`), W4 (tier-ladder UI mock), W5 (engine wiring after Phase 2.6 C1 lands).

## Repo push + Gallowfell scan (Claude Code on Paul's laptop, 2026-05-02)

**Pushed to `Gonzo8285/MobileGame@main`:**
- Commit 1: `feat: Godot 4.3 project scaffold + CI workflow` — 214 files (Godot project, all 5 faction card decks as `.tres`, runtime GDScript, GitHub Actions CI).
- Commit 2: `chore: phase 2.5 lore sync — Gallowfell faction names + GDD curse mechanics + warlords v1` — 28 lore/design docs.
- B1 is now physically on GitHub (was previously authored locally only). CI workflow will fire on next push.

**Gallowfell trademark + domain scan (S4 follow-up):**
| Check | Result |
|---|---|
| USPTO (TESS) | No web-visible hits. Programmatic API blocked. **Manual visit to tmsearch.uspto.gov still owed.** |
| EUIPO eSearch | No web-visible hits. Programmatic blocked. **Manual visit to euipo.europa.eu/eSearch still owed.** |
| UKIPO | No web-visible hits. **Manual visit to trademarks.ipo.gov.uk still owed.** |
| gallowfell.com | NXDOMAIN — appears unregistered |
| gallowfell.app | NXDOMAIN — appears unregistered |
| gallowfell.io | NXDOMAIN — appears unregistered |
| gallowfell.game | NXDOMAIN — appears unregistered |

**Bottom line:** zero web footprint for "Gallowfell" — no existing game, company, or product. All 4 candidate domains appear unregistered. Programmatic-level scan is clean. The three trademark registries block bots, so the formal sign-off requires Paul to log in manually to each. **Paul-action flagged in S4** — the only remaining gate before "Gallowfell" can be locked as the canonical title.

## B2.5 — Combat scene scaffold (heartbeat 2026-05-02 14:35 UTC)

Authored under green-light from Paul ("feel free to run some processes while we have allowances").

**New files (12):**
- `game/src/data/enemy.gd` — Enemy Resource (id, name, hp, atk, armor, move_speed, base_damage_override, faction, keywords, flavour). Mirrors Card pattern.
- `game/src/data/wave.gd` + `wave_spawn_entry.gd` — Wave Resource + sub-entry pair. Wave holds `Array[WaveSpawnEntry]` of {on_turn, lane, enemy}.
- `game/src/runtime/enemy_instance.gd` — RefCounted runtime for one enemy alive on a lane (data ref + current_hp + tile + statuses + take_damage/advance/add_status helpers).
- `game/src/runtime/lane.gd` — RefCounted, owns `enemies: Array[EnemyInstance]` + reserved `friendly_units` slot for B2.6. Tile convention: 0 = base, tile_count = spawn position. `advance_all()` moves every alive enemy by its move_speed and emits `enemy_reached_base(enemy, dmg)` for any that cross 0; despawns them.
- `game/src/runtime/wave_spawner.gd` — RefCounted, holds current_wave + lanes ref. `tick(turn)` reads spawn entries for that turn and spawns into lanes. `is_complete()` = wave turn_count reached AND all lanes empty.
- `game/src/runtime/combat.gd` — Node2D orchestrator. setup() builds lanes + spawner. start() binds GameState turn signals, kicks `start_combat()`. Turn signals route to `_on_turn_started` (spawner.tick) and `_on_turn_ended` (lanes advance + win/loss check). `_finish` disconnects signals + emits `combat_ended(victory)`. `cleanup()` for safe tear-down.
- `game/scenes/combat.tscn` — placeholder scene (3 ColorRect lanes + base ColorRect + status Label HUD). Sized for 1080×1920 portrait.
- `game/data/enemies/E1–E5.tres` — 5 placeholder enemy archetypes (Cathedral Flagellant melee / Carrion Hound rusher / Bog-Lurker tank / Ash-Wraith FEAR-debuffer / Reaper-Bell siege).
- `game/data/waves/act1_combat1.tres` — 5-spawn 10-turn wave for testing.
- `game/src/runtime/combat_test.gd` — 14-assertion smoke test, three fights: (1) load act1 wave + drive 10 turns + verify spawns/damage; (2) defeat path with low-HP base + over-tuned Reaper-Bell; (3) victory path by manually killing the lone enemy and ticking past wave.turn_count.
- `game/src/main.gd` — added third `_run_dev_test` line for `combat_test.gd`.

**Bugs caught and fixed in-flight:**
- Initial `combat.gd` self-called `GameState.next_turn()` from inside `_on_turn_ended`. That signal is itself fired by `next_turn()` → infinite recursion. Removed the auto-advance; B2.7 turn engine (or the test driver) is responsible for ticking. Added `is_over` guard so a stale signal connection can't double-handle.
- Between-fights signal leak: combat1's connections to GameState.turn_started/turn_ended persisted into fight 2, where combat1's lingering 6-tile-lane enemies would advance during fight 2's 2-tile-lane ticks. Added explicit `cleanup()` method, called between fights in the test.

**Verification:** Python mirror of lane + spawner + GameState + combat orchestration. All 14 assertions pass — fight 1 ends turn 10 with base_hp=24 (E1+E2 reach base for 6 dmg, E1-lane-2 + E3 + E4 still in-flight); fight 2 ends in 2 ticks with combat_ended(false) and base_hp=0; fight 3 ends in 3 ticks with combat_ended(true) and full HP. Engine syntax cannot be tested headless in this sandbox — Paul should run `main.gd` in Godot and confirm `[combat_test] PASS` appears.

**Hand-off to next heartbeat (B2.6 — card-play loop):**
- `lane.friendly_units: Array` is the slot UnitInstance lands in; class needs authoring next.
- Drag-drop input requires the placeholder Lane visuals to gain Area2D children for hit detection. ColorRects in combat.tscn are stand-ins for that.
- Card cost spend should route through `GameState.spend_mana()` (already returns bool — false = "not enough" UX hook).

**Open Qs surfaced:**
1. tile_count default = 6. Feels right for portrait but should mock once hand UI lands (B2.6) — fewer tiles = faster fights, more = more strategic depth.
2. Enemy keywords currently exposed but unused. B2.7 status-tick will consume them (FEAR/SLOW/BLEED apply to enemies; SMOKE/DREAD apply to lanes).
3. Wave .tres uses `Array[Resource]([SubResource(...)])` syntax for `spawns`. If Godot's parser is stricter than expected and needs `Array[WaveSpawnEntry](...)` instead, swap that one literal.

## B2.6 (logic slice) — CardPlay resolver (heartbeat 2026-05-02 14:55 UTC)

Push-on-from-B2.5 under same green light. Strategy: split B2.6 into logic-first (this run) + UI scaffold (next run). Logic gets robust testing; UI lands once we have a verified resolver to call.

**New files (3) + 1 edit:**
- `game/src/runtime/unit_instance.gd` — RefCounted runtime mirror of EnemyInstance for friendly units. Fields: card_data, current_hp, lane_index, tile, cooldown_counter, status. Methods: is_alive / can_attack / take_damage / heal / tick_cooldown / reset_cooldown / add_status / get_status. cooldown_counter starts at card.cooldown so units don't insta-attack on the turn they're played.
- `game/src/runtime/card_play.gd` — central `CardPlay.play_card(card, target, hand, discard, lanes) -> Dictionary`. Static-method module via `class_name CardPlay`. Validates → deducts mana → moves card hand→discard → branches on card_type. UNIT places on `lane.place_unit(card, tile)`. SPELL/TRAP are intentional stubs — cost paid + card discarded, effect engine arrives in B2.7. Result dict shape: `{success, reason, unit, spell_target, trap_lane}` — UI consumers read `success` first, branch on others.
- `game/src/runtime/card_play_test.gd` — 19-assertion smoke test. Loads cards from all 5 faction pool dirs, picks first UNIT/SPELL/TRAP it finds. Tests: AS1-6 successful unit placement (mana, hand, discard, lane state); AS7-8 occupied-tile rejection + state-immutable; AS9 invalid lane; AS10 tile 0 rejected; AS11-12 auto-tile picks back rank (tile 1); AS13 insufficient mana; AS14 null card; AS15-16 spell stub preserves spell_target; AS17-19 trap invalid-lane fail / valid-lane success / trap_lane preserved.
- `game/src/runtime/lane.gd` — extended with: `signal unit_placed/unit_killed`, friendly_units typed `Array[UnitInstance]`, `is_tile_occupied / is_tile_in_range / first_empty_tile / place_unit / cull_dead_units / unit_count`. _to_string updated to include unit count.
- `game/src/main.gd` — added 4th `_run_dev_test` line for `card_play_test.gd`.

**Validation rule order (fail-fast, no state mutation on any rejection):**
1. card non-null
2. card in hand
3. cost ≤ GameState.mana
4. type-specific target validation (UNIT lane+tile, TRAP lane, SPELL no-validate)
5. type-specific resolution

If validation passes but a downstream call (hand.remove / lane.place_unit) returns null due to a race, the resolver refunds mana + re-adds card to hand and returns failure. Idempotent on retry.

**Verification:** Python mirror with simplified Card/Lane/UnitInstance/Hand/Discard. All 19 assertions PASS — final state mana=3, hand empty, discard=4, lane 0 has 1 unit (auto-tile placement), lane 1 has 1 unit (tile 3), lane 2 has 0. Engine syntax untestable headless; Paul to confirm in Godot.

**Hand-off to next slice (B2.6 UI):**
- Need a CardView Control (one card visual — Label name/cost + tap-to-drag input).
- Need a HandView Control (HBoxContainer of CardViews wired to GameState.hand signals — `added` / `removed`).
- Need lane drop targets — Area2D children on Lane{0,1,2}Vis in combat.tscn, hit-tested on drag-release.
- On drop: build target dict `{lane: int, tile: int}`, call `CardPlay.play_card`. On success: refresh hand/lane visuals from signals. On failure: bounce card back to hand position + flash a "not enough mana" / "tile occupied" toast.
- The B2.6 stub for SPELL/TRAP means UI can ship without effect-engine wiring — they just animate the card to discard. Effects fire in B2.7.

**Open Qs surfaced:**
1. Default tile for UNIT placement when player just taps (no specific tile chosen) — currently auto-picks back rank (tile 1, closest to base, defensive). Alternative: front rank (tile_count-1, aggressive). Lean defensive for accessibility — front-rank choice is one Q for Paul once we see it on screen.
2. Card-target-required spells (e.g. Self-Scourge needs a unit to target) vs no-target spells (e.g. Iron Cohort buffs whole side) — B2.6 stub treats all spells as no-target. The effect engine in B2.7 will need a per-card targeting flag on the Card resource. Flag for next pass.

## B2.6 (UI slice) — drag-drop hand + lane targets (heartbeat 2026-05-02 15:35 UTC)

Push-on after Paul confirmed all 4 dev tests PASS in Godot 4.6.2.

**New files (5):**
- `game/src/ui/card_view.gd` — Control extending CardView. Holds Card ref; draws name/cost/type/stats over a faction-tinted ColorRect BG. Implements `_get_drag_data` returning `{kind: "card", card: <Card>, source_view: <self>}`. Drag preview = duplicated translucent self. CARD_WIDTH × CARD_HEIGHT = 200×280.
- `game/scenes/card_view.tscn` — placeholder visual with BG ColorRect + 4 Labels (Name/Cost/Type/Stats).
- `game/src/ui/hand_view.gd` — Control extending HandView. On _ready (or manual `rebind()`) connects to GameState.hand `added` / `removed` signals; populates one CardView per card in an HBoxContainer child. CARD_VIEW_SCENE preloaded.
- `game/scenes/hand_view.tscn` — Control 1080×320 with translucent BG + centred HBoxContainer.
- `game/src/ui/lane_drop_zone.gd` — ColorRect-extending script. Exports `lane_index: int`. `_can_drop_data` accepts any `kind == "card"` payload. `_drop_data` calls `combat_root.handle_drop(lane_index, card, at_position)` — combat_root auto-discovered by walking up the tree until a node with `handle_drop` is found.
- `game/src/runtime/sandbox.gd` + `game/scenes/sandbox.tscn` — manual playground launcher. Loads cards, kicks GameState.start_run + start_combat, force-bumps mana to 8, draws 5 starter UNITs into hand, instances combat.tscn, listens to `card_play_attempted` and prints "PLAY OK" / "PLAY REJECTED" on each drop attempt.

**Edits:**
- `game/src/runtime/combat.gd` — added `signal card_play_attempted(result: Dictionary)` and `func handle_drop(lane_idx, card, _drop_position) -> Dictionary`. handle_drop builds the CardPlay target dict (currently `{lane: lane_idx}` only — auto-tile picks back rank), invokes CardPlay, emits result signal, returns it.
- `game/scenes/combat.tscn` — Lane{0,1,2}Vis ColorRects now carry `lane_drop_zone.gd` script + `lane_index` 0/1/2. Added HandView child (instance of hand_view.tscn) at y=1300 spanning the full width below the player base. Updated status label text to "drag a card from hand to a lane".

**Drag-drop wiring (Godot Control API):**
1. Player presses mouse on a CardView → CardView._get_drag_data fires → returns dict + sets translucent preview.
2. Mouse moves over a LaneDropZone → _can_drop_data fires → returns true (any "card") → cursor signals "valid drop".
3. Mouse-up over the LaneDropZone → _drop_data fires → forwards to combat.handle_drop.
4. combat.handle_drop calls CardPlay.play_card with auto-tile target → returns result dict.
5. On success: card already removed from GameState.hand by CardPlay (which also bumped discard); HandView's `removed` signal handler queues_free's the visual.
6. On failure: no state mutation; visual stays in HandView (no bounce-back animation yet — that's polish).
7. card_play_attempted signal emits → sandbox.gd prints to console for visual debug.

**Untested-in-sandbox:** the .tscn / drag-drop API surface is the most engine-coupled code in the project so far and cannot be Python-mirrored. Paul's visual smoke test is the verification path.

**Hand-off to next heartbeat (B2.7 turn engine):**
- Drop _position currently ignored; per-tile drop targeting (e.g. drop at the front of the lane to push forward, drop at the back to defend) is a polish item — open Q for Paul once playtested.
- HUD lacks a mana counter / turn counter / hp counter widget. The labels exist as placeholder strings; B2.7 should bind them to GameState signals so the player sees state.
- Failed-drop bounce-back animation: nice-to-have, not required for B2.7.
- Card cooldown_counter and lane unit attacks fire from B2.7's turn engine.

**Open Qs surfaced:**
1. Per-tile drop targeting vs auto-tile back-rank — needs visual playtest. Could feel "magic" (auto) or "fiddly" (manual).
2. Mana counter visibility — currently tucked into console only. Heartbeat-suitable: a small Label child on HandView showing mana would close the loop without scope creep.
3. Faction tint palette — placeholder, will be replaced by B3 art. But interim: the 5 tinted backgrounds make hand legibility instant during dev — keep through internal MVP.

## D-LORA-1 — Civitai LoRA URL hunt + verification (heartbeat 2026-05-04 14:18 UTC)

Resolved all 8 LoRA slots from `pipeline_spec.md` §2.2 to canonical Civitai URLs (or documented substitutes). Full mapping + rationale lives in `pipeline_setup/loras_resolved.md`.

**Headline findings:**

- 3 of the 8 original placeholder slugs reference WotC IP (`mtg-style`, `phyrexian-corruption`, `lorwyn-folkloric`) — no public Civitai LoRA exists for any of them (DMCA history). Substituted with style-adjacent LoRAs that hit the same aesthetic axis without naming the IP.
- 1 exact match found: `Elden Ring Style` v1.0 (Civitai 457103) for the `elden-ring-concept-sdxl` slot.
- 5 close-match substitutes resolved on first 4 web searches — search efficiency was high because Civitai's SEO surfaces SDXL fantasy LoRAs cleanly.

**Resolved stack (final):** ClassipeintXL + Dark Fantasy LORA + Elden Ring Style (style); RPGNightmareXL (Penitents); gothic cathedral interior + Dark Gothic Fantasy (Mourners); Swamp people + Mythical Forest Style (Coven); ArmorSentinel medieval armor (Legion); Mythical Forest Style + Mythical Creatures (Skinward Pact). Total disk ≈ 1.5–2 GB inside the 30 GB budget.

**Open follow-ups (deferred — none block 9-tile sheet):**

1. License audit per LoRA (Phase 4 legal pass — `pipeline_spec.md` §10 Q4).
2. Trigger-word capture per LoRA — append to §3.2 once Paul has installed and run one to confirm activation tokens.
3. Exact-version pinning once LoRA files are on disk and we can read metadata.
4. Backup-LoRA verification (Painterly Fantasia + Eldritch Impressionism) — only if a primary gets yanked.

Files touched this heartbeat: `pipeline_setup/loras_resolved.md` (created), `pipeline_setup/README.md` (step 3 LoRA list rewritten with URLs), `pipeline_spec.md` §2.2 (placeholder slugs replaced with resolved names + Civitai IDs + weights).

D-LORA-1 ticked. Next D-WORKFLOW-1 (author the ComfyUI workflow JSON) is the natural successor — it now has all the LoRA names it needs as LoRA-loader node inputs.

## D-WORKFLOW-1 — ComfyUI workflow JSON authored (heartbeat 2026-05-04 21:30 UTC)

Authored `pipeline_setup/workflow_gallowfell_card.json` — the ComfyUI graph every Gallowfell card image generates through. Validated: parses cleanly + all 17 nodes / 29 links cross-reference consistently in both directions (subagent ran the audit, all checks PASSED).

**Graph shape:** CheckpointLoaderSimple → 10× LoraLoader chain (3 style + 7 faction) → 2× CLIPTextEncode (positive + negative) → KSampler → VAEDecode → SaveImage. EmptyLatentImage feeds the KSampler latent slot in parallel; checkpoint VAE pipes directly to VAEDecode (skipping the LoRA chain — LoRAs don't touch VAE). Loaded via ComfyUI's browser **Load** button per `pipeline_setup/README.md` step 5.

**Locked parameters (hardcoded in widget values, never edit):**

- Sampler `dpmpp_2m` / scheduler `karras` (= "DPM++ 2M Karras" per §2.3)
- Steps 30, CFG 6.5, denoise 1.0
- Latent dimensions 832 × 1216 (0.685 portrait card ratio)
- Seed control = `fixed` — NOT randomized between runs (reproducibility rule §7.4)
- Default seed 4242 — placeholder; per-card spec files override per `art_specs/_template.md` deterministic seed rule
- Negative prompt = full §3.6 text baked into node 13's widget (node title says "do not edit")
- Checkpoint filename `juggernautXL_v9.safetensors`

**Player-editable surfaces (the only things meant to change per card):**

- Node 12 positive prompt — paste resolved prompt from the card's `art_specs/<faction>/<id>.md` file
- Each LoraLoader's `strength_model` + `strength_clip` weights, per the protocol baked into the workflow's `extra.lora_weight_protocol`: keep style LoRAs (nodes 2-4) at spec defaults always; for faction LoRAs (nodes 5-11), keep only the active card's faction at spec defaults and zero out every other faction's weights before queueing.

**LoRA node mapping** (per `loras_resolved.md`, weights per `pipeline_spec.md` §2.2):

| Node | LoRA filename (in widget) | Default weight | Layer |
|---|---|---|---|
| 2 | classipeintXL_v21.safetensors | 0.8 / 0.8 | Style — always on |
| 3 | DarkFantasyLora_v1.safetensors | 0.8 / 0.8 | Style — always on |
| 4 | EldenRingStyle_v10.safetensors | 0.5 / 0.5 | Style — always on (also = Last Legion knight axis) |
| 5 | RPGNightmareXL_v10.safetensors | 0.4 / 0.4 | Iron Penitents (capped 0.4 for PEGI 12) |
| 6 | gothicCathedralInterior_v10.safetensors | 0.6 / 0.6 | Ash-Mourners environment |
| 7 | DarkGothicFantasy_v301.safetensors | 0.5 / 0.5 | Ash-Mourners figures |
| 8 | swampPeople_sdxl.safetensors | 0.5 / 0.5 | Coven |
| 9 | MythicalForestStyle_sdxl.safetensors | 0.5 / 0.5 | Coven + Skinward Pact (shared environment LoRA) |
| 10 | ArmorSentinel_v2.safetensors | 0.6 / 0.6 | Last Legion |
| 11 | MythicalCreatures_sdxl.safetensors | 0.5 / 0.5 | Skinward Pact |

**Filename gotcha for Paul (likely first failure mode at install time):** Civitai downloads land with whatever filename the model author uploaded — usually versioned + slugified, but inconsistent. The names baked into the workflow above are educated guesses at the most common default. If after Step 5 of the README ComfyUI throws "Lora not found" or "Could not load LoRA" errors when queueing the test prompt, the fix is one of:

1. **Rename the .safetensors file** in `C:\ComfyUI\models\loras\` to match the filename listed above. Cheap and reproducible — recommended. Every future ComfyUI install on any machine will then match this workflow without edits.
2. **Edit the workflow** — open `workflow_gallowfell_card.json` in a text editor, find the offending LoraLoader node's widgets_values, swap the filename. Don't do this if anyone else will share the workflow — it locks reproducibility to your exact filename set.

Recommend option 1.

**SD 1.5 fallback (D-WORKFLOW-2) still queued.** Same graph minus the SDXL-only LoRAs (RPGNightmareXL is SDXL-native; ArmorSentinel SDXL only; Mythical Forest Style SDXL/Illustrious only) — the SD 1.5 workflow drops those three and leans on prompt engineering to carry the missing faction silhouettes. Authored as a separate file once Paul confirms ComfyUI installs cleanly with the SDXL workflow first.

**Cheap validation path:** Paul runs the README's Step 4 + 5 install + the §"Smoke test" prompt. If a recognisable hooded brass-mask figure renders, the wiring is provably correct on his RTX 2050. After that, A-SPEC-1 onward can begin populating the ~220 per-card spec files knowing the prompts will drop straight into node 12 unchanged.

Files touched this heartbeat: `pipeline_setup/workflow_gallowfell_card.json` (created — 17 nodes, 29 links, ~9 KB).

D-WORKFLOW-1 ticked. Next eligible: A-SPEC-1 (per-card art spec files for Iron Penitents). Recommend Paul runs the ComfyUI install + smoke test first to surface any wiring/filename issues before we commit ~220 spec files against an unverified workflow — one heartbeat to fix the workflow is much cheaper than re-authoring 220 specs to a different LoRA stack.

## A-SPEC-1 — Iron Penitents art specs (heartbeat 2026-05-05)

- 40 spec files authored at `art_specs/iron_penitents/p{n}_<snake_name>.md` (P1–P40)
- All files follow `art_specs/_template.md` format exactly
- Resolved prompts = §3.1 global + §3.2 Iron Penitents faction + §3.3 subject + §3.4 composition + §3.5 quality
- Seed formula: 40000 + 101 × card_number (verified P25 → 42525)
- Unit cards use portrait composition; spell/trap/relic cards use wide establishing shot
- Iron Penitents faction LoRA: RPGNightmareXL @ 0.4 (capped for PEGI 12)
- idle_loop_frames = 2 for all (no Warlords in this pool; Warlords get 4 at A-SPEC-6)

---

## A-SPEC-2 — Ash-Mourners art-spec population (heartbeat 2026-05-05)

- **Output:** 40 markdown spec files under `art_specs/ash_mourners/` (M1–M40, lowercase-id snake_case filenames matching Iron Penitents convention).
- **Card-type split:** 24 UNIT (§3.4 portrait composition) / 10 SPELL + 4 TRAP + 2 RELIC (§3.4 environment composition). Mirrors `cards_ash_mourners_v1.md` distribution exactly.
- **Subject descriptions:** ~25–30 words each, pulled from card mechanic in v1.0 doc + Ash-Mourners motif vocabulary from `lore_gallowfell.md` (court-shroud, raven-quill, censer-smoke, catacomb-vault, ink-stained, no-shadow, dusk-purple). Each card's description is mechanic-coherent (e.g. M21 Wraith-Caller shows the Wraith forming in violet smoke; M11 Funeral Bell shows the bell-rope coiled into a snare).
- **Faction LoRA stack:** ClassipeintXL@0.8 + Dark Fantasy@0.8 + Elden Ring Style@0.5 + gothic cathedral interior@0.6 + Dark Gothic Fantasy@0.5 (faithful to `pipeline_spec.md` §2.2 resolved 2026-05-04).
- **Seed formula:** 50000 + 101 × N (Ash-Mourners faction tag = 5). Mirrors Iron Penitents' 40000 + 101 × N pattern → no cross-faction collisions, every seed unique up to ~999 cards per faction. M1=50101, M5=50505, M40=54040.
- **Validation checklist:** faction-specific palette line tightened to "dusk-purple accent, not blue or fuchsia" (Iron Penitents version reads "rust-red, not magenta or pink") so Paul's per-faction QA pass is unambiguous at sign-off.
- **Pattern parity with Iron Penitents:** verified by spot-comparison — file naming (lowercase id), output_path (lowercase), iterations_path (uppercase id), all five locked layers in §3 order, same template skeleton.
- **Next heartbeat hop:** A-SPEC-3 — Coven of the Black Mire (~40 cards, C1–C40) using bog-green accent + swamp/lorwyn faction style + Swamp People + Mythical Forest + Witch Style LoRA stack.

Heartbeat 2026-05-05 — A-SPEC-2 complete, advancing.

## A-SPEC-3 — Coven of the Black Mire spec files (heartbeat 2026-05-08 09:20 UTC)

- **Output:** 40 markdown spec files written under `art_specs/coven/c1_…c40_…`. One per card from `cards_coven_v1.md` v1.0 (C1–C40). Folder created from scratch this run.
- **Composition split:** UNIT cards (24) use §3.4 portrait composition; SPELL (10), TRAP (4), and RELIC (2) cards (16) use §3.4 environment composition. C1 Bog-Spawn flagged as the §5 reference-tile-7 candidate (validates "ugly little creature without making it cute").
- **Subject descriptions:** ~25–30 words each, pulled from card mechanic in v1.0 doc + Coven motif vocabulary from `lore_gallowfell.md` and `pipeline_spec.md` §3.2 (swamp-witch silhouette, demon-coin wreath, three-shadows-cast, green pyre eyes, briar-tangled cloak, bog-green accent, fungal-grove background, lorwyn-folkloric grotesque). Each card's description is mechanic-coherent (e.g. C24 Quag-Mother's Daughter cradles three newborn spawn at once mirroring her on-play summon-3; C29 Drowning of the Demon-Coin shows three coins sinking with bog-green discharge mirroring its 3-sacrifice payoff).
- **Faction LoRA stack:** ClassipeintXL@0.8 + Dark Fantasy@0.8 + Elden Ring Style@0.5 + Swamp people@0.5 + Mythical Forest Style [SDXL]@0.5 (faithful to `pipeline_spec.md` §2.2 resolved 2026-05-04). Optional `Witch Style` @ 0.4 NOT included in default stack — flagged for Paul's call if reference-sheet tile 7 (Bog-Spawn) reads too clean and needs the witch-aesthetic boost. Trigger word `ral-mytfrst` baked into LoRA-loader chain via Mythical Forest's documented activation; not duplicated in prompt body since LoRA at 0.5 fires reliably without the textual trigger on SDXL.
- **Seed formula:** 60000 + 101 × N (Coven faction tag = 6). Range 60101–64040. Mirrors Iron Penitents' 40000+101×N and Ash-Mourners' 50000+101×N → 0 cross-faction collisions, every seed unique up to ~999 cards per faction.
- **Validation checklist:** faction-specific palette line set to "bog-green accent, not lime green or neon" (Iron Penitents reads "rust-red, not magenta or pink"; Ash-Mourners reads "dusk-purple accent, not blue or fuchsia") so Paul's per-faction QA pass is unambiguous at sign-off. Body-horror line widened to "Phyrexian / lorwyn-grotesque undertone" since Coven leans Lorwyn-grotesque (witches, three-shadows) rather than Phyrexian-corporeal.
- **Pattern parity with prior factions:** verified by spot-comparison — file naming (lowercase id), output_path (lowercase), iterations_path (uppercase id), all five locked layers in §3 order, same template skeleton, RELIC card_type used (matches Ash-Mourners M39/M40 convention).
- **Generated by:** `outputs/gen_coven_specs.py` — script not committed; per-card spec files are the source of truth (per `pipeline_spec.md` §7).
- **Open Q for Paul (non-blocking):**
  1. Optional `Witch Style` @ 0.4 LoRA — keep out of default stack (current state) or add per-spec for the witch-heavy cards (C11 Witch of the Bound Coin, C17 Witch of the Slow Decay, C23 Sigil-Drawn Bog-Witch)?
  2. C29 Drowning of the Demon-Coin is the faction's flagship spell — escalate composition to "warlord_signature" tier so it gets the same iteration budget as a free Warlord? Currently set to "event" tier.
- **Next heartbeat hop:** A-SPEC-4 — The Last Legion (~40 cards, L1–L40) using brass accent + soot-blackened cuirass faction style + ArmorSentinel medieval armor LoRA on top of the locked style trio.

---

## A-SPEC-4 — The Last Legion spec files (heartbeat 2026-05-08)

- **Done:** 40 spec files written to `art_specs/last_legion/l1_…l40_…` (one per card, L1–L40, lowercase ids, snake-cased display names with apostrophes/commas/hyphens collapsed to `_`).
- **Composition split:** UNIT cards (24) use §3.4 portrait composition; SPELL (10), TRAP (4), and RELIC (2) cards (16) use §3.4 environment composition. L7 Sergeant-Smith Vikar / L18 Echo-Sergeant / L33 Banner-Captain of the Crowned Anvil = the 3 portrait Rares (archetype identities); L34 Crowned Anvil Standard = the 4th Rare, kept on portrait composition (artifact-unit but card_type stays UNIT, mirrors how aura-pieces L29 Iron Wardrum / C29-style Coven tokens were handled).
- **Subject descriptions:** ~25–30 words each, mechanic-coherent: L7 Vikar holds an ironwood baton signalling lockstep (matches his identity buff); L9 Iron Standard Unfurled is a wide unfurling banner over the lane (matches "all friendly Legion in lane gain +2 ATK"); L18 Echo-Sergeant has a ghost-after-image of the second strike (matches Echo replay); L25 Hammer-Stroke Doctrine shows a battalion of synchronised hammer-blows across the row (matches "all Legion attacks this turn trigger Echo"); L34 Crowned Anvil Standard is a towering hammered-brass anvil on ironwood pole with brass-glow aura (matches its 8 HP / 0 ATK / persistent +1 ATK aura).
- **Faction LoRA stack:** ClassipeintXL@0.8 + Dark Fantasy@0.8 + Elden Ring Style@0.5 + ArmorSentinel medieval armor style@0.6 (faithful to `pipeline_spec.md` §2.2 — only 4 LoRAs total, vs 5 for Mourners/Coven, since the Elden Ring style LoRA already covers the decayed-knight axis natively per §2.2 note).
- **Seed formula:** 70000 + 101 × N (Last Legion faction tag = 7). Range 70101–74040. Mirrors Penitents (40000+101×N), Mourners (50000+101×N), Coven (60000+101×N) → 0 cross-faction collisions. Faction tag 7 leaves 8/9 free for Skinward Pact (next heartbeat hop) and any future faction.
- **Validation checklist:** faction-specific palette line set to **"brass accent, not gold or copper"** (gold = too sunlit-noble; copper = too pinkish-warm; the Last Legion needs hammered-brass cool with forge-glow). Body-horror line softened to **"decayed-knight elden-ring scale present, no explicit gore"** — the Last Legion is the least body-horror of the five factions; they're broken imperial soldiers, not flagellants/witches/bog-things, so the Phyrexian undertone gets dialled down in QA criteria.
- **Echo soft-keyword:** ~10 cards in the pool reference Echo in card text (L9, L14, L16, L20, L21, L22, L23, L24, L25, L26, L39 by name or function). Per `cards_last_legion_v1.md` Q1, Echo is text-only — not in `GFEnums.Keyword` yet. No spec-file impact: the visual is just "ghost-after-image / twin-strike" in the subject text, no special composition or seed treatment.
- **Pattern parity with prior factions:** verified by spot-comparison of L7 + L9 against C1 (Coven UNIT) + C9 (Coven SPELL) — file naming (lowercase id), output_path (lowercase), iterations_path (uppercase id), all five locked layers in §3 order, same template skeleton, RELIC card_type used for L39/L40 (matches Ash-Mourners M39/M40 + Coven C39/C40 convention).
- **Generated by:** `outputs/gen_last_legion_specs.py` — script not committed; per-card spec files are the source of truth (per `pipeline_spec.md` §7).
- **Next heartbeat hop:** A-SPEC-5 — Skinward Pact (~40 cards, W1–W40). Faction style §3.2: antler-crown + hide cloak + druidic-with-phyrexian-undertones + bark-brown accent + cinderwood-grove. LoRA stack: Mythical Forest Style [SDXL]@0.5 (shared with Coven) + Mythical Creatures SDXL@0.5. Seed formula: 80000 + 101 × N (faction tag = 8). Will close out the 5-faction card-art spec pass; Warlords (A-SPEC-6) and enemies (A-SPEC-7) come after.

---

## A-SPEC-5 — Skinward Pact spec file population (heartbeat 2026-05-08)

40 spec files authored under `art_specs/skinward_pact/w1_…w40_…`.

- **Composition split:** UNIT × 24 → §3.4 portrait composition; SPELL × 10 + TRAP × 4 + RELIC × 2 → §3.4 environment composition.
- **Distribution check:** 24/10/4/2 type split + 24C/12U/4R rarity skew — both hit exactly, matches `cards_skinward_pact_v1.md` v1.0 spec.
- **Subject vocabulary:** pulled from `cards_skinward_pact_v1.md` mechanics + `pipeline_spec.md` §3.2 Skinward Pact motif (antler-crown sprouting through bone, hide cloak layered, mismatched eyes, smoke-trailing fingers, druidic shaman with phyrexian undertones, bark-brown accent, cinderwood-grove background). All subjects 25–30 words.
- **Faction LoRA stack** (per `pipeline_spec.md` §2.2): ClassipeintXL@0.8 + Dark Fantasy LORA@0.8 + Elden Ring Style@0.5 + Mythical Forest Style [SDXL]@0.5 + Mythical Creatures SDXL@0.5. Mythical Forest is shared with Coven — same LoRA, different per-card prompts drive the divergence.
- **Seed formula:** 80000 + 101 × N (faction tag = 8). Range 80101–84040. Verified no collisions with Penitents (40101–44040), Mourners (50101–54040), Coven (60101–64040), Last Legion (70101–74040).
- **Validation checklist:** palette line set to "bark-brown accent, not red-brown or olive"; body-horror line set to "druidic-with-phyrexian-undertones present, no explicit gore" (Skinward Pact's phyrexian undertone is faction-canonical per §3.2, unlike Last Legion which is decayed-knight scale-only).
- **RELIC card_type** used for W39 Antler-Crown Sigil + W40 Wolf-Pelt Sigil (matches the Penitents/Mourners/Coven/Last Legion convention; relic-slot system still pending Paul's call from the upstream C-series Q).
- **Token spec rule:** W27 Cub-Token + W28 Wolf-Token authored as `card_type=UNIT` with portrait composition, role=standard (mirrors C1 Bog-Spawn pattern from Coven). They're draftable 0c per the cards file, even though they're also runtime-generated by other cards.
- **Soft-keyword note:** Transformation appears in subject text on 9 cards (W14, W15, W17, W18, W19, W20, W21, W22, W23, W24, W25) but no engine impact this pass — text-only per `cards_skinward_pact_v1.md` Q1, mirrors C5 Echo handling. Engine enum addition `TRANSFORM = 15` still queued for Paul's call before B2.5 wave-spawner work.
- **Generation script:** `outputs/gen_skinward_specs.py` — not committed; per-card spec files are the source of truth.

**Phase 2.11 milestone:** A-SPEC-1..5 now complete. All 5 factions × ~40 cards = 200 per-card spec files are populated and pipeline-ready. Remaining Phase 2.11 work: A-SPEC-6 (11 Warlords, flagship-tier seeds), A-SPEC-7 (5 enemies + future bosses), D-WORKFLOW-2 (SD 1.5 fallback workflow JSON), D-VALIDATE-1 (9-tile reference sheet — gated on Paul's local ComfyUI install + B3.0a smoke test).


---

## A-SPEC-6 — Warlord art-spec files (heartbeat 2026-05-09)

11 spec files written under `art_specs/warlords/w1_…w11_….md`. Phase 2.11 spec-file population for the Warlord roster is now complete; only A-SPEC-7 (5 placeholder enemies) remains in the spec-population sub-phase.

### Mapping (Warlord → primary faction → seed)

| # | Warlord | Primary faction | LoRA stack | Seed |
|---|---|---|---|---|
| 1 | Penance-Captain Vyrrun | iron_penitents | Penitents stack (ClassipeintXL+DarkFantasy+EldenRing+RPGNightmareXL@0.4) | 14242 |
| 2 | Court-Necromant Sieren | ash_mourners | Mourners stack (+gothic_cathedral@0.6 + DarkGothicFantasy@0.5) | 24242 |
| 3 | Marsh-Mother Eddra | coven | Coven stack (+Swamp_people@0.5 + MythicalForest@0.5) | 34242 |
| 4 | Forge-Marshal Veska | last_legion | Legion stack (+ArmorSentinel@0.6) | 44242 |
| 5 | Tree-Walker Mhar | skinward_pact | Pact stack (+MythicalForest@0.5 + MythicalCreatures@0.5) | 54242 |
| 6 | The Vow-Broken Magus | iron_penitents (× ash_mourners hybrid) | Penitents stack — court-shroud motif via subject text | 64242 |
| 7 | Warden Caspar Voll | last_legion | Legion stack | 74242 |
| 8 | The Saint of Gallowsmoke | coven (× ash_mourners hybrid) | Coven stack — censer-chains motif via subject text | 84242 |
| 9 | The Brass-Crowned Whelp | skinward_pact (× iron_penitents hybrid) | Pact stack — brass-crown motif via subject text | 94242 |
| 10 | The Last Confessor | ash_mourners (faction-flex, deviation note) | Mourners stack | 104242 |
| 11 | The Saint That Should Not Hang | ash_mourners (curse-bound, deviation note) | Mourners stack | 114242 |

### Reproducibility checks

- **Seed-collision audit:** all 11 warlord seeds clear of every faction common-card range. Faction ranges are 40101–44040 / 50101–54040 / 60101–64040 / 70101–74040 / 80101–84040; warlord seeds 14242, 24242, 34242, 44242, 54242, 64242, 74242, 84242, 94242, 104242, 114242 either fall under (1–5 × 10000+4242) or above the corresponding range (44242 > 44040 etc). 0 collisions.
- **Composition tier:** warlord_signature → uses `pipeline_spec.md` §3.4 portrait variant (warlords are character cards). No new composition variant introduced. Validation checklist gets one extra line — "Warlord-signature flagship presence: silhouette readable from across the screen, costume / props clearly faction-coded" — to enforce the flagship bar.
- **idle_loop_frames=4** on all warlords per `art_direction.md` §3.
- **alt_arts=["mastery_skin"]** placeholder slot for the Tier-4 mastery cosmetic per `warlord_tiers_v0.md` (W1).
- **PEGI-12 guard** sharpened on W11 only: rope-mark MUST read as iconography, not injury — flag for re-roll if first pass produces visible bruising or trauma. The negative-prompt baseline (`severed limbs, exposed organs, blood pools`) does the heavy lifting; W11's per-card validation catches the residual edge case.

### Open Q raised for Paul (non-blocking)

- **Hybrid warlord rendering:** W6/W8/W9 use primary-faction LoRA + secondary-faction motif via subject text. If the first 9-tile reference sheet shows them under-reading as hybrids (e.g. W6 looks 100% Penitent with no Court overlay), the spec files document the escalation path: add the secondary faction's faction-LoRA at 0.3–0.4 weight, file as a flagged proposal in `pipeline_spec_proposals.md`, await Paul. Default = single-faction LoRA stack for cleanest reproducibility.
- **Neutral warlords (W10/W11):** mapped to Ash-Mourners as closest-existing pipeline_spec faction style. Cleanly justified for both (W10 = cathedral-confessor / Victorian mourning aesthetic, W11 = no-shadow-figure / mourning-Saint-iconography), but they're the only specs in the project carrying a `Deviation note` block. If Paul wants a true neutral faction style added to `pipeline_spec.md` §3.2 (sixth entry), that's a flagged-proposal heartbeat — does NOT block first generation pass.

### Pattern parity with prior A-SPEC heartbeats

Same template, same prompt-layer concatenation, same locked sampler/CFG/steps. Only deltas vs A-SPEC-1..5: seed formula (warlord-specific), card_type (WARLORD vs UNIT/SPELL/TRAP/RELIC), rarity (LEGENDARY vs COMMON/UNCOMMON/RARE), idle_loop_frames (4 vs 2), alt_arts (mastery_skin slot vs []), and the warlord-signature flagship-presence validation line. Generated by `outputs/gen_warlord_specs.py` — same author-pattern as A-SPEC-2 through A-SPEC-5, script not committed, per-spec files are the source of truth.

## A-SPEC-7 — Enemy spec files (heartbeat 2026-05-09 04:19 UTC)

5 spec files written under `art_specs/enemies/e1_…e5_…`. Mirrors the per-faction spec convention: subject ~25–30 words from each enemy's `.tres` flavour + faction motif vocabulary; pipeline parameters fully resolved per `pipeline_spec.md`.

**Faction routing** (enemy.faction enum → art_specs/<faction-style>):
| Card | display_name | enemy.faction | Pipeline faction style | LoRA stack |
|---|---|---|---|---|
| E1 | Cathedral Flagellant | 0 (Iron Penitents) | iron_penitents | ClassipeintXL+DarkFantasy+EldenRing + RPGNightmareXL@0.4 |
| E2 | Carrion Hound | 2 (Coven) | coven | + Swamp people@0.5 + Mythical Forest@0.5 |
| E3 | Bog-Lurker | 2 (Coven) | coven | + Swamp people@0.5 + Mythical Forest@0.5 |
| E4 | Ash-Wraith | 1 (Ash-Mourners) | ash_mourners | + gothic_cathedral_interior@0.6 + Dark Gothic Fantasy@0.5 |
| E5 | Reaper-Bell | 1 (Ash-Mourners) | ash_mourners | + gothic_cathedral_interior@0.6 + Dark Gothic Fantasy@0.5 |

**Seed range** = 90000 + 101 × N (range 90101–90505). Enemy tag = 9, distinct from Penitents 4 / Mourners 5 / Coven 6 / Last Legion 7 / Skinward 8 / Warlords (N×10000+4242). No collisions (90101–90505 vs 40101–84040 vs 14242–114242).

**Composition deviations:**
- E1–E4 use §3.4 portrait composition (humanoid focal figures).
- E5 Reaper-Bell uses §3.4 environment-led wide-shot variant — it's a siege-object on a frame, not a humanoid; the procession is dressing, the bell is the hero. Override documented in spec file.

**Rarity assignment** (no card-side rarity exists for enemies; assigned for art-tier signalling):
- E1–E3 = COMMON (basic mooks, low HP/ATK)
- E4 = UNCOMMON (Smoke keyword, mid-game presence)
- E5 = RARE (Reaper-Bell — siege-bell with Toll keyword, 15 HP / 5 base damage override, faction-defining unit)

**idle_loop_frames** = 2 across all 5 (per `art_direction.md` §3 convention; bosses get 4 when added).

Phase 2.11 spec-file population now complete for: 5 factions × 40 cards (Iron Penitents / Ash-Mourners / Coven / Last Legion / Skinward Pact) + 11 Warlords + 5 placeholder enemies = **216 spec files total**. D-WORKFLOW-2 (SD 1.5 fallback workflow) + D-VALIDATE-1 (9-tile reference sheet) still queued for next runs.


---

## M1 — Persist keyword design (heartbeat 2026-05-10)

- **Outputs (4 files touched):**
  - `keywords/persist_v0.md` — full keyword spec (one-line text, mechanics-locked block, interactions vs Resurrect/Sacrifice/DoT/board-wipe/Hanging-Hour/tokens, engine wiring sketch, anti-P2W invariant, 3 open Qs).
  - `game/src/data/enums.gd` — `GFEnums.Keyword.PERSIST` added (15th keyword; doc-comment points at the spec).
  - `faction_bible.md` — Ash-Mourners §2 mechanical-role line now names PERSIST as primary keyword alongside existing Smoke / Resurrect.
  - `cards_ash_mourners_v1.md` — appended "Persist candidates" section flagging 5 cards (M5 / M12 / M20 / M22 / M24) with rationale + risk note. **No `.tres` edits** — tagging happens at M2.
- **Locked design:** end-of-turn return, ATK-1 floor 0, once-per-combat (`CardInstance.has_persisted` flag, resets on `Combat.cleanup()`), tile-occupied → push to nearest empty in row, no empty tile = silent fail. Self-buffs/auras lost on Persist. Tokens cannot Persist (engine-side `is_token` early-out). Resurrect wins over Persist when both could fire on the same unit.
- **Hanging Hour hook (M4):** Persist's once-per-combat lock + ATK-1 clause are both overridden during the Hanging Hour boss-escalation. M4 will spec the override flag formally — design contract reserved here so M4 doesn't have to renegotiate the keyword shape.
- **Sacrifice synergy preserved:** sacrificed friendlies count as deaths → Persist fires on them. Coven sacrifice-combos + Iron Penitents Penance loops gain a free splash if a Persist-tagged Ash-Mourner is included. Intentional — matches Paul's MTG-references centred on persist/sac/graveyard-recursion.
- **Anti-P2W note locked into the spec:** PERSIST is gameplay-only, never cosmetic. Restated in the spec because Persist is one of the most powerful effects in the pool and the IAP-temptation is real.
- **Open Qs queued for Paul (none block M2):** ATK-floor (0 chump body vs hard-kill at ATK=0; default 0); Persist on enemy side (no on standard, yes on chapter bosses recommended); UI display (silhouette behind cost vs icon next to keyword text — defer to B3.2).
- **Sandbox note:** GDScript syntax untestable in Cowork sandbox; the enum addition is a single-token append after `SLOW`, no risk to existing call sites that branch on `Keyword`. Paul to confirm the project still parses in Godot. No engine-wide rename; existing keyword constants untouched.
- **Next M-track hop:** M2 (sacrifice-and-return loop hardening). Will revisit the 5 candidate cards then and decide which 2-3 actually get the keyword + author 2-3 missing combo enablers (sacrifice outlet, return-to-hand, sacrifice-payoff).

---

## Cloud smoke test PASSED — first Gallowfell render (heartbeat 2026-05-10)

- **Output:** `art_iterations/_smoke/smoke_1778402592_iron_penitent.png` (832×1216, 1.45 MB).
- **Subject:** Iron Penitents reference — hooded figure in oxblood/rust-red cloak, brass-mask silhouette under the hood, iron chains coiled at the feet, candle-yellow cathedral arch backlight, painterly oil-painting brushwork. **Matches `faction_bible.md` §1 palette + motif and `art_direction.md` §1c MTG-painterly + Elden-Ring-grandeur direction on first try.**
- **Pipeline used:** RunPod community 3090 ($0.22/hr) → official ComfyUI template (cw3nka7d08, runpod/comfyui:latest, Manager V3.40 onboard) → Manager API installed `sd_xl_base_1.0.safetensors` from registry → submitted minimal 7-node SDXL workflow (KSampler dpmpp_2m karras 30 steps CFG 6.5 seed 4242) → downloaded via /view → pod terminated.
- **Cost incurred:** ~£0.03 (pod was up ~10 min total: ~3 min idle test/teardown of 2 wrong-template pods + ~7 min for the working run).
- **Total elapsed for working run:** ~7 min from deploy to image-in-folder.
- **Path lessons (worth a research note for D-VALIDATE-1+):**
  1. ComfyUI-Manager V3.40 install_model API rejects arbitrary URLs — payload must match its registry (`type: "checkpoint"` singular, `save_path` matching the registry entry). Civitai-only LoRAs in `loras_resolved.md` will need a different install path on cloud pods.
  2. The proxy URL `<podid>-8188.proxy.runpod.net` is HTTP-only and works the moment ComfyUI binds — about 15-30s after pod RUNNING.
  3. RunPod's pytorch templates expose only HTTP-proxy ports, no public TCP — direct SSH to a community pod is not available without secure-cloud upgrade. Stick with ComfyUI HTTP API for orchestration.
  4. SDXL base alone (without LoRA stack) already produces strong painterly grimdark output on a single short prompt. The 10-LoRA stack from `pipeline_spec.md` is a quality-uplift layer, not a baseline requirement — useful framing for Phase 2.11 D-VALIDATE-1 expectations.
- **Working automation script:** `pipeline_setup/runpod_smoke_test.py` (B3.0d) authored — needs minor fixes (registry-format install_model, log path to /tmp not OneDrive) before becoming the canonical re-runnable batch tool. Patches noted in head of file. Effectively this run = a partial B3.0d validation: 80% of the script ran as intended end-to-end this heartbeat.
- **Next:** B2.7 turn engine + M2 sacrifice-loop hardening. D-VALIDATE-1 (9-tile reference sheet) now technically unblocked — a single tile cost £0.03 in 7 min, so 9 tiles = £0.27 and ~30 min once batch-submitting works. Defer until Paul confirms aesthetic on this single image.

## B2.10 — End-to-end smoke test (heartbeat 2026-05-12 19:20 UTC)

- **Authored:** `game/src/runtime/e2e_smoke_test.gd` (~280 LoC, 27 assertions). Wired into `main.gd` dev-test runner after `map_test.gd` so `RUN_DEV_TESTS=true` exercises it on launch. Paul confirms via `[e2e_smoke_test] PASS` console line.
- **Coverage:** composes B2.4 (GameState lifecycle) + B2.5 (Combat) + B2.7 (TurnEngine, via Combat hookup) + B2.8 (Reward) + B2.9 (Map graph nav). Each prior B2.x test exercised one system in isolation; this one verifies they hand off correctly across phase transitions.
- **Walked flow:** `start_run → enter_chapter(1) → choose_next_node → setup+start combat → drive turns → combat_ended(true) → start_reward → offer.choose → choose_next_node → setup+start combat → defeat path → combat_ended(false) → run_ended(false) → phase == GAME_OVER`. The second combat uses `base_hp=2` + a killer wave to force the lethal-damage path that collapses out to GAME_OVER through `GameState.take_damage → end_run(false)`.
- **Anti-P2W:** no monetisation state read anywhere in the test or the systems it composes.
- **Signal-emit assertions:** `run_started`/`run_ended`/`chapter_started`/`map_node_entered`/`reward_offered`/`reward_resolved` each gated to exactly-one emit; `phase_changed` log scanned for both REWARD and GAME_OVER transitions. This catches signal-fan-out bugs where a phase transition forgets to emit, or a reward handshake double-fires.
- **Helpers:** mirrored `_make_lonely_wave` + `_make_killer_wave` pattern from `combat_test.gd` (same field names — `on_turn` not `turn`, typed `Array[WaveSpawnEntry]` for `w.spawns`). Highest-damage enemy picked for killer wave so the 2-tile lane resolves to lethal on a single advance.
- **NOT in scope (deliberate IMV-1 trim):** map_view.tscn UI scene, reward_view.tscn UI scene, shop/event/shrine/rest/boss nodes (only COMBAT exercised), chapter-2 generator (placeholder clone), run-victory variant (boss-defeated → run_ended(true)) — left to a future test once boss-node wave content lands.
- **Sandbox can't run Godot syntax:** Paul to confirm `[e2e_smoke_test] PASS` line appears in Godot editor console on next `F5`. If the deck reshuffle or combat-2 signal disconnect quietly desyncs, the relevant assertion will surface (AS16 deck-grew-by-1, AS23 run_ended emit count). Phase 3 B2 parent item now has all 10 sub-items checked — B2 itself can tick once Paul has eyeballed PASS.

_Claude-Code git heartbeat 2026-05-12 -- pushed 3138aa1 "feat(engine): game_state expansion + map_test and more"_

## B3.0b — LoRA HF mirror scan (heartbeat 2026-05-12 14:17 UTC)

- **Brief:** Scan Hugging Face for trustworthy mirrors of the 10 (+1 optional) LoRAs locked in `pipeline_setup/loras_resolved.md`. Contingency-only — RunPod pods aren't UK-IP'd, so pod-side Civitai wget already works for the primary install path.
- **Method:** 2 broad web searches scanning for HF + LoRA-name + civitai cross-references. Did NOT chase 10 individual LoRA pages — diminishing returns vs the heartbeat budget, and per-LoRA HF re-scan only matters if a Civitai URL actually breaks.
- **Result:** 1 of 10 + 1 optional has a confirmed HF mirror:
  - **Dark Gothic Fantasy (293532)** → `https://huggingface.co/thwri/dark-gothic-fantasy-xl` (safetensors hosted, README cross-links the Civitai page).
- **Other 9 (+ optional Witch Style):** `Civitai-only — pod-side download`. ClassipeintXL is referenced in `EldritchAdam/SDXL_Eldritch_LoRAs` but that repo doesn't host the .safetensors. RalFinger-authored LoRAs (Mythical Forest) have other style-LoRA mirrors on HF (chrome / alien) but Mythical Forest itself is not yet up.
- **IP note:** Elden Ring Style is the most fragile slot — FromSoft-named LoRAs are DMCA-bait on HF specifically. If that Civitai URL ever 404s mid-batch, expect to re-resolve via author-feed (not by mirror-scan) or substitute with a generic decayed-knight LoRA.
- **Implication for the install bat / D-WORKFLOW scripts:** zero changes required. Pod-side wget of the Civitai URLs (existing plan) is the cheap path. The single HF fallback (Mourners slot #2) is documented in `loras_resolved.md` so a future heartbeat hitting a Civitai failure has a one-line swap ready.
- **Deferred:** per-LoRA HF scan (D-LORA-3-CONTINGENCY) only spawns if a pod-side Civitai download actually fails in B3.0a smoke-test or D-VALIDATE-1 batching. Don't pre-optimise — same rationale as `loras_resolved.md` §"Next heartbeat" list 4 (license audit also deferred).
- **Next:** B3.0b ticked. First-unchecked-non-gated remaining: B3.0a (Paul-runnable RunPod first-pod smoke test) which the prior heartbeat already partially validated end-to-end. T4 collection-screen UI mock unlocks once B2.10 smoke test ships.

Heartbeat 2026-05-13 04:17 — idle, awaiting Paul (B2 needs editor-PASS eyeball; B3.0a RunPod smoke test + B3.1 Apple Dev are Paul-runnable; B3.0c/B3.0d self-deferred until B3.0a result observed; D-VALIDATE-1 gated on B3.0a + ComfyUI confirm)

Heartbeat 2026-05-13 09:17 — idle, awaiting Paul (B3.0a manual RunPod smoke test gates B3.0c/B3.0d/D-VALIDATE-1; B2 parent awaits Godot dev-test eyeball; B3.1 Apple Dev registration)

Heartbeat 2026-05-13 15:23 — idle, awaiting Paul (3rd idle today; same gates: B3.0a Paul-runnable RunPod smoke test blocks B3.0c/B3.0d/D-VALIDATE-1; B2 parent awaits Godot dev-test eyeball PASS; B3.1 Apple Dev registration Paul-only)

Heartbeat 2026-05-14 04:17 — B3.0e art inventory pass: art owed: 216, done: 0 (216 specs across iron_penitents/ash_mourners/coven/last_legion/skinward_pact/warlords/enemies; zero production renders yet — gated on B3.0a RunPod smoke test). See `art_iterations/_owed.md` + `art_iterations/_inventory.json`.


_Claude-Code git heartbeat 2026-05-14 07:22 — pushed f9a3dcf "docs: heartbeat updates (2026-05-14)"_


---

## B3.0g — Warlord LoRA pack audit (heartbeat 2026-05-15 — Controller)

**Brief:** `IMAGE-GEN-SHOTLIST.md` §4 names per-Warlord LoRA packs (e.g. W1 uses `iron mask portrait @ 0.7` + `cathedral ruin @ 0.5`). These names were authored speculatively. Audit each one against `pipeline_setup/loras_resolved.md` — flag any that don't exist in the resolved manifest so the shotlist can be amended before generation runs.

**Method:** lexical match of the 13 unique LoRA short-names referenced across W1–W11 against the §"Quick reference table" of `loras_resolved.md`. No fuzzy match — if the warlord-pack name doesn't appear verbatim or as a documented alias in the resolved manifest, it's flagged.

### Findings — every Warlord-pack LoRA name is unresolved

| Warlord-pack name (from shotlist §4) | Used by | In `loras_resolved.md`? | Closest resolved substitute |
|---|---|---|---|
| `iron mask portrait` | W1, W6, W9 | **NO** | RPGNightmareXL (cap 0.4 for PEGI-12) — used as Penitents body-horror slot, NOT a mask-portrait specialist |
| `cathedral ruin` | W1 | **NO** | gothic cathedral interior (Mourners env slot, not Penitents) |
| `gothic court robes` | W2, W6 | **NO** | no clean substitute — Mourners style relies on prompt-side `pipeline_spec.md` §3.2 vocabulary |
| `catacomb interior` | W2 | **NO** | gothic cathedral interior is the nearest env, not catacomb-specific |
| `swamp witch` | W3 | **NO** | Swamp people SDXL (people, not witch-specific) + optional Old Witch Style `ral-wtchz` (best fit, currently OPTIONAL slot) |
| `bog mire interior` | W3 | **NO** | Mythical Forest Style SDXL (`ral-mytfrst`) — fungal-grove, not bog-mire |
| `military commander portrait` | W4, W7 | **NO** | ArmorSentinel medieval armor style (armor, not portrait-composition) |
| `industrial foundry` | W4, W7 | **NO** | no resolved env LoRA for foundry/industrial — prompt-side only |
| `druidic shaman` | W5, W9 | **NO** | Mythical Forest Style SDXL + Mythical Creatures (creatures, not shaman-specific) |
| `cinderwood forest` | W5 | **NO** | Mythical Forest Style SDXL (forest yes, cinder-burn no) |
| `funeral smoke` | W8 | **NO** | no resolved smoke/atmospheric LoRA — prompt-side only |
| `saint portrait halo` | W8 | **NO** | no resolved religious/halo LoRA — prompt-side only |
| `religious icon portrait` | W11 | **NO** | no resolved religious/icon LoRA — prompt-side only |

**Net:** 0 of 13 warlord-pack LoRA names are present in the resolved manifest. Every named pack is aspirational.

### Implication for D-VALIDATE-1 Stage A (5 Warlord anchors)

The 5 free Warlords (W1–W5) are the Stage-A validation anchors. With the audit above, the per-Warlord LoRA stacks fall into two paths:

- **Path A (cheap, prompt-only):** drop the per-Warlord LoRA list entirely. Use only the resolved faction-style stack from `pipeline_spec.md` §2.2 mapped via primary-faction (W1→iron_penitents stack, W2→ash_mourners stack, etc., per A-SPEC-6 spec convention). Subject specificity rides on the §4 prose. **Lowest risk; matches what `art_specs/warlords/` already assumes; first-pass output already known to be strong from the 2026-05-10 cloud smoke test.**

- **Path B (deferred, costly):** resolve each missing name to a real Civitai LoRA. ~13 lookups, ~30 min of search; some (`military commander portrait`, `funeral smoke`, `saint portrait halo`, `religious icon portrait`) have low odds of finding a clean match. Best case yields marginal quality uplift on Path-A baseline; worst case adds hours to validation and surfaces LoRA-load conflicts that the per-faction stack already balances.

**Recommendation: Path A.** Run Stage A with the resolved faction-style stack only, prompt-side specificity for each Warlord. If Paul rejects any of the 5 anchors as "off-brand", THEN spend the search budget on the specific missing slot for that Warlord — never speculatively. Same logic as `loras_resolved.md` §"Substitution rationale" + B3.0b's `Don't pre-optimise` line.

### Amendment proposed for IMAGE-GEN-SHOTLIST.md §4 (not yet applied)

Add a one-line note at the top of §4: *"Warlord-pack LoRA names below are aspirational. Per B3.0g audit 2026-05-15, none are resolved; D-VALIDATE-1 runs Path A — primary-faction stack from `loras_resolved.md` only, prompt-side specificity. Pack names retained as design intent for future deep-LoRA pass."*

Defer the actual amendment to next heartbeat — three of the §4 entries (W1, W2, W3) sit inside the Stage-A render queue, and rewriting the shotlist mid-validation risks confusing whoever orchestrates the pod run. Add the note in a separate edit pass once Stage A has produced its first anchors.

### W11 special-case carry-forward

W11's `religious icon portrait @ 0.6` notation is unresolved like the others, BUT the W11 art spec already flags `art_specs/warlords/w11_…` as the most PEGI-sensitive render in the whole project (rope-mark must read as iconography, not injury). The Path-A primary-faction-stack route maps W11 to Ash-Mourners (per A-SPEC-6 deviation note). That stack alone can drive the icon-portrait composition prompt-side. No new gating from this audit on W11 — its existing Paul-approval gate is unchanged.

### Open questions

1. **Path-A confirmation.** Paul to confirm Path A (resolved-stack-only) for Stage A is the right call before D-VALIDATE-1 fires. If yes, append the §4 amendment next heartbeat.
2. **Optional Witch Style for W3.** Old Witch Style (Civitai 262925, trigger `ral-wtchz`) is the closest LoRA to `swamp witch` semantically and sits in `loras_resolved.md` as the Coven faction's optional slot. Promote it to W3's default stack at 0.4? Default = leave optional, prompt-side only.
3. **Future `D-LORA-WARLORD` task.** Worth queueing a real-resolution pass for warlord-pack LoRAs after Stage A produces results, OR delete the §4 pack-name lines entirely once Path A is locked? Recommend: delete them — speculative names misled this audit, retention risks the same misread next time.


---

## B3.0f S5 + B3.0g + Persist-tag verification (heartbeat 2026-05-15 09:50 UK — Controller)

**Three heartbeat-sized passes in one Controller run** while the user was AFK:

### 1. B3.0f S5 — Skinward Pact sigil glyph authored

Wrote the full S5 entry into `art_specs/_sigils.md` replacing the prose stub. Subject: five-point antler-crown over a horizontal cord binding wrapping a single upright sapling stem with two small flanking leaves. Seed 200800. Bark-brown accent on bone-white. Same flat-vector-silhouette protocol as S1–S4 (prompt-only, no LoRA stack, sigil-specific composition tier `sigil_glyph`). PEGI-12-safe; explicit negative-prompt guard against real-world hunting/taxidermy/deer-trophy reference clusters added because SDXL's antler-tagged training data over-indexes there. Phase 2.11 sigil sub-track now complete: S1✅ S2✅ S3✅ S4✅ S5✅.

### 2. B3.0g — Warlord LoRA pack audit complete

See the dedicated B3.0g section above for the full table. Headline: 0 of 13 warlord-pack LoRA short-names in `IMAGE-GEN-SHOTLIST.md` §4 resolve against `pipeline_setup/loras_resolved.md`. Every per-Warlord LoRA name was aspirational. **Recommended Path A** — drop the per-Warlord LoRA list entirely for D-VALIDATE-1 Stage A and run on the resolved per-faction style stacks only (matches what `art_specs/warlords/` A-SPEC-6 already assumes). Path B (resolve the 13 missing slots) is deferred and only spawns if a Stage A anchor reads off-brand. Shotlist §4 amendment proposed but not applied this run — defer to after Stage A anchors land to avoid mid-validation confusion.

### 3. Persist tagging verification (5/5 candidates)

The M1 design note ("tagging happens at M2") was earlier interpreted as pending. Re-audited this run — Persist (Keyword.PERSIST = 14) is already present on all 5 candidate Ash-Mourners cards. Decoded keyword arrays:

- **M5 Last Censer-Bearer** (`game/data/cards/M5.tres` — TOP-LEVEL not subfolder; starter card, pre-Phase-2.6): `[DREAD, PERSIST]`
- **M12 Necrologist of the Catacombs** (`game/data/cards/ash_mourners/M12.tres`): `[RESURRECT, SUMMON, PERSIST]`
- **M20 Bone-Shroud Acolyte** (`game/data/cards/ash_mourners/M20.tres`): `[PERSIST]`
- **M22 Hollow Mortician** (`game/data/cards/ash_mourners/M22.tres`): `[PERSIST]`
- **M24 Choir of the Long Dead** (`game/data/cards/ash_mourners/M24.tres`): `[PERSIST]`

**Layout note for future heartbeats:** the 30 starter cards (P1–P9, M1–M11, C1–C10) live at `game/data/cards/` top level, NOT under per-faction subdirs. Phase 2.6 expansion (M12–M40 etc.) lives under `game/data/cards/ash_mourners/`. Don't grep only the subfolder when chasing a starter card — that's how Controller first thought M5 was missing this run. The hybrid layout is intentional (preserves the v0 → v1 expansion history) and shouldn't be flattened without a deliberate engine-load refactor.

### Implication for the M1 design contract

M1 design contract = closed. No further .tres edits required on the Persist axis. The 3 open Qs flagged in `keywords/persist_v0.md` (ATK floor, enemy-side Persist, UI display) still defer to Paul + B3.2 art pass respectively; none of them gate B2 / B3 / IMV-1.


---

## Phase 2.12.M5 — TAUNT keyword design v0 (heartbeat 2026-05-15 09:55 UK — Controller)

**Outputs (5 files touched):**
- `keywords/taunt_v0.md` — full keyword spec (one-line text, mechanics-locked block, 6 interactions vs SHIELD/PIERCE/FEAR/SMOKE/PERSIST/ROOT/HangingHour/Cleave/spells, faction allocation Last Legion primary + Iron Penitents secondary, engine wiring sketch, anti-P2W invariant, 4 open Qs).
- `game/src/data/enums.gd` — `GFEnums.Keyword.TAUNT` added (16th keyword; doc-comment points at spec).
- `faction_bible.md` — Last Legion §4 mechanical-role line now names TAUNT alongside RALLY + ECHO.
- `cards_last_legion_v1.md` — appended "TAUNT candidates" §: L7 / L11 / L18 / L33 (4 cards, 3R + 1U, 10% pool density).
- `cards_iron_penitents_v1.md` — appended "TAUNT candidates" §: P3 / P34 (2 cards, 1C + 1U, 5% pool density).

**Locked design:** in-lane targeting override, range-scoped (TAUNT body must be in range of the attacker, no free back-line shield), token-excluded (`is_token = true` cards cannot carry TAUNT), multiple-taunters defaults to lowest-tile (consistent with existing target rule), Cleave/AoE ignores TAUNT (collateral is the counter to formation), spell-targeting unaffected.

**Faction allocation:** Last Legion primary (4 cards = 10% of pool, 3R+1U, no C-tier TAUNT to keep formation decks rewarding rare-pulls); Iron Penitents secondary (2 cards = 5% pool, 1C+1U, thematic accent on the "zealot throws himself on the spike" fantasy); other 3 factions: no TAUNT at v1 — Mourners' Smoke/Dread already covers lane-control, Coven swarms by overload not by shielding, Skinward Big-Monsters self-soak via raw HP.

**.tres tagging deferred** to next engine-wiring heartbeat (Phase 2.12.E1 in the new backlog block). Same M1 → M2 pattern as PERSIST — keyword design isolates from engine work, .tres edits batch into a focused E1 run after Paul's keyword approval. 6 markdown-flagged candidate cards: L7 Sergeant-Smith Vikar, L11 Iron Watch Standard-Bearer, L18 Echo-Sergeant, L33 Banner-Captain of the Crowned Anvil, P3 Cathedral Brother, P34 Hammer-Curate.

**Engine wiring sketch (for E1):** extend `TurnEngine.choose_enemy_target(enemy, lane)` — before falling through to the existing lowest-tile rule, filter `lane.friendlies` for units where `card.has_keyword(TAUNT) AND not card.is_token AND tile_distance(enemy, unit) <= enemy.card.attack_range_tiles`. Non-empty filtered set → target lowest-tile member. No `UnitInstance` state changes — TAUNT is a static keyword check, always-on, no per-combat lock. Test coverage: 3 new assertions in `turn_engine_test.gd` (MELEE-in-range-redirect / MELEE-out-of-range-falls-through / Cleave-hits-both).

**Anti-P2W invariant:** TAUNT is gameplay-only, never cosmetic. Restated explicitly in spec §"Anti-P2W invariant" because TAUNT is high-impact and the IAP-temptation is real but would break PvP fairness if multiplayer is ever added.

**Open Qs queued for Paul (none block E1):** TAUNT visual cue (halo/banner/border-glow defer to B3.2); player-initiated TAUNT activation (always-on vs cost-1-mana toggle, default = always-on); cross-lane TAUNT at LEGENDARY tier (defer to post-IMV-1 boss-counter pass); TAUNT-pull vs Penance-trigger priority (recommend: TAUNT-soak first, then Penance fires on TAUNT-body death — lock at E1).

**Sandbox note:** GDScript syntax untestable in Cowork sandbox; enum addition is a single-token append after `PERSIST`, same risk profile as M1. Paul to confirm the project still parses in Godot. No engine-wide rename; existing keyword constants untouched.

**Phase 2.12 forward queue:** E1 (engine wiring), M6 (cross-faction synergy refinement v0.2 — TAUNT shifts 3 counter relationships), M7 (faction-internal sub-archetype cohesion check), M8 (event-card content v0 — 10 prompts for the EVENT NodeKind added in B2.9), M9 (shrine + rest content v0), M10 (Hanging Hour Chapter 1 boss). All queued in backlog.md.


_Claude-Code git heartbeat 2026-05-20 08:06 — pushed c88d1f4 "feat: showcase art for coven and iron_penitents …and more"_
_Claude-Code git heartbeat 2026-05-22 04:07 — pushed b7464c3 "feat: upgrade_trees_v0.md and more"_
_Claude-Code git heartbeat 2026-05-22 08:07 — pushed 0a59570 "docs: heartbeat updates (2026-05-22)"_
_Claude-Code git heartbeat 2026-05-26 16:07 — pushed db9e3e8 "feat: theme packs system + pvp/season design docs …and more"_
_Claude-Code git heartbeat 2026-05-26 20:07 — pushed 71e045d "feat: card and keyword design updates ...and more"_

_Claude-Code git heartbeat 2026-05-27 20:07 — pushed 72c5649 "feat: c8 AI/deck/playtest design v0 ...and more"_

## Cowork-Paul liaison turn (Cowork Claude, 2026-05-28)

Paul asked for "more fully-autonomous engine/data tasks the heartbeat can pull without my sign-off, instead of all-design-docs-all-the-time" + "communicate with cowork as much as possible". This turn delivered both:

**Authored — Phase 2.17 "Cowork-Paul liaison: autonomous queue" appended to `backlog.md`.** 9 items (AC1–AC9), all genuinely no-Paul-input, tagged by collision risk (`cold` / `engine-safe` / `engine-hot`) so the Controller hourly cycle can interleave without colliding with Phase 2.16 engine work. Pickable in any order; full files + acceptance criteria spec'd inline. Topics: data layout cleanup (AC1–AC2), doc-data drift reconciliation (AC3), `is_token` schema + TAUNT filter tightening (AC4), CardDatabase validation hook (AC5), audio stubs for IMV-1 (AC6), RNG determinism audit for PvP-1 (AC7), doc index for the now-50+ `*_v0.md` corpus (AC8), and a settle on the dormant `icon_path` field (AC9).

**Done live this turn — AC1 (P3 file relocation):**
- `game/data/cards/P3.tres` → `game/data/cards/iron_penitents/P3.tres` (faction = 0 = IRON_PENITENTS, belongs there)
- `game/assets/cards/cards/P3.webp` → `game/assets/cards/iron_penitents/P3.webp`
- `P3.tres` `art_path` updated to `res://assets/cards/iron_penitents/P3.webp`
- Stale `cards/cards/P3.webp.import` removed (Godot will regen the sidecar at next editor open)
- Verified: no code references the old path; CardDatabase (DB-1, queued) will index the new location identically when it lands

**Surfaced — broader data drift:** the P3 move uncovered that **29 root-level cards** (`C1–C10`, `M1–M11`, `P1–P9`) follow the same legacy "no faction subfolder" layout. Not duplicates — they're the canonical original cards from before the subfolder convention. Captured as AC2 with full spec; ~30 min Controller work, fully scoped, low collision risk. Recommend a Controller cycle pick that up before DB-1 ships so the deck-builder doesn't index 29 cards via the "cards" pseudo-faction.

**Collision avoidance taken this turn:** all engine `.gd` (turn_engine / combat / game_state / aura_dispatch / lane / card_play / turn_engine_test) are Controller-hot — I deliberately did NOT edit them this turn since cycle #22 just landed W41.E1. Anything in Phase 2.17 tagged `engine-hot` should be scheduled between Controller cycles, or queued for when Phase 2.16 quiesces.

**Note re: TAUNT E1 (Cowork-authored 2026-05-26):** Controller cycle (likely #17–#22) extended my SCENE D in `turn_engine_test.gd` by completing the D2 truncation + adding SCENE E (LIFESTEAL) + SCENE F (AURA dispatch). Per the W41.E1 done-note that work is now complete. AC4 above adds a Scene D4 (token-with-TAUNT-does-not-pull) as a defensive completeness assertion once `is_token` exists.

**PvP design doc** (`pvp_design_v0.md`) was authored 2026-05-26 by Cowork. Heartbeat appears to have independently produced `extended_game_modes_v0.md` covering similar ground from the design side. **Action queued:** Paul or a future Controller cycle should mark which is canonical and merge or cross-link to avoid future fork. (Not in Phase 2.17 — that's a Paul / Controller-judgement item, not a pure-autonomous one.)


## Ungate-cascade turn (Cowork Claude, 2026-05-28)

Paul's directive: "ungate anything I have gated right now — if there is no cost implication other than what's already allocated, you just smash through stuff." Cleared every doc-/data-level gate that didn't have a pod-cost or Civitai-network implication.

**Decisions taken, ranked by downstream unblock impact:**

1. **C7-v0.2 audit §8 Open Qs (all 7) resolved.** Appended `## 8b. Resolutions` section to `c7_v0_2_balance_audit.md` with per-Q rationale. Each endorsed the embedded recommendation. **Unblocks C8.D3b / D4 / D5** (gate on Q1 Option β cleared). Also generated two follow-on items (Phase 2.17 AC10 Fear-Caller text+engine from Q4; AC11 GDD pool-target from Q6).

2. **PvP reversal endorsed in `extended_game_modes_v0.md` §0.** "PvE only" lock from `gdd_v0.md` / `shop_economy_v0.md` / `monetisation_map.md` superseded by the limited-PvP-with-cosmetic-only-rewards model. Anti-P2W invariant is *stronger* in the new form than blanket prohibition. Cross-linked with `pvp_design_v0.md` (the architecture supplement; that doc updated to point at extended_game_modes as canon). **Unblocks PvP design+spec work**; engineering still gates on soft-launch validation per the ship-order tables. Follow-on: Phase 2.17 AC12 captures the three downstream doc edits (gdd/shop/monetisation) that need to land.

3. **W3 Cinderwood Stalker retagged to LIFESTEAL.** Phase 2.16 W3.E1-or-balance-call ticked. `W3.tres` keywords `[]→[16]`, effect_text → "Lifesteal." Buff is bounded (max_hp=3 cap on heal-per-hit); keyword consistency wins over bespoke effect_text. Full rationale + nerf-path-if-needed documented in `cards_skinward_pact_v1.md` Open-Q6.

4. **AC3 L11 doc-data drift fixed.** Live `L11.tres` is SPELL "Form Ranks", not the markdown's UNIT "Iron Watch Standard-Bearer". TAUNT can't apply to a SPELL — kept the data, struck-through the markdown row in `keywords/taunt_v0.md` with reconciliation note. Last Legion TAUNT count canonicalised to **3** (L7/L18/L33).

5. **AC9 `icon_path` resolution flipped from "drop the field" to "keep + document".** Investigation found `theme_pack_manager.gd` (lines 165, 176-177) AND `card_theme_treatment.gd` both consume `icon_path` — dropping it would break the theme-pack bundling pipeline. Added `art_direction.md §8` clarifying the three icon-related surfaces (`art_path` per-card portrait, `icon_path` per-card theme-pack thumb, `game/assets/icons/{kw_,stat_}*.svg` shared UI icons). Field stays empty per card until theme-pack UI needs the thumbs; populate-script outline noted for that future heartbeat.

**Items genuinely still Paul-only (will not auto-ungate):**

- `D-VALIDATE-1` Stage A LoRA anchors — Civitai 451 geo-block from Cowork's UK IP. Network-level, not a sign-off question. Paul or `.151` must run.
- Anything that would require live pod-spend without a pre-allocated budget. Phase 2.17 AC6 (audio stub sourcing) is pod-zero; AC7 (RNG audit) is pod-zero. AC10 wiring is engine-hot, not gated.

**Net effect on the autonomous queue:** Phase 2.16 has **zero open items** now (W3 was the last). Phase 2.15 (C8 chain) has D3b/D4/D5 ungated for the next Controller cycle. Phase 2.17 grew from AC1-AC9 to AC1-AC12; AC1, AC3, AC9 ticked done. Heartbeat has a clean runway.

**Coordinating with `extended_game_modes_v0.md` author:** that doc was Controller round 5 (2026-05-25), one day before my `pvp_design_v0.md`. Now cross-linked. If a future Controller cycle wants to merge the two, the natural shape is: extended_game_modes owns mode design + reward shape; pvp_design stays as the engineering-architecture appendix for Modes B/D. No code edits required for the dedup.


## Cowork status snapshot — 2026-05-28 end-of-session (Cowork Claude)

_Written so the next heartbeat / Controller hourly cycle can orient in 60s without reconstructing from git log + scattered notes. Read once; tick what's relevant._

### Where we are (one line)

Phase 2.16 engine-wiring is **fully closed** (W3.E1 last to tick); Phase 2.15 C8 sim chain is **ungated**; Phase 2.17 "Cowork-Paul liaison" queue is up (12 items, 3 done); engine UI build is mid-polish with the courier pushing the IMV-1 visual stream.

### What happened this session (most recent first)

1. **Ungate-cascade pass (2026-05-28).** Per Paul's "ungate anything I have gated, no cost implication beyond allocated" directive: closed 5 Paul-gated items + cascaded 6 follow-ons. See `## Ungate-cascade turn` block immediately above for the full per-decision rationale. Net: Phase 2.16 W3.E1 done; C7-v0.2 audit §8b adds Resolutions section endorsing Q1–Q7; extended_game_modes §0 PvP-reversal endorsed; cross-linked with pvp_design_v0.md; AC3 / AC9 in Phase 2.17 closed; AC10–AC12 queued as follow-ons.
2. **Phase 2.17 authored (2026-05-28).** New "Cowork-Paul liaison: autonomous queue" section in `backlog.md` — 12 items (AC1–AC12) tagged by collision risk (`cold` / `engine-safe` / `engine-hot`). AC1 (P3 file relocation) done live; AC3 (L11 drift) done; AC9 (icon_path) done. 9 items pickable.
3. **TAUNT E1 done in prior turn (2026-05-26).** Engine wired in `turn_engine.gd::_friendly_on_tile`, SCENE D added to `turn_engine_test.gd`, 5/6 cards tagged (L11 SKIPPED — it's a SPELL not a UNIT, now formally reconciled by AC3 above). Controller cycle later picked up SCENE D and extended with SCENE E (LIFESTEAL) + SCENE F (AURA).
4. **PvP design v0 doc authored (2026-05-26).** `pvp_design_v0.md` at root. Now cross-linked to `extended_game_modes_v0.md` as the architecture supplement (extended_game_modes = canon design; pvp_design = engineering shape for Modes B/D).

### Open backlog right now (full list, in priority order)

**Phase 2.17 — Cowork-Paul liaison (autonomous queue):**

- AC2. Consolidate 29 root-level cards (`C1–C10`, `M1–M11`, `P1–P9`) into faction subfolders. `engine-safe`. Pure data move + populate_art_path re-run. **Recommend pick this up next — closes the data-layout drift before DB-1 ships.**
- AC4. Add `is_token` Card schema field + tighten TAUNT filter. `engine-hot` (touches card.gd + turn_engine.gd).
- AC5. Wire `Card.validate()` into a dev test (depends on DB-1). `cold`.
- AC6. Source 3 SFX stubs for IMV-1 from freesound. `engine-hot` for wiring step.
- AC7. RNG determinism audit per `pvp_design_v0.md` §3.1. `cold`.
- AC8. Doc index for the *_v0 corpus. `cold`.
- AC10. Fear-Caller TAUNT-conditional `effect_text` rewrite + engine wiring (from C7-v0.2 §8b Q4). `engine-hot`.
- AC11. GDD canonical-pool-target update 40→40-45 (from C7-v0.2 §8b Q6). `cold`.
- AC12. GDD / shop_economy / monetisation_map PvP-canon updates (from extended_game_modes §0 endorsement). `cold`.

**Phase 2.15 — Playtest sim charter (C8 chain, now ungated):**

- C8.D3b. Sim runner Python game-loop module. Was gated on Q1; **ungated.** Pick up freely.
- C8.D4. Results doc — post-run only.
- C8.D5. Tuning recommendations — post-run only.

**Phase 2.16 — Deck-Builder screen (Paul-directed, original spec):**

- DB-1 → DB-7. CardDatabase autoload, deck persistence, deck_builder logic + UI, title wiring, test, polish. All `cold`/`engine-safe` — paint-by-numbers from the spec doc.

### Paul-only items (will NOT auto-resolve; do not waste cycles attempting)

- **D-VALIDATE-1 Stage A LoRA anchors.** Civitai 451 geo-blocks Cowork's UK IP. Paul or `.151` must run from a machine with Civitai access (or HF-mirror the 9 LoRAs). Network-level, not a sign-off.
- **IMV-1 playtest "feel" gate.** Only Paul can pass the 5-criteria gate in `internal_mvp_scope.md`. Engine is reportedly ready (per `HOW_TO_TEST.md` + the courier's recent UI-polish commits).
- **Godot editor import handoff.** The staged 203 card webps + 21 SVG icons need a one-time Godot 4.6 editor open to generate `.import` sidecars. Until then `card_view.gd`'s safe-fallback shows placeholder.

### Engine collision discipline (active surface)

Controller's hourly cycle (#17–#22 on 2026-05-27) is editing `game/src/runtime/{turn_engine,turn_engine_test,combat,game_state,aura_dispatch,lane,card_play,run_controller}.gd` actively. **Cowork edits in these files this turn: zero.** Phase 2.17 items tagged `engine-hot` should be scheduled between Controller cycles or queued for a Phase 2.16 lull.

### What I (Cowork Claude) am NOT working on

- Engine `.gd` edits (collision discipline). Controller's surface.
- Stage A LoRA anchors / any Civitai-dependent work (network blocked).
- DB-1 deck-builder build (queued for Controller; Paul-directed, well-spec'd).
- Faction sigil generation S2–S5 (heartbeat workstream per `_sigils.md`).

### Files modified this session (for courier visibility)

`backlog.md` (Phase 2.17 + W3.E1 / AC3 / AC9 ticks + AC10–AC12), `research_notes.md` (3 new sections: Cowork-Paul liaison turn / Ungate-cascade turn / this status snapshot), `c7_v0_2_balance_audit.md` (new §8b Resolutions), `c8_ai_policy_v0.md` (Q1 ungate lines), `extended_game_modes_v0.md` (§0 PvP-reversal endorsement), `pvp_design_v0.md` (cross-link to extended_game_modes), `cards_skinward_pact_v1.md` (Open-Q6 resolved), `keywords/taunt_v0.md` (L11 drift fix), `art_direction.md` (new §8 icon-path clarification), `game/data/cards/skinward_pact/W3.tres` (LIFESTEAL retag), P3 moved `game/data/cards/iron_penitents/P3.tres` + webp.

### Next-heartbeat suggested pick

Phase 2.17 **AC2** (consolidate 29 root cards). Pure data move, idempotent re-run of `populate_art_path.py` verifies, closes the data-layout drift surfaced when AC1's single-card move uncovered the broader pattern. Estimated effort: 1 Controller cycle. Removes the `game/assets/cards/cards/` pseudo-faction folder permanently before DB-1's CardDatabase indexes it as a real faction.


_Claude-Code git heartbeat 2026-06-30 18:34 — pushed c373a27 "feat(engine): add deck builder UI and tests"_

_Claude-Code git heartbeat 2026-07-08 — pushed d005e2c "feat(engine): add warlord select/deck builder uid files …and more"_
