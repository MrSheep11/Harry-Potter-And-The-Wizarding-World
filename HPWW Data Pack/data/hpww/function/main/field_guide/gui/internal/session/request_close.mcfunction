$data modify storage hpww:field_guide sessions."$(session)".exit set value 1b
$data remove storage hpww:field_guide sessions."$(session)".next
scoreboard players set @s hpww.fg.busy 1
function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/hide
return 1
