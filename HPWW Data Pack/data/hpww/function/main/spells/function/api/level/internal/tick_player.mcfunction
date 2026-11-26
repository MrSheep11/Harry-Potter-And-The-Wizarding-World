scoreboard players add @s hpww.lv.age 1
execute if score @s hpww.lv.age matches 4..32 run function hpww:main/spells/function/api/level/internal/animate
execute if score @s hpww.lv.age matches 72.. run function hpww:main/spells/function/api/level/internal/finish
