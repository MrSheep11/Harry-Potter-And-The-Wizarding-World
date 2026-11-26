"""Rebuild HPWW's 26.3 level HUD atlas and static /posteffect IDs (requires Pillow)."""
import json
from pathlib import Path

from PIL import Image, ImageDraw

ASSETS = Path(__file__).resolve().parents[2] / "HPWW Resource Pack" / "assets"
ART = ASSETS / "hpww_field_guide" / "textures" / "level"
CHAINS = ASSETS / "hpww" / "post_effect" / "level"
ATLAS_ID = "hpww_field_guide:level/hud_atlas"
CELL = 32
W, H = 512, 256
DIGITS = ("111101101101111", "010110010010111", "111001111100111",
          "111001111001111", "101101111001001", "111100111001111",
          "111100111101111", "111001010010010", "111101111101111",
          "111101111001111")
XP = ("101101010101101", "110101110100100")
PLUS = "000010111010000"
MINUS = "000000111000000"


def sprite(rel):
    with Image.open(ART / rel) as source:
        if source.size != (CELL, CELL):
            raise ValueError(f"Expected 32x32 level art: {rel}")
        return source.convert("RGBA")


def number(level):
    if level <= 20:
        return sprite(f"number/fg_level_number_{level}.png")
    # The right-hand digits of the original 10..19 form a complete matching alphabet.
    out = Image.new("RGBA", (CELL, CELL))
    for digit, left in ((level // 10, 6), (level % 10, 15)):
        source = number(10 + digit).crop((15, 6, 25, 27))
        out.alpha_composite(source, (left, 6))
    return out


def tiny(*patterns):
    tile = Image.new("RGBA", (CELL, CELL))
    draw = ImageDraw.Draw(tile)
    for offset, color in ((1, "#392813"), (0, "#ffdf86")):
        for n, pattern in enumerate(patterns):
            for i, pixel in enumerate(pattern):
                if pixel == "1":
                    draw.point((n * 4 + i % 3 + offset, i // 3 + offset), fill=color)
    return tile


def build():
    atlas = Image.new("RGBA", (W, H))

    def put(index, image):
        atlas.paste(image, ((index % 16) * CELL, (index // 16) * CELL))

    def effect(name, index, pos=-1, width=32, height=32):
        # Direct to main with no scene sampler: transparent pixels discard instead of
        # copying the entire framebuffer twice per layer. Only a tiny triangle is drawn.
        config = {"passes": [{
            "vertex_shader": "hpww:post/level_hud", "fragment_shader": "hpww:post/level_hud",
            "inputs": [{"sampler_name": "Atlas", "location": ATLAS_ID,
                        "width": W, "height": H}],
            "output": "minecraft:main",
            "uniforms": {"TileConfig": [{"name": "TileData", "type": "vec4",
                                         "value": [index, pos, width, height]}]},
        }], "targets": {}}
        path = CHAINS / (name + ".json")
        path.parent.mkdir(exist_ok=True, parents=True)
        path.write_text(json.dumps(config, separators=(",", ":")) + "\n", encoding="ascii")

    front = sprite("front/fg_level_front_normal.png")
    gold = sprite("front/fg_level_front_highlight.png")
    for frame in range(31):
        fill = sprite(f"fill/fg_level_fill_{frame}.png")
        put(frame, Image.alpha_composite(fill, front))
        effect(f"fill/{frame}", frame)
        # Older worlds may still have these combined effect IDs saved on players.
        put(96 + frame, Image.alpha_composite(fill, gold))
        effect(f"fill/{31 + frame}", 96 + frame)
    put(95, gold)
    effect("highlight", 95)
    for level in range(1, 51):
        put(31 + level, number(level))
        effect(f"number/{level}", 31 + level)
    for digit, pattern in enumerate(DIGITS):
        put(82 + digit, tiny(pattern))
        for pos in range(10):
            effect(f"gain/{pos}_{digit}", 82 + digit, pos, 10 if pos == 0 else 5, 6)
        if digit:
            effect(f"gain/0_n{digit}", -(82 + digit), 0, 10, 6)
    put(92, tiny(*XP))
    put(93, tiny(PLUS))
    put(94, tiny(MINUS))
    for pos in range(1, 11):
        effect(f"gain/{pos}_e", 92, pos, 8, 6)
    # PostChain prefixes texture input locations with textures/effect/ in 26.3.
    namespace, path = ATLAS_ID.split(":")
    output = ASSETS / namespace / "textures" / "effect" / (path + ".png")
    output.parent.mkdir(parents=True, exist_ok=True)
    atlas.save(output)


if __name__ == "__main__":
    build()
