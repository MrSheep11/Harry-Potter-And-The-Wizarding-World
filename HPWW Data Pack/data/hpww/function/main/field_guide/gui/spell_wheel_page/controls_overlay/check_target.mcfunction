execute unless entity @s[type=interaction] run return 0
execute unless score @s aj.id = #rig aj.id run return 0
execute if entity @s[tag=aj.fg_spell_wheel.bone.spell_wheel_slot_display.decendant.interaction] run return run scoreboard players set #controls_hover hpww.fg.work 1
execute if entity @s[tag=aj.fg_spell_wheel.bone.spell_drawer.decendant.interaction] run scoreboard players set #controls_hover hpww.fg.work 2
