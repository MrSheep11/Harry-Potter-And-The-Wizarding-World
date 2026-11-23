execute if score @s hpww.interaction.is_being_looked_at matches 2 unless entity @s[tag=hpww.fg.hovered] run function hpww:main/field_guide/gui/main_page/hover_variant {state:"highlight"}
execute if score @s hpww.interaction.is_being_looked_at matches 1 if entity @s[tag=hpww.fg.hovered] run function hpww:main/field_guide/gui/main_page/hover_variant {state:"normal"}
execute if score @s hpww.interaction.is_being_looked_at matches 2 run tag @s add hpww.fg.hovered
execute if score @s hpww.interaction.is_being_looked_at matches 1 run tag @s remove hpww.fg.hovered
scoreboard players remove @s hpww.interaction.is_being_looked_at 1
