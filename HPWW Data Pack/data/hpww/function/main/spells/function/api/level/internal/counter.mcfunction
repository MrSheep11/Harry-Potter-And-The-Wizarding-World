execute if score #count hpww.lv.work = @s hpww.lv.count run return 0
execute store result storage hpww:level counter.old int 1 run scoreboard players get @s hpww.lv.count
execute store result storage hpww:level counter.new int 1 run scoreboard players get #count hpww.lv.work
function hpww:main/spells/function/api/level/internal/strings with storage hpww:level counter
scoreboard players operation @s hpww.lv.count = #count hpww.lv.work
