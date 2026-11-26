scoreboard players operation #owner hpww.diagon_alley.collider = @s aj.id
execute as @e[type=minecraft:marker,tag=hpww.diagon_alley.collider,distance=..4] if score @s hpww.diagon_alley.collider = #owner hpww.diagon_alley.collider at @s run function hpww:main/diagon_alley/internal/collider/clear_marker
tag @s remove hpww.diagon_alley.solid
