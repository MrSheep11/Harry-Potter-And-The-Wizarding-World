"""Build isolated HPWW release copies; never edit the working packs."""

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import urllib.request
import zipfile
from collections import Counter
from pathlib import Path


SOURCE = Path(__file__).resolve().parents[1]
RESOURCE_SOURCE = SOURCE.parent / "HPWW Resource Pack"
DEFAULT_WORK = Path.home() / "Documents/Codex/2026-11-07/hpww-release"
CLIENT_OLD = Path.home() / "AppData/Roaming/ModrinthApp/meta/versions/1.21.11/1.21.11.jar"
CACHE_263 = Path.home() / "Documents/Codex/2026-09-16/up/work"
CHANGES = Counter()


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def predicate(value):
    if isinstance(value, list):
        return {"type": "minecraft:all_of", "terms": [predicate(v) for v in value]}
    if not isinstance(value, dict):
        return value
    result = {}
    for key, item in value.items():
        if key == "condition" and isinstance(item, str):
            key = "type"
        if key == "terms" and isinstance(item, list):
            result[key] = [predicate(v) for v in item]
        elif key == "term":
            result[key] = predicate(item)
        else:
            result[key] = item
    kind = result.get("type", "").removeprefix("minecraft:")
    if kind == "reference":
        return result["name"]
    if kind == "block_state_property":
        result["type"] = "minecraft:match_block"
        if "block" in result:
            result["blocks"] = result.pop("block")
        if "properties" in result:
            result["state"] = result.pop("properties")
    if kind == "value_check":
        result["type"] = "minecraft:float_value_check"
        result["test"] = result.pop("range")
    return result


def loot(value):
    if isinstance(value, list):
        return [loot(v) for v in value]
    if not isinstance(value, dict):
        return value
    if "condition" in value and isinstance(value["condition"], str):
        return predicate(value)
    result = {}
    is_sequence = value.get("function", "").removeprefix("minecraft:") == "sequence"
    for key, item in value.items():
        if key == "function" and isinstance(item, str):
            result["type"] = item
        elif key == "conditions":
            result["condition"] = predicate(item)
        elif key == "functions":
            result["functions" if is_sequence else "modifier"] = loot(item)
        elif key in {"components", "custom_data", "tag"}:
            result[key] = item
        else:
            result[key] = loot(item)
    kind = result.get("type", "").removeprefix("minecraft:")
    if kind == "tag" and "name" in result:
        result["items"] = "#" + result.pop("name").removeprefix("#")
    if kind == "reference":
        return result["name"]
    return result


def enchantment(value):
    if isinstance(value, list):
        return [enchantment(v) for v in value]
    if not isinstance(value, dict):
        return value
    return {key: predicate(item) if key == "requirements" else enchantment(item)
            for key, item in value.items()}


def advancement(value):
    for criterion in value.get("criteria", {}).values():
        conditions = criterion.get("conditions", {})
        for key in ("player", "entity", "victim", "parent", "partner", "child", "projectile", "shooter", "zombie", "villager"):
            node = conditions.get(key)
            if isinstance(node, list):
                conditions[key] = predicate(node)
        if isinstance(conditions.get("location"), list):
            conditions["location"] = predicate(conditions["location"])
        if criterion.get("trigger", "").removeprefix("minecraft:") in {
            "player_hurt_entity", "player_interacted_with_entity"
        } and isinstance(conditions.get("entity"), dict) and "type" not in conditions["entity"]:
            conditions["entity"] = {"type": "minecraft:entity_properties", "entity": "this", "predicate": conditions["entity"]}
    return value


def metadata(source, target, version, kind):
    document = read_json(source / "pack.mcmeta")
    pack = document["pack"]
    for key in ("pack_format", "supported_formats"):
        pack.pop(key, None)
    fmt = {("26.3", "data"): 121, ("26.3", "resource"): [97, 1],
           ("1.21.11", "data"): [94, 1], ("1.21.11", "resource"): 75}[version, kind]
    pack["min_format"] = fmt
    pack["max_format"] = fmt
    write_json(target / "pack.mcmeta", document)


