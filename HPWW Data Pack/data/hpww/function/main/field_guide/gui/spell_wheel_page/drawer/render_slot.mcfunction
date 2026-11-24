data remove storage hpww:fg_spell_wheel_runtime slot.entry
$data modify storage hpww:fg_spell_wheel_runtime slot.entry set from storage hpww:field_guide drawer.p$(page).s$(number)
$data modify storage hpww:fg_spell_wheel_runtime slot.model set value "aj:blueprint/fg_spell_wheel/d_slot_$(number)"
$data modify storage hpww:fg_spell_wheel_runtime slot.variant set value "drawer_blank_slot_$(number)"
data modify storage hpww:fg_spell_wheel_runtime slot.name set value ""
execute if data storage hpww:fg_spell_wheel_runtime slot.entry run function hpww:main/field_guide/gui/spell_wheel_page/drawer/render_spell with storage hpww:fg_spell_wheel_runtime slot.entry
$execute as @e[type=item_display,tag=aj.fg_spell_wheel.bone.d_slot_$(number),distance=0..8] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/drawer/apply_model
$execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.drawer_slot_$(number)_interaction,distance=0..8] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/drawer/update_interaction
$scoreboard players set #slot hpww.fg.work $(number)
execute if score #slot hpww.fg.work matches 8 run return 1
scoreboard players add #slot hpww.fg.work 1
execute store result storage hpww:fg_spell_wheel_runtime slot.number int 1 run scoreboard players get #slot hpww.fg.work
function hpww:main/field_guide/gui/spell_wheel_page/drawer/render_slot with storage hpww:fg_spell_wheel_runtime slot
