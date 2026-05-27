# Card Balance Audit v0 — The Curse of Gallowfell

_Authored 2026-05-22 by Controller (round 3). Plans the **balance-audit method** for the ~205-card launch pool, defines the heuristic score, names the per-card capture columns, and ships the **top-20 flagged review queue** based on v1 docs. Closes inventory item CARD-4. Companion to `cards_*_v1.md` (5 faction pools) and `archetypes_v0.md` (anti-synergy grid)._

**Status:** v0 plan. The spreadsheet is the deliverable. This doc is the spec the spreadsheet implements + the seed review queue.

---

## 1. Method

The audit is a **single-source xlsx workbook** that ingests every card from the five `cards_*_v1.md` files plus the Warlord-attached signature cards from `warlords_v1.md`. The workbook computes a heuristic balance score per card, flags outliers against per-faction means, and produces a ranked review queue for the soft-launch playtest cohort.

The workbook is **not a balance model**. It is a **triage tool**. It tells us which cards to playtest in week 1 of soft-launch. Real balance comes from soft-launch telemetry + Ascension-level break analysis. The heuristic exists so we don't waste week-1 playtest hours on cards that are obviously fine.

**Workbook location:** `Gaming app/card_balance_audit_v0.xlsx` (to be authored by Controller round 4 or by skill xlsx invocation. This doc specs the schema + algorithm; the .xlsx is the artefact).

**Data ingest:** copy-paste from the five `cards_*_v1.md` markdown tables. ~205 rows + 11 Warlord signatures = ~216 cards. One row per card per archetype assignment (a card splashing two archetypes gets two rows for archetype-fit scoring, then merged for the flag).

---

## 2. Per-card columns

| Column | Type | Source | Notes |
|---|---|---|---|
| `id` | text | card .md table (e.g. P15, M5, C6, L12, S20) | Primary key |
| `name` | text | card .md | "Hierarch of the Open Wound" |
| `faction` | enum | card filename | one of {Penitents, Mourners, Coven, Legion, Skinward} |
| `archetype` | enum | `archetypes_v0.md` | 15 archetypes total, 3 per faction |
| `card_type` | enum | card .md row position | {Unit, Spell, Trap, Relic, Special} |
| `cost` | int | card .md | 0–8 |
| `hp` | int | card .md (unit only) | blank for spell/trap/relic |
| `atk` | int | card .md (unit only) | blank for spell/trap/relic |
| `range` | enum | card .md (unit only) | {M, S, L} |
| `cd` | int | card .md (unit only) | cooldown turns |
| `rarity` | enum | card .md | {C, U, R} |
| `primary_effect` | text | card .md | full effect text |
| `keyword_tags` | list | extracted | comma-separated, e.g. "Bleed,Cleave,Penance" |
| `text_length_chars` | int | calc | character count of `primary_effect` |
| `complexity_score` | int 1–5 | designer judgement | 1 = vanilla, 5 = nested triggers + state machine |
| `obvious_power_score` | int 1–5 | designer judgement | 1 = clearly weak, 5 = clearly snap-keep |
| `known_interactions` | list | designer + grep | other card IDs this references / synergises with |
| `base_stat_index` | float | calc | (hp + atk) ÷ cost for units; (effect_count × multiplier) ÷ cost for spells |
| `faction_archetype_fit` | int 1–5 | designer + `archetypes_v0.md` | how clearly this card belongs to its named archetype |
| `flag_score` | float | calc | weighted formula, see §3 |
| `flag_severity` | enum | calc | {clear, watch, flag, fix-now} |
| `notes_2026_05_22` | text | seeded by Controller | initial designer notes per card |
| `playtest_priority` | int | rank | 1–216, where 1 = highest priority for week-1 cohort |

---

## 3. Algorithm — flag score formula

```
flag_score =
    abs_z(base_stat_index, by faction)          × 0.35
  + abs_z(text_length_chars, by faction)        × 0.10
  + abs(complexity_score − faction_mean_cmplx)  × 0.15
  + abs(obvious_power_score − 3)                × 0.25
  + (5 − faction_archetype_fit)                 × 0.10
  + (1 if any keyword in {Bleed,Cleave,Persist,Smoke,Poison,Penance}
      AND archetype mismatch else 0)            × 0.05
```

Where:

- `abs_z(x, by faction)` = absolute z-score of `x` against the faction-mean ± faction-stdev. A card with a per-cost stat-index two standard deviations above its faction peers gets a high z; below also gets a high z.
- `obvious_power_score − 3` centres designer-judgement around "average" (3/5). Cards rated 1 or 5 get the max +2 contribution.
- `faction_archetype_fit` inverse: a card with fit-score 1 (badly fits its named archetype) contributes 4 × 0.10 = +0.40.
- Keyword-archetype mismatch row is a tripwire — a Persist-keyword card in a non-Mourner archetype is a structural smell.

