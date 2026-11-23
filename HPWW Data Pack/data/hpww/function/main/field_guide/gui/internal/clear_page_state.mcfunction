tag @s remove hpww.field_guide.page_main
function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/hide
scoreboard players set @s SettingsMenu.page.main 0
scoreboard players set @s SettingsMenu.page.spell_wheel 0
scoreboard players reset @s hpww.drawer_selected_slot
scoreboard players reset @s hpww.fg.spell_wheel_page.drawer_page
scoreboard players reset @s hpww.fg.spell_wheel_page.wheel_page
