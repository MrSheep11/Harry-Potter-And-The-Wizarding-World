# Changing rounds also invalidates partial sequences from players who logged out.
tag @s remove hpww.diagon_alley.closing
tag @s remove hpww.diagon_alley.opened
scoreboard players reset @s hpww.diagon_alley.close_at
scoreboard players reset @s hpww.diagon_alley.round
# Earlier exports had fewer hitboxes; refresh once if any of the six are missing.
scoreboard players operation #reset_wall hpww.diagon_alley.rig = @s aj.id
scoreboard players set #hitboxes diagonalley_wall 0
execute as @e[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction,distance=..4] if score @s aj.id = #reset_wall hpww.diagon_alley.rig run scoreboard players add #hitboxes diagonalley_wall 1
execute unless score #hitboxes diagonalley_wall matches 6 run function hpww:main/diagon_alley/internal/replace_entrance
