# Game Design Document v0 — The Curse of Gallowfell

> **SUPERSEDED 2026-05-22 by `GDD_v1.md`.** Kept for diff history only. v0 contains pre-Gallowfell run structure (16-node / 4-act) + 10-Warlord count + 30-card starter pool — all of which are no longer canonical. Read `GDD_v1.md` for the live design. Patched by CANON_PATCHES_APPLIED_2026-05-22.

_Drafted 2026-04-29 by heartbeat. Approved by Paul 2026-04-30. Title locked: The Curse of Gallowfell._

## Pitch
A grimdark roguelite **tower-defence deckbuilder** for mobile. You play a Warlord leading a doomed warband into **Gallowfell** — a cursed gallows-town the Monarchy filled with the wrongfully hanged, then forgot. Each run, you draft cards (units, spells, traps), place them on a winding lane, and survive escalating waves of horrors. Permadeath per run; meta progression between runs. Original IP, painterly 2D, gallows humour. PvE only. PEGI 12.

## Setting
Gallowfell is the Monarchy's cursed gallows-town. Centuries of executions cursed it; the dead refuse to leave; reality frays. Each Warlord marches in for a different reason — pilgrimage, reclamation, patron-following, sealed orders, or vengeance. The town's six districts are the chapter biomes: **Cathedral Ruins** (Iron Penitents), **Catacombs** (Ash-Mourners), **Bog of Bargains** (Coven of the Black Mire), **The Foundry** (The Last Legion), **Cinderwood** (Skinward Pact), **Gallows Hill** (boss biome). Full setting + faction reasons in `lore_gallowfell.md`.

## Curse mechanics (in-fiction systems, per `lore_gallowfell.md`)
- **The Hanging Hour** — every battle has an in-fiction "midnight" beat. All units on the field (yours and enemies') gain +1 ATK for 1 turn. Drives mid-fight tension; Warlord 11 and several signature cards key off it.
- **The Reanimation** — defeated enemies in Gallowfell have a small % chance to rise once at 1 HP on the same tile. Justifies the Ash-Mourners's identity AND escalates difficulty in late chapters. Warlord 11 (lore-locked) flips Reanimation to your side.

## Core loop (60–90s micro / 8–15 min run / multi-run meta)
1. **Pick Warlord & faction** (meta choice).
2. **Draft starting deck** — 12 cards from faction pool + neutrals.
3. **Run map** — branching node graph (battle / elite / event / shop / shrine / boss). Slay-the-Spire-style.
4. **Battle node** — wave-based TD on a lane: draw 5 cards, pay mana, place units on tiles, cast spells, trigger traps. Survive 8–12 waves. Boss every 4 nodes.
5. **Reward** — pick 1 of 3 cards, gold, relic, or shrine boon.
6. **Run end** — death or boss kill at node 16. Convert XP → meta currency. Unlock new cards / Warlords.

## Run structure
- 4 acts × 4 nodes + boss = 16 nodes per run.
- Difficulty curve: Act 1 friendly, Act 4 brutal. Ascension levels 1–20 unlock post-first-win for replayability.
- Deck size grows from 12 → ~25 cards by run end. Pruning is its own meta-skill.

## Card types (starter pool: 30 cards across 3 factions; full pool target: 300+ by D30)
- **Units (60% of pool):** placed on lane tiles, attack passing waves. Stats: cost, HP, ATK, range, cooldown, keywords.
- **Spells (25%):** one-shot effects — damage, buffs, summons, board control.
- **Traps (10%):** placed on lane, trigger on enemy entry — slow, burn, root, fear.
- **Relics / Shrines (5%, meta-only, drop in run):** passive effects, build-defining.

## Keywords (v0.1 — evergreen set)
Cleave, Pierce, Burn, Bleed, Poison, Root, Fear, Lifesteal, Shield, Resurrect, Summon, Echo, Sacrifice, Penance, Dread, **Smoke**, **Slow**.

_Promoted in v0.1 (2026-04-30):_
- **Smoke** _(zone status):_ tile/area filled with smoke for N turns; enemies in Smoke suffer Fear-1 and -1 ATK while inside; stacks with Dread.
- **Slow-X** _(unit status):_ target's movement reduced by X tiles per turn; stacks up to Slow-3 (= Root-equivalent); stacks cleanly with Poison and Bleed.

## Warlord classes (5 archetypes — full roster: `warlords_v1.md`)
- **Aggro** — fast cheap units, snowball damage.
- **Control** — traps, debuffs, board lock.
- **Swarm** — tokens, sacrifice synergies.
- **Summoner** — big stationary units + summons.
- **Tempo** — value trades, draw, mana acceleration.

Roster shape: 5 free + 5 paid + 1 lore-locked secret (Warlord 11 — the Innocent Saint, unlocked by completing a campaign with all 10 others; no IAP path).

## Factions (5 — full bible in `faction_bible.md` v1)
1. **Iron Penitents** (Cathedral Ruins) — flagellant crusaders, hammer + chain motif. Aggro / sacrifice.
2. **Ash-Mourners** (Catacombs) — necromancer-aristocrats of the dying Monarchy. Control / debuff.
3. **Coven of the Black Mire** (Bog of Bargains) — demon-bargained bog-folk and their familiars. Swarm / poison.
4. **The Last Legion** (The Foundry) — industrial regiment of the dying empire, soot + brass. Tempo / formation.
5. **Skinward Pact** (Cinderwood) — beastfolk and wyrd shapeshifters of the felled god-tree. Summoner / monstrous.

(Original IP — no GW / WotC / Privateer Press names. Crosschecked memory.)

## Monetisation surfaces (full map in G8)
- **IAP:** gem currency packs ($0.99–$99.99 ladder), Warlord unlocks, cosmetic skins, battle pass premium track ($4.99/season), starter & weekly bundles.
- **Rewarded video:** continue-after-defeat, 2× run rewards, free daily chest, gacha bonus pull, energy refill.
- **Battle pass:** 30-day season, free + premium tracks, 50 levels.
- **Energy:** soft cap on runs (5 charges, 30-min refill, sell refills + ad refill). Will A/B-test removal — modern midcore trends away from energy.
- **Live ops:** rotating events, faction wars, l