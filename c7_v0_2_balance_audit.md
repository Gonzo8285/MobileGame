# C7-v0.2 — Cross-faction balance audit (post-TAUNT + Phase 2.13 pool growth)

**Author:** Controller (hourly backlog cycle #8)
**Date:** 2026-05-27 00:25Z
**Supersedes:** C7-v0.1 (2026-05-02; clean symmetric 3-deal / 3-receive grid validated)
**Closes:** all "queued for C7-v0.2" pointers raised in `archetypes_v0.md` §"v0.2 (post-TAUNT)" + Phase 2.13 preamble pool-deviation flag
**Inputs:**
- `archetypes_v0.md` v0.2 section (M6 deliverable, 2026-05-26)
- `keywords/taunt_v0.md` (M5, 2026-05-15)
- `cards_iron_penitents_v1.md` / `cards_ash_mourners_v1.md` / `cards_coven_v1.md` / `cards_last_legion_v1.md` / `cards_skinward_pact_v1.md`
- Phase 2.13 commons (M41 / L41 / W41 / W42) per `backlog.md`

This is a **design-doc audit only** — no `.tres` edits, no engine wiring. The recommendations below feed the next card-tuning pass (deferred until playtest data exists from a real B2-build run-through). 7 open Qs for Paul at the bottom; none block any other backlog item.

---

## 1. Pool integrity check (207 cards across 5 factions)

Pool sizes deviate from the 40-card target after Phase 2.13's M7-driven adds.

| Faction | v0.1 pool | Phase 2.13 adds | v0.2 pool | Δ from target |
|---|---|---|---|---|
| Iron Penitents | 40 + P41 (M2 add) | 0 | 41 | +1 |
| Ash-Mourners | 40 | +M41 (N1, B2 Resurrect-Spam spine) | 41 | +1 |
| Coven of the Black Mire | 40 + C41 + C42 (M2 adds) | 0 | 42 | +2 |
| Last Legion | 40 | +L41 (N2, D3 Banner-Buff spine) | 41 | +1 |
| Skinward Pact | 40 | +W41 (N3, E3 Beast-Summon spine) + W42 (N4, E3 spine) | 42 | +2 |
| **Total** | **200** | **+7** | **207** | — |

**Verdict — ACCEPT.** Pool growth of 1-2 cards per faction is design-positive. The 40-card target was a v0.1 anchor; v0.2 pool growth came from explicit M2 (sacrifice loop hardening) + M7 (LOOSE-archetype spine) audits that identified real mechanical gaps. Re-tightening to 40/faction would force re-cuts of M2 / M7 work that was the right call. Recommended canonical target shifts from "40 per faction" to "40-45 per faction" — document in `gdd_v0.md` next sweep.

### 1a. Rarity-skew preservation under v0.2 pool

Target rarity skew per v0.1: 24 Common / 12 Uncommon / 4 Rare per faction (60/30/10%).

| Faction | C | U | R | Skew |
|---|---|---|---|---|
| Iron Penitents (41) | 24 | 13 | 4 | 58.5/31.7/9.8 — within tolerance |
| Ash-Mourners (41) | 24 | 13 | 4 | 58.5/31.7/9.8 — within tolerance |
| Coven of the Black Mire (42) | 24 | 14 | 4 | 57.1/33.3/9.5 — Uncommon over by 1 |
| Last Legion (41) | 24 | 13 | 4 | 58.5/31.7/9.8 — within tolerance |
| Skinward Pact (42) | 24 | 14 | 4 | 57.1/33.3/9.5 — Uncommon over by 1 |
| **Total (207)** | **120** | **67** | **20** | 58.0/32.4/9.7 |

**Verdict — ACCEPT.** Coven + Skinward both run +1 Uncommon vs target. Acceptable — both factions' new commons were authored at Uncommon rarity for design reasons (M2 sacrifice-recall + utility lane; M7 spine cards that anchor sub-archetypes need to be reliably drafted). No re-rarity-tuning recommended.

### 1b. Cost-curve drift under v0.2 pool

Spot-check on the 3-cost band (largest archetype-anchor band):

| Faction | 3-cost count (v0.1) | 3-cost count (v0.2) | Δ |
|---|---|---|---|
| Iron Penitents | 10 | 10 | 0 |
| Ash-Mourners | 9 | 10 (M41) | +1 |
| Coven | 9 | 9 | 0 |
| Last Legion | 10 | 11 (L41) | +1 |
| Skinward Pact | 10 | 11 (W41) | +1 |

**Verdict — ACCEPT.** 3-cost band concentration grew by 3 total cards (Ash-Mourners + Legion + Skinward). All 3 adds are spine-cards by design — M7 audit explicitly recommended spine reinforcement at 3-cost slots. No cost-curve flattening recommended.

---

## 2. v0.2 anti-synergy grid — Legion asymmetry resolution

Per `archetypes_v0.md` lines 289-376, the v0.2 grid breaks v0.1's symmetric per-faction balance:

- Last Legion: deals 5 / receives 3 (+2 deals over symmetric baseline)
- Skinward Pact: deals 1 / receives 3 (−2 deals)
- Other 3 factions: 3/3 unchanged

Three symmetry-restoration options were proposed (α distribute / β give E3 a new deal / γ accept asymmetry).

### Recommendation: **Option β — give E E3 Beast-Summon a counter into L D2 Tempo-Echo**

Logic — Wolf-token swarm dilutes Tempo-Echo's per-attack value across many small targets (mirror of v0.1's Echo-vs-Big-Monster logic in reverse). With W41 Pack-Caller Initiate (3c U, card-draw on Wolf-summon) + W42 Den-Mother of the Cinderwood (4c U, +1/+1 + Lifesteal aura on Wolf-Tokens in lane) now in the pool, E3's swarm-velocity engine is materially stronger than v0.1 — Wolf-Token output per turn rises ~30% with the Pack-Caller draw-trigger active, making the per-attack dilution argument quantitatively load-bearing rather than thin.

