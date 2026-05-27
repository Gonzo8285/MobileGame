# Theme Packs system v0 — The Curse of Gallowfell

_Authored 2026-05-25 by Controller (round 5). New orthogonal cosmetic surface above the alt-arts / treatments / frames stack already locked in `variants_system_v0.md`. A theme pack is a **complete card-art + frame + name + flavour-text re-skin** layered over the mechanically-identical underlying card. Mechanics never change. Only presentation. Paul's "PvP + extended modes + Game-of-Thrones-grimdark-style theme" round mandate._

**Status:** v0 draft. **Anti-P2W invariant locked.** **IP rule paramount** (see §0). Pending Paul sign-off on Open Qs at the bottom.

---

## 0. IP rule (read this first — applies to every entry in §3)

Three categories for every theme idea in this doc. **Every entry below is explicitly tagged.**

1. **PUBLIC-DOMAIN SAFE** — ship freely. Brothers Grimm, classic horror (Dracula/Frankenstein/Wolfman/Jekyll-Hyde/Phantom), Lovecraft pre-1929, Norse / Greek / Egyptian / Mesopotamian / Aztec / Polynesian myth, Arabian Nights, Arthurian legend, generic pirates / ninjas / samurai / gladiators / vikings / steampunk / cyberpunk / westerns.

2. **LICENSED IP — DO NOT SHIP.** Pirates of Dark Water (Warner/Hanna-Barbera). LOTR / Middle-earth (Tolkien Estate). Wizarding World / Harry Potter (Warner / Rowling). Marvel / DC / Disney / Star Wars / Game of Thrones — anything with a corporate owner. These may appear as **internal inspiration** in this doc but must never appear in customer-facing copy. Use safe analogues.

3. **ORIGINAL** — invented for Gallowfell. Always safe. Hold the Gallowfell IP.

**Hard rule:** every theme name in the launch catalogue must be ownable in a TM sense — i.e. the name itself must not be a franchise word, character, or location belonging to category 2. Where this doc references a category-2 IP as "internal flavour direction", that is internal-only and is stripped before any customer-facing copy.

---

## 1. What a theme pack IS

> A `theme_pack` is a complete card-art + card-frame + card-name + card-flavour-text re-skin layered over the mechanically-identical underlying card. Mechanics never change. Only presentation.

A player owns 0+ theme packs. Default = the canonical Gallowfell theme (free, always owned). Per-card application enables mix-and-match decks (half-pirate, half-cosmic-horror is a legal loadout). Deck-wide application paints the whole deck in one theme.

**Boundaries (locked):**

| Question | Answer |
|---|---|
| Can a theme swap card **names**? | **Yes.** Player-visible name swaps; `card_id` stays stable for combat, replay, PvP, achievements, leaderboards. |
| Can a theme swap card **mechanics**? | **No, never.** Combat code reads `Card`, not `ThemeTreatment`. |
| Can a theme swap **board background + UI elements**? | Yes, optional bundled "Full Theme" SKU. Sold separately from the card-art pack. |
| Can themes be **combined** (half pirate, half cosmic horror)? | **Yes** — per-card application enables this. UI surfaces the combo in the Cosmetic Library. |
| Can a theme change **VFX / SFX**? | Yes, optional per-faction; sold as a Theme Audio Pack add-on. |
| Can a theme change **gameplay balance, drop rate, achievement progress, leaderboard rank**? | **No.** Cosmetic-only. Anti-P2W invariant. |
| Can a theme be **applied during PvP**? | Yes (cosmetic — opponent sees your themed cards, but `card_id` and tooltip-original-name remain queryable). |

**Why this exists:** Marvel Snap's lesson — cosmetic-treatment economy is the biggest whale-LTV vector in F2P card games (£40-100M+ ARR per `competitive_landscape_v0.md` §1.4). Theme packs are the next tier *above* alt-arts — instead of one card re-art, you re-skin the entire game-world. Big enough to justify £3.99-£7.99 IAP. Big enough to anchor a season narrative arc (see `season_pass_v2.md`).

---

## 2. Data model

### 2.1 Theme pack record

```
class_name ThemePack extends Resource

@export var id: StringName            # e.g. "grimm_reaping"
@export var display_name: String      # "The Grimm Reaping"
@export var category: StringName      # "public_domain" / "original" / "licensed_blocked"
@export var era: String               # "fairytale_folk_horror" / "norse" / "lovecraftian" / etc
@export var palette: Array[Color]     # 5-7 hex anchors
@export var fonts: Dictionary         # { card_title: font_path, card_body: font_path }
@export var status: StringName        # "art_complete" / "art_stubbed" / "roadmap"
@export var price_tier_gbp: float     # 0.0 / 3.99 / 5.99 / 7.99
@export var bundle_includes_board: bool = false
@export var bundle_includes_back: bool = false
@export var bundle_includes_avatar_frame: bool = false
@export var pass_plus_free_in_season: StringName = &""  # e.g. "season_1" — free for Pass+ S1
@export var subscription_quarterly_free: bool = false   # Ascendant Pact free-of-quarter
```

