execute as @a unless score @s hpww.xp matches 0..150920 run function hpww:main/spells/function/api/level/internal/ensure_total
execute as @e[type=player,scores={hpww.lv.deaths=1..}] run function hpww:main/spells/function/api/level/internal/restore
execute as @a[scores={hpww.lv.age=0..}] run function hpww:main/spells/function/api/level/internal/tick_player
