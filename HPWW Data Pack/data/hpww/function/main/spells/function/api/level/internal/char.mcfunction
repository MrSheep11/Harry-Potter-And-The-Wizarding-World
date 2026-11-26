$data modify storage hpww:level char.old set string storage hpww:level old $(i) $(j)
$data modify storage hpww:level char.new set string storage hpww:level new $(i) $(j)
execute if score #pos hpww.lv.work matches 0 run function hpww:main/spells/function/api/level/internal/signed_head with storage hpww:level char
execute if data storage hpww:level char{old:"x",new:"x"} run return 0
$data modify storage hpww:level char.i set value $(i)
data modify storage hpww:level cmp set from storage hpww:level char.old
execute store success score #changed hpww.lv.work run data modify storage hpww:level cmp set from storage hpww:level char.new
execute if score #changed hpww.lv.work matches 1 run function hpww:main/spells/function/api/level/internal/swap_char with storage hpww:level char
execute if score #pos hpww.lv.work matches 10 run return 0
scoreboard players add #pos hpww.lv.work 1
execute store result storage hpww:level cursor.i int 1 run scoreboard players get #pos hpww.lv.work
$scoreboard players set #end hpww.lv.work $(j)
execute store result storage hpww:level cursor.j int 1 run scoreboard players add #end hpww.lv.work 1
function hpww:main/spells/function/api/level/internal/char with storage hpww:level cursor
