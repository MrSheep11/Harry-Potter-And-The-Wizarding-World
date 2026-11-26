# Animated Java runs this as the brick interaction before consuming its attack.
execute unless entity @s[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction] run return fail
execute unless score @s aj.id matches 1.. run return fail
$scoreboard players set #brick diagonalley_wall $(brick)
execute unless score #brick diagonalley_wall matches 1..3 run return fail
scoreboard players operation #wall hpww.diagon_alley.rig = @s aj.id
# A leftover hitbox must not advance progress for a wall that no longer exists.
scoreboard players set #wall_ready diagonalley_wall 0
execute at @s as @e[type=minecraft:item_display,tag=aj.diagonalley_enterance.root,tag=!hpww.diagon_alley.opened,tag=!aj.diagonalley_enterance.animation.open.playing,tag=!aj.diagonalley_enterance.animation.close.playing,distance=..8] if score @s aj.id = #wall hpww.diagon_alley.rig run function hpww:main/diagon_alley/internal/round/accept_hit
execute unless score #wall_ready diagonalley_wall matches 1 run return run function hpww:main/diagon_alley/internal/cleanup/hitbox
scoreboard players set #complete diagonalley_wall 0
execute on attacker if entity @s[type=minecraft:player] store result score #complete diagonalley_wall run function hpww:main/diagon_alley/internal/record_click
execute if score #complete diagonalley_wall matches 1 run function aj:diagonalley_enterance/as_root {command:"execute at @s run function hpww:main/diagon_alley/internal/open"}
