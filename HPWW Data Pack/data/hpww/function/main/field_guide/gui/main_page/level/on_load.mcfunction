scoreboard players set #fill hpww.fg.work 100
scoreboard players set #level hpww.fg.work 101
execute if score @s hpww.FillGlyph matches 100..130 run scoreboard players operation #fill hpww.fg.work = @s hpww.FillGlyph
execute if score @s hpww.NumberGlyph matches 101..120 run scoreboard players operation #level hpww.fg.work = @s hpww.NumberGlyph
scoreboard players remove #fill hpww.fg.work 100
scoreboard players remove #level hpww.fg.work 100
execute store result storage hpww:field_guide level.fill int 1 run scoreboard players get #fill hpww.fg.work
execute store result storage hpww:field_guide level.number int 1 run scoreboard players get #level hpww.fg.work
execute at @s as @e[type=item_display,tag=aj.field_guide_gui.root,distance=0..3] if score @s aj.id = #opening_rig aj.id run function hpww:main/field_guide/gui/main_page/level/apply with storage hpww:field_guide level