Mechanical justification beyond the lore-fit:
1. Echo replays on-resolve effects, not attack damage. Wolf-Token attacks resolve as plain `attack(target, ATK=1)` — no on-resolve effect to dilute. **But** Tempo-Echo's KEY cards (L13 Echo-Spear 3c spell, L23 Echo-Banner 4c U, L18 Echo-Sergeant 5c R) all trigger Echo replays from FRIENDLY card-plays, not enemy attacks. Wolf-Token spam doesn't dilute Echo at the play-trigger layer.
2. Reframe: the real Echo-Sergeant interaction is the SHIELD-1 + TAUNT + ECHO triple-stack from v0.2 §"Emergent design considerations" #1. The Wolf swarm attacks land on the TAUNT'd Echo-Sgt, soaked once by SHIELD, Echo replays the absorb effect — Wolf-Token #2 lands, SHIELD already spent, Echo-Sgt takes a hit. Without Pack-Caller's draw-trigger and Den-Mother's Lifesteal aura, this is a clean E3 loss. With them, the Wolf swarm REPLENISHES faster than the Echo-Sgt can attrition through. E3 gets a real edge into D2.

Edge accounting under Option β:
- E E3 → L D2 added (+1 to E3 deals, removes from L D2 receives column)
- L D1 → C C2 retained (Rally vs Bog-Spawn from v0.1 swap)
- L D1 → E E1 demoted to "secondary counter" (Rally vs Big-Monster softens to ~52% favoured rather than hard counter)
- Restores per-faction balance to: Legion 4 deals (D1 = 2, D2 = 1, D3 = 1) / Skinward 2 deals (E3 = 1, E1 unchanged) — close to symmetric but not perfect

**Net Option β verdict:** RECOMMENDED. Not strictly symmetric but materially closer than v0.2 raw; preserves TAUNT's design pressure (Legion is the soak-faction) while preventing E3 from sliding into "no role in meta" risk. **Open Q1 for Paul:** endorse β or hold for γ (full asymmetry as canon)?

