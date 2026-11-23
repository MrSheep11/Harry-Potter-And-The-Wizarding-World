# Save the first rig's exact position and the facing before the rig's authored yaw offset.
$data modify storage hpww:field_guide sessions."$(session)" set value {origin:{session:$(session)}}
$data modify storage hpww:field_guide sessions."$(session)".active set from storage hpww:field_guide pages."$(page)"
$data modify storage hpww:field_guide sessions."$(session)".origin.dimension set from entity @s Dimension
$data modify storage hpww:field_guide sessions."$(session)".origin.yaw set from entity @s Rotation[0]
scoreboard players operation #rig aj.id = @s hpww.fg.rig
$execute at @s as @e[type=item_display,tag=hpww.fg.page_root,distance=..3] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/internal/session/save_position {session:$(session)}