### Flag severity thresholds

| Severity | flag_score | Meaning |
|---|---|---|
| `clear` | < 0.50 | No review needed |
| `watch` | 0.50–0.99 | Note for week-2 telemetry pass |
| `flag` | 1.00–1.49 | Add to week-1 cohort playtest queue |
| `fix-now` | ≥ 1.50 | Pre-soft-launch review by Paul + designer |

**Outlier rule:** any card whose `base_stat_index` z-score exceeds **2σ from its faction mean** is auto-promoted to `flag` minimum, regardless of other contributions. Per the deliverable brief.

---

## 4. Per-faction baselines (seeded)

These are the rough faction means we'll calibrate against. Numbers derived by spot-counting the 200-card pool in the v1 docs (units only for stat-index).

| Faction | Mean cost | Mean (HP+ATK)/cost | Median text_length | Designer notes |
|---|---|---|---|---|
| Iron Penitents | 2.6 | 1.55 | 78 chars | Bleed-stack cards skew text-heavy. Penance trigger language is verbose. |
| Ash-Mourners | 2.9 | 1.60 | 92 chars | Persist + Resurrect chains are wordy. Smoke aura cards medium. |
| Coven | 2.4 | 1.40 | 88 chars | Poison stacks + token-spawn language. Many low-cost. |
| Last Legion | 3.0 | 1.85 | 70 chars | Adjacency buffs short to write. Stat-index runs higher. |
| Skinward Pact | 3.1 | 1.95 | 84 chars | Big bodies + Resurrect-once. Highest cost mean. |

**Implication:** Legion + Skinward should be expected to read as "expensive but beefy"; Coven should read as "cheap but light"; Penitents + Mourners are mid. Flag candidates are cards that **don't sit on their faction's curve.**

---

## 5. Workbook layout (sheet plan)

| Sheet | Purpose |
|---|---|
| `Cards` | All 216 rows. One per card. All columns from §2. Editable cells: judgement + notes only; calc cells locked. |
| `Faction_means` | Auto-computed per-faction summary (mean cost, mean stat-index, stdev, median text-length, archetype-fit average). Drives the z-scores. |
| `Flag_queue` | Pivot of `Cards` filtered to `flag_severity ∈ {flag, fix-now}`, sorted by `flag_score` desc. The playtest review queue. |
| `Week1_top20` | Top 20 from `Flag_queue` by `flag_score`. Static-named range for handoff. |
| `Keyword_audit` | Cross-tab: archetype × keyword frequency. Cells with off-archetype keywords highlighted. |
| `Designer_log` | Free-text notes per audit pass, dated. |
| `Acceptance` | Sign-off checklist: each flagged card has a paired playtest result or a documented design-intent override. |

---

## 6. Top-20 flagged cards (designer-judgement seed for week-1 playtest)

Authored against the v1 card pools by Controller. These are the cards I'd flag now, before the spreadsheet exists, on the strength of read-throughs of the five card docs + the anti-synergy grid + the Warlord signature interactions. Ranked by **a priori risk**, not final flag_score.

