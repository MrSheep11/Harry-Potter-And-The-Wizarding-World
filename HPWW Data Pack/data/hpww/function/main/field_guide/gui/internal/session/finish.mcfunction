$data remove storage hpww:field_guide sessions."$(session)"
scoreboard players reset @s hpww.fg.session
scoreboard players reset @s hpww.fg.rig
scoreboard players reset @s hpww.fg.busy
execute at @s run function hpww:main/field_guide/gui/internal/close_owned