### 2.2 Per-card treatment record

```
class_name CardThemeTreatment extends Resource

@export var card_id: StringName              # FK to Card.id (stable underlying mechanic)
@export var theme_pack_id: StringName        # FK to ThemePack.id
@export var art_path: String                 # 832×1166 canvas per art_direction.md
@export var display_name: String             # e.g. "The Pyre-Piper" (re-skin of Ash Speaker)
@export var flavour_text: String             # 1-line, ≤120 chars
@export var frame_variant: StringName        # "grimm_bramble" / "iron_crusade_heraldic" / etc
@export var sfx_variant: StringName = &""    # optional audio override id
```

### 2.3 GameState extensions

```
# Owned theme packs (Gallowfell canonical always present)
var owned_theme_packs: Array[StringName] = [&"gallowfell_canon"]

# Equipped per-card OR deck-wide
var equipped_theme_per_card: Dictionary   # { card_id: theme_pack_id } — sparse, only overrides
var equipped_theme_deck_wide: StringName  # &"gallowfell_canon" if no override; else theme_pack_id
var theme_application_mode: StringName    # "per_card" / "deck_wide" — single toggle

# Signals
signal theme_pack_acquired(id: StringName, source: StringName)
signal theme_pack_equipped(card_id: StringName, theme_pack_id: StringName)
signal theme_pack_applied_deck_wide(theme_pack_id: StringName)
```

### 2.4 Save format

```
# game_save.json additions
"theme_packs": {
  "owned": ["gallowfell_canon", "grimm_reaping"],
  "mode": "per_card",
  "deck_wide_active": "gallowfell_canon",
  "per_card_overrides": {
    "m3_ash_speaker": "grimm_reaping",
    "c4_three_shadows": "cosmic_drowning"
  }
}
```

### 2.5 Layering order (locked, top → bottom)

```
1. Treatment shader (Foil / Gold / Ink / Prism / Cursed / Ultimate)  ← variants_system §2
2. Alt-art variant                                                    ← variants_system §3
3. THEME PACK card art + frame + name + flavour                       ← THIS DOC
4. Canonical Gallowfell card (Card.gd resource)                       ← cards_*_v1.md
```

Treatments stay **on top** of theme. A Gold-treatment Pall-Bearer rendered in the Grimm theme = Gold shimmer over Grimm art over Pall-Bearer mechanics. The treatment shader uniform is theme-agnostic.

---

## 3. Launch catalogue — 12 themes

Mix of safe public-domain + Gallowfell-original. Every entry is explicitly tagged. Theme names below are TM-clean (none use a franchise word).

For each: **category** + **1-paragraph pitch** + **5 example card re-skins** (canonical card name → themed re-skin name → 1-line art direction).

---

### Theme 1 — **The Curse of Gallowfell** (canonical)

**Category:** ORIGINAL (Gallowfell-owned).
**Status:** art-complete (always shipped, free, default).
**Price:** Free. Always owned.

**Pitch:** The grimdark folk-horror tone the game already has. MTG-painterly oil meets Elden Ring grandeur, ash-grey / candle-gold / blood-red palette, gallows-town iconography. This is the canonical — every other theme is layered over the mechanically-identical card it re-skins, but Gallowfell-canon is what the game looks like out of the box.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | Ash Speaker (canonical) | hooded mourner clutching censer, soot streaks down face |
| p2 Whip Brother | Whip Brother (canonical) | flayed-back penitent with iron-knotted lash |
| c4 Three Shadows | Three Shadows (canonical) | three skeletal silhouettes around a bog-pool, demon-coins |
| l5 Iron Banner | Iron Banner (canonical) | tattered banner over field of slain; brass eagle finial |
| s7 Antler Sigil | Antler Sigil (canonical) | bone-carved antler driven into bark, pelt strips |

---

### Theme 2 — **The Grimm Reaping**

**Category:** PUBLIC-DOMAIN SAFE (Brothers Grimm fairy tales — pre-1857, all PD).
**Status:** art-stubbed at launch; first art-complete theme post-launch (proposed launch theme, see §6).
**Price:** £5.99 standalone / £8.99 bundle (with board + back + avatar frame).

