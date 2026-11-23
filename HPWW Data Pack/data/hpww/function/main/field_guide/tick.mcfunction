execute if entity @s[tag=hpww.fg.wheel_controls] unless score @s SettingsMenuStatus matches 1 run function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/hide
execute if entity @s[tag=hpww.fg.drawer_controls] unless score @s SettingsMenuStatus matches 1 run function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/hide
execute unless score @s SettingsMenuStatus matches 1 run return 0
execute unless score @s hpww.fg.session matches 1.. run return run function hpww:main/field_guide/gui/internal/close_owned
execute store result storage hpww:field_guide request.session int 1 run scoreboard players get @s hpww.fg.session
function hpww:main/field_guide/gui/internal/session/tick with storage hpww:field_guide request
