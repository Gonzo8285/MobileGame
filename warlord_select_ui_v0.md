# W4 — Warlord-select UI mock v0

_Authored 2026-05-11 by heartbeat. Phase 2.7 wireframe spec. Visualises the screens that surface the W1/W2 tier system + the W3 XP-booster economy so an engineer can build against a single layout and Paul can eyeball whether the tier ladder reads right. ASCII-first; this is a wireframe, not pixel-pushing. Real visual design lives in B3.x after the art pipeline is hot._

## 0. Scope + non-goals

**In scope (v0):**
- Top-level Warlord roster grid (free / paid / lore-locked).
- Warlord detail panel — big art slot + tier ladder.
- Tier 2 variant-passive picker modal.
- Tier 3 alt-fire picker modal.
- Tier 4 mastery-payoff one-shot modal (the celebratory unlock screen).
- XP-booster strip — the persistent UI that surfaces _why_ the next win is worth ×N XP.
- Multiplier display-string lock (Open Q3 from `monetisation_map.md` §13).

**Out of scope:** colours, fonts, real card art, animation timing, controller-vs-touch input layer, accessibility audit (deferred to B3.x art pass + B5 device-test pass).

**Aspect ratio assumption:** portrait phone, 9:19.5 (modern iPhone/Android), 1080×2340 working canvas. ASCII below is rough proportional — boxes ≠ pixels.

---

## 1. Display-string lock (closes W1 Q5 / W3 §13 Q3)

**Locked form: `+25% XP`** — additive-percentage above the booster row, never `×1.25`.

Rationale: player-survey conventions (Slay the Spire, Marvel Snap, Hearthstone) all surface percentage uplift, not multiplier notation. Multiplier notation reads as "math" — bad for the casual end of the audience. The engine still stores multipliers (`Dictionary[StringName, float]` per W3 §13) and computes `effective = min(3.0, prod(values))`; UI converts to `+((effective - 1.0) × 100)% XP` at render time. **Cap hit is displayed as `+200% XP (max)` with the source rows that overflowed greyed-out** — answers W3 §13 Q1 (skin+quest stack-overflow surface).

---

## 2. Screen A — Warlord roster grid (entry screen)

The screen the player lands on when picking a Warlord for a new run.

```
+-----------------------------------------------+
|  [<]  WARLORDS                       [⚙]      |
|                                                |
|  Active XP boosts:  +37% XP   [tap to detail] |   <-- §6 booster strip (always visible)
|                                                |
|  FREE                                          |
|  +-------+ +-------+ +-------+                |
|  | VYRR  | | SIER  | | EDDRA |                |
|  | T2 ●● | | T1 ●  | | T3 ●●●|                |   <-- tier dot count = current tier
|  | [ART] | | [ART] | | [ART] |                |
|  | Iron  | | Ash   | | Coven |                |   <-- faction tag
|  | Aggro | | Ctrl  | | Swarm |                |
|  +-------+ +-------+ +-------+                |
|  +-------+ +-------+                          |
|  | VESKA | | MHAR  |                          |
|  | T1 ●  | | T2 ●● |                          |
|  | [ART] | | [ART] |                          |
|  | Legion| | Skin  |                          |
|  | Tempo | | Summ  |                          |
|  +-------+ +-------+                          |
|                                                |
|  ─────────────────────────────────────────    |
|                                                |
|  PAID (5)                                      |
|  +-------+ +-------+ +-------+                |
|  | WHELP | | TWELV | | SAINT |                |
|  | LOCK🔒| | T1 ●  | | LOCK🔒|                |
|  | 12k 💀| | OWNED | | 9.99$ |                |   <-- unlock cost (Marrow Shards or gems)
|  | [SIL] | | [ART] | | [SIL] |                |
|  +-------+ +-------+ +-------+                |
|  +-------+ +-------+                          |
|  | DREAD | | KARN  |                          |
|  | LOCK🔒| | LOCK🔒|                          |
|  | 14k 💀| | 12k 💀|                          |
|  | [SIL] | | [SIL] |                          |
|  +-------+ +-------+                          |
|                                                |
|  ─────────────────────────────────────────    |
|                                                |
|  +-------+                                     |
|  | ???   |                                     |
|  | LOCK🔒|                                     |   <-- W11 "Saint That Should Not Hang"
|  |[?????]|                                     |   <-- silhouette only, lore-locked
|  | Beat  |                                     |   <-- unlock hint: campaign all 10
|  | all 10|                                     |
|  +-------+                                     |
|                                                |
+-----------------------------------------------+
```

