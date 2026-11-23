execute unless entity @s[type=player] run return fail
execute unless score @s hpww.fg.session matches 1.. at @s run return run function hpww:main/field_guide/gui/internal/close_owned
execute store result storage hpww:field_guide request.session int 1 run scoreboard players get @s hpww.fg.session
return run function hpww:main/field_guide/gui/internal/session/request_close with storage hpww:field_guide request
