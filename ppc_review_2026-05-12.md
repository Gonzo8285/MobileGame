# PPC review — 2026-05-12 (late afternoon UK)

Quick coordination note from paul-pc (Cowork on the laptop). Not a heartbeat, not a code edit — a status read so the next Claude Code run knows where we stand and Paul has a single paragraph to act on.

## Where B2 is

| Card    | Status                                                                                  |
|---------|-----------------------------------------------------------------------------------------|
| B2.1–6  | done (logic + UI scaffold)                                                              |
| B2.7    | done 2026-05-10 — turn engine + cull + Persist drain                                    |
| B2.8    | done 2026-05-11 — reward generator + offer + GameState integration (logic-only)         |
| B2.9    | done 2026-05-12 today — branching map graph + chapter 1 prototype (logic-only)          |
| **B2.10** | **only B2 task left** — start → 1 combat → reward → next node → die, playable in editor |

B2.8 and B2.9 deliberately landed logic-only. The two missing scenes are `reward_view.tscn` and `map_view.tscn` — both UI scaffolds, both small relative to the runtime work already in place. B2.10 sits on top of those.

## What B2.10 needs (paul's eyes only)

The end-to-end smoke test is fundamentally a Paul-task because it requires opening the Godot editor and verifying the loop works visually. Code-side, the prerequisites are:

1. **`reward_view.tscn`** — three CardView nodes in a row, skip button, hooks into `RewardOffer.resolved`. Minimal styling — placeholder rectangles fine.
2. **`map_view.tscn`** — render the 5-node chapter 1 graph as clickable circles; on click, call `GameState.choose_next_node(id)`; emit a phase transition the run loop watches for.
3. **Run loop wiring** — a `run.gd` autoload-or-scene that sequences: `enter_chapter` → load combat scene at start node → on combat end, build a reward offer + show `reward_view` → on resolve, return to `map_view` → on node click, route to combat or terminal. Today the pieces exist as isolated singletons; the wiring is the missing glue.

Suggested smallest viable B2.10:
- Skip the visual map for the first pass — represent the 5 nodes as a vertical column of buttons. Get the **state machine** end-to-end first, prettify later.
- Defeat ends the run (no save/load yet). Victory at boss-node also ends the run with a "RUN COMPLETE" toast.
- One faction's starter deck only. Pick Iron Penitents — that's the most complete card pool.

## Where the rest of Phase 3 sits

| Track     | Next card                                       | Blocked on               |
|-----------|--------------------------------------------------|--------------------------|
| B3 art    | B3.0a smoke test pod re-run                      | Paul confirming aesthetic of 2026-05-10 smoke image |
| D-VALIDATE-1 | Stage A: 5 free Warlord anchor tiles           | B3.0a pod-smoke + Paul on ComfyUI install |
| M-track   | M3 next (Hanging Hour boss-escalation spec)      | none                     |
| T-track   | T4 collection screen UI mock                     | sequenced after B2.10 smoke test ships |
| W-track   | W3 XP-booster economy integration                | none                     |

So once B2.10 lands, M3 / W3 / T4 can all proceed independently. The B3 art pass is independent of B2 and just needs Paul's go-ahead on the smoke-test aesthetic.

## Open Qs for Paul (none block B2.10)

- B2.10 smallest-viable shape — buttons-as-map first pass acceptable, or want the prototype visual map up-front?
- Iron Penitents as the smoke-test deck, or different faction?
- After B2.10 ships, sequence M3 → W3 → T4, or run them in parallel?
- B3.0a — still parked pending your aesthetic call on `art_iterations/_smoke/smoke_1778402592_iron_penitent.png`. Single yes/no would unblock the validation chain.

## Coordination housekeeping

- Visibility dashboard now cloud-hosted at https://gonzo8285.github.io/claudebridge-dashboard/. Gallowfell is workstream #2 in the priority spine; ff-151 is told it never touches `Gonzo8285/MobileGame`.
- PPC will not author engine commits here. This file is a coordination note; next heartbeat picks it up and pushes it. No `.gd` / `.tres` / enum edits this run.

— paul-pc 2026-05-12T15:55Z