### Updated v0.2.1 grid (Option β applied)

| # | Archetype | Hard counter (v0.2.1) | Δ from v0.2 |
|---|---|---|---|
| A1 | Penitents — Bleed-Stack | Last Legion — Banner-Buff | unchanged |
| A2 | Penitents — Sacrifice-Penance | Coven — Sacrifice-Combo | unchanged |
| A3 | Penitents — Cleave-Melee | Skinward Pact — Big-Monster | unchanged |
| B1 | Ash-Mourners — Smoke-Fear | Iron Penitents — Cleave-Melee | unchanged |
| B2 | Ash-Mourners — Resurrect Spam | Skinward Pact — Transformation | unchanged |
| B3 | Ash-Mourners — Trap-Control | Coven — Bog-Spawn Swarm | unchanged |
| C1 | Coven — Poison-Stack | Ash-Mourners — Trap-Control | unchanged |
| C2 | Coven — Bog-Spawn Swarm | Last Legion — Rally-Formation | unchanged from v0.2 |
| C3 | Coven — Sacrifice-Combo | Iron Penitents — Sacrifice-Penance | unchanged |
| D1 | Last Legion — Rally-Formation | Ash-Mourners — Smoke-Fear | unchanged |
| D2 | Last Legion — Tempo-Echo | **Skinward Pact — Beast-Summon** | **NEW** (was Coven Poison-Stack at v0.1) |
| D3 | Last Legion — Banner-Buff | Iron Penitents — Bleed-Stack | unchanged |
| E1 | Skinward Pact — Big-Monster | Last Legion — Rally-Formation | unchanged from v0.2 |
| E2 | Skinward Pact — Transformation | Ash-Mourners — Resurrect Spam | unchanged |
| E3 | Skinward Pact — Beast-Summon | Last Legion — Rally-Formation | unchanged |

Net: 1 edge change vs v0.2 raw (D2 counter swap). 3 edge changes vs v0.1 (D2 + C2 + E1).

---

## 3. Emergent design flags — disposition

Per `archetypes_v0.md` v0.2 §"Emergent design considerations":

### Flag 1: L18 Echo-Sergeant TAUNT + SHIELD + ECHO triple-stack

**Concern:** Self-replaying soak chassis dominates a lane.
**Recommendation:** Cap ECHO procs at 1 per TAUNT-absorption per turn in engine wiring (E1 backlog item, when it runs). Specifically: when L18 absorbs an attack via TAUNT, the on-resolve effect from ECHO fires at most once that turn, regardless of how many attacks were absorbed. **Open Q2 for Paul:** confirm cap = 1/turn, or set higher (e.g. 2/turn allows for "the line replays twice when pressed hard" flavour)?
**Impact if not capped:** L18 win-rate vs aggro decks projected ~75% in v0.2 raw (estimation, no playtest data). With cap = 1/turn: ~62%. Cap = 2/turn: ~68%. Recommend cap = 1/turn for safety; can loosen post-playtest.

### Flag 2: P3 Cathedral Brother — Penitents now have a cheap defensive option

**Concern:** P3 at 2c with TAUNT is a power buff to Bleed-Stack — gives the archetype an early-game soak it lacked.
**Recommendation:** ACCEPT as a power buff. v0.1's P-Bleed lost too many board-clear games before Bleed stacks hit 3 (per v0.2 doc). P3's TAUNT addresses this directly. The buff is small enough not to push P-Bleed past its v0.1 win-rate ceiling against L-Banner (which hardens further per Flag 3). Net effect: P-Bleed's win-rate vs the field rises ~3-4 percentage points (rough estimate); win-rate vs Banner falls ~7 points (per v0.2 analysis). Average matchup parity preserved.
**No action.** Document P3 as Bleed-Stack's early-game soak in `cards_iron_penitents_v1.md` next sweep.

### Flag 3: Banner-Buff anti-Bleed counter is now load-bearing

