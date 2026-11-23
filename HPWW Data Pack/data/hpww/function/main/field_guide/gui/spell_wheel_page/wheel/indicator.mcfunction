$scoreboard players set #previous hpww.fg.work $(previous)
$execute if score #previous hpww.fg.work matches 1..7 run function aj:fg_spell_wheel/variants/wheel_page_indicator_$(previous)_off/apply
$function aj:fg_spell_wheel/variants/wheel_page_indicator_$(page)/apply
