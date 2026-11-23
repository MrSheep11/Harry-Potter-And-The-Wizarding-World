function hpww:main/spells/function/other/store_uuid
execute at @s run function hpww:main/field_guide/gui/internal/close_owned
execute if score @s SpellWheelStatus matches 1 at @s run function hpww:main/spellwheel/wheel/function/close_wheel
scoreboard players reset @s hpww.fg.rig
$execute at @s rotated ~ 0 positioned ^ ^ ^1.5 run function hpww:main/field_guide/gui/internal/session/spawn_page with storage hpww:field_guide pages."$(page)"
execute unless score @s hpww.fg.rig matches 1.. run return fail
execute store result storage hpww:field_guide request.session int 1 run scoreboard players operation @s hpww.fg.session = @s hpww.fg.rig
$data modify storage hpww:field_guide request.page set value "$(page)"
function hpww:main/field_guide/gui/internal/session/save_origin with storage hpww:field_guide request
return 1