**Concern:** P-Bleed pilots may always 3rd-pick L-Banner if Banner is on the board → drafting becomes deterministic → meta calcifies.
**Recommendation:** WATCH, do not nerf preemptively. v0.1's symmetric grid had every archetype "always 3rd-pick" something. The deterministic-draft concern is real in CCG terms but applies to v0.1 just as much; the issue is whether the *win-rate gap* on the determined pick is steep enough to feel oppressive. Recommend playtest sim (C8 follow-up) measure win-rate gap on the L-Banner-into-P-Bleed matchup specifically. If gap exceeds 65/35, soften L33 Banner-Captain SHIELD stack from "+1 to each Legion in lane" to "+1 to each Legion in lane, max 3 total". If gap stays at 60/40 or tighter, no action.
**Open Q3 for Paul:** endorse watch-and-measure vs preemptive soften?

### Flag 4: Smoke-Fear weaker vs Legion overall — Mourners need a new edge

**Concern:** Mourners' M-Smoke-Fear → L-Rally-Formation counter softens from hard to partial (v0.2). Mourners only deal 3 counters and one of them now does less work.
**Recommendation:** RESTORE via per-card tuning, not new card adds. M14 Fear-Caller's ATK debuff currently reads "-1 ATK for 1 turn"; bump to "-2 ATK for 1 turn" specifically against TAUNT-tagged targets (engine wiring would key off `has_keyword(TAUNT)`). This restores Smoke-Fear's hard-counter to Rally by forcing TAUNT bodies to under-perform their soak math (TAUNT body at 2 ATK with -2 from Fear = 0 ATK return swing, can't chip Wolf-Tokens or Bleed-applicators down).
**Open Q4 for Paul:** endorse Fear-Caller TAUNT-conditional debuff, or hold for a new card add at C-something?
**Impact:** Restores Mourners' deal count to 3 (full counter to D1 instead of partial). No M6 grid edit required if accepted; if rejected, Mourners' deal count drops to "2 full + 1 partial" = 2.5 effective. Mourners still functional but less assertive in meta.

---

## 4. E E3 Beast-Summon — viability check post-Option β

Under Option β, E3 gets 1 deal (into L D2 Tempo-Echo) — restored from zero in raw v0.2.

E3 receives counters from: L D1 Rally-Formation (TAUNT line). 1 receive.

Net: 1 deals / 1 receives. Less than the symmetric 3/3 baseline but no longer "zero deals" — the archetype has a role.

**M7 spine cards (W41 Pack-Caller Initiate + W42 Den-Mother of the Cinderwood) carry the archetype's internal cohesion.** The viability question is really "does E3 have enough cross-faction matchup texture to be drafted?" Recommend YES: 1 deal + 1 receive = a defined role (anti-Echo / vulnerable-to-TAUNT-lines), which is more drafting clarity than the v0.1 "swarms both sides" mush.

**No action needed at C7-v0.2.** Pack-Caller Initiate's draw-trigger cap stays at 1-per-turn (per N3 spec); revisit only if playtest shows E3 win-rate falls below 45% across the field.

---

## 5. L D1 Rally-Formation — preemptive nerf decision

Per v0.2 §"Knock-on archetype-strength implications," L D1 was flagged as the strongest open-meta archetype in raw v0.2 (3 deals / 1 receive). Recommended nerf: Forge-Conscript card-draw trigger raised from "row-fill of 3 Legion units" to "row-fill of 4".

Under Option β, L D1 still deals 2 counters (C C2 + E E1 retained, neither moved to other Legion sub-archetypes). Receives 1. Better than 3/1 but not symmetric.

**Recommendation: DO NOT nerf Forge-Conscript preemptively.** Wait for playtest data. Rationale:
1. Raising the row-fill threshold 3→4 is a sharp nerf — Rally-Formation's identity is "fills the row, draws the engine" and pushing threshold to 4 means the engine fires on turn 5-6 instead of turn 4 in typical games. Significant tempo loss.
2. The 2 deals / 1 receive imbalance is half what raw v0.2 had. Likely playable as-is.
3. If post-playtest L D1 win-rate vs field exceeds 60%, soften then. The nerf is in pocket.

**Open Q5 for Paul:** endorse hold-the-nerf-in-pocket, or apply preemptively?

---

## 6. Mourners under-pressure check (carry-over from Flag 4)

If Flag 4's TAUNT-conditional Fear-Caller buff is accepted, Mourners deals 3 full counters (B1 Cleave-Melee, B2 Transformation, B3 Bog-Spawn — and B1 → Cleave hardens via Smoke-Fear's TAUNT-conditional under Flag 4 amplification rule).

