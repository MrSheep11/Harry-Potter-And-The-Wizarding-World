# Connect the drawer slot to the shared selection handler.
data modify entity @s CustomName set value ""
data modify entity @s data.animated_java.on_interact_function set value "function aj:fg_spell_wheel/interactions/drawer_slot_1_interaction_on_interact"
data modify entity @s data.animated_java.on_attack_function set value "function hpww:main/field_guide/gui/spell_wheel_page/drawer/on_attack {slot:1}"