**Pitch:** Brothers Grimm fairy tales reframed as folk horror — the version your grandmother told you to scare you into not wandering off the path. Red Riding Hood as Coven, Pied Piper as Ash Mourner, Bremen Musicians as Last Legion warband, Rapunzel's tower as Iron Penitents, Hansel-and-Gretel as Skinward Pact lost-children. Palette: blood-on-snow red, charcoal black, parchment cream, dried-flower green. Frame: bramble-and-thorn vines, hand-illuminated capital letters.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Pyre-Piper | tall thin piper in patchwork red-and-black, soot-charred pipe trailing smoke-children behind him |
| p6 Crowned Martyr | The Bramble Princess | woman bound by living thorns; crown of brambles drawing blood from forehead |
| c7 Bog Witch | Big Wolf's Granny | hag in nightcap with wolf-fangs visible under bonnet; cottage door splintered behind her |
| l3 Drummer Boy | Bremen Drummer | donkey-headed jester drumming on iron pot; dog/cat/rooster shadows behind |
| s4 Lost Child | Gretel of the Crumb-Path | child in patched dress trailing breadcrumbs into dark forest; gingerbread house silhouette |

---

### Theme 3 — **The Black Iron Sea**

**Category:** ORIGINAL (Gallowfell-owned). Generic pirate / nautical horror imagery — PD genre, original execution. **Internal inspiration only:** the "Pirates of Dark Water" thematic territory (Warner-owned, do not name in customer copy).
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Pirate / nautical horror. A cursed sea that drinks ships and spits out crews. Iron Penitents become anchor-chained press-ganged sailors; Ash Mourners become drowned-bell ringers; Coven becomes sea-witch cabal trading wishes for souls; Last Legion becomes mutineer-armada; Skinward Pact becomes leviathan-bound flesh-changers. Palette: black-iron grey, sea-foam green, brine-rust orange, lantern-amber. Frame: rope-coil and anchor-chain border with barnacle accents.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m11 Funeral Bell | The Drowned Bell | bell encrusted with barnacles, half-submerged; rope vanishing into black water |
| p2 Whip Brother | The Press-Gang Bosun | shirtless sailor with knotted cat-o-nine-tails, anchor-chain across shoulder |
| c4 Three Shadows | The Three Sirens | three figures in foam at the rail, lantern-light catching only their teeth |
| l1 Iron Banner | The Mutineer Flag | tattered black flag with white skull-and-noose (Gallowfell-original, not Jolly Roger) |
| s6 Wyrm-Bound | The Leviathan's Vow | tattooed sailor with kraken-arm replacing his own arm; sea spray |

---

### Theme 4 — **The Hollowing Hall**

**Category:** ORIGINAL (Gallowfell-owned). Kid-friendly magical-school adventure. **Internal inspiration only:** the "Wizarding World for children" tonal slot Paul wants — never named in customer copy. Custom school name "The Hollowing Hall" is Gallowfell-original.
**Status:** art-stubbed at launch.
**Price:** £3.99 standalone (lower-stakes tone, lower price tier).

**Pitch:** A bright, doodly, kid-friendly magical school where the lessons go wrong in fun-spooky ways. Reads as bright sketchy ink art, jolly stained-glass palette, doodled monsters in textbook margins. The grimdark of Gallowfell sanded smooth into "first scary book" tone. Iron Penitents = stern caretakers; Ash Mourners = ghosts of past students still doing their homework; Coven = potion-club; Last Legion = chess-club tournament knights; Skinward Pact = the wild-magic kids who keep turning into things. Palette: chalkboard navy, ink black, parchment cream, stained-glass red/blue/gold. Frame: doodled-margin sketch of imp-faces around a hand-illuminated initial. **Tone note:** the only theme in the launch catalogue that softens the grimdark; lets Gallowfell address a 9-12 audience without breaking the canonical world.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Ghost Tutor | translucent old wizard in dressing gown, still trying to mark essays, ink-stained fingers |
| p4 Hammer Confessor | The Caretaker's Hammer | grumpy man with iron mallet, lantern, cat at heel; broken statue behind |
| c4 Three Shadows | The Detention Triplets | three identical kids in patched school robes, all writing lines on a chalkboard |
| l3 Drummer Boy | The Chess-Tournament Page | child-knight on tiled floor, blunt practice-sword, banner of school colours |
| s5 Antler Sigil | The Wild-Magic Stag | child mid-transformation, antlers sprouting through cap, frightened classmates |

---

### Theme 5 — **The Cosmic Drowning**

