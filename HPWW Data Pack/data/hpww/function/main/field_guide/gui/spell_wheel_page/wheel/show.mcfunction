execute unless function hpww:main/field_guide/gui/spell_wheel_page/drawer/find_rig run return fail
execute store result storage hpww:fg_spell_wheel_runtime wheel.previous int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.wheel_page
scoreboard players operation @s hpww.fg.spell_wheel_page.wheel_page = #page hpww.fg.work
execute store result storage hpww:fg_spell_wheel_runtime wheel.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.wheel_page
execute as @e[type=item_display,tag=aj.fg_spell_wheel.root,distance=0..3] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/wheel/indicator with storage hpww:fg_spell_wheel_runtime wheel
function hpww:main/field_guide/gui/spell_wheel_page/wheel/render
