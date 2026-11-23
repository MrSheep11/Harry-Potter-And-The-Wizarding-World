execute if score @s SettingsMenuStatus matches 1 run return 0
execute if predicate hpww:on_ground run return run advancement revoke @s only hpww:blocks/main_wand/right_click_settings_button
return run function hpww:main/field_guide/api/open {page:"main"}