**Category:** PUBLIC-DOMAIN SAFE (Lovecraft mythos pre-1929 — Cthulhu / Dagon / Hastur / Nyarlathotep / Innsmouth are all PD; Lovecraft died 1937, US works pre-1929 are PD; avoid post-1929 elements like Mountains of Madness).
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Lovecraftian cosmic horror. The curse of Gallowfell reinterpreted as a sleeper-god awakening beneath the seabed. Iron Penitents = cultists of the deep church; Ash Mourners = those who saw too much and now whisper to drowned things; Coven = star-witches reading non-Euclidean geometry; Last Legion = drowned navy regiment returning from below; Skinward Pact = those bargained with the deep ones, slowly turning fish-eyed. Palette: deep-ocean black, abyssal teal, bioluminescent green, drowned-bone white. Frame: tentacle-coil and non-Euclidean angle border, with glyphs that hurt to look at.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m6 Pyre Priest | The Deep Church Curate | robed figure with octopus-mouth, candle burning underwater, kelp-strands for hair |
| p6 Crowned Martyr | The Drowned Pope | tiara-crowned figure bound to deep-sea anchor, eyes black, mouth coral |
| c4 Three Shadows | The Hastur Triumvirate | three robed figures in yellow tatters; ragged king-sigil hovering above |
| l8 Iron Banner | The Drowned Regiment | underwater army standing in formation, sea-floor silt around feet, banner waterlogged |
| s6 Wyrm-Bound | The Innsmouth Convert | fish-eyed man halfway through transformation; gills sprouting on neck |

---

### Theme 6 — **The Ash Pantheon**

**Category:** PUBLIC-DOMAIN SAFE (Norse mythology — Odin / Thor / Loki / Fenrir / Hel / Ragnarok / Valkyries / Yggdrasil are all PD).
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Norse mythology re-skin. Ragnarok-eve as Gallowfell-the-gallows-town. Iron Penitents = Einherjar (Valhalla warriors); Ash Mourners = Hel's court (the dishonoured dead); Coven = Norns weaving fate; Last Legion = Loki's giant-army; Skinward Pact = berserkers (bear/wolf shape-takers). Palette: rune-iron blue-grey, frost-white, blood-on-snow red, gold-amber. Frame: knotwork runes, longhouse-beam corners, raven motifs. Wolf-Fenrir as boss-tier; Jormungandr as world-serpent set-piece.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Norn at the Loom | three-faced woman at loom, threads of fate spilling around her feet |
| p2 Whip Brother | The Berserker's Whip | bear-pelted warrior with iron-knotted scourge, frost on shoulders |
| c7 Bog Witch | Hel of the Half-Face | half-living half-corpse queen, throne of bone |
| l5 Iron Banner | The Einherjar Standard | golden eagle on storm-grey field; Valhalla longhouse silhouette |
| s7 Antler Sigil | The Wolf-Skinned | warrior mid-transformation into Fenrir-pup form |

---

### Theme 7 — **The Underworld's Maw**

**Category:** PUBLIC-DOMAIN SAFE (Greek mythology — all Olympian + chthonic + monster — fully PD).
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Greek underworld. Hades / Cerberus / Sisyphus / Charon / the Furies. Iron Penitents = Spartan hoplite phalanx of the dead; Ash Mourners = Furies and shade-priests; Coven = oracles at the bone-altar; Last Legion = Charon's ferrymen-army; Skinward Pact = satyr/centaur shape-bound. Palette: black-and-red Attic vase / Etruscan funerary fresco — black silhouettes on terracotta red, ochre gold accents. Frame: meander key-border (Greek key pattern) and laurel-wreath corners.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Sibyl at the Cleft | woman over chasm, breathing oracle-smoke, painted in Attic-vase silhouette |
| p2 Whip Brother | The Fury's Lash | winged fury with serpent-tail whip; blood-droplet motif |
| c4 Three Shadows | The Three Moirai | Klotho / Lachesis / Atropos — Attic-vase trio with thread, rod, shears |
| l11 Iron Banner | Charon's Standard | dark oarsman with banner-stern; River Styx visible behind |
| s7 Antler Sigil | The Cerberus Tongue | three-headed dog-warrior; collar of bones |

---

### Theme 8 — **The Iron Crusade**

**Category:** ORIGINAL (Gallowfell-owned). Crusader / holy-knight heraldry. **Internal inspiration only:** the LOTR-adjacent territory Paul wants — Middle-earth is Tolkien Estate, never named in customer copy. All names here are generic medieval-religious-knight-original.
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Crusader / holy-knight theme. Parallel to Iron Penitents but cleaner heraldry, less folk-horror, more honour-and-banners epic-fantasy tone. Iron Penitents = Templar order; Ash Mourners = monks of the sealed scripture; Coven = heretic mystics; Last Legion = banneret companies; Skinward Pact = wild-knights of the unconquered marches. Palette: heraldic red/white/gold, ink-blue azure, polished-silver steel. Frame: heraldic cross-and-fleur-de-lys, banner-tabard motif. Less grimdark, more high-medieval-illuminated-manuscript.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Scriptorium Monk | tonsured monk illuminating manuscript; sealed-book-of-prophecy in lap |
| p2 Whip Brother | The Templar Discipline | white-mantled knight with red cross, knotted scourge, prayer-bead belt |
| c4 Three Shadows | The Three Heretic Mystics | hooded figures with forbidden grimoires; iron-key pendants |
| l5 Iron Banner | The Banneret Standard | red-and-gold checked banner, lion-rampant, knight in plate behind |
| s5 Antler Sigil | The Wild-March Knight | knight in fur-trimmed cloak, antlered helm, no heraldry but personal |

