# A completed or currently playing wall must not jump back to frame zero.
execute unless entity @s[type=minecraft:item_display,tag=aj.diagonalley_enterance.root] run return fail
execute if entity @s[tag=hpww.diagon_alley.opened] run return fail
tag @s add hpww.diagon_alley.opened
execute if entity @s[tag=hpww.diagon_alley.solid] run function hpww:main/diagon_alley/internal/collider/clear_for_wall
execute unless entity @s[tag=aj.diagonalley_enterance.animation.open.playing] run function aj:diagonalley_enterance/animations/open/play