**Annotations:**
- `T2 ●●` = current tier as a dot ladder of 4. Reads instantly. No XP bar at this density.
- Tile size scales with viewport — 3-up on phone portrait, 4–5-up on tablet. Don't bother with a 1-col fallback; if the screen is narrower than ~320 px we have bigger problems.
- **Locked paid Warlords** show silhouette art + price chip (Marrow Shards 💀 OR gems). Tap → unlock confirm modal (existing G8 §4 flow).
- **W11 lore-lock** uses `???` text + heavy-veil silhouette. No price, no tier. Unlock hint is one short phrase.
- **Active XP boosts strip** sits below the title. Tap-to-expand shows the §13 registry table as a per-source breakdown. This is the only persistent place the booster economy is surfaced — keeps Vermutung-style cognitive load down.

---

## 3. Screen B — Warlord detail panel (selected)

Tapping a tile pushes this screen. The meat of W4. Tier ladder is the central spine.

```
+-----------------------------------------------+
|  [<]  PENANCE-CAPTAIN VYRRUN         [START] |
|                                                |
|  +-------------------+                        |
|  |                   |                        |
|  |   [BIG ART        |   IRON PENITENTS       |
|  |    SLOT — 4:5     |   Cathedral Ruins      |
|  |    PORTRAIT       |   Aggro / Bleed-stack  |
|  |    @ warlord_     |                        |
|  |    signature      |   ⚔ Bleed-stack vibe  |
|  |    tier]          |                        |
|  |                   |                        |
|  +-------------------+                        |
|                                                |
|  ┌─ TIER LADDER ──────────────────────────┐   |
|  │                                         │   |
|  │   T1 ●─── T2 ●═══ T3 ○───── T4 ○        │   |
|  │   default   choice  alt-fire  mastery   │   |
|  │                                         │   |
|  │   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░  4,200/4,800 │   |  <-- XP bar to next tier
|  │                                         │   |
|  │   600 XP to TIER 3 — Bone-Pageant       │   |  <-- next-unlock teaser by name
|  │                                         │   |
|  │   +37% XP active  [▸ detail]            │   |  <-- booster echo (consistent w/ roster)
|  │                                         │   |
|  └─────────────────────────────────────────┘   |
|                                                |
|  ┌─ LOADOUT ─────────────────────────────┐    |
|  │                                        │    |
|  │  Passive:   [Mortify ▾]                │    |  <-- dropdown, currently default
|  │             ─ choices unlock at T2 ─   │    |  <-- A/B locked at this tier yet
|  │                                        │    |
|  │  Sig spell: Self-Scourge   [info]      │    |  <-- alt-fire grey'd, unlocks at T3
|  │                                        │    |
|  │  Sig unit:  Cathedral Brother [info]   │    |
|  │                                        │    |
|  └────────────────────────────────────────┘    |
|                                                |
|  [    START RUN    ]                          |
|                                                |
+-----------------------------------------------+
```

**Tier ladder rules:**
- ● = unlocked, ○ = locked, ═ = current tier marker. Visual flair (gallows-rope motif over the underscores?) deferred to B3.x.
- XP bar fills the *current* tier's remaining XP — never lifetime cumulative. Cumulative would mean a Tier-3 player sees a near-full bar from their T1-→T2 grind; not what we want.
- **Next-unlock teaser** is a single named string ("Bone-Pageant," "Pall Writ," "Twelvebirth"). Pulls from `warlord_tiers_full.md`. Anti-FOMO: only the *name*, not the mechanical text — keeps locked content alluring without spoiling sidegrades the player will compare against.
- **Tier 4 unlock** shows a small 🗝 icon adjacent to ○ — signals "this is mastery, it's special, it's a one-shot moment when it lands."

