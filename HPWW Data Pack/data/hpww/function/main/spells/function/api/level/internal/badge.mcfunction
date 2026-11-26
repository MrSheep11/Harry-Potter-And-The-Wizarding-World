scoreboard players operation #xp hpww.lv.work = @s hpww.lv.shown
scoreboard players set #level hpww.lv.work 1
execute if score @s hpww.lv.number matches 1..50 run scoreboard players operation #level hpww.lv.work = @s hpww.lv.number
function hpww:main/spells/function/api/level/internal/progress
scoreboard players set #gold hpww.lv.work 0
execute if score @s hpww.lv.age matches 0..31 run scoreboard players set #gold hpww.lv.work 1
execute if score #level hpww.lv.work = @s hpww.lv.number if score #fill hpww.lv.work = @s hpww.lv.frame if score #gold hpww.lv.work = @s hpww.lv.gold run return 0
execute store result storage hpww:level badge.old_fill int 1 run scoreboard players get @s hpww.lv.frame
execute store result storage hpww:level badge.old_level int 1 run scoreboard players get @s hpww.lv.number
execute store result storage hpww:level badge.fill int 1 run scoreboard players get #fill hpww.lv.work
execute store result storage hpww:level badge.level int 1 run scoreboard players get #level hpww.lv.work
function hpww:main/spells/function/api/level/internal/swap_badge with storage hpww:level badge
scoreboard players operation @s hpww.lv.number = #level hpww.lv.work
scoreboard players operation @s hpww.lv.frame = #fill hpww.lv.work
scoreboard players operation @s hpww.lv.gold = #gold hpww.lv.work
