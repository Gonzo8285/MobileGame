# LoRA stack — resolved Civitai URLs

_Heartbeat D-LORA-1, 2026-05-04 14:18 UTC. Resolves the speculative LoRA names in `pipeline_spec.md` §2.2 to canonical Civitai URLs (or documented closest-match substitutions). All URLs returned valid Civitai pages at search time. Verify the page still resolves before each download._

> **Bias of this resolution:** the original `*-sdxl` slugs in `pipeline_spec.md` were aspirational placeholders, not real LoRA names. Almost everything below is a documented substitution. The substitutions are picked to (a) prefer SDXL-native (rejecting Flux-only, Illustrious-only, or SD-1.5-only LoRAs unless no SDXL alternative exists), (b) prefer recently updated + highly rated, and (c) keep IP-safe (no MTG / Phyrexian / Lorwyn LoRAs exist publicly because Wizards of the Coast actively DMCAs them — substitutions go style-adjacent instead).

## Quick reference table

| Slot in `pipeline_spec.md` §2.2 | Resolved name | Civitai URL | Version | Default weight | Notes |
|---|---|---|---|---|---|
| **Style #1** `mtg-style-sdxl` | ClassipeintXL (oil paint / oil painting style) | https://civitai.com/models/127139/classipeintxl-oil-paint-oil-painting-style | v2.1 | 0.8 | Substitute. Painter-name-mixing built in — rely on `in the style of Steve Argyle and Volkan Baga` prompt suffix to drive MTG-painterly look. |
| **Style #2** `dark-fantasy-oil-painting-sdxl` | Dark Fantasy LORA | https://civitai.com/models/932379/dark-fantasy-lora | v1 | 0.8 | Close match. Author description: "inspired by dark fantasy style and dark oil paintings". Trigger phrase: `Dark Fantasy`. |
| **Style #3** `elden-ring-concept-sdxl` | Elden Ring Style | https://civitai.com/models/457103/elden-ring-style | v1.0 | 0.5 | **Exact match.** Cap at 0.5 per spec — don't overdrive Elden Ring identity. |
| **Iron Penitents** `phyrexian-corruption-sdxl` / `body-horror-religious-sdxl` | RPGNightmareXL | https://civitai.com/models/182002/rpgnightmarexl | v1.0 SDXL | 0.4 | Substitute. **Cap weight at 0.4 for PEGI 12** — this LoRA can push past gore tolerance if driven hard. Phyrexian-named LoRAs do not exist publicly (WotC IP-takedown history). |
| **Ash-Mourners** `gothic-cathedral-sdxl` | gothic cathedral interior | https://civitai.com/models/1904235/gothic-cathedral-interior | v1.0 | 0.6 | Verified close. Environment-led — best applied to Mourners units with explicit cathedral/catacomb backgrounds. |
| **Ash-Mourners** `victorian-mourning-sdxl` | Dark Gothic Fantasy | https://civitai.com/models/293532/dark-gothic-fantasy | 3.01 | 0.5 | Substitute. The Halloween: Victorian Gothic Horror LoRA is Flux-only — rejected. Dark Gothic Fantasy holds the funerary-figure aesthetic. |
| **Coven of the Black Mire** `swamp-witch-sdxl` | Swamp people (SDXL/Illustrious) | https://civitai.com/models/2134348/swamp-people-sdxlillustrious | latest | 0.5 | Verified close. Fantasy-people, swamp-tagged. Optional layer: Witch Style https://civitai.com/models/262925/old-witch-style-lora-15sdxl (trigger `ral-wtchz`) for explicit witch silhouette. |
| **Coven of the Black Mire** `lorwyn-folkloric-sdxl` | Mythical Forest Style [SDXL] | https://civitai.com/models/303030/mythical-forest-style-sdxl | SDXL | 0.5 | Substitute. Lorwyn-named LoRAs do not exist publicly (WotC). Mythical Forest covers the fungal-grove + folkloric grotesque atmosphere. Trigger: `ral-mytfrst`. |
| **The Last Legion** `medieval-armor-decay-sdxl` | ArmorSentinel medieval armor style | https://civitai.com/models/643451/armorsentinel-medieval-armor-style-lora | v2 | 0.6 | Verified close. Trained explicitly on knight armor + armored monsters — fits decayed-knight Elden-Ring-scale aesthetic. |
| **The Last Legion** `elden-ring-knight-sdxl` | (covered by Style #3 Elden Ring Style) | — | — | — | No second LoRA needed. The Style #3 Elden Ring Style already in the stack hits the Legion-knight axis at 0.5; ArmorSentinel above adds the armor-decay specificity. |
| **Skinward Pact** `druidic-shaman-sdxl` | Mythical Forest Style [SDXL] | https://civitai.com/models/303030/mythical-forest-style-sdxl | SDXL | 0.5 | Substitute (shared with Coven). Druidic-grove background. Trigger: `ral-mytfrst`. |
| **Skinward Pact** `nordic-mythology-sdxl` | Mythical Creatures [LoRA 1.5+SDXL] | https://civitai.com/models/218327/mythical-creatures-lora-15sdxl | SDXL | 0.5 | Substitute. No clean nordic/pagan SDXL LoRA found. Mythical Creatures covers beast/spirit-companion aesthetic; the antler-crown / hide-cloak nordic-pagan look is driven prompt-side via `pipeline_spec.md` §3.2 Skinward Pact block. |

## Substitution rationale — the 3 IP-blocked slots

Three of the original placeholder names in `pipeline_spec.md` §2.2 referenced Wizards of the Coast IP (`mtg-style`, `phyrexian-corruption`, `lorwyn-folkloric`). These slugs do not exist on Civitai because WotC has historically DMCA'd MTG-named models from public hosting. Substitutions above are picked to:

1. Hit the same aesthetic axis through art-style proxies rather than IP names.
2. Rely on the prompt template (`pipeline_spec.md` §3.1, §3.2) to do the IP-flavour heavy lifting — the LoRAs supply painterly texture + faction silhouette, the prompt supplies the named-artist + named-aesthetic targeting.
3. Stay commercially-licensable. Each Civitai URL above must still be license-audited per `pipeline_spec.md` §10 open Q4 before commercial use.

## Total disk footprint estimate

Eight active LoRA files at typical SDXL LoRA sizes (~150-250 MB each) → **~1.5-2.0 GB** of LoRA storage in `C:\ComfyUI\models\loras\`. Plus the ~7 GB juggernautXL_v9 checkpoint. Comfortably inside the 30 GB budget called out in `pipeline_setup\README.md`.

## Next heartbeat — open follow-ups

1. **License audit per LoRA.** Each Civitai page lists a license (CC-BY, CC-BY-NC, custom, etc.). Open each URL, capture the license string, decide commercial-viability per LoRA. Flag any CC-BY-NC / custom-restrictive ones for replacement before B3 cloud-batch generation. (Belongs to `pipeline_spec.md` §10 Q4 — Phase 4 legal pass.)
2. **Trigger-word capture.** Several of these LoRAs have specific activation tokens (`ral-mytfrst`, `ral-wtchz`, `Dark Fantasy`, etc.). Capture each LoRA's documented trigger-word from its Civitai page and append to `pipeline_spec.md` §3.2 as faction-specific prefix tokens. Without trigger words, LoRAs may activate at lower strength than expected.
3. **Version pinning.** Civitai LoRAs get re-uploaded with new versions. The version column above is "latest at resolution time"; once ComfyUI installs them, capture the exact version-id from the model file's metadata and pin it here. `pipeline_spec.md` §7 reproducibility rule 2 demands this.
4. **Backup verification.** For Style #1 + Style #2 (the workhorse style LoRAs), download and test a 2nd-choice backup (Painterly Fantasia + Eldritch Impressionism respectively) so we have a fallback if the primary gets yanked.

These are deliberately deferred — the cheapest path to a first 9-tile reference sheet (`pipeline_spec.md` §5) is to install everything above as-is, generate, and let actual output quality decide which slots need iteration. Don't pre-optimise.