**Loadout panel rules:**
- Each row is a dropdown but only the default is selected for T1 players. The dropdown still *exists* — that way the player sees the shape of "this becomes a choice later." Educational.
- `[info]` chips open card-detail modals (existing card-view UI from B2.6).
- The whole loadout panel is read-only when the player is in a run; you can't swap passive mid-run (per W1 §3.2).

---

## 4. Screen C — Tier 2 variant-passive picker (modal)

Fires on Warlord-detail screen tap of the Passive dropdown, when the Warlord is at T2+.

```
+-----------------------------------------------+
|  [×]  CHOOSE PASSIVE — VYRRUN                 |
|                                                |
|  ┌─ DEFAULT ─────────────────────────────┐    |
|  │  [●]  MORTIFY                          │    |  <-- currently selected
|  │  Start of each wave, lose 2 HP;        │    |
|  │  your units gain +1 ATK that wave.     │    |
|  │                                        │    |
|  │  ── balanced ──                        │    |  <-- design-axis tag
|  └────────────────────────────────────────┘    |
|                                                |
|  ┌─ VARIANT A — unlocked at T2 ────────┐      |
|  │  [○]  FLAGELLANT RITE                  │    |
|  │  Start of each wave, lose 4 HP;        │    |
|  │  your units gain +2 ATK & Bleed-1.     │    |
|  │                                        │    |
|  │  ── more risk, more reward ──          │    |
|  └────────────────────────────────────────┘    |
|                                                |
|  ┌─ VARIANT B — unlocked at T2 ────────┐      |
|  │  [○]  ASH-VOW                          │    |
|  │  No HP lost; your units gain +1 armor  │    |
|  │  that wave (no ATK buff).              │    |
|  │                                        │    |
|  │  ── defensive ──                       │    |
|  └────────────────────────────────────────┘    |
|                                                |
|  [   CONFIRM   ]   [  CANCEL  ]               |
|                                                |
+-----------------------------------------------+
```

**Annotations:**
- All three rows are visible **at every tier**, but A/B are dimmed and tagged "unlocked at T2" when locked. Keeps the system legible to new players and surfaces the W1 §3.2 design promise ("more shapes, same kit") *before* they earn it.
- The design-axis tag (`── balanced ──` / `── more risk, more reward ──` / `── defensive ──`) is the litmus-test surface. If those tags don't tell the truth, the variant is mis-tuned.
- Confirm writes to `GameState.warlord_loadout[warlord_id].passive_id`. No mid-run swap.

---

## 5. Screen D — Tier 3 alt-fire picker (modal)

Same layout pattern as C. Fires from Sig-spell row when Warlord is T3+.

```
+-----------------------------------------------+
|  [×]  CHOOSE SIG SPELL — VYRRUN               |
|                                                |
|  ┌─ DEFAULT (3 mana) ─────────────────────┐   |
|  │  [●]  SELF-SCOURGE                      │   |
|  │  Deal 3 damage to your strongest unit.  │   |
|  │  All your units +2 ATK this wave.       │   |
|  │  ── self-damage burst ──                │   |
|  └─────────────────────────────────────────┘   |
|                                                |
|  ┌─ ALT-FIRE (3 mana, T3) ────────────────┐   |
|  │  [○]  BONE-PAGEANT                      │   |
|  │  Force a Persist trigger now on every   │   |
|  │  friendly UNIT in your discard.         │   |
|  │  ── delayed swarm payoff ──             │   |
|  └─────────────────────────────────────────┘   |
|                                                |
|  [   CONFIRM   ]   [  CANCEL  ]               |
|                                                |
+-----------------------------------------------+
```

**Rules:**
- Same cost shown prominently on both rows — anti-P2W reinforcement (W1 §6). The player needs to *see* that the alt-fire costs the same.
- The design-axis tag describes the *axis rotation* (W1 §3.3): "self-damage burst" vs "delayed swarm payoff" — different shape, neutral expected-value.

---

## 6. Screen E — Tier 4 mastery payoff (one-shot modal)

Fires once per Warlord, the moment the XP-claim path crosses the T4 threshold. Skippable.

