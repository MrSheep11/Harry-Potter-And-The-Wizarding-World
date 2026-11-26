# Only the leading digit carries the sign, so changing sign never redraws unrelated digits.
$data modify storage hpww:level char.old set value "$(before)$(old)"
$data modify storage hpww:level char.new set value "$(after)$(new)"
