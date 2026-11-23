# Register an exported Animated Java project as a Field Guide page.
$data modify storage hpww:field_guide pages."$(page)" set value {page:"$(page)",project:"$(project)",yaw:0,opening:"open",closing:"none"}
return 1
