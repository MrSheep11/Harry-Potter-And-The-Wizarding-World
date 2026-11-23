execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return fail
$data modify storage hpww:fg_spell_wheel_runtime selection.slot set value $(slot)
execute store result storage hpww:fg_spell_wheel_runtime selection.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
function hpww:main/field_guide/gui/spell_wheel_page/drawer/read_slot with storage hpww:fg_spell_wheel_runtime selection
execute if data storage hpww:fg_spell_wheel_runtime selection.spell run function hpww:main/field_guide/gui/spell_wheel_page/drawer/tellraw_message with storage hpww:fg_spell_wheel_runtime selection
