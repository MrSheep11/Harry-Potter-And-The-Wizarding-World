execute unless entity @s[type=player,scores={SettingsMenu.page.spell_wheel=1}] run return fail
$scoreboard players set #page hpww.fg.work $(page)
execute unless score #page hpww.fg.work matches 1..10 run return fail
execute at @s run function hpww:main/field_guide/gui/spell_wheel_page/drawer/show