def shader_263(resource):
    core = resource / "assets/minecraft/shaders/core"
    vertex = (core / "text.vsh").read_text(encoding="utf-8-sig")
    fragment = (core / "text.fsh").read_text(encoding="utf-8-sig")
    if "gl_VertexIndex" in vertex and "#include <minecraft:oit.glsl>" in fragment:
        return
    for variable, location in (("Position", 0), ("Color", 1), ("UV0", 2), ("UV2", 3)):
        vertex = re.sub(rf"(?m)^in (\w+) {variable};", rf"layout(location = {location}) in \1 {variable};", vertex)
    locations = {"sphericalVertexDistance": 0, "cylindricalVertexDistance": 1,
                 "vertexColor": 2, "texCoord0": 3, "hpwwGuiMarker": 4, "hpwwGuiLocalOffset": 5}
    for variable, location in locations.items():
        for direction in ("in", "out"):
            pattern = rf"(?m)^(flat )?{direction} (\w+) {variable};"
            replacement = rf"layout(location = {location}) \1{direction} \2 {variable};"
            vertex = re.sub(pattern, replacement, vertex)
            fragment = re.sub(pattern, replacement, fragment)
    vertex = vertex.replace("gl_VertexID", "gl_VertexIndex")
    fragment = fragment.replace('#moj_import <minecraft:dynamictransforms.glsl>',
                                '#moj_import <minecraft:dynamictransforms.glsl>\n#moj_import <minecraft:oit.glsl>')
    fragment = fragment.replace("out vec4 fragColor;", "#ifndef OIT_ALPHA_ONLY\nlayout(location = 0) out vec4 fragColor;\n#endif")
    end = fragment.index("#ifdef IS_SEE_THROUGH\n    fragColor")
    fragment = fragment[:end] + """#ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
#endif
#if !defined(IS_SEE_THROUGH) && !defined(IS_GUI)
#ifdef OIT_ACCUMULATE
    vec4 hpwwFogColor = vec4(FogColor.rgb * color.a, FogColor.a);
#else
    vec4 hpwwFogColor = FogColor;
#endif
    color = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, hpwwFogColor);
#endif
#ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
#else
    fragColor = color;
#endif
}
"""
    for name, text in (("text.vsh", vertex), ("text.fsh", fragment)):
        text = text.replace("#version 330", "#version 330\n#extension GL_ARB_separate_shader_objects : require", 1)
        (core / name).write_text(text.replace("#moj_import", "#include"), encoding="utf-8")


def shaders_12111(resource):
    core = resource / "assets/minecraft/shaders/core"
    vertex = (core / "text.vsh").read_text(encoding="utf-8-sig")
    fragment = (core / "text.fsh").read_text(encoding="utf-8-sig")
    # Shared GUI helpers stay identical to the working pack; only vanilla interfaces differ.
    helpers = vertex[vertex.index("const float HPWW_GUI_COLUMNS"):vertex.index("void main()")]
    helpers = helpers.replace("gl_VertexIndex", "gl_VertexID")
    flip = fragment[fragment.index("vec2 hpwwGuiFlipTexCoord"):fragment.index("void main()")]
    with zipfile.ZipFile(CLIENT_OLD) as client:
        for variant in ("rendertype_text", "rendertype_text_intensity", "rendertype_text_see_through", "rendertype_text_intensity_see_through"):
            for ext in ("vsh", "fsh"):
                name = variant + "." + ext
                text = client.read("assets/minecraft/shaders/core/" + name).decode("utf-8")
                if ext == "vsh":
                    # Screen text uses an orthographic projection in the old render pipeline.
                    addition = "\n#moj_import <minecraft:globals.glsl>\nflat out float hpwwGuiMarker;\nout vec2 hpwwGuiLocalOffset;\n" + helpers
                    text = text.replace("void main()", addition + "\nvoid main()", 1)
                    text = text.replace("gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);", """vec4 hpwwViewPosition = ModelViewMat * vec4(Position, 1.0);
    hpwwGuiMarker = 0.0;
    hpwwGuiLocalOffset = vec2(0.0);
    HpwwGuiSlot hpwwSlot = hpwwGuiDecodeSlot(Color);
    if (abs(ProjMat[3][3] - 1.0) < 0.001 && hpwwSlot.enabled) {
        hpwwViewPosition = hpwwGuiPositionForSlot(hpwwViewPosition, hpwwSlot, hpwwGuiLocalOffset);
        hpwwGuiMarker = 1.0;
    }
    gl_Position = ProjMat * hpwwViewPosition;""")
                else:
                    text = text.replace("void main()", "flat in float hpwwGuiMarker;\nin vec2 hpwwGuiLocalOffset;\n" + flip + "\nvoid main()", 1)
                    text = text.replace("texture(Sampler0, texCoord0)", "texture(Sampler0, hpwwGuiMarker > 0.5 ? hpwwGuiFlipTexCoord(texCoord0) : texCoord0)")
                    text = text.replace(" * vertexColor", " * (hpwwGuiMarker > 0.5 ? vec4(1.0) : vertexColor)")
                (core / name).write_text(text, encoding="utf-8")
    (core / "text.vsh").unlink()
    (core / "text.fsh").unlink()


