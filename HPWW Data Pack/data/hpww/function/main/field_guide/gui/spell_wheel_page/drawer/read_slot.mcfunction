# Return the current category's registered spell into selection.spell.
data remove storage hpww:fg_spell_wheel_runtime selection.spell
$data modify storage hpww:fg_spell_wheel_runtime selection.spell set from storage hpww:field_guide drawer.p$(page).s$(slot).spell
execute unless data storage hpww:fg_spell_wheel_runtime selection.spell run return fail
return 1
