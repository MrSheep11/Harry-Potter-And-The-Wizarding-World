$data modify storage hpww:fg_spell_wheel_runtime slot.name set value "$(entry)"
$data modify storage hpww:fg_spell_wheel_runtime slot.name set from storage hpww:gobal_spell_data "$(entry)".display_name
$execute unless data storage hpww:field_guide models."$(entry)" run data modify storage hpww:fg_spell_wheel_runtime slot.variant set value "wheel_$(entry)_slot_$(number)"
$execute if data storage hpww:field_guide models."$(entry)" run data modify storage hpww:fg_spell_wheel_runtime slot.model set value "hpww:field_guide/drawer/$(entry)"
$execute if data storage hpww:field_guide models."$(entry)" run data modify storage hpww:fg_spell_wheel_runtime slot.variant set value "wheel_$(number)"
