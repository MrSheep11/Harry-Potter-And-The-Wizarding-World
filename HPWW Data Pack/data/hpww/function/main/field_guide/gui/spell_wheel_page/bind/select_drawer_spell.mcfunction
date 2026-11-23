execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return fail
$data modify storage hpww:fg_spell_wheel_runtime selection.slot set value $(slot)
execute store result storage hpww:fg_spell_wheel_runtime selection.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
function hpww:main/field_guide/gui/spell_wheel_page/drawer/read_slot with storage hpww:fg_spell_wheel_runtime selection
execute unless data storage hpww:fg_spell_wheel_runtime selection.spell run return fail
execute store result score #unlocked hpww.fg.work run function hpww:main/field_guide/gui/spell_wheel_page/drawer/is_unlocked with storage hpww:fg_spell_wheel_runtime selection
execute unless score #unlocked hpww.fg.work matches 1 run return fail
execute unless function hpww:main/field_guide/gui/spell_wheel_page/drawer/find_rig run return fail
$scoreboard players set @s hpww.drawer_selected_slot $(slot)
playsound ui.button.click master @s ~ ~ ~ 0.2
function hpww:main/field_guide/gui/spell_wheel_page/drawer/render
