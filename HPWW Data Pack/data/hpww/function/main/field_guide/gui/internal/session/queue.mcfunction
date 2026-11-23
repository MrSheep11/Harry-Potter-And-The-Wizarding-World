$execute if data storage hpww:field_guide sessions."$(session)"{exit:1b} run return fail
$execute unless score @s hpww.fg.busy matches 1 if data storage hpww:field_guide sessions."$(session)".active{page:"$(page)"} run return 1
$data modify storage hpww:field_guide sessions."$(session)".next set from storage hpww:field_guide pages."$(page)"
scoreboard players set @s hpww.fg.busy 1
function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/hide
return 1
