# Canon Patches Applied — 2026-05-22

_Authored 2026-05-22 by Controller (round-4 readiness agent). Closes the loop on `CONFLICTS_RESOLVED_2026-05-22.md` (6 round-2 conflicts) + round-3 canon wobbles flagged by the marketing/balance agent. Every patch listed below has been **applied** to the source file; this document is the audit trail._

**Status:** v1. Applied in this session. Pre-commit (git unblock pending per `git_unblock_oneliner.md`). If Paul vetoes any decision in review, revert is per-file from this audit log.

---

## Summary

| # | Conflict / wobble | Files touched | Status |
|---|---|---|---|
| C1 | Run structure 16-node → 8-round linear | `gdd_v0.md`, `monetisation_map.md`, `HANDOVER.md` | ✅ Applied |
| C2 | Card pool 3-tier (IMV-1 120 / launch 205 / D30 300+) | `gdd_v0.md` (deprecation banner) | ✅ Applied (v0 deprecated) |
| C3 | Monetisation MVP rename → FCP / Soft / Post | `monetisation_map.md` | ✅ Applied |
| C4 | Warlord count 10 → 11 | `HANDOVER.md`, `warlords_v0.md` (deprecation banner) | ✅ Applied |
| C5 | Coven Mother Quag trigger "this turn" canonical | `archetypes_v0.md` | ✅ Applied (cards_coven_v1.md C6 was already correct) |
| C6 | Subscription "Ascendant Pact" in monetisation_map | `monetisation_map.md` §15 (new) | ✅ Applied |
| W1 | Wraith/Bog-Spawn/Brass-Hound caps (5/combat default) | `tokens_v0.md` §3.7 (new), `cards_coven_v1.md` C35 line | ✅ Applied |
| W2 | Vyrrun Self-Scourge × Hanging Hour cap (+6 ATK/combat) | `warlords_v1.md` line 14, `warlord_tiers_full.md` line 23 | ✅ Applied |
| W3 | W11 unlock trigger Ch3 vs Ch8 → Ch8 canonical | `bosses_chapters_2_3_v0.md` (2 lines), `bosses_chapters_4_to_8_v0.md` Q7 | ✅ Applied |

**Patch count:** 12 distinct file edits across 10 files.

---

## Patch detail — file → line range → before → after → reason

### C1 — Run structure (16-node → 8-round linear)

**File 1: `gdd_v0.md`** (lines 1-3)
- **Before:** No deprecation banner.
- **After:** Added banner: _"SUPERSEDED 2026-05-22 by `GDD_v1.md`. Kept for diff history only. v0 contains pre-Gallowfell run structure (16-node / 4-act) + 10-Warlord count + 30-card starter pool — all of which are no longer canonical. Read `GDD_v1.md` for the live design."_
- **Reason:** Conflict 1 — wholesale deprecate v0 rather than line-edit; `GDD_v1.md` is the new canonical doc per round-2.

**File 2: `monetisation_map.md`** (Mermaid diagram, line 13)
- **Before:** `D --> E[Run Map<br/>16 nodes / 4 acts]`
- **After:** `D --> E[Run Map<br/>8 sequential combats]`
- **Reason:** Conflict 1 — diagram-line update per `CONFLICTS_RESOLVED_2026-05-22.md` §"Conflict 1".

**File 3: `HANDOVER.md`** (line 9)
- **Before:** _"pushes through a 10-minute branching dungeon of TD-lane fights"_
- **After:** _"pushes through an 8-round linear gauntlet of TD-lane fights"_ + canon-patched footer note.
- **Reason:** Conflict 1 — HANDOVER §1 alignment to 8-round linear.

### C2 — Card pool (3-tier)

**File 1: `gdd_v0.md`** (lines 1-3, same edit as C1)
- v0 deprecation banner notes the "30-card starter pool" is no longer canonical. Three-tier model lives in `GDD_v1.md` §"Card pool" (already correct per round-2). No further file-line edit needed — the v0 doc dies as a whole.
- **Reason:** Conflict 2 closed by v0 deprecation rather than line surgery.

### C3 — Monetisation MVP coverage scope (FCP rename)

**File 1: `monetisation_map.md`** ("What's in MVP vs later" table, lines 196-211)
- **Before:** Two-column table headed `Surface | MVP (first internal build) | Post-soft-launch`.
- **After:** Three-column table headed `Surface | First Commercial Pass (FCP) | Soft launch | Post-soft-launch` + lock-naming preamble paragraph + new Ascendant Pact row.
- **Reason:** Conflict 3 — the "MVP" column is the FCP slice, not IMV-1. Header rename + 3-column split unambiguously surfaces the build-slice ladder.