---

### Theme 9 — **The Lantern's Keep**

**Category:** ORIGINAL (Gallowfell-owned). Cozy fantasy / cottagecore mushroom-forest. **Internal inspiration only:** Wildfrost's tone (Chucklefish, do not name in customer copy) — we want the "looks cute, plays deep" appeal Wildfrost demonstrated per `competitive_landscape_v0.md` §1.3.
**Status:** art-stubbed at launch.
**Price:** £3.99 standalone (lower-stakes tone, lower price tier).

**Pitch:** Cozy-fantasy theme. Warm lantern light, soft palette, mushroom forests, knitted-hat hedgehog warriors, lantern-keeper grandmothers. Iron Penitents = forest-keeper rangers; Ash Mourners = mushroom-druid herbalists; Coven = tea-witches; Last Legion = badger-knight order; Skinward Pact = friendly were-creatures. Palette: warm amber lantern-light, moss green, mushroom-cream white, dusk lavender. Frame: knotted-wood and ivy-twining border. This is the **tonal counterpoint** to canonical Gallowfell — it's the same game, played at "tea in the cottage" register instead of "gallows at midnight".

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Lantern-Granny | kindly old woman with copper lantern, knitted shawl, tabby cat at hem |
| p4 Hammer Confessor | The Toad-Knight | armoured toad-folk warrior with mushroom-helm, oversized wooden mallet |
| c7 Bog Witch | The Tea-Witch | cottage-coven elder pouring tea from a singing kettle; hedgehog familiar |
| l3 Drummer Boy | The Badger-Drummer | small badger in regimental coat, beating tiny drum |
| s7 Antler Sigil | The Stag-Friend | kindly stag-folk, antlers strung with ribbons, mushroom growing on shoulder |

---

### Theme 10 — **The Universal Dread**

**Category:** PUBLIC-DOMAIN SAFE (classic monster movie iconography — Dracula 1897 / Frankenstein 1818 / Wolfman folklore / Mummy/Egyptian / Phantom of the Opera 1909 / Jekyll-Hyde 1886 — all source novels PD; **avoid** the specific Universal Studios film designs from 1931+ which have separate copyright; use generic Dracula/Frankenstein/Wolfman iconography, not Karloff-Lugosi specifics).
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Classic horror monster cinema treatment. **Black-and-white film grain** over the entire card surface — the one theme that ships a unique shader on top of the art. Dracula's coven for the Coven faction; Frankenstein's lab-army for Last Legion; Wolfman pack for Skinward Pact; Mummy / Egyptian-tomb keepers for Iron Penitents; opera-house Phantom ghosts for Ash Mourners. Palette: greyscale only, with a single accent colour (blood red) per card. Frame: art-deco theatre-poster border with 1920s typography. Tagline overlay on each card. **Cinematic.**

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Phantom of the Aisle | masked figure at organ; falling chandelier shadow; greyscale + red rose |
| p6 Crowned Martyr | The Bandaged Pharaoh | mummified king on throne, bandages unspooling; greyscale + red eye-glow |
| c7 Bog Witch | The Count's Bride | pale woman in black gown, fangs visible, red ribbon at throat |
| l5 Iron Banner | The Reanimated Regiment | stitch-suture army in trenchcoats; greyscale + red lightning-arc |
| s7 Antler Sigil | The Howl Under Moon | wolfman mid-transformation, full moon backdrop; greyscale + red eyes |

---

### Theme 11 — **The Forge-King's Engine**

**Category:** ORIGINAL (Gallowfell-owned). Generic steampunk — PD genre.
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Steampunk industrial. Iron Penitents already lean toward "industrial brass-and-rivet"; The Forge-King's Engine pushes the whole game in that direction. Iron Penitents = clockwork inquisitors; Ash Mourners = boiler-stoker funereal engineers; Coven = aetheric tinkers; Last Legion = brass-armoured automaton regiment; Skinward Pact = bioluminescent-organic-tech hybrids. Palette: brass gold, oil black, soot grey, copper-patina green, hot-iron orange. Frame: cog-wheel border with rivet corners and steam-pipe accents.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Steam-Choir Soprano | brass-masked singer connected to bellows-organ via copper pipes |
| p2 Whip Brother | The Inquisitor-Mechanic | brass-armoured penitent with steam-driven chain-flail |
| c4 Three Shadows | The Aether Tinker Trio | three women at brass workbench, copper goggles, electricity arcing |
| l5 Iron Banner | The Automaton Regiment Standard | wind-up brass soldier holding banner; gears visible in chest |
| s6 Wyrm-Bound | The Bio-Engine Hybrid | half-flesh half-brass beast; veins as copper pipes |

---

### Theme 12 — **The Shattered Throne**

