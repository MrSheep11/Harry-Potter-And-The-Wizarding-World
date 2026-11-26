# Replace the nearest entrance at its original position and rotation.
execute as @n[type=minecraft:item_display,tag=aj.diagonalley_enterance.root,distance=..6] at @s run return run function hpww:main/diagon_alley/internal/replace_entrance
tellraw @s {"text":"No Diagon Alley entrance rig within 6 blocks.","color":"red"}
return fail
