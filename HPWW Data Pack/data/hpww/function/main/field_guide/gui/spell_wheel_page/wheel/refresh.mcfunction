execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return 0
execute at @s if function hpww:main/field_guide/gui/spell_wheel_page/drawer/find_rig run function hpww:main/field_guide/gui/spell_wheel_page/wheel/render
