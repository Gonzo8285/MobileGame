# Art direction — The Curse of Gallowfell

_Drafted 2026-05-02 by Cowork. Lives at the front of the design pipeline so B3 art generation has a single source of truth. Paul fills the open-prompt sections with references; Cowork translates each into AI-pipeline guidance (model choice, prompt template, negative-prompt list, LoRA candidates) before B3.0 starts._

## 0. What's locked in already

- **Setting:** grimdark fantasy. Fictional gallows-town named Gallowfell, cursed by a wrongful execution. Five factions converged on it. See `lore_gallowfell.md`.
- **Mood:** doom-haunted, gallows-humour edge, low magic but the magic that exists is wrong. PEGI 12 cap — implication, not gore.
- **Camera / format:** portrait phone (1080×1920). Cards held in hand at bottom; 3-lane combat board above; map navigation between combats. No 3D, no cinematics.
- **Per-faction visual cues** (in `faction_bible.md` + `warlords_v1.md`):
  - Iron Penitents — execution-mask brass, flayed-back motif, hammer + rope
  - Ash-Mourners — court robes turned to grave-shrouds, ink-stained fingers, raven quill, no shadow
  - Coven of the Black Mire — bog-witch silhouette, demon-coin wreaths, three teeth, three shadows
  - The Last Legion — soot-blackened cuirass, brass officer gorget, ironwood baton, chain-bound hair
  - Skinward Pact — antler crowns sprouting through bone, hide cloaks, smoke-trailing fingers
- **Working palette assumption (not locked):** desaturated overall, faction-specific accent colour does the lifting (rust-red Penitents, dusk-purple Mourners, bog-green Coven, brass Legion, bark-brown Pact). Currently mirrored in CardView placeholder tints.

## 1. Render style — LOCKED 2026-05-02 from Paul's references

**Direction: MTG-painterly oil × Phyrexian body-horror × Elden Ring doomed grandeur × BG3 painterly portraiture.** Photographic depth, low-key lighting, muted earth-tone palette with faction accent.

Specifically NOT: Slay-the-Spire cartoony, Inscryption analog-grunge, Darkest Dungeon woodcut, Disco Elysium impressionist, anime/cel-shaded.

### 1a. MTG card references (Paul's picks)

- **Pinnacle:** Deathrite Shaman (Return to Ravnica) — Steve Argyle. Black-green graveyard utility. Anchors the entire visual language.
- **Phyrexian Infect deck refs:** Glistener Elf, Plague Stinger, Phyrexian Crusader (NPH/MM2 art era), Ignoble Hierarch (MH2 reprint frame), Thoughtseize (TSP/Theros art).
- **Lorwyn-block creatures:** Murderous Redcap, Kitchen Finks (folkloric grotesque, slightly comic, painterly).
- **Abzan ramp / persist Commander deck:** Pattern of Rebirth, Soul of the Harvest, Magus of the Order, Cauldron of Souls, Pattern of Rebirth (lush druidic-with-decay), Surrak and Goreclaw (mythic-creature scale).
- **Sacrifice / death-loop signature cards:** Melira Sylvok Outcast, Murderous Redcap, Bloodthrone Vampire, Viscera Seer, Blasting Station.

### 1b. Game refs (Paul's picks)

- **Baldur's Gate 3** — character-portrait closeups, painterly cinematic backgrounds, high fantasy with grimdark undertones, conversational lighting.
- **Dungeons & Dragons** (broad reference) — classical fantasy art tradition, faction-coded armour silhouettes, the painterly tradition that MTG inherits.
- **Elden Ring** — doomed grandeur, decayed beauty, sky-scraping ruins, gold-on-grey decay palette, oversized armour silhouettes, mythic scale, low-saturation cinematography.

### 1c. The mechanical thread (Paul's deck list signal)

Paul's collected references centre on **persist / sacrifice / return-from-graveyard / corruption-that-spreads.** This is not just visual — it's the central fantasy he wants to express. Translates directly to Gallowfell:

