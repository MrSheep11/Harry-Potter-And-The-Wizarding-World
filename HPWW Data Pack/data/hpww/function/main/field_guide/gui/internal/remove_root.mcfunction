scoreboard players operation #closing_rig aj.id = @s aj.id
execute store result storage animated_java:temp args.id int 1 run scoreboard players get @s aj.id
function animated_java:global/data_manager/read with storage animated_java:temp args
function hpww:main/field_guide/gui/internal/remove_rig with storage animated_java:temp entry.data
# Some exports leave detached nodes behind. Match the exact allocation ID.
execute as @e[tag=aj.global.entity] if score @s aj.id = #closing_rig aj.id run kill @s
