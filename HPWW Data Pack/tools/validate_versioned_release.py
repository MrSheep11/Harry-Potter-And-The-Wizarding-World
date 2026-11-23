"""Validate release copies using official servers and version-matched shaders."""

import argparse
import json
import queue
import re
import shutil
import subprocess
import threading
import time
import zipfile
from pathlib import Path

from build_versioned_release import DEFAULT_WORK, CACHE_263, CLIENT_OLD, write_json


def install_smoke_pack(root, pack):
    harness = root / "world/datapacks/hpww_release_smoke"
    write_json(harness / "pack.mcmeta", json.loads((pack / "pack.mcmeta").read_text(encoding="utf-8")))
    functions = harness / "data/release_smoke/function"
    functions.mkdir(parents=True, exist_ok=True)
    entries = {
        "main": '''forceload add 0 0 16 0
schedule function release_smoke:run 10t replace
''',
        "run": '''kill @e[tag=hpww.release_smoke]
summon marker 0 100 0 {Tags:["hpww.release_smoke","hpww.release_a"]}
summon marker 1 100 0 {Tags:["hpww.release_smoke","hpww.release_b"]}
execute unless entity @e[tag=hpww.release_a] run say HPWW_RELEASE_FAIL: test owner A did not spawn
execute unless entity @e[tag=hpww.release_b] run say HPWW_RELEASE_FAIL: test owner B did not spawn
execute as @e[tag=hpww.release_smoke] at @s run function hpww:main/spells/function/other/store_uuid
execute as @e[tag=hpww.release_smoke] at @s run function pdb:new_player
execute as @e[tag=hpww.release_a,limit=1] at @s run function release_smoke/owner_a
execute as @e[tag=hpww.release_b,limit=1] at @s run function release_smoke/owner_b
execute as @e[tag=hpww.release_a,limit=1] at @s run function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:119} run data get storage pdb:main out
execute unless data storage pdb:main out.cooldowns.lumos{remaining:119} run say HPWW_RELEASE_FAIL: owner isolation
execute as @e[tag=hpww.release_a,limit=1] at @s run function release_smoke/operations
execute as @e[tag=hpww.release_a,limit=1] at @s run function release_smoke/spell_wheel_draw
loot spawn 0 101 0 loot hpww:wand_crafting_table
execute as @e[tag=hpww.release_a,limit=1] at @s run function hpww:main/spellwheel/wheel/function/give_wands/replace/slot_0 {wand_wood:"oak",wand_core:"unicorn_hair",lore:[]}
kill @e[tag=hpww.release_smoke]
say HPWW_RELEASE_SMOKE_DONE
''',
        "owner_a": '''function hpww:main/spells/function/api/spell_cooldown/start_cooldown {spell:"lumos",time:5.2}
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:120,duration:120} run say HPWW_RELEASE_FAIL: decimal cooldown
function hpww:main/spells/function/api/spell_cooldown/tick/player
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:119} run say HPWW_RELEASE_FAIL: cooldown tick
''',
        "owner_b": '''function hpww:main/spells/function/api/spell_cooldown/start_cooldown {spell:"lumos",time:2}
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:40,duration:40} run say HPWW_RELEASE_FAIL: second owner
''',
        "spell_wheel_draw": r'''data modify storage hpww:gui_api refresh_base_only set value 1b
function hpww:main/spellwheel/wheel/function/display/draw {slot_1:"A100",slot_1_font:"lumos",slot_2:"B100",slot_2_font:"levioso",slot_3:"C101",slot_3_font:"protego",slot_4:"E101",slot_4_font:"custom_glyphs",selected_page_number:0,protego_value:0}
data remove storage hpww:gui_api refresh_base_only
execute unless data storage hpww:gui_api base_actionbar[1].extra[{text:"\uE041",font:"hpww:custom_glyphs"}] run say HPWW_RELEASE_FAIL: missing slot 1 mouse glyph
execute unless data storage hpww:gui_api base_actionbar[4].extra[{text:"\uE040",font:"hpww:custom_glyphs"}] run say HPWW_RELEASE_FAIL: missing slot 2 mouse glyph
execute unless data storage hpww:gui_api base_actionbar[7].extra[{text:"\uE042",font:"hpww:custom_glyphs"}] run say HPWW_RELEASE_FAIL: missing slot 3 mouse glyph
execute unless data storage hpww:gui_api base_actionbar[10].extra[{text:"\uE043",font:"hpww:custom_glyphs"}] run say HPWW_RELEASE_FAIL: missing slot 4 mouse glyph
''',
        "operations": '''function hpww:main/spells/function/api/spell_cooldown/pause_cooldown {spell:"lumos",pause_mode:"constant",global:false}
function hpww:main/spells/function/api/spell_cooldown/tick/player
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:119,paused:1} run say HPWW_RELEASE_FAIL: paused tick
function hpww:main/spells/function/api/spell_cooldown/unpause_cooldown {spell:"lumos",global:false}
function hpww:main/spells/function/api/spell_cooldown/cooldown_operation {spell:"lumos",operation:"addition",value:2.1}
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:179,paused:0} run say HPWW_RELEASE_FAIL: addition
function hpww:main/spells/function/api/spell_cooldown/cooldown_operation {spell:"lumos",operation:"subtraction",value:20}
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:0} run say HPWW_RELEASE_FAIL: subtraction
function hpww:main/spells/function/api/spell_cooldown/stop_cooldown {spell:"lumos",trigger_function:"none"}
function pdb:get_me_cached
execute unless data storage pdb:main out.cooldowns.lumos{remaining:0,duration:0} run say HPWW_RELEASE_FAIL: stop
''',
    }
    for name, contents in entries.items():
        contents = contents.replace("function release_smoke/", "function release_smoke:")
        (functions / (name + ".mcfunction")).write_text(contents, encoding="utf-8")


