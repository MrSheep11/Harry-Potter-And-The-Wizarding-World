# Use the Animated Java animation names. Closing "none" removes the page without an animation.
$execute unless data storage hpww:field_guide pages."$(page)" run return fail
$data modify storage hpww:field_guide pages."$(page)".opening set value "$(opening)"
$data modify storage hpww:field_guide pages."$(page)".closing set value "$(closing)"
return 1
