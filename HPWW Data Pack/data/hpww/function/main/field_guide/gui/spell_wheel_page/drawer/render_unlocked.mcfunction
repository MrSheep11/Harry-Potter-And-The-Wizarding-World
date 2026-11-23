data modify storage hpww:fg_spell_wheel_runtime slot.name set from storage hpww:fg_spell_wheel_runtime slot.entry.name
data modify storage hpww:fg_spell_wheel_runtime slot.state set value "active"
execute store result score #slot hpww.fg.work run data get storage hpww:fg_spell_wheel_runtime slot.number
execute if score @s hpww.drawer_selected_slot = #slot hpww.fg.work run data modify storage hpww:fg_spell_wheel_runtime slot.state set value "selected"
