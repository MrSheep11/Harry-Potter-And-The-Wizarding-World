execute store result storage hpww:fg_spell_wheel_runtime slot.page int 1 run scoreboard players get @s hpww.fg.spell_wheel_page.drawer_page
data modify storage hpww:fg_spell_wheel_runtime slot.number set value 1
function hpww:main/field_guide/gui/spell_wheel_page/drawer/render_slot with storage hpww:fg_spell_wheel_runtime slot
