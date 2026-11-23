# Built-in exits remove their rig on the last frame. A custom exit can simply stop playing.
execute if entity @s[tag=hpww.fg.closing] run return run function hpww:main/field_guide/gui/internal/remove_root
tag @s add hpww.fg.closing
$data modify storage hpww:field_guide closing set value {animation:"$(closing)"}
execute if data storage hpww:field_guide closing{animation:"none"} run return run function hpww:main/field_guide/gui/internal/remove_root
$function aj:$(project)/as_all_interactions {command:"kill @s"}
$return run function aj:$(project)/animations/$(closing)/play_exclusive
