execute if entity @s[tag=aj.diagonalley_enterance.animation.open.playing,tag=!hpww.diagon_alley.opened] run tag @s add hpww.diagon_alley.opened
execute if entity @s[tag=hpww.diagon_alley.opened,tag=hpww.diagon_alley.solid] run function hpww:main/diagon_alley/internal/collider/clear_for_wall
execute if entity @s[tag=hpww.diagon_alley.opened] run function hpww:main/diagon_alley/internal/cycle/tick
execute if entity @s[tag=!hpww.diagon_alley.opened,tag=!hpww.diagon_alley.solid,tag=!aj.diagonalley_enterance.animation.close.playing,scores={aj.id=1..}] run function hpww:main/diagon_alley/internal/collider/orient
