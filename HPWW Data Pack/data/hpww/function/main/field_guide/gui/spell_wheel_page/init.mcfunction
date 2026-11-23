scoreboard players set @s SettingsMenu.page.spell_wheel 1
function hpww:main/field_guide/api/spell_wheel/show_drawer_page {page:1}
scoreboard players set #page hpww.fg.work 1
function hpww:main/field_guide/gui/spell_wheel_page/wheel/show
execute unless score @s hpww.fg.spell_wheel_page.notice_seen matches 1 run function hpww:main/field_guide/gui/spell_wheel_page/show_first_open_notice
