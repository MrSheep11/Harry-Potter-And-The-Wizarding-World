execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return fail
playsound ui.button.click master @s ~ ~ ~ 0.2
data modify storage hpww:bind_spell_api args.spell_name set value "blank"
$data modify storage hpww:bind_spell_api args.slot set value $(slot)
execute store result storage hpww:bind_spell_api args.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.wheel_page
function hpww:main/spells/function/api/bind_spell/api/bind with storage hpww:bind_spell_api args
function hpww:main/field_guide/gui/spell_wheel_page/bind/clear_drawer_selection