**Category:** ORIGINAL (Gallowfell-owned). Political-fantasy intrigue. **Internal inspiration only:** the Game-of-Thrones-adjacent grimdark Paul wants — Game of Thrones / ASOIAF is HBO+Martin, never named in customer copy. All names here are Gallowfell-original.
**Status:** art-stubbed at launch.
**Price:** £5.99 standalone / £8.99 bundle.

**Pitch:** Political-fantasy intrigue. Less monster, more conspiracy. The curse of Gallowfell reinterpreted as a kingdom's slow disintegration through betrayal, sworn-sword loyalty, and broken oaths. Iron Penitents = the king's-guard sworn-swords; Ash Mourners = court-spy network; Coven = the bastard-claimant's witch-council; Last Legion = the rebel army-of-the-North; Skinward Pact = the wild-clan kingsmoot. Palette: muted royal blue, blood-burgundy, gold-on-black sigils, parchment cream. Frame: heraldic dynasty-sigil corners, sworn-sword crossed-blades border. **Tone:** every card is a betrayal foretold.

**5 example treatments:**
| Canonical card | Re-skin name | Art direction |
|---|---|---|
| m3 Ash Speaker | The Master of Whispers | hooded figure in council chamber; ravens at shoulder; one finger to lips |
| p2 Whip Brother | The Sworn-Sword's Discipline | armoured knight with cat-of-nine; oath-scroll burned at his feet |
| c4 Three Shadows | The Three Pretender Witches | three women at council-table; one crown floating between them |
| l5 Iron Banner | The Rebel King's Standard | grey wolf on white field, snow-crusted; northern-army silhouette behind |
| s7 Antler Sigil | The Antler-Crown Claimant | bearded king with antler-and-bone crown, sworn before clan-circle |

---

## 4. Roadmap themes (Y2+ slot, mentioned not fully spec'd)

For each, category + 1-line pitch only. Full spec on activation.

| Theme | Category | Pitch |
|---|---|---|
| **The Sun-Bone Kingdom** | PUBLIC-DOMAIN SAFE — Egyptian mythology | Anubis, Ra, Set, mummified pharaohs, Book of the Dead funerary motifs over the entire game-world. |
| **The Feathered Sacrifice** | PUBLIC-DOMAIN SAFE — Aztec / Mayan mythology | Tlaloc / Quetzalcoatl / jade-blood-step-pyramid palette; sacrifice-as-ritual theme. |
| **The Lamplit Bazaar** | PUBLIC-DOMAIN SAFE — Arabian Nights / 1001 Nights | Djinn / roc / sand-witch / flying-carpet army; brass-lantern palette. |
| **The Neon Throat** | PUBLIC-DOMAIN SAFE — generic cyberpunk (do NOT name Cyberpunk 2077 / Shadowrun) | Hacker-coven, corp-knight Last Legion, neon-lit Ash Mourners as data-ghosts. |
| **The Dust Sermon** | PUBLIC-DOMAIN SAFE — generic western | Gunslinger Iron Penitents, ghost-town Ash Mourners, snake-oil Coven, posse Last Legion, wild-tribe Skinward. |
| **The Cherry-Steel Garden** | PUBLIC-DOMAIN SAFE — generic samurai-era Japan (do NOT name specific clan or licensed property) | Bushido honour, oni boss-tier, kitsune Coven, ronin Last Legion. |
| **The Coral Drum** | PUBLIC-DOMAIN SAFE — Polynesian mythology | Maui, Pele, tiki-mask palette, lava-and-coral biome. |

Activation gating: each roadmap theme requires a category 1/3 confirmation pass + full art spec before greenlight. Default cadence = 1 new theme pack per quarter post-soft-launch.

---

## 5. Cross-cutting design notes

### 5.1 TM-clean naming policy

Every theme name in the launch + roadmap catalogue is reviewed for:

