# Conflicts Resolved — 2026-05-22

_Authored 2026-05-22 by Controller (round 2 design agent). Resolves the 6 conflicts flagged in `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` §"CONFLICTS found". For each conflict: the conflict statement, the canonical answer Paul is taking forward, and the list of file patches needed to bring the codebase in line. **Patches are not applied in this doc** — they are listed as a worklist for the next heartbeat / Claude Code._

**Status:** v1. Decisions are "controller's resolution" — Paul has blanket-approved this class of housekeeping (see `feedback_act_then_report.md`). If Paul rejects any answer in review, the patches are not yet shipped, so reverting is cheap._

---

## Summary table

| # | Conflict | Canonical answer | Files to patch | Risk |
|---|---|---|---|---|
| 1 | Run structure: 16-node/4-act vs 8-round linear | **8-round linear** (most recent + locked in `2026-05-18_gallowfell_balance.md`) | `gdd_v0.md` (superseded by `GDD_v1.md`), `monetisation_map.md` §journey-diagram | low |
| 2 | Card pool size: "300+ by D30" vs "120 cards in IMV-1" | **Two-track:** IMV-1 = ~120 / launch = ~205 / D30 target = ~300 | `gdd_v0.md` §"Card types", `GDD_v1.md` (new), `internal_mvp_scope.md` (already correct, reaffirmed) | low |
| 3 | Monetisation MVP coverage scope | **IMV-1 = IAP buttons stubbed only; first-commercial-pass (post-IMV-1) = `monetisation_map.md` §"MVP" column lit up** | `monetisation_map.md` §"What's in MVP vs later" header line, `internal_mvp_scope.md` (reaffirmed) | low |
| 4 | Warlord count: 10 vs 11 | **11 (per `warlords_v1.md`)** — W11 lore-locked included in the canonical count | `HANDOVER.md` §5 + §1 "10 Warlords" → "11 Warlords (10 playable + 1 lore-locked W11)" | low |
| 5 | Coven flagship Mother Quag trigger timing | **"Every 3rd enemy killed this turn"** (per `faction_bible.md` v1, the canonical doc) | `cards_coven_v1.md` C6 (if wording diverged), `archetypes_v0.md` Coven section (if wording diverged), `game/data/cards/C6.tres` description field | low — mechanical implication: per-turn reset vs per-combat reset matters for Persist + Hanging Hour interactions |
| 6 | Subscription absent from `monetisation_map.md` | **Add "Ascendant Pact" subscription as `shop_economy_v0.md` §14** (placeholder § already named) + add §15 to `monetisation_map.md` | `monetisation_map.md` new §15, `shop_economy_v0.md` new §14 | low |

---

## Conflict 1 — Run structure (16-node/4-act vs 8-round linear)

### Statement
- `gdd_v0.md` §"Core loop" and §"Run structure" describes a **16-node, 4-act branching map** with Slay-the-Spire pacing ("Boss every 4 nodes").
- `2026-05-18_gallowfell_balance.md` §"Run structure (locked for IMV-1)" describes **8 sequential combats, no branching**.
- `monetisation_map.md` Mermaid diagram line E `[Run Map\n16 nodes / 4 acts]` still shows 16-node.
- `research_notes.md` confirms IMV-1 prototype only ships 5 nodes for B2.9 smoke — explicitly minimal pending UI work.

### Canonical answer
**8-round linear is canonical for IMV-1 + IMV-2 + soft-launch.** Branching map is deferred to v1.1 patch (post-soft-launch). Reasons:
1. Balance doc is the most recent, most thoroughly tuned document; numbers exist for an 8-round run, not a 16-node run.
2. Engine has shipped against linear (`map_generator.gd` was REPLACED with linear gauntlet on 2026-05-18 per `2026-05-18_gallowfell_balance.md` §"Files added/changed").
3. The 8 rounds map cleanly to the 8 chapter biomes in `lore_gallowfell.md` (5 faction biomes + Foundry-extended + Gallows-Hill-approach + Gallows-Hill-summit), giving a narrative reason for the linear shape.
4. Branching map = "v1.1 'Forked Roads of Gallowfell' patch" — keeps a roadmap milestone for content-pivot marketing later.

