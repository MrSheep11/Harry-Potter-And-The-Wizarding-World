# HPWW Spell Generator

Run `py .\tools\add_spell.py` to open the small generator window. Enter one
lowercase spell id, choose one image, and click **Create Spell**.

The cleanest input is a finished `34x36` active spell-wheel icon. Other image
sizes are fitted into the existing `26x26` icon area automatically.

Command-line use is also supported:

```powershell
py tools/add_spell.py --name stupefy --image "C:\path\to\stupefy.png"
```

The generator creates:

- A dedicated resource-pack font for the spell.
- Active, selected, and all 26 cooldown textures.
- A three-second starter cooldown and a visible particle trail.
- A no-effect hit function at
  `data/hpww/function/main/spells/function/<spell>/function/hit.mcfunction`.
- Every cooldown API registration needed for off-wheel ticking and refreshes.

After `/reload`, a generated spell can be bound directly with:

```mcfunction
/function hpww:main/spells/function/api/bind_spell/api/bind {spell_name:"stupefy",slot:1,page:1}
```

Use `--cooldown 4.2` to choose another duration (rounded up), `--dry-run` to
preview paths, or `--force` to intentionally rebuild an existing generated
spell. The script uses Pillow for image generation.

## Field Guide Spell Drawer

Choose a **Drawer page** and **Drawer slot** in the generator or supply both
flags:

```powershell
py tools/add_spell.py --name stupefy --image "C:\path\to\stupefy.png" --drawer-page 1 --drawer-slot 2
```

Pages 1-5 are Damage, Control, Force, Utility, and Curses. Pages 6-10 are Other
1-5. Each has eight slots. Leave both fields blank to skip drawer placement.
The generator rejects occupied slots and reuses an existing placement on a
`--force` rebuild if both fields are blank.

Drawer placements are kept at the bottom of
`data/hpww/function/main/spells/function/api/spell_cooldown/spell_definitions.mcfunction`.
Edit the page or slot there to move a spell, then run `/reload`.

```mcfunction
function hpww:main/field_guide/api/spell_wheel/register_spell {spell:"stupefy",page:1,slot:2}
```

The spell definition supplies the display name. The spell's
`hpww:spells/unlocked/<spell>_unlocked` advancement controls its locked state.
Left-clicking the spell in the drawer shows its optional `drawer_message` to
the clicking player, even while it is locked. Define it in
`spell_definitions.mcfunction` using the same text component as `tellraw`:

```mcfunction
data modify storage hpww:gobal_spell_data stupefy.drawer_message set value [{text:"Stupefy",color:"gold"},{text:" stuns its target.",color:"white"}]
```

The generator creates that advancement when needed and builds the active,
locked, selected, and bound-slot models. Reload the matching resource pack to
load new models. For a test unlock:

```mcfunction
/advancement grant @s only hpww:spells/unlocked/stupefy_unlocked
```

The generator window offers **Update the Modrinth 26.3 resource pack ZIP** when
it finds the installed HPWW ZIP. On the command line, use `--resource-zip` with
the path to the ZIP Minecraft actually loads. The generated files still go into
the source resource pack for future releases.

## Field Guide Page API

Register an exported Animated Java rig once, then open its page as a player.
Use the AJ project name without the `aj:` prefix. The example uses an existing
test rig so the commands can be tried as written.

```mcfunction
/function hpww:main/field_guide/api/create {page:"trial_test",project:"hpww_trial_start_button"}
/function hpww:main/field_guide/api/open {page:"trial_test"}
/function hpww:main/field_guide/api/close
```

Use `main` and `spell_wheel` for the built-in pages. The first page sets the
position and facing for the whole session. A switch waits for the old page's
opening and closing animations before the new page opens. Walking more than
three blocks from the original spot closes the guide.

For a custom page, supply its visuals and interactions in the AJ export.
If it has animations, use `api/set_animations` after registering it, for
example `{page:"trial_test",opening:"open",closing:"close"}`. The rig's summon
callback must start its opening animation. The closing animation can remove
its rig on the last frame or finish and let the API remove it. Leave
`closing` set to `"none"` for a page with no exit animation. Put registration
commands in a function referenced by the `#hpww:field_guide/register` load tag.

In an Animated Java interaction callback, use `api/click_open {page:"..."}` or
`api/click_close` as the interaction. Those helpers verify that the click came
from the page's owner. With the Spell Wheel page open, call
`api/spell_wheel/show_drawer_page {page:10}` as the player to switch categories.
These paths are all under `hpww:main/field_guide/`.
