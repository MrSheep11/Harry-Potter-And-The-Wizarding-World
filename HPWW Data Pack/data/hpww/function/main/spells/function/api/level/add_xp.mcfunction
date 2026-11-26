# Limit gains before addition so even a maximum-size input cannot wrap the score.
execute unless entity @s[type=player] run return fail
$scoreboard players set #award hpww.lv.work $(amount)
execute if score #award hpww.lv.work matches 0 run return fail
execute unless score @s hpww.xp matches 0..150920 run function hpww:main/spells/function/api/level/internal/ensure_total
scoreboard players operation #room hpww.lv.work = #max hpww.lv.work
scoreboard players operation #room hpww.lv.work -= @s hpww.xp
scoreboard players operation #award hpww.lv.work < #room hpww.lv.work
execute if score #award hpww.lv.work matches 0 run return run scoreboard players get @s hpww.xp
execute if score #award hpww.lv.work matches ..-1 if score @s hpww.xp matches 0 run return 0
scoreboard players operation @s hpww.xp += #award hpww.lv.work
execute if score @s hpww.xp matches ..-1 run scoreboard players set @s hpww.xp 0
function hpww:main/spells/function/api/level/internal/commit
execute if score @s hpww.lv.age matches 0..31 run return run function hpww:main/spells/function/api/level/internal/retarget
# Same-direction clicks during the two-second hold extend the visible tally.
execute if score @s hpww.lv.age matches 32..71 if score #award hpww.lv.work matches 1.. if score @s hpww.lv.count matches 1.. run return run function hpww:main/spells/function/api/level/internal/retarget
execute if score @s hpww.lv.age matches 32..71 if score #award hpww.lv.work matches ..-1 if score @s hpww.lv.count matches ..-1 run return run function hpww:main/spells/function/api/level/internal/retarget
function hpww:main/spells/function/api/level/internal/begin
return run scoreboard players get @s hpww.xp
