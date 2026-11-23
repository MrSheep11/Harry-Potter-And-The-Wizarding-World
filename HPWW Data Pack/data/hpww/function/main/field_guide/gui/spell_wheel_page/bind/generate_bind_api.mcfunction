execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return fail
execute unless score @s hpww.drawer_selected_slot matches 1..8 run return fail
execute store result storage hpww:fg_spell_wheel_runtime selection.slot int 1 run scoreboard players get @s hpww.drawer_selected_slot
execute store result storage hpww:fg_spell_wheel_runtime selection.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
function hpww:main/field_guide/gui/spell_wheel_page/drawer/read_slot with storage hpww:fg_spell_wheel_runtime selection
execute unless data storage hpww:fg_spell_wheel_runtime selection.spell run return fail
execute store result score #unlocked hpww.fg.work run function hpww:main/field_guide/gui/spell_wheel_page/drawer/is_unlocked with storage hpww:fg_spell_wheel_runtime selection
execute unless score #unlocked hpww.fg.work matches 1 run return fail
data modify storage hpww:bind_spell_api args.spell_name set from storage hpww:fg_spell_wheel_runtime selection.spell
$data modify storage hpww:bind_spell_api args.slot set value $(slot)
execute store result storage hpww:bind_spell_api args.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.wheel_page
playsound ui.button.click master @s ~ ~ ~ 0.2
function hpww:main/spells/function/api/bind_spell/api/bind with storage hpww:bind_spell_api args
function hpww:main/field_guide/gui/spell_wheel_page/bind/clear_drawer_selection
