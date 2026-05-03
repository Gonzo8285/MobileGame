# Internal-MVP scope lock (C8)

**Status:** locked 2026-05-02 by heartbeat (C8). Supersedes the "300+ cards by D30" note in `gdd_v0.md` for the *internal* build only — public/launch scope is unchanged.
**Purpose:** prove the deckbuilder *feels* good before we sink heartbeats into the other 2 factions, the Warlord tier system, and B3 art.

## In scope (Internal-MVP a.k.a. "IMV-1")

- **3 factions only:** Iron Penitents, Ash-Mourners, Coven of the Black Mire.
  - Card pools authored = ~120 cards total (P1–P40, M1–M40, C1–C40 — already on disk under `game/data/cards/{iron_penitents,ash_mourners,coven}/`).
  - Last Legion (L1–L40) and Skinward Pact (W1–W40) **stay authored on disk** — `is_draftable=false` toggle, hidden from the deck-builder, kept ready for IMV-2 flip-on.
- **Warlords:** 3 of the 5 free Warlords — one anchored to each in-scope faction (faction-locked starter Warlords). The other 7 stay locked / hidden.
- **Phase 3 build slice covered:** B2.5 → B2.10 (combat scene → end-to-end smoke loop). Map = 1 chapter, 5 nodes, 1 boss. No meta-progression yet beyond "did you finish the run".
- **Tier system (Phase 2.7 W1–W5):** **deferred** to IMV-2. Warlords are flat in IMV-1.
- **Monetisation:** stubbed only — IAP buttons present, no real SDK wiring. Battle pass / energy not in. (B4 lives in IMV-2.)
- **Art:** placeholder shapes + colour-by-faction. AI art pipeline (B3) deferred to IMV-2.
- **Audio:** silence + 3 SFX stubs (card-play, hit, defeat). No music.
- **Platform target:** Godot editor playthrough on Paul's laptop. No iOS/Android build yet.

## Out of scope (deferred to IMV-2)

- Last Legion + Skinward Pact unlock + their faction-locked Warlords.
- Warlord XP / tier ladder (Phase 2.7).
- Meta-progression: shrines, relics-as-meta-currency, mastery unlocks.
- Real ad SDK + IAP wiring (Phase 3 B4).
- AI art pipeline + real cards art (B3).
- Soft-launch CI builds (B5–B7).
- Multi-chapter map (chapter 2 onwards), multi-boss biome rotation.

## Validation gate (what "feel" means before IMV-2 unlocks)

Paul plays IMV-1 in the Godot editor. Pass = **all 5** of the following are true:

1. **Draft choice matters** — at least one IMV-1 run has Paul choosing between two non-trivial reward picks per node (not "obvious upgrade" 80%+ of the time).
2. **Sub-archetypes feel distinct** — Paul can name which of the 3 sub-archetypes he was leaning into by mid-run, without checking the doc.
3. **Counter-play exists** — at least one wave/elite forces a tactical re-think of the deck, not just stat-checking.
4. **Death is informative** — when Paul dies, he can articulate the deck's failure mode in one sentence ("ran out of removal", "no early board", etc.) — not "RNG screwed me".
5. **One-more-run pull** — after a defeat, Paul *wants* to try again with a different sub-archetype seed. (Subjective but the headline KPI for any roguelike.)

## What heartbeat picks up next once C8 lands

The unblocked queue (in priority order):

1. **B2.5** — Combat scene scaffold (3-lane grid, wave spawner, base HP, win/lose).
2. **B2.6** — Card-play loop (drag from hand → drop on lane → cost + place).
3. **B2.7** — Turn engine.
4. **B2.8** — Reward screen.
5. **B2.9** — Map screen.
6. **B2.10** — End-to-end smoke test (the IMV-1 gate).

W1–W5 (tier system) and L3 (pitch .docx re-export) stay queued behind B2 progress. B3.0 (cloud GPU research for art) can be slotted in any heartbeat after B2.5 lands, since it's a research item and doesn't conflict with build work.

## Engine impact

- `Card.is_draftable` already exists and is already set `false` on the L*/W*/relic cards — no schema change.
- IMV-1 deck-builder UI just needs to filter `Card.is_draftable == true AND Card.faction IN {IRON_PENITENTS, ASH_MOURNERS, COVEN}`. The other two factions' enums and `.tres` files stay registered so we don't break load when we flip them on for IMV-2.
- No Warlord tier fields needed in IMV-1 — `Warlord` Resource stays as-is until W5.

## Open question for Paul (non-blocking)

Should the 3 IMV-1 starter Warlords be the **canonical free 3** from `warlords_v1.md` (i.e. the 3 that ship as free at public launch too) or a **temporary IMV-1-only trio** chosen specifically to stress-test the 3 in-scope factions? Heartbeat default if unanswered: pick the canonical free 3, then audit at IMV-1 gate whether their sub-archetype coverage is good. Cheaper than designing throwaway Warlords.
