data modify storage hpww:fg_spell_wheel_runtime slot set value {name:"Blank"}
$data modify storage hpww:fg_spell_wheel_runtime slot.model set value "aj:blueprint/fg_spell_wheel/w_slot_$(number)"
$data modify storage hpww:fg_spell_wheel_runtime slot.variant set value "wheel_blank_slot_$(number)"
$data modify storage hpww:fg_spell_wheel_runtime slot.entry set from storage pdb:main out.spell_wheel_data.spells.page_$(page).slot_$(number).Spell
$data modify storage hpww:fg_spell_wheel_runtime slot.number set value $(number)
execute if data storage hpww:fg_spell_wheel_runtime slot.entry run function hpww:main/field_guide/gui/spell_wheel_page/wheel/render_spell with storage hpww:fg_spell_wheel_runtime slot
$execute as @e[type=item_display,tag=aj.fg_spell_wheel.bone.w_slot_$(number),distance=0..8] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/spell_wheel_page/drawer/apply_model
$execute as @e[type=interaction,tag=aj.fg_spell_wheel.interaction.wheel_slot_$(number)_interaction,distance=0..8] if score @s aj.id = #rig aj.id run data modify entity @s CustomName set from storage hpww:fg_spell_wheel_runtime slot.name
$scoreboard players set #slot hpww.fg.work $(number)
execute if score #slot hpww.fg.work matches 4 run return 1
scoreboard players add #slot hpww.fg.work 1
execute store result storage hpww:fg_spell_wheel_runtime wheel.number int 1 run scoreboard players get #slot hpww.fg.work
function hpww:main/field_guide/gui/spell_wheel_page/wheel/render_slot with storage hpww:fg_spell_wheel_runtime wheel
