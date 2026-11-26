# e draws the XP suffix; x is an empty position. Only changed characters need packets.
$data modify storage hpww:level old set value "$(old)exxxxxxxxxxx"
$data modify storage hpww:level new set value "$(new)exxxxxxxxxxx"
data modify storage hpww:level char.before set value ""
data modify storage hpww:level char.after set value ""
execute if score @s hpww.lv.count matches -2147483647..-1 run data modify storage hpww:level old set string storage hpww:level old 1
execute if score @s hpww.lv.count matches -2147483647..-1 run data modify storage hpww:level char.before set value "n"
execute if score #count hpww.lv.work matches -2147483647..-1 run data modify storage hpww:level new set string storage hpww:level new 1
execute if score #count hpww.lv.work matches -2147483647..-1 run data modify storage hpww:level char.after set value "n"
execute if data storage hpww:level counter{old:-2147483648} run data modify storage hpww:level old set value "xxxxxxxxxxx"
execute if data storage hpww:level counter{new:-2147483648} run data modify storage hpww:level new set value "xxxxxxxxxxx"
scoreboard players set #pos hpww.lv.work 0
function hpww:main/spells/function/api/level/internal/char {i:0,j:1}
