execute if entity @s[tag=hpww.diagon_alley.solid] run function hpww:main/diagon_alley/internal/collider/clear_for_wall
# Floating brick hitboxes are not passengers and older exports stored their UUIDs separately.
execute as @e[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction,distance=..6] run function hpww:main/diagon_alley/internal/cleanup/hitbox
execute if score @s aj.id matches 1.. run scoreboard players operation #refresh hpww.diagon_alley.rig = @s aj.id
execute if score @s aj.id matches 1.. as @e[type=minecraft:interaction,tag=aj.diagonalley_enterance.interaction] if score @s aj.id = #refresh hpww.diagon_alley.rig run kill @s
# Use AJ's backwards-compatible cleanup, which does not require current bone names.
function animated_java:global/remove/outdated_rig
return run function aj:diagonalley_enterance/summon {args:{}}
