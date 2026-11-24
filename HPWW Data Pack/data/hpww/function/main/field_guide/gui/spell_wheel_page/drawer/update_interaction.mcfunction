# Backfill click handlers when a rig predates this wiring or was re-exported.
execute unless entity @s[tag=hpww.fg.drawer_clicks] run function hpww:main/field_guide/gui/spell_wheel_page/drawer/configure_clicks with storage hpww:fg_spell_wheel_runtime slot
data modify entity @s CustomName set from storage hpww:fg_spell_wheel_runtime slot.name
