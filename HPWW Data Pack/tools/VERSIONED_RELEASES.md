# Building HPWW for 26.3 and 1.21.11

The release builder copies the current working datapack and resource pack into
isolated build folders. It does not modify their gameplay source files.

The default build location is
`C:/Users/levim/Documents/Codex/2026-11-07/hpww-release`.
Use `--work <directory>` on both scripts to select another location. Preparation
requires a new output directory, so it cannot overwrite an earlier build.

## Inputs

- The current `HPWW Data Pack` and neighboring `HPWW Resource Pack` folders.
- The installed vanilla 1.21.11 client jar in Modrinth's metadata folder.
- The previously downloaded official 26.3 client and server jars under
  `Documents/Codex/2026-09-16/up/work`.
- Java and `glslc` on PATH.

## Build

```powershell
python tools/build_versioned_release.py prepare
python tools/build_versioned_release.py download-server
```

Generate the older registry reports by running the official 1.21.11 server
bundle's data generator. This only generates reference files; it does not start
a gameplay server:

```powershell
$work = 'C:/Users/levim/Documents/Codex/2026-11-07/hpww-release'
New-Item -ItemType Directory -Force "$work/validation/1.21.11" | Out-Null
Push-Location "$work/validation/1.21.11"
java -Xmx1G '-DbundlerMainClass=net.minecraft.data.Main' -jar "$work/vanilla/1.21.11-server.jar" --reports --output reports-generated
Pop-Location
python tools/build_versioned_release.py backport-registries
```

Validate both editions, then package:

```powershell
python tools/validate_versioned_release.py server 26.3
python tools/validate_versioned_release.py server 1.21.11
python tools/validate_versioned_release.py shaders 26.3
python tools/validate_versioned_release.py shaders 1.21.11
python tools/validate_versioned_release.py resources 26.3
python tools/validate_versioned_release.py resources 1.21.11
python tools/build_versioned_release.py package
```

The packager requires passing server, shader, and resource-reference reports.
It writes four installable zips and a SHA-256 manifest to `outputs`.

## Version Changes

26.3 uses datapack format 121.0 and resource pack format 97.1. Its release copy
converts loot functions, predicates, and advancement conditions to the new
formats. Text shaders use the new imports, explicit input/output locations,
vertex-index name, and order-independent transparency passes.

The working datapack and release copies carry a 26.3-only `hpww_aj_26_3`
overlay. It overrides the two global Animated Java interaction advancements so
older Blockbench exports cannot reintroduce the 26.3 reload error. The generated
advancements under `data/animated_java` can still be rewritten by the exporter.

1.21.11 uses datapack format 94.1 and resource pack format 75.0. It gets the four
older text shader variants, with the current GUI placement and color behavior.
References to newer vanilla blocks/entities are removed from hitbox registry
lists. Its Levioso fallback uses a removable movement-speed modifier because
this version has no `air_drag_modifier` attribute. Momentum damping will differ
from 26.3.

Both resource packs recover the original legacy field-guide atlas from Git
history because eight retained models still reference it.

## Validation Scope

Official dedicated servers are started on localhost with new test worlds.
Checks include startup, reload, instantiated wand macros, generated loot, UUID
storage isolation, decimal cooldown rounding, ticking, pause/unpause, addition,
subtraction, and stopping. All 26 shader variants are compiled against the
matching vanilla shader includes. Font, model, item-model, and sound references
are checked against the pack and matching vanilla client jar.

These checks do not replace a visual playtest in the Minecraft client.
