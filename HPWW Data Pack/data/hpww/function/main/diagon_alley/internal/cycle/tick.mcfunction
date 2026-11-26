# Animated Java calls this after updating the active animation.
execute if entity @s[tag=aj.diagonalley_enterance.animation.open.playing] run return 0
execute if entity @s[tag=aj.diagonalley_enterance.animation.close.playing] run return 0
execute if entity @s[tag=hpww.diagon_alley.closing] run return run function hpww:main/diagon_alley/internal/cycle/reset
execute store result score #now hpww.diagon_alley.close_at run time query gametime
execute unless score @s hpww.diagon_alley.close_at matches 0.. run return run function hpww:main/diagon_alley/internal/cycle/start_hold
execute if score #now hpww.diagon_alley.close_at >= @s hpww.diagon_alley.close_at run function hpww:main/diagon_alley/internal/cycle/start_close
