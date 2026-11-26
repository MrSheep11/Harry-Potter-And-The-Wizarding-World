execute if score @s hpww.lv.age matches -1 run scoreboard players set @s hpww.lv.count -2147483648
scoreboard players operation @s hpww.lv.start = @s hpww.lv.shown
scoreboard players operation @s hpww.lv.from = @s hpww.lv.shown
scoreboard players set @s hpww.lv.age 0
scoreboard players set #count hpww.lv.work 0
function hpww:main/spells/function/api/level/internal/counter
function hpww:main/spells/function/api/level/internal/badge
