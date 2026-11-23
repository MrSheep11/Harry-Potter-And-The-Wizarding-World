$data modify storage hpww:fg_spell_wheel_runtime slot.model set value "hpww:field_guide/drawer/$(spell)"
$data modify storage hpww:fg_spell_wheel_runtime slot.name set value "$(name) (Locked)"
data modify storage hpww:fg_spell_wheel_runtime slot.state set value "locked"
$execute if entity @s[advancements={hpww:spells/unlocked/$(spell)_unlocked=true}] run function hpww:main/field_guide/gui/spell_wheel_page/drawer/render_unlocked
function hpww:main/field_guide/gui/spell_wheel_page/drawer/set_variant with storage hpww:fg_spell_wheel_runtime slot