def server(work, version):
    root = work / "validation" / version
    root.mkdir(parents=True, exist_ok=True)
    pack = work / "build" / version / "HPWW Data Pack"
    destination = root / "world/datapacks/hpww"
    shutil.copytree(pack, destination, dirs_exist_ok=True)
    install_smoke_pack(root, pack)
    (root / "eula.txt").write_text("eula=true\n", encoding="ascii")
    (root / "server.properties").write_text(
        "server-ip=127.0.0.1\nserver-port=0\nonline-mode=false\nwhite-list=false\n"
        "enable-rcon=false\nmax-players=1\nview-distance=2\nsimulation-distance=2\n"
        "level-type=minecraft:flat\nspawn-protection=0\nmax-tick-time=0\n"
        'generator-settings={"layers":[{"block":"minecraft:bedrock","height":1}],"biome":"minecraft:plains","structures":{}}\n'
        "pause-when-empty-seconds=0\n",
        encoding="ascii",
    )
    jar = CACHE_263 / "minecraft_server_26.3.jar" if version == "26.3" else work / "vanilla/1.21.11-server.jar"
    command = ["java", "-Xms256M", "-Xmx2G", "-jar", str(jar), "nogui"]
    events = queue.Queue()
    process = subprocess.Popen(command, cwd=root, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT, text=True, encoding="utf-8", errors="replace")
    def reader():
        for line in process.stdout:
            events.put(line)
        events.put(None)
    threading.Thread(target=reader, daemon=True).start()
    ready = False
    stopped = False
    limit = time.monotonic() + 180
    with (root / "validation.log").open("w", encoding="utf-8") as log:
        while time.monotonic() < limit:
            try:
                line = events.get(timeout=0.5)
            except queue.Empty:
                if process.poll() is not None:
                    break
                continue
            if line is None:
                break
            log.write(line)
            log.flush()
            if any(token in line for token in ("ERROR", "Failed to load", "Couldn't parse", "Done (", "Starting minecraft", "Loaded ", "HPWW_RELEASE", "macro")):
                print(line.rstrip(), flush=True)
            if 'Done (' in line and not ready:
                ready = True
                process.stdin.write("datapack list enabled\nfunction release_smoke:main\n")
                process.stdin.flush()
                limit = time.monotonic() + 40
            elif ready and "HPWW_RELEASE_SMOKE_DONE" in line:
                process.stdin.write("reload\n")
                process.stdin.flush()
            elif ready and "Loaded " in line and "advancements" in line and not stopped:
                process.stdin.write("stop\n")
                process.stdin.flush()
                stopped = True
        if process.poll() is None and not stopped:
            process.stdin.write("stop\n")
            process.stdin.flush()
        try:
            process.wait(timeout=30)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
    text = (root / "validation.log").read_text(encoding="utf-8")
    errors = [line for line in text.splitlines() if any(token in line for token in ("/ERROR]", "Failed to load function", "Couldn't load", "Couldn't parse", "Failed to parse", "HPWW_RELEASE_FAIL", "Failed to instantiate"))]
    # A blocked external authentication endpoint does not affect datapack parsing.
    errors = [line for line in errors if "services public key" not in line and "Perflib 009" not in line]
    smoke_done = "HPWW_RELEASE_SMOKE_DONE" in text
    write_json(root / "result.json", {"version": version, "ready": ready, "smoke_done": smoke_done, "exit_code": process.returncode, "errors": errors})
    print(json.dumps({"version": version, "ready": ready, "smoke_done": smoke_done, "errors": len(errors), "exit_code": process.returncode}), flush=True)
    return ready and smoke_done and not errors


