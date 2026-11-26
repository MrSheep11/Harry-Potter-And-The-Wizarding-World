# Death can recreate the player without the old effect list. Reinstall only our own layers.
scoreboard players reset @s hpww.lv.deaths
posteffect remove @s hpww:level/highlight
scoreboard players reset @s hpww.lv.gold
function hpww:main/spells/function/api/level/internal/badge
scoreboard players operation #count hpww.lv.work = @s hpww.lv.count
execute if score @s hpww.lv.age matches -1 run scoreboard players set #count hpww.lv.work -2147483648
scoreboard players set @s hpww.lv.count -2147483648
function hpww:main/spells/function/api/level/internal/counter
