execute store result storage hpww:level args.age int 1 run scoreboard players get @s hpww.lv.age
function hpww:main/spells/function/api/level/internal/weight with storage hpww:level args
# Animate the unsigned distance: floor division on a negative delta can overflow near INT_MAX.
execute unless score @s hpww.lv.from matches 0.. run scoreboard players operation @s hpww.lv.from = @s hpww.lv.start
scoreboard players operation #count hpww.lv.work = @s hpww.xp
scoreboard players operation #count hpww.lv.work -= @s hpww.lv.from
execute if score #count hpww.lv.work matches ..-1 run scoreboard players operation #count hpww.lv.work *= #negate hpww.lv.work
scoreboard players operation #rem hpww.lv.work = #count hpww.lv.work
scoreboard players operation #rem hpww.lv.work %= #scale hpww.lv.work
scoreboard players operation #rem hpww.lv.work *= #weight hpww.lv.work
scoreboard players operation #rem hpww.lv.work /= #scale hpww.lv.work
scoreboard players operation #count hpww.lv.work /= #scale hpww.lv.work
scoreboard players operation #count hpww.lv.work *= #weight hpww.lv.work
scoreboard players operation #count hpww.lv.work += #rem hpww.lv.work
execute if score @s hpww.xp < @s hpww.lv.from run scoreboard players operation #count hpww.lv.work *= #negate hpww.lv.work
scoreboard players operation @s hpww.lv.shown = @s hpww.lv.from
scoreboard players operation @s hpww.lv.shown += #count hpww.lv.work
scoreboard players operation #count hpww.lv.work = @s hpww.lv.shown
scoreboard players operation #count hpww.lv.work -= @s hpww.lv.start
function hpww:main/spells/function/api/level/internal/counter
function hpww:main/spells/function/api/level/internal/badge
