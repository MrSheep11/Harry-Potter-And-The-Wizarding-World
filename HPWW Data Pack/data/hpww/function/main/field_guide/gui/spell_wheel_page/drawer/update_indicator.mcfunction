data remove storage hpww:fg_spell_wheel_runtime indicator.off
$data modify storage hpww:fg_spell_wheel_runtime indicator.off set from storage hpww:field_guide categories.p$(previous)
$data modify storage hpww:fg_spell_wheel_runtime indicator.on set from storage hpww:field_guide categories.p$(page)
execute if data storage hpww:fg_spell_wheel_runtime indicator.off as @e[type=item_display,tag=aj.fg_spell_wheel.root,distance=0..3] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/drawer/indicator_off with storage hpww:fg_spell_wheel_runtime indicator
execute as @e[type=item_display,tag=aj.fg_spell_wheel.root,distance=0..3] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/drawer/indicator_on with storage hpww:fg_spell_wheel_runtime indicator
