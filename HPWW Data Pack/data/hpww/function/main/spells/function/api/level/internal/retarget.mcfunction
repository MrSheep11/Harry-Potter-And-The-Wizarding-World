# Preserve the batch's starting XP for the counter, but ease from the current visual position.
scoreboard players operation @s hpww.lv.from = @s hpww.lv.shown
execute if score @s hpww.lv.age matches 4.. run scoreboard players set @s hpww.lv.age 3
execute unless score @s hpww.lv.gold matches 1 run function hpww:main/spells/function/api/level/internal/badge
return run scoreboard players get @s hpww.xp