- **Persist mechanic for Ash-Mourners** is now a design priority. Lore-fit: Reanimation curse (`lore_gallowfell.md`) means dead don't stay dead. Mechanical fit: maps onto MTG's persist (return with -1/-1 counter) cleanly. Cards return at reduced stats; combos with sacrifice outlets and Hanging Hour curse boss-escalation.
- **Sacrifice + recursion combos** as Coven of the Black Mire's secondary archetype. Already partly in design (`archetypes_v0.md` C-Sacrifice-Combo). Lean harder.
- **Discard-as-resource** worth a design pass. A Warlord passive like "Cards in discard count as +1 resource toward unit summon cost" emulates the Deathrite-Shaman / graveyard-utility fantasy.

(Adding a backlog item to surface-up these mechanical opportunities into the GDD before B2.7 turn engine ossifies.)

## 2. Card frame — LOCKED 2026-05-02 — Marvel Snap-style minimal frame + cosmetic treatments

**Base frame:** minimal Snap-style overlay. Full-bleed painterly art (no frame around the art window). UI elements overlaid: cost in top-left circle, attack/HP in bottom-right circle, name + 1-line description in a translucent bar across lower-quarter, faction sigil small-corner.

**Why:** lets the MTG-painterly oil-paint art breathe (heavy MTG frames would fight the art). Mobile-readable at thumbnail size. Snap's iteration on this is mobile-tested across 30M+ players.

**Cosmetic treatment system (Snap pattern, mapped to Gallowfell):**

| Treatment | Effect | Unlock | Price tier |
|---|---|---|---|
| Default | base frame | free | — |
| **Faction frame** (×5) | base frame re-styled per faction (Iron Penitents brass border, Coven briar-tangle, etc.) | earned via faction-loyalty milestones | free, 1-per-faction |
| Foil | static sparkle highlight | gacha + low-tier IAP | $2.99 |
| Gold | metallic gold treatment | mid-tier IAP + season pass | $9.99 |
| Ink | monochrome alt-art version | season pass premium | $14.99 |
| Prism | rainbow-shimmer animated overlay | high-tier IAP + battle pass+ | $19.99 |
| Cursed (limited) | green-pyre flame animated overlay, Hanging Hour event-exclusive | event-only, 14-day window | $14.99 ltd |
| Ultimate | combo of Gold + Prism + animated highlight | top-tier whale SKU | $49.99 |

