execute unless function hpww:main/field_guide/gui/spell_wheel_page/drawer/find_rig run return fail
scoreboard players reset @s hpww.drawer_selected_slot
execute store result storage hpww:fg_spell_wheel_runtime indicator.previous int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
scoreboard players operation @s hpww.fg.spell_wheel_page.drawer_page = #page hpww.fg.work
execute store result storage hpww:fg_spell_wheel_runtime indicator.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
function hpww:main/field_guide/gui/spell_wheel_page/drawer/update_indicator with storage hpww:fg_spell_wheel_runtime indicator
function hpww:main/field_guide/gui/spell_wheel_page/drawer/render