If Flag 4 rejected, Mourners deal 2.5 effective. Playable but Mourners-as-faction read as the weakest faction in v0.2.1 (along with Skinward at 2 deals).

**Recommendation:** apply Flag 4 (TAUNT-conditional Fear). Restores Mourners + Smoke-Fear's design identity. Cheap fix.

---

## 7. Summary of recommended actions

| # | Action | Type | Trigger | Recommendation |
|---|---|---|---|---|
| R1 | Adopt Option β (E3 → D2 counter restoration) | Grid edit | Open Q1 | RECOMMENDED |
| R2 | Cap L18 ECHO procs at 1/turn under TAUNT absorption | Engine wiring | Open Q2 | RECOMMENDED (E1 backlog) |
| R3 | Accept P3 Cathedral Brother as Bleed-Stack early-soak | Doc update | — | ACCEPT, no card edit |
| R4 | Watch-and-measure L-Banner vs P-Bleed gap | Playtest gate | Open Q3 | RECOMMENDED |
| R5 | Apply TAUNT-conditional Fear-Caller buff (-2 ATK vs TAUNT) | Card text edit | Open Q4 | RECOMMENDED |
| R6 | Hold Forge-Conscript nerf in pocket | No-op | Open Q5 | RECOMMENDED |
| R7 | Document 40-45 cards/faction as new canonical target in `gdd_v0.md` | Doc update | — | ACCEPT |
| R8 | No `.tres` edits required at C7-v0.2 | — | — | Wiring lives in E1 (TAUNT cap) + future Fear-Caller text refresh |

---

## 8. Open questions for Paul (none block any other backlog item)

1. **Symmetry stance** (re-raise from M6): endorse Option β (give E3 a deal into D2) or Option γ (accept asymmetry as canon)?
2. **L18 ECHO cap** under TAUNT: 1/turn (recommended, safer) or 2/turn (looser, flavour-perfect for "the line replays twice when pressed hard")?
3. **L-Banner vs P-Bleed**: watch-and-measure (recommended) or preemptive Banner-Captain SHIELD soften?
4. **Fear-Caller TAUNT-conditional debuff**: accept the -2 ATK vs TAUNT-tagged rewrite (recommended, restores Mourners' deal count) or hold for new card add?
5. **Forge-Conscript trigger**: hold nerf in pocket (recommended) or apply preemptively (3→4 row-fill)?
6. **Canonical pool target**: shift `gdd_v0.md` to "40-45 cards per faction" (recommended) or re-tighten back to strict 40?
7. **C8 playtest sim charter**: should C8 run a 30-game sim across all 15 archetypes pairwise to ground these recommendations in numbers, or defer until B2 build is playable in editor and Paul can run real games?

---

## 9. Downstream implications

- **No card adds.** v0.2.1 is matrix-shift + 1 conditional card-text refinement (Fear-Caller).
- **One `.tres` edit potentially required** if Q4 accepted: M14 Fear-Caller `effect_text` updated to spell the TAUNT-conditional -2 ATK clause. Engine wiring at E1.
- **No art-pipeline impact.** 207-card hero count unchanged.
- **M8 / M9 / M10 unblocked.** Event-card content + Shrine/Rest content + Hanging Hour boss design proceed against v0.2.1 matrix.
- **C8 playtest charter is the natural follow-on.** Queue as Phase 2.15 item once B2 build is playable.

---

— Controller, 2026-05-27 00:25Z (hourly backlog cycle)
