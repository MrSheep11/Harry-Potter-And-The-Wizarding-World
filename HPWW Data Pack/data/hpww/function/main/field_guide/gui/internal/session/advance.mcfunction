$data modify storage hpww:field_guide sessions."$(session)".active set from storage hpww:field_guide sessions."$(session)".next
$data remove storage hpww:field_guide sessions."$(session)".next
scoreboard players reset @s hpww.fg.rig
$function hpww:main/field_guide/gui/internal/session/spawn_page with storage hpww:field_guide sessions."$(session)".active
execute if score @s hpww.fg.rig matches 1.. run return 1
$return run function hpww:main/field_guide/gui/internal/session/finish {session:$(session)}
