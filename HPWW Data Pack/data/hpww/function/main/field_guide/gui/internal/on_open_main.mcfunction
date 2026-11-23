tag @s add hpww.field_guide.page_main
scoreboard players set @s SettingsMenu.page.main 1
function hpww:main/field_guide/gui/main_page/level/on_load
execute unless score @s hppw.field_guide.first_open_dialog matches 1 run function hpww:main/field_guide/gui/first_open
