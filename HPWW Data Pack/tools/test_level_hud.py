"""Check the shipped effect textures. Run with python tools/test_level_hud.py."""
import json
import unittest

from PIL import Image

from build_level_hud import ART, ASSETS, CHAINS


def effect_tile(effect):
    render_pass, = json.loads((CHAINS / (effect + ".json")).read_text())["passes"]
    sampler, = render_pass["inputs"]
    namespace, path = sampler["location"].split(":")
    # This is the client's texture lookup, independent of the builder's output path.
    with Image.open(ASSETS / namespace / "textures/effect" / (path + ".png")) as atlas:
        assert atlas.size == (sampler["width"], sampler["height"])
        tile, _, width, height = render_pass["uniforms"]["TileConfig"][0]["value"]
        x, y = (abs(tile) % 16) * 32, (abs(tile) // 16) * 32
        return atlas.convert("RGBA").crop((x, y, x + width, y + height))


class LevelHudTest(unittest.TestCase):
    def test_fill_is_visible_through_highlight_and_number(self):
        border = effect_tile("highlight")
        number = effect_tile("number/2")
        frames = set()
        with Image.open(ART / "front/fg_level_front_highlight.png") as gold:
            for i in range(31):
                with self.subTest(frame=i), Image.open(ART / f"fill/fg_level_fill_{i}.png") as fill:
                    expected = Image.alpha_composite(fill.convert("RGBA"), gold.convert("RGBA"))
                    actual = Image.alpha_composite(effect_tile(f"fill/{i}"), border)
                    self.assertEqual(expected.tobytes(), actual.tobytes())
                    frames.add(Image.alpha_composite(actual, number).tobytes())
        self.assertEqual(len(frames), 31)

    def test_counter_palette(self):
        with Image.open(ART.parent / "effect/level/hud_atlas.png") as atlas:
            for tile in range(82, 95):  # Digits, XP suffix, plus and minus.
                x, y = tile % 16 * 32, tile // 16 * 32
                colors = {c for _, c in atlas.crop((x, y, x + 32, y + 32)).getcolors() if c[3]}
                self.assertEqual(colors, {(255, 223, 134, 255), (57, 40, 19, 255)})


if __name__ == "__main__":
    unittest.main()