def convert_data(target, version):
    for path in (target / "data").rglob("*.json"):
        before = read_json(path)
        registry = path.relative_to(target / "data").parts[1]
        value = before
        if version == "26.3":
            if registry == "predicate":
                value = predicate(before)
            elif registry in {"loot_table", "item_modifier"}:
                value = loot(before)
            elif registry == "enchantment":
                value = enchantment(before)
            elif registry == "advancement":
                # Work on a fresh copy so the comparison catches nested edits.
                value = advancement(json.loads(json.dumps(before)))
        if value != before:
            write_json(path, value)
            CHANGES[version + " JSON"] += 1
    for path in (target / "data").rglob("*.mcfunction"):
        before = path.read_text(encoding="utf-8-sig")
        after = before
        if version == "26.3":
            after = re.sub(r'(?<=[{,])\s*condition\s*:', 'type:', after)
            after = after.replace('target:"this_entity"', 'target:"this"')
        elif path.parent.name == "controls_overlay" and path.parent.parent.name == "spell_wheel_page":
            after = "# The Field Guide controls overlay requires Minecraft 26.3.\n"
        else:
            lines = []
            for line in after.splitlines():
                if not line.lstrip().startswith("#") and "attribute " in line and "air_drag_modifier" in line:
                    # 1.21.11 has no air-drag attribute. A namespaced modifier preserves
                    # each entity's original movement speed when the spell releases it.
                    line = re.sub(r'attribute (@\S+) (?:minecraft:)?air_drag_modifier base set 100',
                                  r'attribute \1 minecraft:movement_speed modifier add hpww:levioso_freeze -1 add_multiplied_total', line)
                    line = re.sub(r'attribute (@\S+) (?:minecraft:)?air_drag_modifier base reset',
                                  r'attribute \1 minecraft:movement_speed modifier remove hpww:levioso_freeze', line)
                lines.append(line)
            after = "\n".join(lines) + "\n"
        if after != before:
            path.write_text(after, encoding="utf-8")
            CHANGES[version + " functions"] += 1


def convert_resources(target, version):
    for path in (target / "assets").rglob("*.json"):
        value = read_json(path)
        before = json.dumps(value)
        if version == "26.3" and "models" in path.relative_to(target / "assets").parts:
            for element in value.get("elements", []):
                if element.pop("shade", True) is False:
                    element["shade_direction_override"] = "up"
        if json.dumps(value) != before:
            write_json(path, value)
            CHANGES[version + " models"] += 1
    if version == "26.3":
        shader_263(target)
    else:
        shaders_12111(target)
    recover_legacy_atlas(target)


def recover_legacy_atlas(target):
    relative = "assets/aj/textures/blueprint/hpww_field_guide/main_menu_field_guide.png"
    destination = target / relative
    if destination.exists():
        return
    git_path = "HPWW Resource Pack/" + relative
    history = subprocess.run(["git", "-C", str(SOURCE.parent), "log", "--all", "--format=%H",
                              "--diff-filter=AM", "-1", "--", git_path],
                             capture_output=True, text=True, check=True).stdout.strip()
    if not history:
        raise SystemExit("Cannot recover the texture atlas still referenced by legacy field-guide models")
    data = subprocess.run(["git", "-C", str(SOURCE.parent), "show", history + ":" + git_path],
                          capture_output=True, check=True).stdout
    if not data.startswith(b"\x89PNG\r\n\x1a\n"):
        raise SystemExit("Recovered atlas is not a PNG")
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
    CHANGES["legacy atlas recovered"] += 1


def copy_pack(source, target, kind):
    if target.exists():
        raise SystemExit(f"Output already exists: {target}. Use a fresh --work directory.")
    target.mkdir(parents=True)
    shutil.copytree(source / ("data" if kind == "data" else "assets"), target / ("data" if kind == "data" else "assets"))
    if kind == "data":
        overlay = source / "hpww_aj_26_3"
        if overlay.is_dir():
            shutil.copytree(overlay, target / overlay.name)
    for name in ("pack.mcmeta", "pack.png"):
        if (source / name).is_file():
            shutil.copy2(source / name, target / name)


def prepare(work):
    for version in ("26.3", "1.21.11"):
        for source, kind in ((SOURCE, "data"), (RESOURCE_SOURCE, "resource")):
            target = work / "build" / version / ("HPWW Data Pack" if kind == "data" else "HPWW Resource Pack")
            copy_pack(source, target, kind)
            metadata(source, target, version, kind)
            if kind == "data":
                convert_data(target, version)
            else:
                convert_resources(target, version)
    write_json(work / "conversion_counts.json", dict(CHANGES))
    print(json.dumps(dict(CHANGES), indent=2))