| Rank | ID | Card | Faction | Why flagged |
|---|---|---|---|---|
| 1 | **C6** | Mother Quag, Twice-Drowned | Coven | Dual-archetype payoff card (Poison-Stack + Bog-Spawn Swarm). 5c R doing two engines' work is structurally suspect — either it's one engine too few, or two engines too many. Paul-locked as one card 2026-05-01; needs telemetry to validate. |
| 2 | **P15** | Hierarch of the Open Wound | Penitents | 4c R, 4/3/M/CD-1. Penance trigger fires _per friendly-Penitent damage event_, "once per turn" — at 1.75 stat-index over faction mean (1.55), and a self-damage faction stacks damage events fast. Trigger budget may need a within-combat cap (currently turn-cap only). |
| 3 | **M5** | Last Censer-Bearer (post-S2 reshape) | Mourners | 4c R, 4/2/S/CD-2, Dread-1 aura to all enemies in 2 tiles each turn. The S2 promotion (3c U → 4c R) was a Paul-call 2026-05-01. The aura is unbounded in target count; vs a HORDE wave (8-9 enemies at half stats) the Dread stacks accumulate before counters land. Check vs Coven Bog-Spawn Swarm. |
| 4 | **P6** | The Crucified Saint | Penitents | 5c R, 6/4/M/CD-1. On-play deals 2 dmg to all friendly Penitents in lane (Penance feed). Combined with **P23 Saint of Cinders** (+1 ATK to all friendly Penitents per Penitent death this combat, cap +3) this is one combo away from a deterministic +3 ATK board buff at turn 5. Combo risk. |
| 5 | **P19** | Procession Bleeds the Lane | Penitents | 6c U payoff. Deals 1 damage per Bleed stack on each row enemy. With P14 Stigmata-Bearer (auto-stack Bleed to cap-3) and P39 Reliquary of Wounds (relic, +1 dmg per Bleed stack at end-of-turn), Bleed builds vertically. 6-mana cost should gate but cap-3 in stacks is bypass-able with multi-target Bleed-3 spells (P17). |
| 6 | **M6** | The Pyre-Priest | Mourners | 5c R. Resurrects fallen Mourners as 1/1 Ash Wraiths with Fear. In a Resurrect-spam deck with cheap M2/M14/M15 fodder, Pyre-Priest can cycle 4-5 Wraiths per combat. Wraith cap absent in current spec. Add cap to spec. |
| 7 | **C6** alt-read | Mother Quag | Coven | (Already #1 — listed twice to flag the second risk: Mother Quag triggers vary between `faction_bible.md` v1 ("every 3rd enemy killed _this turn_") and `archetypes_v0.md`/`cards_coven_v1.md` ("every 3 enemy kills _this combat_"). Per `CONFLICTS_RESOLVED_2026-05-22.md` conflict 5 — needs reconciliation.) |
| 8 | **L12** placeholder | Sergeant-Smith Vikar, the Iron Watch | Last Legion | 4c flagship per `faction_bible.md` — all friendly Host units in same lane row gain +1 ATK AND Shield-1. Two-effect aura at 4c is dense. Legion stat-index is highest in the pool (1.85); this card lifts adjacent units past that ceiling. |
| 9 | **L7-Echo-cards** | Echo keyword stack | Last Legion | Echo replays effects. Per anti-synergy grid v0.1 Echo deals to Skinward Big-Monster but receives from Coven Poison. Stacking Echo with Vikar's adjacency-buff + Forge-Marshal Veska's card-draw-on-Host-summon is the suspected Tempo deck T1 list. Test it. |
| 10 | **S-Big-Monster-payoff** | Skinward big-body T1 | Skinward | Skinward 1.95 stat-index is highest. Their big bodies (8+ HP) walk past Cleave value (Penitent counter neutralised) and Resurrect-once gives a second-life budget. Combine with Tree-Walker Mhar's _Don the Pelt_ (50% stat buff via sacrifice) — chain ceiling exceeds 12/12 by turn 6. |
| 11 | **P1** | Nail-Choir Flagellant | Penitents | 1c, 2/1/M, +1 ATK per Penitent death this run (persistent across combats). Run-persistent ATK accumulator at 1c is a structural flag — late-run Flagellant in a multi-Penance deck could exceed 8 ATK at 1c. Cap missing. |
| 12 | **W-Sieren-passive** | Court-Necromant Sieren — Hanged Memory | Warlord (Mourners) | First-death-per-battle raises as 1/1 Withered Servant. Stacks with `M12 Necrologist` and `M6 Pyre-Priest`. Three-source Wraith spam without a per-combat Wraith cap. |
| 13 | **W11-passive** | Saint That Should Not Hang — The First Wrongful Death | Lore-locked Warlord | Reanimation enemies rise fighting _for_ you. Per `gameplay_keywords_resolution_v0.md` Reanimation is 5%/8%/12% per chapter. In a HORDE wave (8-9 enemies) the expected-value flip count = 0.4-1.1 enemies/wave. Cap missing on flipped-enemy budget; high variance, designer-intent or bug? |
| 14 | **C-Antler Crown** (C8) | Antler Crown | Coven | 3c spell, Poison-2 to all enemies in row. Row-wide Poison-2 at 3c is mathematically the strongest application-per-mana spell in the pool. Compare to P36 Long Office (3c, 2 dmg in 3-tile line — single-row, finite). |
| 15 | **M36** | The Long Dirge | Mourners | 5c U. Board-wide -1 ATK + Fear-1 for 1 turn AND draw 1 per friendly Mourner alive (cap 4). Two-effect spell with card-draw clause. Spell stat-index by effect-count is high; combined with Pyre-Priest cycling, card-draw economy may push the deck into a draw-everything state. |
| 16 | **P26** | The Long Confession | Penitents | 4c U. Sacrifice up to 3 friendly Penitents; each grants +1 mana and draws 1 card this turn. Ritual mana spike + card draw. Risk: 4c spell that returns +3 mana = net 0c. With cheap Penitent bodies sacrificed, net is +3 cards + Penance trigger feed. Loop risk. |
| 17 | **Hammer-Confessor / Cleave** (P4) splash card | Penitents | 3c U, 3/3/M/CD-1, Cleave. Confessor-At-Arms (P30, R identity for Cleave-Melee) makes melee Penitents Cleave when attacking 2+ adjacent. Combined with Bleed splash (P-Bleed-Stack archetype) the Cleave-Bleed value-per-mana climbs into pseudo-aggro-control hybrid. |
| 18 | **P40** | Crown of the Hanged Confessor | Penitents | Relic R. While ≥3 friendly Penitents in any lane, all Penitents gain Cleave-1. Relic-floor effect that scales with the cheapest faction's bodies. Three-body threshold is trivially met by P1/P2/P10/P11/P21/P28 (all 1-2c). Borderline mandatory pick if drafted. |
| 19 | **Vyrrun signature spell** — Self-Scourge | Warlord (Penitents) | Spell. Deal 3 damage to strongest unit; all your units +2 ATK this wave. At Hanging Hour the self-damage doubles _and_ the buff doubles (per `warlords_v1.md` Hanging Hour synergy block). Double-double on a Warlord signature means a single Hanging-Hour Self-Scourge = +4 ATK wave-wide on a vertical-aggro Warlord. Burst risk. |
| 20 | **Mother Quag interaction with Eddra passive** | Coven | Marsh-Mother Eddra's Brood passive (free 1/1 Familiar each wave) + Mother Quag's Bog-Spawn-on-3rd-kill = wave-start with one Familiar guaranteed and a token-cascade engine. With C2 Bog-Witch Initiate (1c, summons Bog-Spawn) + C4 Toad-Caller (2c U, summons Bog-Spawn each turn) the swarm starts at turn 1. HORDE-wave counter test required. |

**Bench (next-15, watch list):**

- P-bleed cycle cards as a set (P12 Bone-Lash, P14 Stigmata-Bearer, P-relic P39 Reliquary).
- M-trap-control sequence (M11 Funeral Bell as payoff + M9 Smoke Veil + M10 Ash-Shroud — trap saturation risk).
- L-Forge-Marshal Veska passive (Forge-Heat: draw on Host summon if 3+ Host) — card-economy cascade.
- C-Saint of Gallowsmoke (paid Warlord, Smoke-tile +1 turn + 1 dmg/turn — Smoke pillar amplifier).
- Warden Caspar Voll's _Throne Gone Cold_ — banishes non-boss enemies. Edge-case vs HORDE.
- The Last Confessor's _Hearsay_ passive (random rival faction cards in starter deck) — variance amplifier.
- Brass-Crowned Whelp's _Wail_ (3 Brass Hounds in single tile, ignore blockers 1 turn) — anti-Cleave tech.
- The Saint of Gallowsmoke's _Veil of Gallowsmoke_ — Fear-1 + Smoke fill — anti-Coven swarm.
- Bog-Spawn token cap in Coven (currently no cap, only soft via mana ceiling).
- Persist-end-of-turn timing windows (Mourners primary, see `keywords/persist_v0.md`).

---

## 7. Week-1 playtest plan (cohort-side)

For each top-20 flagged card the cohort will produce:

1. **Pickrate.** Did the card get drafted when offered?
2. **Pickrate by archetype.** Did the right archetype draft it?
3. **Win-rate when drafted.** Drafted-this-card runs vs cohort baseline.
4. **Combo cluster.** Top-3 cards co-drafted with it.
5. **Designer override?** If telemetry says fine, designer can override the flag — _with a written reason._

Cohort = 50 testers per `soft_launch_playbook_v0.md`. Each tester runs ≥ 5 chapter-1 runs in week 1 = 250 runs. The top-20 cards each appear in the reward-pick offer pool at ~30% expected rate = ~75 drafted instances per card. Sample size adequate for picking the worst three for an emergency tuning patch.

---

## 8. Outputs

- **`card_balance_audit_v0.xlsx`** — the workbook (Controller round 4 to author, or invoke xlsx skill).
- **`Week1_top20`** named range — handed to cohort runner.
- **`Designer_log`** — Paul + Controller append per audit pass.
- **`Acceptance`** — sign-off checklist per flagged card with playtest result or designer-override paired.

---

## 9. Version history

- v0 — 2026-05-22 — Controller round 3. Method + columns + top-20 seed.

— Controller, 2026-05-22
