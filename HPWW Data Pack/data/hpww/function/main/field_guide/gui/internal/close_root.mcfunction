tag @s add hpww.fg.closing
execute if entity @s[tag=aj.fg_spell_wheel.root] run return run function hpww:main/field_guide/gui/internal/close_spell_wheel_root
execute if entity @s[tag=aj.field_guide_gui.root] run return run function hpww:main/field_guide/gui/internal/close_main_root
function hpww:main/field_guide/gui/internal/remove_root
