execute unless score @s SettingsMenu.page.spell_wheel matches 1 run return fail
playsound ui.button.click master @s ~ ~ ~ 0.2
scoreboard players operation #page hpww.fg.work = @s hpww.fg.spell_wheel_page.drawer_page
$scoreboard players set #page_step hpww.fg.work $(step)
scoreboard players operation #page hpww.fg.work += #page_step hpww.fg.work
execute if score #page hpww.fg.work matches ..0 run scoreboard players set #page hpww.fg.work 10
execute if score #page hpww.fg.work matches 11.. run scoreboard players set #page hpww.fg.work 1
function hpww:main/field_guide/gui/spell_wheel_page/drawer/show
