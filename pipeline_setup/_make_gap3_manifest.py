"""Generate _gap3_manifest.json — art for the 3 spec-less cards
(C41 Bog-Bargain Recall, C42 Black Mire Pact, P41 Last Vows).

All three are SPELL/TRAP -> figureless object/scene treatment, same proven
transform as the validated event cards. Prompts hand-crafted from each card's
display_name + flavour_text (no art_spec exists for these). Output lands in
_showcase/full/<faction>/ so integrate_card_art.py picks them up next.
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SHOWCASE = ROOT / "showcase_manifest.json"
OUT = ROOT / "_gap3_manifest.json"

STYLE = ("masterpiece, magic the gathering card art, oil painting, painterly, "
         "photographic depth, low-key lighting, cinematic, atmospheric, dark "
         "fantasy, grimdark, gallows-haunted mood, doomed grandeur, muted "
         "earth-tone palette, single accent colour focal, in the style of "
         "Steve Argyle and Volkan Baga, ")
QUALITY = (", extremely detailed, sharp focus, professional, intricate "
           "brushwork, volumetric lighting, oil-paint texture visible in "
           "highlights, 8k, hyper-detailed, masterpiece quality")
FIGURELESS = ("deserted empty environment, abandoned scene, absolutely no "
              "people, no figures, unpopulated, still-life of objects and "
              "place, ")
NEG = ("anime, cartoon, modern clothing, text, watermark, deformed, low "
       "quality, blurry, jpeg artifacts, extra limbs, bad anatomy, signature, "
       "username, logo, explicit gore, severed limbs, exposed organs, blood "
       "pools, person, people, figure, human, character, portrait, face, "
       "hands, crowd, silhouette of a person")

TILES = [
    {
        "tile_id": "C41", "display_name": "Bog-Bargain Recall",
        "faction": "coven", "filename": "c41_bog_bargain_recall.png",
        "seed": 54141,
        "subject": ("a black fetid bog surface mid-exchange, the mire "
                    "swallowing and regurgitating a tarnished demon-coin, "
                    "concentric ripples and reaching tendrils of mud, sunken "
                    "offerings glinting under brackish water, fungal "
                    "swamp-grove, bog-green accent"),
    },
    {
        "tile_id": "C42", "display_name": "Black Mire Pact",
        "faction": "coven", "filename": "c42_black_mire_pact.png",
        "seed": 54142,
        "subject": ("an ominous pact-circle of black tar and bone pressed "
                    "into a bubbling mire, ritual glyph etched in the mud, "
                    "sunken ribs and reeds, oozing bog-spawn slick, "
                    "fungal-grove gloom, bog-green accent"),
    },
    {
        "tile_id": "P41", "display_name": "Last Vows",
        "faction": "iron_penitents", "filename": "p41_last_vows.png",
        "seed": 14141,
        "subject": ("a deserted cathedral-ruin sacrificial dais, a discarded "
                    "tarnished brass execution-mask resting on bloodied "
                    "prayer-ropes, guttering candles, drifting ash and "
                    "cinders, hammer-and-rope motif carved in stone, "
                    "rust-red accent"),
    },
]

base = json.loads(SHOWCASE.read_text(encoding="utf-8"))
tiles = []
for t in TILES:
    tiles.append({
        "tile_id": t["tile_id"],
        "display_name": t["display_name"],
        "role": "event",
        "spec_path": "(none — gap card, prompt from .tres)",
        "positive_prompt": STYLE + "environment establishing shot, " +
            FIGURELESS + t["subject"] +
            ", the focal object/effect as the unmistakable central subject, "
            "wide establishing shot, environment-led, deserted, moody "
            "atmospheric composition, painterly atmospheric perspective" +
            QUALITY,
        "negative_prompt": NEG,
        "seed": t["seed"],
        "output_subdir": f"_showcase/full/{t['faction']}",
        "output_filename": t["filename"],
        "width": 832, "height": 1216, "steps": 30, "cfg": 6.5,
        "sampler": "dpmpp_2m", "scheduler": "karras",
    })
base["tiles"] = tiles
base["generated_for"] = "gap-card art (C41/C42/P41)"
OUT.write_text(json.dumps(base, indent=2, ensure_ascii=False), encoding="utf-8")
for t in tiles:
    print(t["tile_id"], "->", t["output_subdir"] + "/" + t["output_filename"])
print("wrote", OUT.name, "tiles:", len(tiles))
