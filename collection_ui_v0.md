# T4 — Collection screen UI mock v0

_Authored 2026-05-13 by heartbeat. Phase 2.10 placeholder wireframe for the per-card treatment chooser. Visualises the screens that surface the T1 data model (`Card` + `CardInstance` + `TreatmentCatalog`), the T2 shader stack, and the T3 faction frames so an engineer can build the collection-screen scenes against a single layout and Paul can eyeball whether the cosmetic monetisation surface reads right. ASCII-first; real visual design lives in B3.x after the art pipeline is hot._

## 0. Scope + non-goals

**In scope (v0):**

- Collection roster grid (entry screen) — browse owned cards, filter by faction / owned-only / treatment-owned.
- Card detail panel — big art slot rendered through the live shader stack, owned + locked treatments listed.
- Treatment chooser modal — switch the live treatment between owned options (visual-only, no gameplay impact).
- Locked-treatment unlock detail panel — surfaces the acquisition path for each locked tier (loyalty milestone / gacha / IAP / season pass / event window).
- Display-string and visual conventions that match the W4 Warlord-select screen so the two screens feel like one app.
- Anti-P2W audit at the UI surface layer.

**Out of scope:** colours, fonts, real card art, animation timing, controller-vs-touch input layer, accessibility audit, save-load wiring, deck-builder integration (deferred — B2.10's smoke test only proves a run; the deckbuilder caller lands in IMV-2). T4 is the placeholder mock backlog asks for, not the production scene.

**Aspect ratio assumption:** portrait phone, 9:19.5 (modern iPhone/Android), 1080×2340 working canvas. ASCII below is rough proportional — boxes ≠ pixels.

---

## 1. Display-string and visual conventions (mirrors W4 §1)

- **Owned vs locked**: solid frame border = owned; dashed border + 🔒 = locked. Same convention as the Warlord roster.
- **Price-tier badge**: locked treatments show their acquisition path as a single-line badge in the form `[<source-icon> <hint>]`. Examples:
  - `[💎 $2.99]` — direct IAP
  - `[🎟 Season Pass premium]` — battle-pass premium track
  - `[🎲 Gacha drop]` — RNG drop from any gacha bundle
  - `[🏆 Faction loyalty (Iron Penitents)]` — earned, free
  - `[⏳ Event — Hanging Hour, 14 days]` — event-limited
- **Combo treatment (Ultimate)**: only enabled if every `combines` id is owned (catalog reads `[&"gold", &"prism"]`). Otherwise the Ultimate tile lists the missing prerequisites inline.
- **New badge**: instances where `acquired_at` is within the last 24 h render a corner `NEW` pip on the roster tile. Cleared by first detail-panel view.
- **Tier ordering**: 0 Default → 1 Faction frame → 2 Foil → 3 Gold → 4 Ink → 5 Prism → 6 Cursed → 7 Ultimate. Matches `GFEnums.TreatmentTier` and the order in `treatment_definitions.tres`.
- **Anti-P2W banner**: a single quiet line at the bottom of the chooser modal — `"Cosmetic only. Treatments never change card stats or rules."` Lifts directly from the audit in `art_direction.md` §2 and `card_treatment.gd` docstring. Cheap insurance that store-review reads this UI as PEGI 12-clean.

---

## 2. Screen A — Collection roster grid (entry screen)

The screen the player lands on when tapping Collection from the main hub. Defaults to all owned cards across all factions, sorted by faction then cost.

```
+-----------------------------------------------+
|  [<]  COLLECTION                     [⚙]      |
|                                                |
|  Owned: 184 / 216 cards · Treated: 23          |   <-- counter strip
|                                                |
|  [ Faction ▾ ]  [ Treated only ☐ ]  [ Sort ▾ ] |   <-- filter bar
|                                                |
|  IRON PENITENTS  (40 / 40 owned)               |
|  +-----+ +-----+ +-----+ +-----+               |
|  | P1  | | P2  | | P3  | | P4  |               |
|  |[ART]| |[ART]| |[ART]| |[ART]|               |   <-- mini card thumbnails
|  | 1c  | | 2c  | | 2c  | | 3c  |               |
|  | ✦   | |     | | ✦✦  | |  NEW|               |   <-- ✦ = treatment count
|  +-----+ +-----+ +-----+ +-----+               |
|  (... 36 more ...)                             |
|                                                |
|  ASH-MOURNERS  (38 / 40 owned)                 |
|  +-----+ +-----+ +-----+ +-----+               |
|  | M1  | | M2  | | M3  | |  ?  |               |
|  |[ART]| |[ART]| |[ART]| |[SIL]|               |   <-- unowned = silhouette
|  | 1c  | | 1c  | | 2c  | LOCK🔒|               |
|  +-----+ +-----+ +-----+ +-----+               |
|                                                |
|  (... Coven / Last Legion / Skinward Pact ...) |
|                                                |
+-----------------------------------------------+
```

Notes:

- Tap any tile → Screen B (detail panel).
- ✦ pips count owned non-default treatments on that card (max 7: Faction frame + Foil + Gold + Ink + Prism + Cursed + Ultimate). Up to 5 pips visible; "✦✦✦✦✦+" if 6 or 7.
- Unowned cards stay visible as silhouettes — surfaces the collection completion drive (Day-30 retention hook per `phase1_brief.md` R8). Tap on a silhouette goes to Screen B in "preview" mode (no treatments listed, just card text + acquisition hint).
- Filter bar `Treated only` checkbox surfaces only cards with at least one non-default treatment — convenience for cosmetic-flex players reviewing their own collection.

---

## 3. Screen B — Card detail panel (with live shader stack)

Opens when a tile from Screen A is tapped. Shows the card art at near-full size with the currently-applied treatment live-rendered.

```
+-----------------------------------------------+
|  [<]  Cathedral Brother           P1 · Common |
|                                                |
|  +-------------------------+                   |
|  |                          |                   |
|  |                          |                   |
|  |      [BIG CARD ART]      |                   |   <-- rendered via T2 shader
|  |   live treatment stack   |                   |        stack on the card_view scene
|  |                          |                   |
|  |   cost 1   atk 2   hp 1  |                   |
|  +-------------------------+                   |
|                                                |
|  Iron Penitents · Unit · Melee                 |
|  Bleed 1.  Cleaves on overkill.                |   <-- rules text (read-only)
|                                                |
|  ─────────────────────────────────────────    |
|                                                |
|  TREATMENT                                     |
|  Current:  Foil                                |   <-- active label
|  [ Change treatment ▸ ]                        |   <-- opens Screen C
|                                                |
|  Owned (3):  Default · Iron Penitents · Foil   |
|  Locked (4): Gold · Ink · Prism · Cursed · Ult |
|                                                |
|  ─────────────────────────────────────────    |
|                                                |
|  Acquired: 2026-04-22 · via Starter            |
|  Serial:    —                                  |   <-- only Cursed shows a serial
|                                                |
+-----------------------------------------------+
```

Notes:

- The art block is the real shader pipeline from T2, not a static image — proves the stack survives a full screen-redraw, frame change, and combine-resolution on the same scene.
- Rules text lives in a non-editable card-text panel. Combat code never reads from this screen; this is a read-only window onto `Card`. Anti-P2W invariant: there is no `Apply to deck` button here — applying a treatment to your deck-bound CardInstance happens in the deckbuilder, not the collection, so a swapped treatment is never confused with a stat change mid-run.
- `Owned` / `Locked` rows are summary; the full chooser is Screen C.
- The acquired-via metadata reads `CardInstance.acquired_via`. A `serial` ≠ 0 is only ever true for Cursed-tier instances (limited print serials, art_direction §2). When present it renders as `Serial: 0042 / 5000` and adds a small flex border to the art block.

---

## 4. Screen C — Treatment chooser modal

Opens when `Change treatment ▸` is tapped on Screen B. Slides up over the detail panel so the live art stays visible behind the modal — the player can preview the effect of any owned treatment by tapping a tile and watching the art update before confirming.

```
+-----------------------------------------------+
|                                          [×]  |
|  TREATMENT — Cathedral Brother (P1)            |
|                                                |
|  +----------+ +----------+ +----------+       |
|  | DEFAULT  | | FACTION  | | FOIL     |       |
|  | [thumb]  | | [thumb]  | | [thumb]  |       |
|  | owned    | | owned    | | owned ✦  |       |   <-- ✦ = currently-applied
|  | tier 0   | | tier 1   | | tier 2   |       |
|  +----------+ +----------+ +----------+       |
|                                                |
|  +----------+ +----------+ +----------+       |
|  | GOLD     | | INK      | | PRISM    |       |
|  | [thumb]🔒| | [thumb]🔒| | [thumb]🔒|       |   <-- locked
|  | tier 3   | | tier 4   | | tier 5   |       |
|  | 💎 $9.99 | | 🎟 Pass  | | 💎 $19.99|       |   <-- acquisition badge
|  +----------+ +----------+ +----------+       |
|                                                |
|  +----------+ +----------+                    |
|  | CURSED   | | ULTIMATE |                    |
|  | [thumb]🔒| | [thumb]🔒|                    |
|  | tier 6   | | tier 7   |                    |
|  | ⏳ Event | | needs Gold|                   |   <-- combo prereq surfaced
|  |  14 days | | + Prism   |                   |
|  +----------+ +----------+                    |
|                                                |
|  [ Apply ]                  [ See unlock ▸ ]   |
|                                                |
|  Cosmetic only. Treatments never change card  |
|  stats or rules.                              |   <-- anti-P2W banner
+-----------------------------------------------+
```

Notes:

- Tap an owned tile → live-preview the treatment on the art behind the modal. Apply commits it to this CardInstance.
- Tap a locked tile → live-preview too (treat the player to the visual they'd be buying), but `Apply` is disabled and `See unlock ▸` lights up — routes to Screen D for that specific locked tier.
- Ultimate prereq surfacing reads `treatment.combines` and looks each id up against `CardInstance` ownership. The chooser is the only place the prereq is computed; once both prerequisites are owned, the tile flips to `[ Buy Ultimate · 💎 $49.99 ]` without a re-render.
- Faction Frame tile only appears if the card's faction matches a faction-frame treatment the player has earned (`faction_filter` ↔ `card.faction`). For multi-faction cards (currently none in v1 but the engine supports it) the tile becomes a dropdown — `Iron Penitents / Coven` if both loyalties are met.
- The modal is dismissible by [×] and by swipe-down; no commit happens until `Apply` is tapped, so the live-preview is a true preview.

---

## 5. Screen D — Unlock detail panel

Opens when `See unlock ▸` is tapped on a locked tile, or when a silhouette card from Screen A is tapped. The single place the storefront, the season pass, and the event calendar all surface from. Keeps the rest of the collection UI clean.

```
+-----------------------------------------------+
|  [<]  Unlock GOLD                              |
|                                                |
|  +-------------------------+                   |
|  |   [BIG PREVIEW ART]      |                   |   <-- same shader stack, GOLD applied
|  |   live preview           |                   |
|  +-------------------------+                   |
|                                                |
|  Gold treatment                                |
|  Metallic gold HSV-shift across the art with   |
|  metallic mask. Mid-tier whale-bait.           |   <-- pulls from treatment.description
|                                                |
|  HOW TO GET IT                                 |
|                                                |
|  ◉ Direct purchase                             |
|    Mid-tier IAP bundle              💎 $9.99   |
|    [ View bundle ▸ ]                           |
|                                                |
|  ◉ Season Pass · current season                |
|    Awarded at premium track tier 22 of 50.     |
|    You are on tier 14.                         |
|    [ View pass ▸ ]                             |
|                                                |
|  ─────────────────────────────────────────    |
|                                                |
|  This is a cosmetic. Owning Gold does not      |
|  change how Cathedral Brother plays.           |
|                                                |
+-----------------------------------------------+
```

Notes:

- One panel per locked tier; the section list (`Direct purchase` / `Season Pass` / `Gacha` / `Event window`) lights up based on what `unlock_method` says + which monetisation surfaces are live this season.
- Cursed-tier event variant: the `HOW TO GET IT` block becomes a single section with a countdown clock and the event banner. After the window closes, the panel becomes a read-only "Last available: 2026-MM-DD" line — Cursed never re-enters the standard storefront (per `monetisation_map.md` event-tier locking). Reroll-protection wording lifts the same line `monetisation_map.md` already authored.
- Ultimate variant: the panel shows two prereq tiles inline (Gold + Prism), each tapping through to its own Screen D — once both are owned the panel flips to a single `[ Buy Ultimate · 💎 $49.99 ]` row.
- The anti-P2W reminder ("This is a cosmetic. Owning X does not change how Y plays.") is keyed off the treatment id + card so it reads naturally per page. Generic fallback: "This is a cosmetic. Treatments never change card stats or rules." (Same line as Screen C.)

---

## 6. Engine handoff sketch (for T4 follow-on engineering)

Pure UI signals — no monetisation state reads here. The engine wiring is identical-shape to the W4 → W5 handoff so the same patterns apply.

```
GameState
  ├─ collection: CardCollection (RefCounted, owns Array[CardInstance])
  └─ signals:
       ├─ treatment_applied(card_id: StringName, treatment_id: StringName)
       ├─ treatment_acquired(card_id: StringName, treatment_id: StringName, acquired_via: StringName)
       └─ collection_filter_changed(filter: Dictionary)   # diagnostic only

CollectionView (Control)
  ├─ reads CardCollection + TreatmentCatalog (loaded once at boot from
  │       res://data/treatments/treatment_definitions.tres)
  └─ pushes:
       ├─ on Apply  → CardCollection.set_treatment(instance, treatment_id)
       │              → emits treatment_applied(...)
       └─ on Buy    → routes to the storefront scene (out of T4 scope) and
                      passes the desired SKU id; on purchase confirm,
                      CardCollection.grant_treatment(card_id, treatment_id, acquired_via)
                      runs once → emits treatment_acquired(...)
```

Anti-P2W invariants the engineer must preserve:

1. Combat code never queries `treatment_id`. The `_on_unit_killed`, `TurnEngine`, `RewardGenerator` paths must keep reading `card` only.
2. `set_treatment` writes to `CardInstance`, never to `Card`. The shared gameplay `Card` Resource is never mutated by cosmetic state.
3. Combo-treatment ownership is computed on-the-fly from `CardInstance` ownership — never persisted, never authoritative. Removes the only place an exploit-path could mint an Ultimate by editing a save.

---

## 7. Open questions for Paul (none block T4 itself)

1. **Filter precedence**: when `Treated only ☐` is on AND a faction filter is selected, do we AND them (only treated cards in that faction) or OR? Default lean: AND, matches Snap.
2. **Silhouette acquisition hint**: how loud do we make the "you don't own this card" hint on Screen A? Lean A is a single small `?` glyph + a faction tint so the silhouette still feels collection-art-worthy; Lean B is a `LOCKED` ribbon banner.
3. **Storefront routing on Screen D**: do we open the storefront as a modal-over-collection (preserves back-stack) or as a full scene swap (cleaner navigation but more taps to get back to the card)? Lean: modal-over.
4. **Cursed serial visibility on Screen B**: a "Serial: 0042 / 5000" line is a strong collector flex. Do we want it always-on for Cursed instances, or hidden behind a toggle? Lean: always-on, it's the entire reason a player buys a numbered limited.
5. **Faction-frame UX for hypothetical multi-faction cards**: do we ever expect cards belonging to more than one faction? Currently no, but the engine `faction_filter` allows it. If never, drop the dropdown branch in §4. If possible, keep it.

None of these block downstream work. Defaults above ship a coherent v0.

---

## 8. Slot in the bigger picture

T4 closes Phase 2.10 once Paul eyeballs the wireframe. Phase 2.10 sequence now reads: T1 data model ✅ → T2 shader stack ✅ → T3 faction frames ✅ → T4 UI mock (this doc) → ready for B3.x to start painting against a known-shape engine + UI. The next monetisation-surface UI doc to author is the **storefront** itself (currently no `storefront_ui_v0.md`), but per Paul's IMV-1 trim the real ad/IAP SDK is deferred to IMV-2 so storefront wireframes can wait.
