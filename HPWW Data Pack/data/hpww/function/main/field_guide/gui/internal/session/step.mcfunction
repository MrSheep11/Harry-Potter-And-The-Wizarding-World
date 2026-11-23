$execute unless entity @s[distance=..3] unless data storage hpww:field_guide sessions."$(session)"{exit:1b} run function hpww:main/field_guide/gui/internal/session/request_close {session:$(session)}
scoreboard players operation #rig aj.id = @s hpww.fg.rig
scoreboard players set #present hpww.fg.work 0
execute as @e[type=item_display,tag=hpww.fg.page_root,distance=..0.01] if score @s aj.id = #rig aj.id run scoreboard players set #present hpww.fg.work 1
$execute if score #present hpww.fg.work matches 0 if data storage hpww:field_guide sessions."$(session)".next run return run function hpww:main/field_guide/gui/internal/session/advance {session:$(session)}
$execute if score #present hpww.fg.work matches 0 run return run function hpww:main/field_guide/gui/internal/session/finish {session:$(session)}
$execute if score @s hpww.fg.busy matches 1 run return run function hpww:main/field_guide/gui/internal/session/transition with storage hpww:field_guide sessions."$(session)".active
execute if score @s SettingsMenu.page.main matches 1 at @s run function hpww:main/field_guide/gui/main_page/tick
execute if score @s SettingsMenu.page.spell_wheel matches 1 at @s run function hpww:main/field_guide/gui/spell_wheel_page/controls_overlay/tick
