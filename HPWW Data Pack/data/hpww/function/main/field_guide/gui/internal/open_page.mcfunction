$data modify storage hpww:field_guide request.page set value "$(page)"
execute if score @s hpww.fg.session matches 1.. store result storage hpww:field_guide request.session int 1 run scoreboard players get @s hpww.fg.session
execute if score @s hpww.fg.session matches 1.. run return run function hpww:main/field_guide/gui/internal/session/queue with storage hpww:field_guide request
$return run function hpww:main/field_guide/gui/internal/session/start {page:"$(page)"}
