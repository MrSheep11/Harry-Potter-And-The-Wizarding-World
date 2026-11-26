# Render the regular fill first, the optional gold outline second and the numeral last.
$execute if score @s hpww.lv.frame matches 0.. run posteffect remove @s hpww:level/fill/$(old_fill)
execute if score @s hpww.lv.gold matches 1 run posteffect remove @s hpww:level/highlight
$execute if score @s hpww.lv.number matches 1.. run posteffect remove @s hpww:level/number/$(old_level)
$posteffect add @s hpww:level/fill/$(fill)
execute if score #gold hpww.lv.work matches 1 run posteffect add @s hpww:level/highlight
$posteffect add @s hpww:level/number/$(level)
