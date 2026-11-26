# A marker and its wall can be on opposite sides of a chunk boundary.
execute rotated ~ 0 positioned ^ ^ ^-1 unless loaded ~ ~ ~ run return 0
scoreboard players operation #owner hpww.diagon_alley.collider = @s hpww.diagon_alley.collider
scoreboard players set #covered hpww.diagon_alley.collider 0
execute as @e[type=minecraft:item_display,tag=aj.diagonalley_enterance.root,tag=hpww.diagon_alley.solid,distance=..4] if score @s aj.id = #owner hpww.diagon_alley.collider run scoreboard players set #covered hpww.diagon_alley.collider 1
execute if score #covered hpww.diagon_alley.collider matches 0 run function hpww:main/diagon_alley/internal/collider/clear_marker