### C4 — Warlord count (10 → 11)

**File 1: `HANDOVER.md`** (line 9 — touched in same edit as C1; line 126; line 177)
- **Before line 9:** _"Player picks one of 10 Warlords..."_
- **After line 9:** _"Player picks one of 11 Warlords (10 playable + 1 lore-locked W11 The Saint That Should Not Hang)..."_
- **Before line 126:** _"**10 Warlords:** 5 free at unlock..."_
- **After line 126:** _"**11 Warlords (10 playable + 1 lore-locked W11):** 5 free at unlock... + W11 The Saint That Should Not Hang (lore-locked secret, unlocks at Ch8 boss clear)..."_
- **Before line 177:** _"6. `warlords_v0.md` — 10 Warlord roster (5 free + 5 paid)"_
- **After line 177:** _"6. `warlords_v1.md` — 11 Warlord roster (10 playable + 1 lore-locked W11). Note: `warlords_v0.md` superseded — kept for diff history."_

**File 2: `warlords_v0.md`** (lines 1-3)
- **Before:** No deprecation banner; title block says _"G9 — Warlord roster v0 (10 characters)"_.
- **After:** Added banner: _"SUPERSEDED by `warlords_v1.md`. Canonical roster is 11 Warlords (10 playable + W11 The Saint That Should Not Hang, lore-locked). Kept for diff history only."_
- **Reason:** Conflict 4 — `warlords_v1.md` is canon (11 entries); v0 stays for diff context.

### C5 — Coven Mother Quag trigger ("this turn")

**File 1: `archetypes_v0.md`** (line 125)
- **Before:** _"**C6 Mother Quag, Twice-Drowned** (dual-archetype payoff — same card as C1 Poison-Stack; here serves the recycle half: every 3rd enemy killed returns as a friendly Bog-Spawn)."_
- **After:** _"**C6 Mother Quag, Twice-Drowned** (dual-archetype payoff — same card as C1 Poison-Stack; here serves the recycle half: every 3rd enemy killed **this turn** returns as a friendly Bog-Spawn). Canon: per-turn counter reset, per `faction_bible.md` v1. Patched 2026-05-22 (CANON_PATCHES_APPLIED)."_
- **Reason:** Conflict 5 — make "this turn" explicit (was ambiguous "every 3rd enemy killed" → could read as per-combat). Aligns to `faction_bible.md` v1 canonical doc.

**File 2 (verified, no edit needed): `cards_coven_v1.md`** line 43
- C6 line already reads _"Every 3rd enemy killed this turn returns to the lane as a friendly Bog-Spawn"_ — already canonical. Verified during patching, no edit applied.

**File 3 (verified, no edit needed): `faction_bible.md`** line 34
- Already canonical _"every 3rd enemy killed this turn"_. Verified, no edit applied.