def download_server(work):
    target = work / "vanilla/1.21.11-server.jar"
    target.parent.mkdir(parents=True, exist_ok=True)
    meta = read_json(CLIENT_OLD.with_suffix(".json"))["downloads"]["server"]
    if not target.exists():
        urllib.request.urlretrieve(meta["url"], target)
    if hashlib.sha1(target.read_bytes()).hexdigest() != meta["sha1"]:
        raise SystemExit("Server download SHA-1 mismatch")
    print(target)


def backport_registries(work):
    reports = work / "validation/1.21.11/reports-generated/reports"
    registries = read_json(reports / "registries.json")
    root = work / "build/1.21.11/HPWW Data Pack/data"
    block_ids = set(registries["minecraft:block"]["entries"])
    changed = []

    def known(identifier, entries):
        if identifier.startswith("#") or (":" in identifier and not identifier.startswith("minecraft:")):
            return True
        return (identifier if ":" in identifier else "minecraft:" + identifier) in entries

    def filter_blocks(value):
        if isinstance(value, list):
            return [filter_blocks(v) for v in value]
        if not isinstance(value, dict):
            return value
        result = {key: filter_blocks(item) for key, item in value.items()}
        if isinstance(result.get("blocks"), list):
            result["blocks"] = [item for item in result["blocks"] if known(item, block_ids)]
        return result

    for path in root.rglob("*.json"):
        before = read_json(path)
        value = filter_blocks(before)
        parts = path.relative_to(root).parts
        if parts[1] == "tags" and "minecraft:" + parts[2] in registries:
            entries = registries["minecraft:" + parts[2]]["entries"]
            value["values"] = [item for item in value["values"]
                               if known(item if isinstance(item, str) else item["id"], entries)]
        if value != before:
            write_json(path, value)
            changed.append(path.relative_to(root).as_posix())
    write_json(work / "backport_registry_changes.json", changed)
    print(json.dumps({"backport_registry_files": len(changed), "files": changed}, indent=2))


def package(work, data_only=False, suffix=None):
    output = work / "outputs"
    output.mkdir(parents=True, exist_ok=True)
    manifest = []
    for version in ("26.3", "1.21.11"):
        server_result = read_json(work / "validation" / version / "result.json")
        shader_result = read_json(work / "shader-validation" / version / "result.json")
        resource_result = read_json(work / "validation" / version / "resources.json")
        if not server_result["ready"] or not server_result.get("smoke_done") or server_result["errors"]:
            raise SystemExit(f"Server checks have not passed for {version}")
        if shader_result["failures"] or resource_result["missing"]:
            raise SystemExit(f"Resource checks have not passed for {version}")
        for name in (("HPWW Data Pack",) if data_only else ("HPWW Data Pack", "HPWW Resource Pack")):
            root = work / "build" / version / name
            for path in root.rglob("*"):
                if path.suffix == ".json" or path.name.endswith(".mcmeta"):
                    read_json(path)
            archive = output / f"{name} - {version}{' - ' + suffix if suffix else ''}.zip"
            files = sorted(p for p in root.rglob("*") if p.is_file())
            with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as out:
                for path in files:
                    out.write(path, path.relative_to(root).as_posix())
            with zipfile.ZipFile(archive) as check:
                assert check.testzip() is None
                assert "pack.mcmeta" in check.namelist()
            entry = {"file": archive.name, "bytes": archive.stat().st_size, "files": len(files),
                     "sha256": hashlib.sha256(archive.read_bytes()).hexdigest()}
            manifest.append(entry)
            print(json.dumps(entry))
    write_json(output / ("manifest-field-guide-fix.json" if suffix else "manifest.json"), manifest)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("prepare", "download-server", "backport-registries", "recover-atlas", "package"))
    parser.add_argument("--work", type=Path, default=DEFAULT_WORK)
    parser.add_argument("--data-only", action="store_true")
    parser.add_argument("--suffix")
    args = parser.parse_args()
    if args.command == "recover-atlas":
        for version in ("26.3", "1.21.11"):
            recover_legacy_atlas(args.work / "build" / version / "HPWW Resource Pack")
    elif args.command == "package":
        package(args.work, args.data_only, args.suffix)
    else:
        {"prepare": prepare, "download-server": download_server, "backport-registries": backport_registries,
         }[args.command](args.work)


if __name__ == "__main__":
    main()