1. **No franchise word.** "Gondor", "Hogwarts", "Westeros", "Tatooine", "Cyberpunk" (as a single word) are out.
2. **No character name.** "Gandalf", "Voldemort", "Daenerys", "Cthulhu-as-named-card-title" are out. (Cthulhu the *creature* in PD is fine in art; "Cthulhu" as a *card name* is also fine because it's PD; but be careful in compound titles like "Cthulhu's Bargain" — keep it descriptive, not branded.)
3. **No "Lord of the X" style title.** Tolkien Estate has been very litigious about derivatives.
4. **Trademark check before customer-print.** Same UKIPO/USPTO/EUIPO/WIPO pass as `trademark_search_findings_2026-05-22.md` — but per theme, per quarter.

### 5.2 Faction-coverage rule

Every theme must work with **all 5 factions** in the game. No theme is faction-locked. Some pairings will be stronger (Lovecraftian + Coven = natural; Norse + Last Legion = natural) but every theme must include credible re-skins for the 4 weaker pairings too. Player choice of Warlord cannot be punished by theme purchase.

### 5.3 Art pipeline implications

- ~342 cards × 12 themes = **4,104 art slots** if we ever fully populated. This is impossible Y1.
- **Realistic launch ship:** 1-2 themes art-complete + 10 themes art-stubbed for roadmap.
- **Stub strategy:** for art-stubbed themes, ship the canonical Gallowfell art + the **themed name + frame variant only**. Player sees themed name "The Pyre-Piper" on Gallowfell-canonical art; flagged in the UI as "Themed name available; full art coming in patch X.Y". Lets us ship the theme-pack SKU with partial value upfront.
- **Art-complete cadence:** 1 theme art-completes per quarter post-soft-launch (~85 art assets / quarter at the per-card commission rate from `art_pipeline_readiness_v0.md`).
- **Stub conversion:** when a stubbed theme art-completes, all owners get the full art retroactively pushed via the next patch. No re-purchase. (Anti-FOMO + builds trust.)

### 5.4 Surface routing in UI

Settings → Cosmetic Library → Theme Packs subsection. Three modes:

| Mode | UX |
|---|---|
| **Deck-wide** | Single tap; theme paints the whole deck. Hero / default mode. |
| **Per-card** | Card-by-card chooser, mix-and-match enabled. Discoverable in expert UI. |
| **Off (canonical)** | Always available; resets to canonical Gallowfell free theme. |

UI surfaces a "themed/canonical card-name toggle" — players who play PvP can opt to show canonical names on hover so they're not confused by opponent's themed cards.

### 5.5 Anti-FOMO mechanic

No theme pack is ever permanently unavailable. Time-limited bundles return 90 days post-rotation per `shop_economy_v2.md` §3.4. Seasonal Pass+ free themes go to the Vault at the rotation; vaulted themes purchasable at gem-rate after.

---

## 6. Monetisation summary

Cross-references `shop_economy_v2.md` and `season_pass_v2.md`.

### 6.1 Price tiers

| Tier | GBP | What's included |
|---|---|---|
| **Themed name + frame** (art-stubbed) | £3.99 | Card-name swaps + frame variant only; canonical art retained. Auto-upgrades to full art when art-complete (no re-purchase). |
| **Full theme** (art-complete) | £5.99 | All ~342 cards re-arted, named, frame-variant + flavour text. |
| **Theme bundle** (art-complete + extras) | £7.99 | Above + board + card-back + avatar frame. **30% off à la carte equivalent of ~£11.50.** |

The £3.99 / £5.99 / £7.99 ladder mirrors `shop_economy_v0.md` §3 currency-pack rungs — discoverable at the £4.99 sweet spot.

### 6.2 Free-with-Pass+ track

One theme pack free per season for Pass+ owners (£9.99 Pass+ already includes the season's hero skin + 10 instant tiers — adding a themed pack widens perceived value). Theme rotation pinned to the season's narrative arc per `season_pass_v2.md` §4.

| Season | Pass+ free theme |
|---|---|
| S1 "Bell-Tide" | **The Grimm Reaping** (Brothers Grimm fairy-tale theme, narrative tie to the bell-tide-as-Pied-Piper) |
| S2 "Soot Vigil" | **The Forge-King's Engine** (steampunk industrial, narrative tie to the Forgotten Parade) |
| S3 "Mire-Bargain" | **The Cosmic Drowning** (Lovecraft, narrative tie to demon-coin pool) |
| S4 "Cinder-Crown" | **The Ash Pantheon** (Norse Ragnarok, narrative tie to the cinder-end) |

### 6.3 Subscription Ascendant Pact

`shop_economy_v0.md` §4.6 — Ascendant Pact gets **1 free theme pack per quarter** (rotates through the catalogue starting from the player's least-owned themes; player can override pick).

### 6.4 Gifting

Players can gift theme packs to friends (per `shop_economy_v2.md` §5). Gift price = full price (no discount); receiver gets the asset; gifter gets a thank-you cosmetic micro-reward (a one-time "Generous Stranger" banner-frame).

---

## 7. Engine handoff

### 7.1 New resource classes

- `theme_pack.gd` (this doc §2.1)
- `card_theme_treatment.gd` (§2.2)
- `theme_application_controller.gd` (the per-card / deck-wide / off mode controller)

### 7.2 Renderer changes

The `CardView` scene already reads `Card` + `CardInstance.alt_art_id` + `CardInstance.treatment_id` (per `variants_system_v0.md` §3.6). Extend with `CardInstance.theme_pack_id` resolution:

```
func resolve_card_render(card_instance: CardInstance) -> CardRenderBundle:
    var theme_id = GameState.resolve_theme_for_card(card_instance.card_id)
    var theme_treatment = ThemeRegistry.get_treatment(card_instance.card_id, theme_id)
    var alt_art = AltArtRegistry.get_art(card_instance.card_id, card_instance.alt_art_id)
    return CardRenderBundle.new(
        theme_treatment.art_path if theme_treatment else alt_art.art_path,
        theme_treatment.display_name if theme_treatment else card_instance.card_data.display_name,
        theme_treatment.frame_variant if theme_treatment else card_instance.card_data.faction_frame,
        card_instance.treatment_id  # treatment shader on top
    )
```

Resolution priority: per-card override → deck-wide theme → canonical. If theme has no treatment for a given card_id (stubbed roadmap theme), falls back to canonical art + themed name.

### 7.3 Collection UI

Per `variants_system_v0.md` §10.2 — add a "Theme Packs" tab between "Card Treatments" and "Warlord Skins". Tab shows owned + previewable + purchasable themes with the §5.4 mode toggle. Per-card chooser drilling-down from the card-collection-view shows the theme-treatment row.

### 7.4 Anti-cheat / PvP integrity

In PvP modes (per `extended_game_modes_v0.md`), the server simulates using `card_id` only. Theme treatments are client-side render only. The opponent's client receives theme-pack IDs as part of the action stream and renders accordingly — but if the opponent has not purchased the theme, they see the canonical-Gallowfell art with the themed name overlaid. (Or, per-player settings, they can opt to always see canonical names regardless of opponent's theme.)

---

## 8. MVP coverage

| Surface | IMV-1 | IMV-2 | First commercial pass | Soft launch | v1.0 |
|---|---|---|---|---|---|
| Theme pack data model | — | — | spec only | engine live, 2 themes shipped | full catalogue |
| Canonical Gallowfell theme | ✅ default | ✅ | ✅ | ✅ | ✅ |
| First art-complete theme (Grimm Reaping) | — | — | art-in-flight | shipped | ✅ |
| Second art-complete theme | — | — | — | shipped | ✅ |
| 10 art-stubbed themes (themed name + frame only) | — | — | — | shipped | + 1/quarter art-complete |
| Per-card application | — | — | — | ✅ | ✅ |
| Deck-wide application | — | — | — | ✅ | ✅ |
| Theme + board + back bundle | — | — | — | 2 of 12 | all art-complete |
| Pass+ free-of-season theme | — | — | — | S1 ships Grimm | ongoing |
| Gifting theme packs | — | — | — | v1.1 | ✅ |
| Subscription quarterly free theme | — | — | — | — | v1.2 with Ascendant Pact |

---

## 9. Open questions for Paul

1. **Top 3 themes for v1.0 art-complete launch.** Recommend (in priority order): **(1) The Grimm Reaping** (broadest mass appeal, Pass+ S1 anchor, PD-safe), **(2) The Cosmic Drowning** (whale + horror-fan audience overlap, Pass+ S3 anchor), **(3) The Lantern's Keep** (the cozy counterpoint — the *only* theme that opens a different audience door, lowest price tier £3.99 = funnel widener). Confirm.
2. **The Hollowing Hall** — kid-friendly magical-school. Is the £3.99 price tier the right floor, or push to £5.99 alongside the others? Cozy + kid-friendly is the demographic case for keeping it cheap.
3. **The Universal Dread B/W shader** — extra renderer cost (a desaturation pass + selective red-channel boost) is per-card on a treatment that's already shaded by Foil / Gold / Prism / Cursed. Confirm: ship in launch catalogue or push to v1.1 as the engine extra is non-trivial?
4. **Pass+ free-of-season binding** — recommendation maps S1=Grimm, S2=Forge-King, S3=Cosmic, S4=Ash-Pantheon. Lock now or leave flexible until Q3 planning?
5. **Subscription quarterly free theme — opt-in or auto-rotate?** Recommend auto-rotate (player gets the next theme in their unowned list each quarter) with one-tap override.

---

## 10. Cross-references

- `variants_system_v0.md` — alt-arts + treatments + card-backs + boards + summon VFX (orthogonal to themes; layered below treatments / above canonical card).
- `shop_economy_v2.md` — refined IAP ladder, regional pricing, gifting, rotation cadence, loss-leaders.
- `season_pass_v2.md` — Pass+ scope, theme-tie-in per season, Vault catch-up, returning-player track.
- `extended_game_modes_v0.md` — PvP integrity model that themes ride on top of.
- `competitive_landscape_v0.md` §1.4 — Marvel Snap cosmetic-economy lesson + anti-gacha-FOMO rule.
- `art_pipeline_readiness_v0.md` — art commission pipeline cost basis (~$X per card commission used for theme-pack ROI maths).
- `monetisation_map.md` — §5 cosmetic-stack hierarchy.
- `trademark_search_findings_2026-05-22.md` — TM clearance pattern; every theme name in this doc has the same clearance pass owed before customer print.

— Controller, 2026-05-25