```
+-----------------------------------------------+
|                                                |
|              [✦ MASTERY ✦]                    |
|                                                |
|     PENANCE-CAPTAIN VYRRUN — TIER 4           |
|                                                |
|     +-----------------------+                  |
|     |                       |                  |
|     |  [MASTERY SKIN ART]   |   <-- new portrait, animated tilt
|     |                       |                  |
|     +-----------------------+                  |
|                                                |
|     "The Bleed-Saint of the Cathedral Ruins"  |   <-- mastery skin name
|                                                |
|     ─────────────────────────────────         |
|                                                |
|     Lore reveal (one-line):                   |
|     ┌──────────────────────────────────┐      |
|     │ The hammer was never the answer. │      |
|     │ The rope was. He just hadn't     │      |
|     │ found his own yet.               │      |
|     └──────────────────────────────────┘      |
|                                                |
|     ─────────────────────────────────         |
|                                                |
|     Title earned:  Mastered: Penance-Captain  |   <-- shows on social/leaderboard
|                                                |
|     Ascension slot unlocked:                  |
|     [A11 — Vyrrun: Bleed costs +1 mana]       |   <-- W1 §3.4 — harder game for cosmetic
|                                                |
|     [    CONTINUE    ]   [  SKIP  ]           |
|                                                |
+-----------------------------------------------+
```

**Rules:**
- This is the celebration moment. Allow VFX (gallows-rope tightens, mask cracks, dust). B3.x animation slot.
- The lore-reveal box is small, prose-only, never auto-played as voiceover at launch (voice slot per W1 §3.4 is post-launch).
- The Ascension-slot row is grim-flavoured: "the game now has a harder difficulty *just* for you, and the reward is bragging rights." This is the anti-P2W invariant given form.
- Closing the modal returns the player to wherever they were — usually Run Summary.

---

## 7. Screen F — XP-booster detail panel (drawer)

Slides up from the booster strip on either Screen A or Screen B. Surfaces the W3 §13 registry as a per-source breakdown.

```
+-----------------------------------------------+
|  [▾]   ACTIVE XP BOOSTS                       |
|                                                |
|  Effective:  +37% XP                          |
|  (max: +200%)                                 |
|                                                |
|  ┌────────────────────────────────────────┐   |
|  │  Battle Pass (premium)        +25% XP  │   |
|  │  ─ until season end ─                  │   |
|  ├────────────────────────────────────────┤   |
|  │  Equipped skin: Bleed-Saint    +5% XP  │   |
|  │  ─ active ─                            │   |
|  ├────────────────────────────────────────┤   |
|  │  Daily quest: Win w/ Vyrrun   +50% XP  │   |
|  │  ─ consumed on next Vyrrun win ─       │   |
|  ├────────────────────────────────────────┤   |
|  │  Starter bundle               +50% XP  │   |  <-- greyed: stack would overflow
|  │  ─ expired 2d ago ─                    │   |  <-- shows only if expired-recently
|  ├────────────────────────────────────────┤   |
|  │  Live-ops event                  —     │   |
|  │  ─ next event: Sat 04:00 ─             │   |
|  └────────────────────────────────────────┘   |
|                                                |
|  Math:  1.25 × 1.05 × 1.50 = ×1.97 effective  |   <-- small footer; geek audience only
|                                                |
+-----------------------------------------------+
```

**Rules:**
- One source row per registry entry. Greyed-out rows = expired or stack-overflow contribution.
- The "Math" footer is the only place multiplier notation appears in the UI — it's the explainer, not the headline. Keeps the `+X% XP` lock from §1 intact while still letting Paul-style users see what's happening.
- When the cap *clamps*, show `+200% XP (max)` at the top and the row(s) that overflowed get a `— capped —` chip next to them. Closes W3 §13 Q1.

---

## 8. Engine handoff (for W5 + B2.10)

Signals this UI needs from `GameState` (W5 work — names are suggestions):
- `signal warlord_xp_gained(warlord_id: StringName, amount: int, multiplier_applied: float)` — repaints XP bar + flash on Screen B.
- `signal warlord_tier_changed(warlord_id: StringName, new_tier: int)` — fires Screen E if new_tier == 4; otherwise just repaints dot ladder on Screens A + B.
- `signal xp_multiplier_changed(source_id: StringName, value: float)` — repaints Screen A booster strip + Screen F drawer rows.
- `signal xp_multiplier_consumed(source_id: StringName)` — Screen F removes the one-shot row (daily quest) with a small "consumed" animation.

