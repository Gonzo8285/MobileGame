# Theme Packs — `game/data/themes/`

Authoring root for the cosmetic re-skin system. Spec: `../../../theme_packs_system_v0.md`.

## What a theme pack is

A complete card-art + card-frame + card-name + card-flavour-text re-skin layered over the mechanically-identical underlying cards. **Mechanics never change** — combat code reads `Card`, never `ThemePack`. PvP `card_id` and the canonical name remain queryable regardless of theme.

## Files in this folder

| File | Purpose |
|---|---|
| `theme_pack_definitions.tres` | The single `ThemePackCatalog` resource referenced by `ThemePackManager`. Lists every theme `.tres` as an `ext_resource`. |
| `<theme_id>/theme.tres` | One per theme. Holds metadata, palette, price, ownership defaults, and the per-card treatments authored for this theme. |
| `<theme_id>/README.md` (optional) | Per-theme art-direction notes once the theme enters art-complete pipeline. |

## How to add a new theme

1. Pick an `id` (snake_case, no franchise words — see TM-clean policy in `theme_packs_system_v0.md` §5.1). Run the trademark check.
2. Create the folder: `game/data/themes/<id>/`.
3. Author `theme.tres`:
   - Set `id`, `display_name`, `category` (PUBLIC_DOMAIN / ORIGINAL / LICENSED_BLOCKED — if LICENSED_BLOCKED, you must populate `ip_notes`).
   - Set `status` (ART_COMPLETE / ART_STUBBED / ROADMAP). Stubbed themes ship the canonical art + themed name; the player gets the full art retroactively when art-completes (no re-purchase).
   - Set `price_tier_gbp`. Use the £3.99 / £5.99 / £7.99 ladder.
   - Author at least 5 `CardThemeTreatment` sub-resources covering hero / boss / starter cards.
4. Add the theme to `theme_pack_definitions.tres` as a new `ext_resource` + array entry.
5. Run `ThemePackCatalog.validate()` from a smoke-test scene — it will scream about duplicates, missing canonical, LICENSED_BLOCKED priced for sale, etc.

## Per-card treatment authoring

Each `CardThemeTreatment` sub-resource carries:

- `card_id` — must match an existing `Card.id` (e.g. `&"M3"`, `&"P2"`).
- `display_name` — the themed name (e.g. "The Pyre-Piper"). May be empty for an art-only override.
- `art_path` — `res://...` path to the themed 832×1166 illustration. Empty = stubbed (use canonical art).
- `flavour_text` — ≤120 chars, themed.
- `frame_variant` — frame id (themed border treatment).

If all three of `display_name` / `art_path` / `frame_variant` are empty, drop the entry instead — `validate()` will fail.

## Launch catalogue (12 themes)

| id | Category | Price | Status |
|---|---|---|---|
| `gallowfell_canon` | ORIGINAL | Free, always owned | ART_COMPLETE |
| `grimm_reaping` | PUBLIC_DOMAIN (Brothers Grimm) | £5.99 / £8.99 bundle | ART_STUBBED — first post-launch art-complete |
| `black_iron_sea` | ORIGINAL (pirates) | £5.99 | ART_STUBBED |
| `hollowing_hall` | ORIGINAL (magical school) | £3.99 | ART_STUBBED |
| `cosmic_drowning` | PUBLIC_DOMAIN (Lovecraft pre-1929) | £5.99 | ART_STUBBED |
| `ash_pantheon` | PUBLIC_DOMAIN (Norse Ragnarok) | £5.99 | ART_STUBBED |
| `underworlds_maw` | PUBLIC_DOMAIN (Greek underworld) | £5.99 | ART_STUBBED |
| `iron_crusade` | ORIGINAL (crusader heraldic) | £5.99 | ART_STUBBED |
| `lanterns_keep` | ORIGINAL (cozy cottagecore) | £3.99 | ART_STUBBED |
| `universal_dread` | PUBLIC_DOMAIN (classic monster cinema) | £5.99 | ART_STUBBED |
| `forge_kings_engine` | ORIGINAL (steampunk) | £5.99 | ART_STUBBED |
| `shattered_throne` | ORIGINAL (political-fantasy intrigue) | £5.99 | ART_STUBBED |

## Pass+ theme-of-season mapping

Per `season_pass_v2.md` §4 — Pass+ owners auto-receive the season's theme pack:

| Season | Pass+ free theme |
|---|---|
| S1 "Bell-Tide" | `grimm_reaping` |
| S2 "Soot Vigil" | `forge_kings_engine` |
| S3 "Mire-Bargain" | `cosmic_drowning` |
| S4 "Cinder-Crown" | `ash_pantheon` |

## Anti-P2W invariant (paramount)

- Combat code never reads a `ThemePack` or `CardThemeTreatment`.
- PvP server-side simulation strips the theme layer entirely.
- Opponents in PvP see the canonical name on hover (player-toggleable in settings).

## Cross-references

- `theme_packs_system_v0.md` — design spec.
- `season_pass_v2.md` §4 — season-theme tie-in.
- `shop_economy_v2.md` §3 — featured-deal / rotating-shop routing.
- `variants_system_v0.md` §10.2 — Collection UI extension for the Theme Packs tab.