**File 4 (engine — out of this session's scope): `game/data/cards/C6.tres`**
- TODO for the engine team / Claude Code heartbeat — verify `description` text matches and that a `trigger_scope` enum (per-turn) is set. Flagged in `pipeline_setup/` queue, not patched here (this session is design-doc-only).

### C6 — Subscription absent from monetisation_map

**File 1: `monetisation_map.md`** (new §15 + new row in "What's in MVP" table)
- **Before:** No section 15; no Ascendant Pact row.
- **After:** Added new §15 "Subscription — The Ascendant Pact" with full spec block (name, price, daily bonus, XP mult, BP tiers, cosmetic, cancellation, anti-P2W check, FOMO check, MVP coverage). Added row to "What's in MVP" table: `Ascendant Pact subscription | — | — | ✅ (patch 1.2, post-D14 milestone — see §15)`. Added new Q5 to Open Questions: confirm patch-1.2 slot or earlier on D7 conversion signal.
- **Reason:** Conflict 6 — `shop_economy_v0.md` §4.6 already has the catalogue side; monetisation_map needed the player-journey side as a first-class surface. Patch 1.2 (post-D14) is the canonical ship slot.

**File 2 (verified, no edit needed): `shop_economy_v0.md`** §4.6
- Round-2 said it was added; verified line 192 _"### 4.6 Subscription — Ascendant Pact (post-IMV-2)"_ exists with full catalogue spec. Confirmed; no edit applied.

### W1 — Wraith / Bog-Spawn / Brass-Hound caps (round-3 wobble)

**File 1: `tokens_v0.md`** (new §3.7 inserted before §3.6)
- **Before:** No global per-combat token cap rule. Only ad-hoc caps on specific cards (C40 "Cap 3 per combat", C42 "3 charges").
- **After:** Added new §3.7 "Per-combat token cap": **5 active instances per side per combat, default global cap, per token type**. Per-token-type cap table covers TKN-1 Bog-Spawn, TKN-5 Wolf, TKN-7 Brass Hound, Drowned-Choir Wraith, TKN-3 Withered Servant, TKN-6 Banner-Token. Added engine field `Card.token_spawn_cap_per_combat: int = 5` for per-card overrides. Audit comment to engine: silent fizzle + telemetry signal, no UI feedback on cap hit.
- **Reason:** Round-3 marketing/balance agent flagged unbounded swarm risk via Echo + Recall + Persist + token-spam loops. 5 is the design-fantasy ceiling that still resolves Brood-Mother (3) + Brood-Mother-via-Echo (3) cleanly = 6 → 5 caps at 5, one summon fizzles silently.

**File 2: `cards_coven_v1.md`** (line 101 — C35 Drown-Choir)
- **Before:** _"Summon a 2/2 Drowned-Choir Wraith with Poison-1 on death."_
- **After:** _"Summon a 2/2 Drowned-Choir Wraith with Poison-1 on death. Cap: max 5 Drowned-Choir Wraiths in play per combat (per CANON_PATCHES_APPLIED_2026-05-22 token-cap audit — prevents unbounded swarm via Echo + recast loops)."_
- **Reason:** C35 is the highest-recursion-risk Wraith spawner; per-card audit comment surfaces the global rule on the spec doc.

### W2 — Vyrrun Self-Scourge × Hanging Hour (round-3 wobble)

**File 1: `warlords_v1.md`** (line 14)
- **Before:** _"Signature spell — Self-Scourge: Deal 3 damage to your strongest unit. All your units gain +2 ATK this wave."_
- **After:** _"Signature spell — Self-Scourge: Deal 3 damage to your strongest unit. All your units gain +2 ATK this wave. Per-combat ATK-buff cap: +6 ATK total from Self-Scourge stacking (round-3 wobble fix: caps Hanging Hour doubled-buff interaction at 3 meaningful casts per combat. Subsequent casts still resolve the self-damage but no further ATK buff applies. Card balance audit §19 surfaced this risk.)"_

**File 2: `warlord_tiers_full.md`** (line 23)
- **Before:** _"Default sig spell — Self-Scourge (3 mana): Deal 3 dmg to your strongest unit. All your units gain +2 ATK this wave."_
- **After:** _"Default sig spell — Self-Scourge (3 mana): ... gain +2 ATK this wave. Per-combat cap: +6 ATK total from Self-Scourge stacking (CANON_PATCHES_APPLIED_2026-05-22 — Hanging Hour doubled-buff interaction wobble fix; subsequent casts still self-damage but the ATK component fizzles)."_
- **Reason:** Round-3 card balance audit §19 flagged "double-double on a Warlord signature means a single Hanging-Hour Self-Scourge = +4 ATK wave-wide". Stacked Self-Scourge across waves with HH active was unbounded. +6 ATK cap = 3 effective casts (or 1 Hanging-Hour cast giving +4 + 1 more for +6 = 2 effective casts at HH). Holds the burst design fantasy while killing the unbounded tail.

### W3 — W11 unlock trigger (Ch3 vs Ch8 → Ch8 canonical)

**File 1: `bosses_chapters_2_3_v0.md`** (line 174)
- **Before:** _"W11 unlock trigger: if this is the player's 10th unique-Warlord run-victory, the W11 'Saint That Should Not Hang' unlock fires here (per `warlords_v1.md` §11)"_
- **After:** _"W11 unlock trigger: MOVED to Ch8 boss clear — per CANON_PATCHES_APPLIED_2026-05-22 conflict resolution. W11 The Saint That Should Not Hang now unlocks only on Chapter 8 boss clear (full campaign completion across all 10 Warlords). See `bosses_chapters_4_to_8_v0.md` §6.8. Ch3 Saint That Hangs clear is now a progress milestone only (counts toward '10 of 10 Warlords clear' tracker)."_

**File 2: `bosses_chapters_2_3_v0.md`** (line 344, Q4)
- **Before:** _"4. W11 unlock condition. Per `warlords_v1.md` open Q2, current rule = 'beat campaign with all 10 others'. Add: triggered specifically at Ch3 boss victory. Confirm."_
- **After:** _"4. W11 unlock condition. RESOLVED 2026-05-22 (CANON_PATCHES_APPLIED): W11 unlock trigger moved from Ch3 boss clear → Ch8 boss clear (per Controller recommendation in `bosses_chapters_4_to_8_v0.md` §6.8 / Q7). Per-Warlord progress accumulator counts each chapter clear toward '10 of 10 Warlords campaign-complete' achievement; final unlock fires at Ch8 boss clear once that achievement is satisfied."_

**File 3: `bosses_chapters_4_to_8_v0.md`** (line 529, Q7)
- **Before:** _"7. W11 unlock trigger. Resolve conflict between `bosses_chapters_2_3_v0.md` §3.7 ('triggers at Ch3 boss') and §6.8 ('triggers at Ch8 boss'). Recommend: trigger at Ch8 boss (proper campaign clear), with a '10 of 10 progress' achievement visible all the way through. Confirm."_
- **After:** _"7. W11 unlock trigger. RESOLVED 2026-05-22 (CANON_PATCHES_APPLIED): Ch8 boss clear is canonical, with a '10 of 10 Warlord campaign clears' achievement visible all the way through. Ch3 reference in `bosses_chapters_2_3_v0.md` §3.7 patched to 'progress milestone only'."_
- **Reason:** Ch8 is the proper campaign clear gate. Ch3 was a halfway-house unlock that risked the W11 reveal happening before half the chapters were played. Ch8 retains the "the curse only reveals itself once you've walked the whole town" narrative beat.

---

## Files NOT patched in this session (flagged for engine / future heartbeats)

| File | Reason | Owner |
|---|---|---|
| `game/data/cards/C6.tres` | Engine `.tres` edit — needs Godot import + verification | Claude Code heartbeat / `.151` |
| `game/data/cards/coven/C35.tres` (if exists) | Same as above — cap field needs engine wiring | Claude Code heartbeat / `.151` |
| `game/data/cards/iron_penitents/<vyrrun signature spell>.tres` | Self-Scourge cap engine field | Claude Code heartbeat / `.151` |
| `game/src/data/card.gd` | Add `token_spawn_cap_per_combat: int = 5` exported field | Claude Code heartbeat / `.151` |
| `game/src/runtime/combat.gd` | Implement token cap check in `spawn_token()` | Claude Code heartbeat / `.151` |

**FILE_MISSING checks:**
- `monetisation_map.md` — exists ✅
- `shop_economy_v0.md` §14 — already exists at §4.6 (Round-2 numbering was wrong; doc has subsection 4.6 not §14, but the spec is there)
- All other files referenced in `CONFLICTS_RESOLVED_2026-05-22.md` exist on disk

---

## Verification protocol — how to confirm the patches are live

```
# Run from "C:\Users\Paul McCann\OneDrive - R.T. Keedwell Group\Documents\Claude\Projects\Gaming app"

# C1: 8-round linear in monetisation_map.md
grep "8 sequential combats" monetisation_map.md   # should match

# C3: FCP column rename
grep "First Commercial Pass" monetisation_map.md  # should match

# C4: HANDOVER says 11 Warlords
grep "11 Warlords" HANDOVER.md                    # 2 matches expected

# C5: archetypes Mother Quag has "this turn"
grep "every 3rd enemy killed \*\*this turn\*\*" archetypes_v0.md  # 1 match

# C6: Ascendant Pact in monetisation_map.md §15
grep "## 15. Subscription — The Ascendant Pact" monetisation_map.md  # 1 match

# W1: tokens_v0.md §3.7 token cap
grep "### 3.7 Per-combat token cap" tokens_v0.md  # 1 match

# W2: Vyrrun cap
grep "Per-combat cap: +6 ATK" warlords_v1.md      # 1 match

# W3: W11 → Ch8
grep -l "MOVED to Ch8 boss clear" bosses_chapters_2_3_v0.md  # match
grep -l "Ch8 boss clear is canonical" bosses_chapters_4_to_8_v0.md  # match
```

All 9 greps should return matches when run from the repo root.

---

## Cross-references

- `CONFLICTS_RESOLVED_2026-05-22.md` — round-2 conflict resolution (source of patches 1-6)
- `card_balance_audit_v0.md` §19 — round-3 Self-Scourge / Hanging Hour wobble
- `GDD_v1.md` — canonical 8-round linear, 11-Warlord, 3-tier-pool design doc
- `faction_bible.md` v1 — canonical Mother Quag wording
- `warlords_v1.md` — canonical 11-Warlord roster
- `tokens_v0.md` — token registry + new per-combat cap
- `git_unblock_oneliner.md` — when git unlocks, commit these patches with message:
  `chore(canon): apply CANON_PATCHES_APPLIED_2026-05-22 — close 6 conflicts + 3 wobbles`

— Controller round-4, 2026-05-22
