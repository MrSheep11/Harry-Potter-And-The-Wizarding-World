$execute unless data storage hpww:level char{old:"x"} run posteffect remove @s hpww:level/gain/$(i)_$(old)
$execute unless data storage hpww:level char{new:"x"} run posteffect add @s hpww:level/gain/$(i)_$(new)