**Treatments STACK with art variants** — alt-art card editions (different artist's take on same card) are a separate axis. Future expansion: 3 art variants × 7 treatments = 21 cosmetic versions per card. Per-card lifetime value: very high, with zero gameplay-balance impact.

**Anti-P2W audit:** all treatments are visual-only. Card stats / costs / keywords identical across treatments. Whale who buys Ultimate-everything has the same gameplay power as a F2P player. ✓

### Faction-frame visual language (spec for B3.2 frame author)

| Faction | Base frame motif | Accent metal | Border element |
|---|---|---|---|
| Iron Penitents | brass execution-mask top-arch | tarnished brass | hammer-and-rope corner motif |
| Ash-Mourners | shroud-pleat top + raven-quill flourish | corroded silver | ink-stain bleeding into the lower bar |
| Coven of the Black Mire | briar-tangle corners | bog-iron green-rust | three-shadow under name bar |
| The Last Legion | foundry-rivet top + soot-smear edges | smoked brass | chain-link border accent |
| Skinward Pact | antler-arch top + bark-grain edges | bone-white + bark | ivy-leaf accent corners |

## 3. Animation style — LOCKED 2026-05-02 — Idle-loop sprite animation (mid tier)

Each unit + enemy gets a **2–4 frame breathing/idle loop** while standing on the lane. Slay-the-Spire animation tier — adds life without burning the budget. Cards in hand stay static (the cosmetic treatments add sparkle/glimmer so they don't feel dead). Particle FX and screen-shake handle combat impact.

**Implications for B3 pipeline:**
- AI image gen produces a single hero frame per unit. Idle-loop frames are derivatives — generated by re-running through a controlled-variation pass (small pose/breath shift) OR by manual photo-bash-style adjustment in post.
- Boss units get 4 frames (slightly more presence). Common units get 2 frames.
- Total animation budget per unit: ~2 minutes of pipeline time per frame after the hero is locked.
- Animation triggers: idle (always), attack-windup (1 frame swap on attack), death (replace with crumbling/dissolve sprite). NO walk cycle (TD enemies advance via tile-snap, not pixel-walk — looks fine and saves enormous animation budget).

## 4. UI typography — Paul, fill this in

Two slots: **headline** (card names, screen titles) and **body** (card text, dialog, stats).

- [ ] **Headline candidates:** _Cinzel / Cormorant Garamond / IM Fell English / Pirata One / custom hand-drawn? Or a free Google Font you've seen on a game you like — link it._
- [ ] **Body:** _generally a clean serif or humanist sans. Slay-the-Spire uses Kreon. Inscryption uses a typewriter mono. Pick a vibe._

All Google Fonts are free + commercially usable.

## 5. Audio reference (parking spot — answers in B6+ phase)

Out of scope for B3 art but worth noting whatever vibe you want — Diablo-style chant, Witcher-style fiddle, Hollow Knight ambient, etc.

- _your refs here_

## 6. AI pipeline implications (Cowork fills this once §1 lands)

Once Paul commits style refs, Cowork maps them to:
- Base model (SD 1.5 / SDXL / Flux Schnell / Flux Dev — 4GB VRAM constraint per `project_gaming_app_hardware.md`)
- Style LoRA candidates (Civitai search by ref-name)
- Master prompt template per faction
- Negative prompt baseline (no anachronisms, no modern artifacts, no gore beyond PEGI 12)
- Sample card-frame template prompt
- Validation checklist (does it sit on a card? readable at thumbnail size? consistent palette across the same faction?)

## 7. Iteration loop (proposal — Paul approves)

1. Paul fills §1–§4 above (or pastes references in chat; Cowork transcribes).
2. Cowork generates a 9-tile reference sheet (3 sample cards × 3 factions) using the chosen pipeline.
3. Paul approves / iterates the sheet.
4. Once locked: Cowork batch-generates the full faction art set (~100 cards × 5 factions = 500 images) before B3 ships.
5. Cowork authors the matching card frame + UI elements once the visual lock is in.

The 9-tile sheet is the cheap commit point — burns ~30 mins of GPU time, surfaces any style mismatch before we generate 500 images.

## Open questions that don't fit elsewhere

1. **Will the game ever animate the *art* on a card?** (e.g. card flips, breathing portrait). Or is the card a static thumbnail and only the *board unit* animates?
2. **Card backs** — single design or 5 faction-specific backs?
3. **Day/night / Hanging Hour visual shift** — when the Hanging Hour curse kicks in mid-combat, does the whole screen tint? Or just the affected cards/units? Worth a separate spec line.
4. **Boss art tier** — should bosses get 2–3× the art budget (custom illustration, not pipeline-generated) to feel hand-crafted? Standard in this genre.

---

## 8. Card schema icon paths — clarification (2026-05-28, Cowork)

The `Card` schema (`game/src/data/card.gd`) defines two art-related fields that have caused mild confusion:

- **`art_path: String`** — `res://` path to the **card portrait** (the large oil-painted illustration on the card body). Populated for 203/203 cards at 512×768 webp under `game/assets/cards/<faction>/`. Rendered by `card_view.gd` as a portrait `TextureRect` behind the text overlays.
- **`icon_path: String`** — `res://` path to a **small compact icon** for hand/deck-list views. Currently empty on every card; consumed by `theme_pack_manager.gd` (lines 165, 176-177) which bundles it for theme-pack UI and falls back gracefully on empty.

Distinct from both of the above are the **per-keyword + per-stat UI icons** sourced from game-icons.net per `ART_INTEGRATION.md`: those live at `game/assets/icons/{kw_*,stat_*}.svg`, are NOT per-card, and feed the keyword strip + stat row inside `card_view.gd`.

**AC9 resolution (Phase 2.17, Cowork 2026-05-28):** `icon_path` is **kept, documented as intentional, and remains empty per card until the theme-pack UI surfaces a compact list view that genuinely needs a per-card thumb crop.** When that lands, the populate step is: generate a 128×128 webp crop of the existing portrait → `game/assets/icons/cards/<id>.webp` → populate `icon_path` via a script in `pipeline_setup/` mirroring `populate_art_path.py`. Until then, the empty value falls through theme_pack_manager's existing null-check (line 176) and no UI breaks.