State the UI reads (no signals, just on-mount):
- `GameState.warlord_xp: Dictionary[StringName, int]` — per-Warlord cumulative.
- `GameState.xp_multiplier_sources: Dictionary[StringName, float]` — for Screen F.
- `GameState.warlord_loadout: Dictionary[StringName, Dictionary]` — currently selected passive + alt-fire per Warlord (filled by Screens C + D).
- `Warlord.tier_unlocks: Array[Resource]` — names for the next-unlock teaser (Screen B) and the mastery payoff (Screen E).

The W1 §5 Resource shape is unchanged — this wireframe slots into it 1:1.

---

## 9. Anti-pay-to-win audit (UI surface)

Re-applied at the UI layer because UI is where players *feel* P2W, even if the data layer is clean.

- ✅ Tier ladder shows **dots, not stats**. No "Tier 3 grants +5% damage" anywhere.
- ✅ T2 variant picker (Screen C) shows the **default option side-by-side with A/B** — the new player is never shown a "locked, stronger" path. The locked path is *different*, not bigger.
- ✅ T3 alt-fire picker (Screen D) shows the **same mana cost on both rows**, in equal type weight. Visual contract: "same cost, different shape."
- ✅ Mastery payoff (Screen E) headline reward is a **cosmetic + a *harder* Ascension slot**. The reward for mastering Vyrrun is permission to play a harder Vyrrun, not a stronger Vyrrun.
- ✅ XP booster drawer (Screen F) shows the **cap clamp** explicitly. Whales don't get a magic experience. The cap is visible to all players.
- ✅ Locked paid Warlords on Screen A show price chips, **never stat previews**. There is no "look at how strong this paywalled Warlord is" surface.

---

## 10. Open questions for Paul

1. **Tier-2 dropdown vs. cards** — Screen C uses radio-list cards. Alternative: dedicated full-screen picker that big-art's each variant. Cards are faster, full-screen is sexier. Lean: cards for v0 (we'll see at B3.x art pass whether the variant needs more visual real estate).
2. **Mastery skin reveal pacing** — Screen E currently lands all four payoff blocks at once. Alternative: stagger them as a 3-second reveal sequence (skin → name → lore → title → Ascension slot). Lean: stagger, but defer the timing tuning to B3.x.
3. **Booster strip persistence** — Screen A always shows the strip. Should it also persist on the in-run HUD so the player feels the boost while playing? Risk: HUD clutter. Lean: NO on HUD, YES on every meta-screen (Hub, Warlord-select, Run Summary).
4. **W10/W11 visibility on Screen A** — currently W11 shows as silhouette + unlock hint. Should W10 (The Last Confessor) also silhouette-lock, or show standard locked-paid card? W10 is paid-but-not-lore-locked; lean standard. Confirm.
5. **Display-string lock** — I've locked `+X% XP` (§1) without explicit Paul sign-off. If the call's wrong, this wireframe + W3 §13 + the booster strip all change to `×N`. Cheap fix at this stage; expensive fix once B4 SDK + W5 engine wire to one form. Confirm before W5.

---

## 11. What this is and isn't

**This is:** the screen list, the layout boxes, the signals the screens need, and the anti-P2W rules the UI must honour. An engineer can scaffold these screens against the W1/W3 data contracts using only this doc + the existing `Warlord` resource + the registry-Dictionary signals.

**This is not:** visual design, motion design, colour, font, faction skinning on the panels, or accessibility audit. Those land in B3.x once the art pipeline (D-VALIDATE-1 unblock) is producing real assets.

**This is not blocking:** any other backlog item. W5 (engine wiring) can build the signals against this contract; B2.10 (end-to-end smoke test) doesn't surface the tier UI at all in IMV-1; B3.x art pass picks this up when it has assets to slot in.

**Next:** if Paul greenlights, W5 builds the `Warlord.tier_unlocks` resource + the `GameState.xp_multiplier_sources` registry + the four signals above. The wireframe stays a doc; the UI scenes get authored against it post-B2.10.