### Patches required
| File | Section | Patch |
|---|---|---|
| `gdd_v0.md` | §"Run structure" | **Whole section deprecated** — replaced by `GDD_v1.md` §"Run structure". Add deprecation banner at top of `gdd_v0.md`: _"Superseded 2026-05-22 by GDD_v1.md."_ |
| `gdd_v0.md` | §"Core loop" step 3-4 | Same — superseded by GDD v1 |
| `monetisation_map.md` | line E in Mermaid block | `E[Run Map\n16 nodes / 4 acts]` → `E[Run Map\n8 sequential combats]` |
| `monetisation_map.md` | (no other body change needed — surfaces are kind-driven not node-count-driven) | — |

### Implications
- The "Boss every 4 nodes" line in `gdd_v0.md` is dead. New cadence is **1 boss per run** (round 8) for chapters 1-3 of the published metagame. Chapters 4-8 each have their own 8-round run with their own boss — see `bosses_chapters_4_to_8_v0.md`.
- Ascension levels A1-A20 still apply but per-Warlord, not per-act.

---

## Conflict 2 — Card pool size

### Statement
- `gdd_v0.md` §"Card types": _"starter pool: 30 cards across 3 factions; full pool target: 300+ by D30"_.
- `internal_mvp_scope.md`: _"Card pools authored = ~120 cards total (P1-P40, M1-M40, C1-C40)... Last Legion (L1-L40) and Skinward Pact (W1-W40) stay authored on disk, hidden"_.
- True on-disk count today (per inventory): ~200 cards (5 × 40) + P41 + C41 + C42 = **~203 launch cards** + relics.

### Canonical answer
**Three numbers, three meanings, none of them conflict if labelled correctly:**

| Slice | Card count | Definition |
|---|---|---|
| IMV-1 (Internal MVP) | ~120 draftable | 3 factions × 40 cards. L*/W* on disk but `is_draftable=false`. |
| Launch (soft-launch + v1.0) | ~205 draftable | All 5 factions × 40 cards + new specials (P41, C41, C42) + relics |
| D30 stretch target | 300+ | v1.x expansion. Includes alt-arts as cosmetic-only versions — not new cards. |

The "300+ by D30" target is **content-pipeline goal**, not a balance contract. Soft-launch ships ~205. Whether we hit 300 by D30 depends on whether v1.1 patch ships expansion factions or just polish.

### Patches required
| File | Patch |
|---|---|
| `gdd_v0.md` §"Card types" | Replace `(starter pool: 30 cards across 3 factions; full pool target: 300+ by D30)` with `(IMV-1 starter pool: ~120 cards / 3 factions; soft-launch pool: ~205 cards / 5 factions; D30 content target: 300+)`. Note: this line dies entirely when `gdd_v0.md` is fully superseded by `GDD_v1.md`. |
| `GDD_v1.md` §"Card pool" | Already authored against the three-tier model. |
| `internal_mvp_scope.md` | Reaffirmed — no patch needed. |

---

## Conflict 3 — Monetisation MVP coverage scope

### Statement
- `monetisation_map.md` §"What's in MVP" lists "Run-shop (gold sink) ✅" and "Gold IAP (single SKU) ✅" as MVP.
- `internal_mvp_scope.md` says: _"Monetisation: stubbed only — IAP buttons present, no real SDK"_.

### Canonical answer
**These are not in conflict — they are two different build slices.** Two "MVPs" exist in this project and have been getting confused. Lock the names:

| Build slice | What's live | Source of truth |
|---|---|---|
| **IMV-1 (Internal MVP)** | Playable run, no real IAP wiring. IAP buttons exist but click → console.log placeholder. In-run gold-shop ✅ (engine NodeKind SHOP, no stock data yet). | `internal_mvp_scope.md` |
| **First-commercial-pass (FCP)** | Post-IMV-1, pre-soft-launch. Real SDK wired (Google Play Billing + StoreKit). Single SKU live. In-run shop fully stocked. Daily chest ad-gated. | `monetisation_map.md` §"What's in MVP" |
| **Soft-launch build** | FCP + battle pass + gacha + starter bundle + first cosmetics. | `monetisation_map.md` §"Post-soft-launch" half |