def shaders(work, version):
    root = work / "shader-validation" / version
    include = root / "include"
    include.mkdir(parents=True, exist_ok=True)
    client = CACHE_263 / "minecraft_client_26.3.jar" if version == "26.3" else CLIENT_OLD
    with zipfile.ZipFile(client) as archive:
        for name in archive.namelist():
            if name.startswith("assets/minecraft/shaders/include/") and name.endswith(".glsl"):
                text = archive.read(name).decode("utf-8").replace("#moj_import", "#include").replace("<minecraft:", "<")
                # Minecraft's old import preprocessor strips versions from includes.
                text = re.sub(r'(?m)^#version[^\n]*\n?', '', text)
                path = include / name.removeprefix("assets/minecraft/shaders/include/")
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text, encoding="utf-8")
    core = work / "build" / version / "HPWW Resource Pack/assets/minecraft/shaders/core"
    cases = []
    if version == "26.3":
        variants = [[], ["IS_GUI"], ["IS_SEE_THROUGH"], ["IS_GRAYSCALE"], ["IS_GUI", "IS_GRAYSCALE"],
                    ["IS_SEE_THROUGH", "IS_GRAYSCALE"]]
        variants += [["OIT", "OIT_ACCUMULATE", "OIT_COEFF_COUNT=8", "OIT_WAVELET_RANK=3"],
                     ["OIT", "OIT_ALPHA_ONLY", "OIT_DEPTH_BOUNDS", "OIT_COEFF_COUNT=8", "OIT_WAVELET_RANK=3"],
                     ["OIT", "OIT_ALPHA_ONLY", "OIT_TRANSMITTANCE", "OIT_COEFF_COUNT=8", "OIT_COEFF_ATTACHMENT_COUNT=2", "OIT_WAVELET_RANK=3"]]
        for ext in ("vsh", "fsh"):
            for defines in variants:
                cases.append((core / ("text." + ext), defines))
    else:
        cases = [(p, []) for p in core.iterdir() if p.suffix in {".vsh", ".fsh"}]
    failures = []
    for index, (path, defines) in enumerate(cases):
        text = path.read_text(encoding="utf-8-sig").replace("#moj_import", "#include").replace("<minecraft:", "<")
        source = root / path.name
        source.write_text(text, encoding="utf-8")
        args = ["glslc", "--target-env=" + ("vulkan1.0" if version == "26.3" else "opengl"),
                "-fauto-bind-uniforms", "-fauto-map-locations", "-fshader-stage=" + ("vert" if path.suffix == ".vsh" else "frag"),
                "-I" + str(include)]
        args.extend("-D" + define for define in defines)
        args.extend([str(source), "-o", str(root / f"case_{index}.spv")])
        result = subprocess.run(args, text=True, capture_output=True)
        if result.returncode:
            failures.append({"shader": path.name, "defines": defines, "output": result.stdout + result.stderr})
            print(result.stdout + result.stderr)
    write_json(root / "result.json", {"cases": len(cases), "failures": failures})
    print(json.dumps({"version": version, "shader_cases": len(cases), "failures": len(failures)}))
    return not failures


