scoreboard players set @s hpww.xp 0
execute if score @s hpww.xp_nextlevel matches 1.. run scoreboard players operation @s hpww.xp = @s hpww.xp_nextlevel
scoreboard players operation @s hpww.xp < #max hpww.lv.work
scoreboard players set @s hpww.level 1
function hpww:main/spells/function/api/level/internal/commit
scoreboard players operation @s hpww.lv.shown = @s hpww.xp
scoreboard players set @s hpww.lv.number -1
scoreboard players set @s hpww.lv.frame -1
scoreboard players set @s hpww.lv.age -1
scoreboard players set @s hpww.lv.count -2147483648
function hpww:main/spells/function/api/level/internal/badge
