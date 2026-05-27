"""
c8_deck_builder_v0.py — D3 deck-builder sub-module (phased C8.D3a)

Implements `c8_deck_construction_v0.md` §3–§10.

**Status:** v0 scaffold. Encodes the §4 per-archetype spine table and the §5
flex bucket as in-module constants for stand-alone testability. The
production D3 build (per §10 step 4) MUST parse `archetypes_v0.md`,
`cards_<faction>_v1.md`, and each card's `.tres` at sim startup rather than
hard-code IDs — the constants here are the reference tables the parser
should match against, plus a fail-loud guard if the parsed pool diverges.

**Gating:** The full sim runner `c8_sim_runner.py` is gated on Paul Q1
(Option β endorsement) per `c7_v0_2_balance_audit.md`. This deck-builder is
grid-agnostic (Option β changes the counter grid in archetypes_v0.md, not
deck composition) and ships ahead of the game-loop module as a phased D3
deliverable per master file 02_Gallowfell.md "Deck-builder sub-module is
now UNGATED (D2.5 spec is grid-agnostic)".

**Authoring authority:** spec-doc lane only — this file is a Python
implementation of the spec, not engine code. Self-test runs at
`if __name__ == "__main__"` against an in-module mock pool that exercises
all 10 validation gates from §8.

**Anti-P2W invariants restated (per c8_ai_policy_v0.md §6):**
the deck-builder MUST NOT read `treatment_id`, `acquired_via`,
`xp_multiplier_sources`, `warlord_xp`, or any monetisation-shaped field.
A `Card` here exposes ONLY the fields the engine truth (the .tres) carries
that are relevant to deck composition: id, faction, cost, card_type,
keywords, is_token, is_draftable, archetype_tags.

Author: Controller, hourly backlog cycle #13 (2026-05-27T05:25Z)
Spec ref: c8_deck_construction_v0.md (D2.5, cycle #11)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple


# ---------------------------------------------------------------------------
# Constants — bucket sizes per §3
# ---------------------------------------------------------------------------

DECK_SIZE: int = 20
SPINE_SIZE: int = 12
UTILITY_SIZE: int = 6
FLEX_SIZE: int = 2

OPENING_HAND_SIZE: int = 5            # §7 step 1 (StS convention)
LOW_COST_MIN_IN_DECK: int = 4         # §8 gate 5
MIN_FACTION_POOL: int = 17            # §10 step 2

# Mulligan seed XOR per §7 (D3 picks the constant, documented in code).
MULL_TAG: int = 0x4D554C32 ^ 0x303236


# ---------------------------------------------------------------------------
# Data model — minimal Card shape (anti-P2W compliant)
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Card:
    id: str
    faction: str          # "iron_penitents" | "ash_mourners" | "coven" | "last_legion" | "skinward_pact"
    cost: int
    card_type: str        # "UNIT" | "SPELL" | "TRAP" | "RELIC"
    rarity: str           # "COMMON" | "UNCOMMON" | "RARE" | "EPIC" | "LEGENDARY"
    is_token: bool = False
    is_draftable: bool = True
    archetype_tags: Tuple[str, ...] = ()   # e.g. ("A1", "A2") for multi-archetype splash


@dataclass
class Deck:
    archetype_id: str
    spine: List[Card] = field(default_factory=list)
    utility: List[Card] = field(default_factory=list)
    flex: List[Card] = field(default_factory=list)
    fallback_warnings: List[str] = field(default_factory=list)

    def all_cards(self) -> List[Card]:
        return list(self.spine) + list(self.utility) + list(self.flex)

    def distinct_ids(self) -> List[str]:
        # Per §8 gate 2 — all 20 cards have distinct IDs. Flex weighting is a
        # probability-mass property (deck weight=2 in shuffle), not a second
        # physical card. See §5 edge-case paragraph for the contract.
        seen: List[str] = []
        for c in self.all_cards():
            if c.id not in seen:
                seen.append(c.id)
        return seen


# ---------------------------------------------------------------------------
# Per-archetype reference tables (from c8_deck_construction_v0.md §4 + §5)
# ---------------------------------------------------------------------------
#
# These are REFERENCE TABLES that document the per-archetype intent. The
# production D3 build parses archetypes_v0.md and cards_<faction>_v1.md at
# runtime per §10 step 4; this module exposes the tables as constants so the
# self-test below can run stand-alone without source-doc parsing.
#
# Each tuple: (identity_card_id, payoff_card_id, named_spine_card_ids,
#              flex_card_ids, faction)
# Named spine is identity + payoff + 2/3/4-cost spine + Phase 2.13 / M2 adds
# per c8_ai_policy_v0.md §5. Supporting-cast 5–6 are drawn from the faction
# pool's archetype-tagged block at build time (see §4 last paragraph).

ARCHETYPE_TABLE: Dict[str, Dict[str, object]] = {
    # ---- Iron Penitents (A1 / A2 / A3 share P10 + P14 — identity-overlap rule §4) ----
    "A1": {"name": "Bleed-Stack",        "identity": "P10", "payoff": "P14",
           "named_spine": ("P10", "P14", "P3", "P4", "P5", "P8", "P41"),
           "flex": ("P3", "P34"), "faction": "iron_penitents"},
    "A2": {"name": "Sacrifice-Penance",  "identity": "P10", "payoff": "P14",
           "named_spine": ("P10", "P14", "P9", "P5", "P3", "P7", "P41"),
           "flex": ("P9", "P7"), "faction": "iron_penitents"},
    "A3": {"name": "Cleave-Melee",       "identity": "P10", "payoff": "P14",
           "named_spine": ("P10", "P14", "P4", "P5", "P8", "P3"),
           "flex": ("P8", "P34"), "faction": "iron_penitents"},
    # ---- Ash-Mourners ----
    "B1": {"name": "Smoke-Fear Control", "identity": "M14", "payoff": "M8",
           "named_spine": ("M14", "M8", "M3", "M2", "M4", "M1"),
           "flex": ("M14", "M8"), "faction": "ash_mourners"},
    "B2": {"name": "Resurrect-Spam",     "identity": "M12", "payoff": "M24",
           "named_spine": ("M12", "M24", "M2", "M1", "M4", "M3", "M41"),
           "flex": ("M12", "M24"), "faction": "ash_mourners"},
    "B3": {"name": "Trap-Control",       "identity": "M14", "payoff": "M11",
           "named_spine": ("M14", "M11", "M9", "M10", "M2", "M4"),
           "flex": ("M11", "M9"), "faction": "ash_mourners"},
    # ---- Coven of the Black Mire ----
    "C1": {"name": "Poison-Stack",       "identity": "C5",  "payoff": "C6",
           "named_spine": ("C5", "C6", "C3", "C4", "C8"),
           "flex": ("C5", "C6"), "faction": "coven"},
    "C2": {"name": "Bog-Spawn Swarm",    "identity": "C2",  "payoff": "C6",
           # C2-Token is excluded per §3; substitute Token-spawners (C7 etc.).
           "named_spine": ("C6", "C4", "C5", "C7"),
           "flex": ("C7", "C8"), "faction": "coven"},
    "C3": {"name": "Sacrifice-Combo",    "identity": "C5",  "payoff": "C42",
           "named_spine": ("C5", "C42", "C3", "C4", "C41"),
           "flex": ("C41", "C42"), "faction": "coven"},
    # ---- The Last Legion ----
    "D1": {"name": "Rally-Formation",    "identity": "L2",  "payoff": "L33",
           # Identity-by-density: L2 Foundry-Sworn Pikeman per §4 table row D1.
           "named_spine": ("L2", "L33", "L3", "L6"),
           "flex": ("L33", "L6"), "faction": "last_legion"},
    "D2": {"name": "Tempo-Echo",         "identity": "L18", "payoff": "L18",
           "named_spine": ("L4", "L7", "L18", "L25"),
           "flex": ("L18", "L25"), "faction": "last_legion"},
    "D3": {"name": "Banner-Buff",        "identity": "L33", "payoff": "L34",
           "named_spine": ("L30", "L31", "L33", "L34", "L41"),
           "flex": ("L33", "L41"), "faction": "last_legion"},
    # ---- Skinward Pact ----
    "E1": {"name": "Big-Monster",        "identity": "W4",  "payoff": "W8",
           # Spine intentionally thin at 2 cards per §4 empty-slot fallback.
           "named_spine": ("W4", "W8"),
           "flex": ("W4", "W8"), "faction": "skinward_pact"},
    "E2": {"name": "Transformation",     "identity": "W19", "payoff": "W19",
           "named_spine": ("W19",),
           "flex": ("W19",), "faction": "skinward_pact"},
    "E3": {"name": "Beast-Summon",       "identity": "W31", "payoff": "W34",
           # W27/W28 Tokens excluded per §3; W41/W42 added per Phase 2.13.
           "named_spine": ("W31", "W34", "W41", "W42"),
           "flex": ("W41", "W42"), "faction": "skinward_pact"},
}

ARCHETYPE_IDS: Tuple[str, ...] = tuple(ARCHETYPE_TABLE.keys())

# Phase 2.13 / M2 commons that §8 gates 8 + 9 explicitly require in their
# spine decks. Kept as a separate constant so the gate code reads cleanly.
PHASE_213_REQUIRED: Dict[str, Tuple[str, ...]] = {
    "B2": ("M41",),
    "D3": ("L41",),
    "E3": ("W41", "W42"),
}
M2_REQUIRED: Dict[str, Tuple[str, ...]] = {
    "A1": ("P41",),
    "A2": ("P41",),
    "C3": ("C41", "C42"),
}


# ---------------------------------------------------------------------------
# Build path
# ---------------------------------------------------------------------------

def _faction_pool(card_pool: List[Card], faction: str) -> List[Card]:
    return [c for c in card_pool if c.faction == faction]


def _pool_by_id(card_pool: List[Card]) -> Dict[str, Card]:
    return {c.id: c for c in card_pool}


def _archetype_tagged(card_pool: List[Card], faction: str, arch_id: str) -> List[Card]:
    return [c for c in _faction_pool(card_pool, faction) if arch_id in c.archetype_tags]


def _sort_pool(cards: List[Card]) -> List[Card]:
    # §9 determinism — supporting cast in card_id ascending; utility bucket
    # in cost-ascending-then-id-ascending order. Caller picks which sort.
    return sorted(cards, key=lambda c: c.id)


def _sort_pool_cost_then_id(cards: List[Card]) -> List[Card]:
    return sorted(cards, key=lambda c: (c.cost, c.id))


def build_deck(archetype_id: str, card_pool: List[Card]) -> Deck:
    """
    Build a 20-card pseudo-deck for the given archetype.

    Pure function of (archetype_id, card_pool) per §9. Re-running with the
    same inputs MUST produce a byte-identical Deck.
    """
    if archetype_id not in ARCHETYPE_TABLE:
        raise ValueError(f"unknown archetype {archetype_id}")

    arch = ARCHETYPE_TABLE[archetype_id]
    faction = arch["faction"]                                 # type: ignore[index]
    by_id = _pool_by_id(card_pool)
    deck = Deck(archetype_id=archetype_id)

    # ---- Spine (12 cards) ----
    spine_ids_taken: List[str] = []
    for cid in arch["named_spine"]:                           # type: ignore[index]
        if cid in by_id and cid not in spine_ids_taken:
            deck.spine.append(by_id[cid])
            spine_ids_taken.append(cid)

    # Pad spine from archetype-tagged supporting cast (§4 last paragraph).
    if len(deck.spine) < SPINE_SIZE:
        supporting = _sort_pool(_archetype_tagged(card_pool, faction, archetype_id))  # type: ignore[arg-type]
        for c in supporting:
            if len(deck.spine) >= SPINE_SIZE:
                break
            if c.id in spine_ids_taken:
                continue
            # §3 + §8 gate 6: exclude Tokens, undraftable, Relics.
            if c.is_token or not c.is_draftable or c.card_type == "RELIC":
                continue
            deck.spine.append(c)
            spine_ids_taken.append(c.id)

    # Empty-slot fallback (§4 last paragraph) — pad with on-curve generics.
    if len(deck.spine) < SPINE_SIZE:
        short_by = SPINE_SIZE - len(deck.spine)
        generics = _sort_pool_cost_then_id([
            c for c in _faction_pool(card_pool, faction)      # type: ignore[arg-type]
            if c.id not in spine_ids_taken
            and not c.is_token and c.is_draftable
            and c.card_type != "RELIC"
        ])
        for c in generics:
            if len(deck.spine) >= SPINE_SIZE:
                break
            deck.spine.append(c)
            spine_ids_taken.append(c.id)
        deck.fallback_warnings.append(
            f"[deck_builder] FALLBACK: {archetype_id} spine short by {short_by}, padded with generics"
        )

    # ---- Flex (2 cards) ----
    # Per §5, flex slots are often duplicates of spine cards. The spec's
    # edge-case (§5 last paragraph) says: "if a flex slot card is already in
    # the Spine bucket, the builder enforces deck size = 20 by treating the
    # duplicate as one card with weight=2 in the shuffle deck". So at the
    # Deck-object layer the flex bucket physically holds Card references
    # (the same Card may appear in spine and flex), but `distinct_ids()`
    # returns 20 IDs because flex-overlap-with-spine collapses for ID count.
    for cid in arch["flex"]:                                  # type: ignore[index]
        if cid in by_id:
            deck.flex.append(by_id[cid])

    # ---- Utility — §6, sized to keep deck distinct-ID count at 20 ----
    # Per §3 + §5 last paragraph: total distinct IDs = 20. Flex slots that
    # overlap with spine collapse to weight=2 probability mass; utility
    # backfills the shortfall so the deck still has 20 distinct IDs.
    spine_or_flex_ids = {c.id for c in deck.spine} | {c.id for c in deck.flex}
    target_utility = DECK_SIZE - len(spine_or_flex_ids)
    candidates = [
        c for c in _faction_pool(card_pool, faction)          # type: ignore[arg-type]
        if c.id not in spine_or_flex_ids
        and not c.is_token and c.is_draftable
        and c.card_type != "RELIC"
        and c.card_type == "UNIT"                              # §6 rule 4 — prefer Units
        and c.cost in (1, 2)                                   # §6 rule 2 — 1c/2c bias
    ]
    utility = _sort_pool_cost_then_id(candidates)[:target_utility]
    deck.utility.extend(utility)

    # Pad utility bucket if short (§6 rule 3 fallback). Log per §8 gate 10.
    if len(deck.utility) < target_utility:
        short_by = target_utility - len(deck.utility)
        used = spine_or_flex_ids | {c.id for c in deck.utility}
        relaxed = _sort_pool_cost_then_id([
            c for c in _faction_pool(card_pool, faction)      # type: ignore[arg-type]
            if c.id not in used
            and not c.is_token and c.is_draftable
            and c.card_type == "UNIT"
            and c.cost == 3
        ])
        for c in relaxed:
            if len(deck.utility) >= target_utility:
                break
            deck.utility.append(c)
        if len(deck.utility) < target_utility:
            # Final fallback — any draftable Unit/Spell/Trap from faction pool.
            used = spine_or_flex_ids | {c.id for c in deck.utility}
            any_card = _sort_pool_cost_then_id([
                c for c in _faction_pool(card_pool, faction)  # type: ignore[arg-type]
                if c.id not in used
                and not c.is_token and c.is_draftable
                and c.card_type != "RELIC"
            ])
            for c in any_card:
                if len(deck.utility) >= target_utility:
                    break
                deck.utility.append(c)
        deck.fallback_warnings.append(
            f"[deck_builder] FALLBACK: {archetype_id} utility bucket padded "
            f"to 3c+ at slot {target_utility - short_by + 1} (target={target_utility})"
        )

    return deck


# ---------------------------------------------------------------------------
# Validation gates (§8)
# ---------------------------------------------------------------------------

class DeckValidationError(Exception):
    """Raised when a §8 fail-loud gate trips. Per §8 last paragraph,
    D3 aborts the sim — no partial-result production."""


def validate_deck(deck: Deck) -> None:
    """
    Run all 10 validation gates from §8 against a built deck.

    Raises DeckValidationError on any FAIL-LOUD gate trip (gates 1–9).
    Gate 10 (fallback warnings non-fatal) is exercised by inspecting
    deck.fallback_warnings — surfaced in D4 results doc.
    """
    arch = ARCHETYPE_TABLE.get(deck.archetype_id)
    if arch is None:
        raise DeckValidationError(f"unknown archetype {deck.archetype_id}")

    # Gate 1 — deck size = 20.
    if len(deck.distinct_ids()) != DECK_SIZE:
        raise DeckValidationError(
            f"gate 1: {deck.archetype_id} deck has {len(deck.distinct_ids())} distinct cards, expected {DECK_SIZE}"
        )

    # Gate 2 — all 20 IDs distinct.
    spine_ids = [c.id for c in deck.spine]
    utility_ids = [c.id for c in deck.utility]
    # Flex IDs may overlap with spine (weight=2 trick); but spine + utility
    # alone must have no duplicates, and a flex slot must either match a
    # spine ID or be a fresh-into-utility-territory ID that's still distinct.
    if len(set(spine_ids)) != len(spine_ids):
        raise DeckValidationError(f"gate 2: {deck.archetype_id} spine has duplicate IDs")
    if len(set(utility_ids)) != len(utility_ids):
        raise DeckValidationError(f"gate 2: {deck.archetype_id} utility has duplicate IDs")

    # Gate 3 — identity card present.
    identity_id = arch["identity"]                            # type: ignore[index]
    if not any(c.id == identity_id for c in deck.all_cards()):
        raise DeckValidationError(f"gate 3: {deck.archetype_id} missing identity card {identity_id}")

    # Gate 4 — payoff card present.
    payoff_id = arch["payoff"]                                # type: ignore[index]
    if not any(c.id == payoff_id for c in deck.all_cards()):
        raise DeckValidationError(f"gate 4: {deck.archetype_id} missing payoff card {payoff_id}")

    # Gate 5 — at least 4 cards at 1c or 2c.
    low_cost = sum(1 for c in deck.all_cards() if c.cost <= 2)
    if low_cost < LOW_COST_MIN_IN_DECK:
        raise DeckValidationError(
            f"gate 5: {deck.archetype_id} has {low_cost} low-cost cards, expected >= {LOW_COST_MIN_IN_DECK}"
        )

    # Gate 6 — no Tokens, no Relics, no is_draftable=false cards.
    for c in deck.all_cards():
        if c.is_token:
            raise DeckValidationError(f"gate 6: {deck.archetype_id} contains Token {c.id}")
        if not c.is_draftable:
            raise DeckValidationError(f"gate 6: {deck.archetype_id} contains non-draftable {c.id}")
        if c.card_type == "RELIC":
            raise DeckValidationError(f"gate 6: {deck.archetype_id} contains Relic {c.id}")

    # Gate 7 — all cards belong to the archetype's faction.
    faction = arch["faction"]                                 # type: ignore[index]
    for c in deck.all_cards():
        if c.faction != faction:
            raise DeckValidationError(
                f"gate 7: {deck.archetype_id} contains cross-faction card {c.id} ({c.faction})"
            )

    # Gate 8 — Phase 2.13 commons present in respective spine decks.
    required_213 = PHASE_213_REQUIRED.get(deck.archetype_id, ())
    for cid in required_213:
        if not any(c.id == cid for c in deck.spine):
            raise DeckValidationError(
                f"gate 8: {deck.archetype_id} missing Phase 2.13 common {cid} from spine"
            )

    # Gate 9 — Phase 2.9 M2 cards present in respective spine decks.
    required_m2 = M2_REQUIRED.get(deck.archetype_id, ())
    for cid in required_m2:
        if not any(c.id == cid for c in deck.spine):
            raise DeckValidationError(
                f"gate 9: {deck.archetype_id} missing M2 sacrifice-loop card {cid} from spine"
            )

    # Gate 10 — fallback warnings are non-fatal. No raise. D4 surfaces them.


def verify_pool_integrity(card_pool: List[Card]) -> None:
    """§10 step 2 — pool integrity check at parse-time. Fails loud if any
    faction has fewer cards than the spine + flex + utility minimum."""
    factions: Dict[str, int] = {}
    for c in card_pool:
        factions[c.faction] = factions.get(c.faction, 0) + 1
    for faction, n in factions.items():
        if n < MIN_FACTION_POOL:
            raise DeckValidationError(
                f"pool integrity: faction '{faction}' has {n} cards, expected >= {MIN_FACTION_POOL}"
            )


# ---------------------------------------------------------------------------
# In-module mock pool for self-test (stand-alone, no source-doc parsing)
# ---------------------------------------------------------------------------

def _mock_pool() -> List[Card]:
    """Minimal in-memory card pool that exercises the build + validate path
    for a few representative archetypes. Production D3 replaces this with a
    runtime parse of cards_<faction>_v1.md + each card's .tres per §10."""
    pool: List[Card] = []

    # Iron Penitents (faction A1/A2/A3) — enough breadth for shared-identity
    # spine + 1c/2c utility filler.
    pool.extend([
        # Identity / payoff
        Card("P10", "iron_penitents", 4, "UNIT", "RARE", archetype_tags=("A1", "A2", "A3")),
        Card("P14", "iron_penitents", 3, "SPELL", "RARE", archetype_tags=("A1", "A2", "A3")),
        # Spine (mixed costs)
        Card("P3",  "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=("A1", "A3")),
        Card("P4",  "iron_penitents", 3, "UNIT", "COMMON", archetype_tags=("A1", "A3")),
        Card("P5",  "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=("A1", "A2", "A3")),
        Card("P7",  "iron_penitents", 3, "UNIT", "COMMON", archetype_tags=("A2",)),
        Card("P8",  "iron_penitents", 4, "UNIT", "UNCOMMON", archetype_tags=("A1", "A3")),
        Card("P9",  "iron_penitents", 3, "UNIT", "UNCOMMON", archetype_tags=("A2",)),
        Card("P34", "iron_penitents", 3, "UNIT", "UNCOMMON", archetype_tags=("A1", "A3")),
        Card("P41", "iron_penitents", 0, "SPELL", "COMMON", archetype_tags=("A1", "A2")),
        # Utility-bucket-eligible 1c/2c Units
        Card("P15", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=("A1",)),
        Card("P16", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=("A3",)),
        Card("P17", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=("A1",)),
        Card("P18", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=("A2",)),
        Card("P19", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=("A3",)),
        Card("P20", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=("A1",)),
        # 3c padding for fallback
        Card("P21", "iron_penitents", 3, "UNIT", "COMMON", archetype_tags=("A1",)),
        Card("P22", "iron_penitents", 3, "UNIT", "COMMON", archetype_tags=("A2",)),
        Card("P23", "iron_penitents", 3, "UNIT", "COMMON", archetype_tags=("A3",)),
        # Extra 1c/2c utility candidates to keep distinct-ID count at 20
        Card("P24", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=()),
        Card("P25", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=()),
        Card("P26", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=()),
        Card("P27", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=()),
        Card("P28", "iron_penitents", 1, "UNIT", "COMMON", archetype_tags=()),
        Card("P29", "iron_penitents", 2, "UNIT", "COMMON", archetype_tags=()),
        # Relic (must be excluded per §3 / §8 gate 6)
        Card("P39", "iron_penitents", 5, "RELIC", "RARE", is_draftable=False),
        Card("P40", "iron_penitents", 5, "RELIC", "RARE", is_draftable=False),
    ])

    # Ash-Mourners — B2 Resurrect-Spam test path includes M41 (Phase 2.13)
    pool.extend([
        Card("M1",  "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=("B1", "B2")),
        Card("M2",  "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=("B1", "B2", "B3")),
        Card("M3",  "ash_mourners", 3, "UNIT", "COMMON", archetype_tags=("B1", "B2")),
        Card("M4",  "ash_mourners", 3, "UNIT", "COMMON", archetype_tags=("B1", "B2", "B3")),
        Card("M8",  "ash_mourners", 4, "UNIT", "RARE",   archetype_tags=("B1",)),
        Card("M9",  "ash_mourners", 1, "TRAP", "COMMON", archetype_tags=("B3",)),
        Card("M10", "ash_mourners", 2, "TRAP", "COMMON", archetype_tags=("B3",)),
        Card("M11", "ash_mourners", 4, "UNIT", "RARE",   archetype_tags=("B3",)),
        Card("M12", "ash_mourners", 4, "UNIT", "RARE",   archetype_tags=("B2",)),
        Card("M14", "ash_mourners", 4, "UNIT", "RARE",   archetype_tags=("B1", "B3")),
        Card("M24", "ash_mourners", 5, "UNIT", "UNCOMMON", archetype_tags=("B2",)),
        Card("M41", "ash_mourners", 3, "UNIT", "UNCOMMON", archetype_tags=("B2",)),
        # Utility-bucket fillers
        Card("M15", "ash_mourners", 1, "UNIT", "COMMON", archetype_tags=("B1",)),
        Card("M16", "ash_mourners", 1, "UNIT", "COMMON", archetype_tags=("B2",)),
        Card("M17", "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=("B1",)),
        Card("M18", "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=("B2",)),
        Card("M19", "ash_mourners", 1, "UNIT", "COMMON", archetype_tags=("B3",)),
        Card("M20", "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=("B2",)),
        # Extra B2-tagged supporting cast + neutral fillers
        Card("M5",  "ash_mourners", 3, "UNIT", "COMMON", archetype_tags=("B2",)),
        Card("M6",  "ash_mourners", 3, "UNIT", "COMMON", archetype_tags=("B1", "B2")),
        Card("M21", "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=()),
        Card("M22", "ash_mourners", 1, "UNIT", "COMMON", archetype_tags=()),
        Card("M23", "ash_mourners", 2, "UNIT", "COMMON", archetype_tags=()),
        Card("M25", "ash_mourners", 1, "UNIT", "COMMON", archetype_tags=()),
    ])

    return pool


# ---------------------------------------------------------------------------
# Self-test (smoke)
# ---------------------------------------------------------------------------

def _selftest() -> int:
    """Smoke-test build + validate for two archetypes covering distinct
    code paths (A1 = identity-overlap rule, B2 = Phase 2.13 gate 8 fires)."""
    pool = _mock_pool()
    failed = 0

    print("[deck_builder] self-test starting...")
    print(f"[deck_builder] pool size = {len(pool)} cards across {len({c.faction for c in pool})} factions")

    # §10 step 2 — pool integrity (note: mock pool only has 2 factions, so
    # MIN_FACTION_POOL guard would fail for the full 5-faction expectation;
    # the per-faction sample sizes here pass the 17-card minimum).
    try:
        verify_pool_integrity(pool)
        print("[deck_builder] pool integrity: PASS")
    except DeckValidationError as exc:
        print(f"[deck_builder] pool integrity: FAIL — {exc}")
        failed += 1

    for arch_id in ("A1", "B2"):
        try:
            deck = build_deck(arch_id, pool)
            print(
                f"[deck_builder] built {arch_id}: spine={len(deck.spine)}, "
                f"utility={len(deck.utility)}, flex={len(deck.flex)}, "
                f"distinct_ids={len(deck.distinct_ids())}"
            )
            if deck.fallback_warnings:
                for w in deck.fallback_warnings:
                    print(f"  warning: {w}")
            validate_deck(deck)
            print(f"[deck_builder] {arch_id} validation: PASS")
        except DeckValidationError as exc:
            print(f"[deck_builder] {arch_id} validation: FAIL — {exc}")
            failed += 1
        except Exception as exc:  # noqa: BLE001 — smoke-test catches all
            print(f"[deck_builder] {arch_id} build: ERROR — {type(exc).__name__}: {exc}")
            failed += 1

    # Determinism check (§9) — same inputs → byte-identical Deck IDs.
    deck_a = build_deck("A1", pool)
    deck_b = build_deck("A1", pool)
    if [c.id for c in deck_a.all_cards()] == [c.id for c in deck_b.all_cards()]:
        print("[deck_builder] determinism: PASS (A1 re-build matches)")
    else:
        print("[deck_builder] determinism: FAIL (A1 re-build diverged)")
        failed += 1

    print(f"[deck_builder] self-test complete — {failed} failure(s)")
    return failed


if __name__ == "__main__":
    raise SystemExit(_selftest())