The `monetisation_map.md` "MVP" column is the FCP slice, not the IMV-1 slice. Recommend rename to remove ambiguity.

### Patches required
| File | Patch |
|---|---|
| `monetisation_map.md` §"What's in MVP vs later" | Rename column header `MVP (first internal build)` → `First Commercial Pass (FCP)`. Add explanatory note: _"FCP = post-IMV-1, pre-soft-launch slice. IMV-1 ships only stubbed IAP buttons per `internal_mvp_scope.md`."_ |
| `internal_mvp_scope.md` §"Monetisation" line | Reaffirmed — no patch needed but add cross-link: _"FCP slice (first SDK wiring) is the next monetisation milestone — see `monetisation_map.md` §'First Commercial Pass'"_. |

---

## Conflict 4 — Warlord count

### Statement
- `warlords_v0.md` = 10 Warlords.
- `warlords_v1.md` = **11** (10 + W11 lore-locked "The Saint That Should Not Hang").
- `HANDOVER.md` §5 says "10 Warlords" + repeats in §1.
- `gdd_v0.md` says "5 free + 5 paid + 1 lore-locked secret (Warlord 11)" — actually consistent with 11, but says "10 Warlords" elsewhere.

### Canonical answer
**11 Warlords.** `warlords_v1.md` wins (most recent + incorporates `lore_gallowfell.md`'s Innocent Saint concept).

Note: count framing matters. Two valid framings:
- _"11 Warlords"_ — emphasises W11 exists. Used in design docs, GDD v1, lore.
- _"10 playable Warlords + 1 lore-locked"_ — emphasises grindable count for marketing. Used in store copy.

Use both depending on audience. Don't mix mid-doc.

### Patches required
| File | Patch |
|---|---|
| `HANDOVER.md` §1 | `10 Warlords` → `11 Warlords (10 playable + 1 lore-locked W11)` |
| `HANDOVER.md` §5 | Same |
| `gdd_v0.md` | Deprecated — replaced by GDD v1 anyway |
| `warlords_v0.md` | Add deprecation banner at top: _"Superseded by `warlords_v1.md`. Kept for diff history only."_ |

---

## Conflict 5 — Coven flagship (Mother Quag) trigger timing

### Statement
- `faction_bible.md` v1 §3: _"Mother Quag, Thirteen-Times-Drowned — 5-cost, every 3rd enemy killed this turn re-enters lane as a Bog-Spawn for you."_
- `archetypes_v0.md` and `cards_coven_v1.md` C6 may say _"every 3 enemy kills this combat"_ — flagged in the inventory but not verified.
- Implication: **per-turn reset vs per-combat reset** is a real mechanical difference, especially around Hanging Hour and Persist interactions.

### Canonical answer
**"Every 3rd enemy killed this turn"** wins (per `faction_bible.md` v1, the canonical Coven canon doc).

Rationale:
1. `faction_bible.md` is the named source-of-truth doc.
2. Per-turn reset is the more interesting mechanic — it rewards burst-kill turns, which is on-theme for swarm-Coven.
3. Per-combat reset would interact with PERSIST in a way that creates infinite Bog-Spawn loops (each Persist counts as a death — accumulates 3 quickly — infinite tokens).
4. Engine-side, per-turn reset is just a counter reset on `combat.turn_resolved`, trivial.

### Patches required
| File | Patch |
|---|---|
| `cards_coven_v1.md` C6 | Verify wording; if currently `this combat` → change to `this turn`. |
| `archetypes_v0.md` Coven section | Same verification + edit. |
| `game/data/cards/C6.tres` | Verify the `description` / `ability_text` field; align to "this turn". |
| `game/data/cards/C6.tres` | If a `trigger_scope` enum field exists (per-turn vs per-combat), set to `per_turn`. If not, engine handler must reset counter on `combat.turn_resolved`. |
| `keywords/` | No new keyword spec needed — this is a card-level effect, not a global keyword. |

### Implications
- Persist interaction: a Persisted unit dying then re-Persisting counts as 2 deaths in the same combat but only 1 death "this turn" if the Persist trigger resolves on next turn. So PERSIST + Coven = 1 Bog-Spawn per Persist, not 3. Clean.
- Hanging Hour interaction: HH-driven death waves on turn 5 happen all in one turn → if 3+ enemies die at HH, the Bog-Spawn triggers fire normally. Burst-favouring is on-tone.

---

## Conflict 6 — Subscription absent from monetisation_map

### Statement
- `monetisation_map.md` does **not** list the "Ascendant Pact" subscription anywhere.
- `HANDOVER.md` §5 says: _"Subscription 'Ascendant Pact' £4.99/mo"_.
- `shop_economy_v0.md` does not yet have a §14 "Subscription" section either.

### Canonical answer
**Add subscription as a first-class monetisation surface.** Place it in both `monetisation_map.md` (player journey view) and `shop_economy_v0.md` (catalogue view). Soft-launch decision: subscription ships in **first-commercial-pass**, not soft-launch (too much wallet-state plumbing for tight launch scope).

**Spec (locking the basics here so the patch is shovel-ready):**

| Field | Value |
|---|---|
| Name | The Ascendant Pact |
| Price | £4.99/mo (recurring; auto-renew per platform conventions) |
| Daily login bonus | +50 gems / day |
| Daily run-XP multiplier | ×1.25 on the first run completed each day |
| BP-tier advancement | +5 free tiers per month |
| Exclusive cosmetic | 1 "Ascendant-only" treatment unlocked monthly (rotating per faction) |
| Cancellation | per-platform; access continues to end of billing period |
| Pay-to-win check | All multipliers feed into the ×3.0 cap registry per `monetisation_map.md` §13. No power-creep. |
| FOMO check | Cosmetic-only rewards. No card-power locked behind it. |
| MVP coverage | Not in IMV-1. Not in FCP. **Ships at soft-launch end (post-D14 success milestone) or v1.1.** |

### Patches required
| File | Patch |
|---|---|
| `monetisation_map.md` | Add §15 "Subscription — The Ascendant Pact" with the spec above. Update player-journey Mermaid diagram with `B -->|$ ASCENDANT PACT subscription` arrow. |
| `monetisation_map.md` §"What's in MVP vs later" table | Add row `Ascendant Pact subscription` with `— / ✅ post-D14 milestone`. |
| `shop_economy_v0.md` | Add §14 "Subscription — The Ascendant Pact". Mirror catalogue side of the spec. |
| `HANDOVER.md` §5 | Reaffirmed — no patch needed. |

---

## Worklist (apply when git is unlocked)

In order:

1. Apply §"Conflict 1" patches (`monetisation_map.md` Mermaid line E + deprecation banner on `gdd_v0.md`).
2. Apply §"Conflict 2" patches (`gdd_v0.md` card-pool line, if `gdd_v0.md` is not yet superseded).
3. Apply §"Conflict 3" patches (`monetisation_map.md` column rename + `internal_mvp_scope.md` cross-link).
4. Apply §"Conflict 4" patches (`HANDOVER.md` Warlord count + `warlords_v0.md` deprecation banner).
5. Apply §"Conflict 5" patches (`cards_coven_v1.md` C6 + `archetypes_v0.md` Coven + `C6.tres`).
6. Apply §"Conflict 6" patches (new §15 in `monetisation_map.md` + new §14 in `shop_economy_v0.md`).

Estimated total patch work: ~1 hour for a Claude Code heartbeat, half of which is verification reads.

---

## Cross-references

- `GALLOWFELL_BACKLOG_INVENTORY_2026-05-21.md` §"CONFLICTS found" — original flagging.
- `GDD_v1.md` (new, this session) — supersedes `gdd_v0.md` and locks 8-round canon.
- `2026-05-18_gallowfell_balance.md` — balance doc that locked the 8-round structure.
- `warlords_v1.md` — canonical Warlord roster (11 entries).
- `faction_bible.md` v1 — canonical faction doc.
- `monetisation_map.md` — monetisation player-journey diagram.
- `shop_economy_v0.md` — shop catalogue + currency model.
- `internal_mvp_scope.md` — IMV-1 lock.

— Controller, 2026-05-22
