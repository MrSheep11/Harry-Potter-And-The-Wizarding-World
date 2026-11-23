# A spell definition provides its display name and unlock advancement ID.
$execute unless data storage hpww:gobal_spell_data "$(spell)".display_name run return fail
$execute if data storage hpww:gobal_spell_data "$(spell)"{Spell:"blank"} run return fail
$scoreboard players set #page hpww.fg.work $(page)
$scoreboard players set #slot hpww.fg.work $(slot)
execute unless score #page hpww.fg.work matches 1..10 run return fail
execute unless score #slot hpww.fg.work matches 1..8 run return fail
$data modify storage hpww:field_guide drawer.p$(page).s$(slot) set value {spell:"$(spell)"}
$data modify storage hpww:field_guide drawer.p$(page).s$(slot).name set from storage hpww:gobal_spell_data "$(spell)".display_name
$data modify storage hpww:field_guide models."$(spell)" set value 1b
return 1
