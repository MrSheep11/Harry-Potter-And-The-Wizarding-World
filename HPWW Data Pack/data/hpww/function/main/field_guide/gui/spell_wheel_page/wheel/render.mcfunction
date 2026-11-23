execute unless score @s hpww.fg.spell_wheel_page.wheel_page matches 1..7 run return fail
function pdb:get_me_cached
execute store result storage hpww:fg_spell_wheel_runtime wheel.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.wheel_page
data modify storage hpww:fg_spell_wheel_runtime wheel.number set value 1
function hpww:main/field_guide/gui/spell_wheel_page/wheel/render_slot with storage hpww:fg_spell_wheel_runtime wheel