def resources(work, version):
    root = work / "build" / version / "HPWW Resource Pack"
    client_path = CACHE_263 / "minecraft_client_26.3.jar" if version == "26.3" else CLIENT_OLD
    missing = []
    checked = 0
    with zipfile.ZipFile(client_path) as client:
        vanilla = set(client.namelist())

        def resolve(identifier, directory, suffix):
            namespace, name = identifier.split(":", 1) if ":" in identifier else ("minecraft", identifier)
            return "assets/" + namespace + "/" + directory + "/" + name + ("" if name.endswith(suffix) else suffix)

        def exists(asset):
            return (root / asset).is_file() or asset in vanilla

        def check(path, identifier, directory, suffix):
            nonlocal checked
            checked += 1
            asset = resolve(identifier, directory, suffix)
            if not exists(asset):
                missing.append({"file": path.relative_to(root).as_posix(), "resource": asset})

        for path in (root / "assets").rglob("*.json"):
            value = json.loads(path.read_text(encoding="utf-8-sig"))
            parts = path.relative_to(root / "assets").parts
            if parts[1] == "font":
                for provider in value.get("providers", []):
                    kind = provider["type"].removeprefix("minecraft:")
                    if kind == "bitmap":
                        check(path, provider["file"], "textures", ".png")
                        if (provider.get("ascent", 0) > provider.get("height", 8)):
                            missing.append({"file": path.relative_to(root).as_posix(), "error": "ascent exceeds height"})
                    elif kind == "reference":
                        check(path, provider["id"], "font", ".json")
            elif parts[1] == "models":
                parent = value.get("parent")
                if parent and not parent.removeprefix("minecraft:").startswith("builtin/"):
                    check(path, parent, "models", ".json")
                for texture in value.get("textures", {}).values():
                    if isinstance(texture, str) and not texture.startswith("#"):
                        check(path, texture, "textures", ".png")
            elif parts[1] == "items":
                def item_model(node):
                    if isinstance(node, list):
                        for child in node:
                            item_model(child)
                    elif isinstance(node, dict):
                        if node.get("type", "").removeprefix("minecraft:") == "model":
                            check(path, node["model"], "models", ".json")
                        for child in node.values():
                            if isinstance(child, (dict, list)):
                                item_model(child)
                item_model(value)
            elif path.name == "sounds.json":
                for event in value.values():
                    for sound in event.get("sounds", []):
                        if isinstance(sound, str):
                            check(path, sound, "sounds", ".ogg")
                        elif sound.get("type", "file") == "file":
                            check(path, sound["name"], "sounds", ".ogg")
    write_json(work / "validation" / version / "resources.json", {"checked": checked, "missing": missing})
    print(json.dumps({"version": version, "checked": checked, "missing_count": len(missing), "missing": missing[:30]}, indent=2))
    return not missing


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("kind", choices=("server", "shaders", "resources"))
    parser.add_argument("version", choices=("26.3", "1.21.11"))
    parser.add_argument("--work", type=Path, default=DEFAULT_WORK)
    args = parser.parse_args()
    raise SystemExit(0 if {"server": server, "shaders": shaders, "resources": resources}[args.kind](args.work, args.version) else 1)


if __name__ == "__main__":
    main()
