execute unless score @s hpww.xp = @s hpww.xp run return run function hpww:main/spells/function/api/level/internal/init
# Existing balances outside the new bounds are repaired without displaying a made-up award.
execute if score @s hpww.xp matches ..-1 run scoreboard players set @s hpww.xp 0
scoreboard players operation @s hpww.xp < #max hpww.lv.work
execute unless score @s hpww.level matches 1..50 run scoreboard players set @s hpww.level 1
function hpww:main/spells/function/api/level/internal/commit
function hpww:main/spells/function/api/level/internal/finish
scoreboard players operation @s hpww.lv.shown = @s hpww.xp
scoreboard players operation @s hpww.lv.start = @s hpww.xp
scoreboard players operation @s hpww.lv.from = @s hpww.xp
function hpww:main/spells/function/api/level/internal/badge
