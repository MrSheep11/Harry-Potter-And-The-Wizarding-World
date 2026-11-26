execute unless entity @s[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction] run return fail
execute unless score @s aj.id matches 1.. run return run kill @s
execute store result storage hpww:diagon_alley cleanup.rig int 1 run scoreboard players get @s aj.id
function hpww:main/diagon_alley/internal/cleanup/if_unregistered with storage hpww:diagon_alley cleanup
