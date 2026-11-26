# Compare against the center of the one-block-deep wall, using its collision axis.
$execute store result score #hint_plane hpww.diagon_alley.rig run data get entity @s Pos[$(axis)] 10
$scoreboard players $(offset) #hint_plane hpww.diagon_alley.rig 10
$data modify storage hpww:diagon_alley hint_side set value {axis:$(axis),front:"$(front)",rear:"$(rear)"}
execute as @e[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction,distance=..4] if score @s aj.id = #hint_wall hpww.diagon_alley.rig positioned as @s run function hpww:main/diagon_alley/internal/hints/at_brick
