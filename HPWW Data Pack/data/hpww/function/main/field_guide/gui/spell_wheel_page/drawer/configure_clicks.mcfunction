$data modify entity @s data.animated_java.on_attack_function set value "function hpww:main/field_guide/gui/spell_wheel_page/drawer/on_attack {slot:$(number)}"
$data modify entity @s data.animated_java.on_interact_function set value "function hpww:main/field_guide/gui/spell_wheel_page/drawer/on_interact {slot:$(number)}"
tag @s add hpww.fg.drawer_clicks
