scoreboard players operation #xp hpww.lv.work = @s hpww.xp
scoreboard players operation #level hpww.lv.work = @s hpww.level
function hpww:main/spells/function/api/level/internal/progress
scoreboard players operation @s hpww.level = #level hpww.lv.work
scoreboard players operation @s hpww.NumberGlyph = #level hpww.lv.work
scoreboard players add @s hpww.NumberGlyph 100
scoreboard players operation @s hpww.FillGlyph = #fill hpww.lv.work
scoreboard players add @s hpww.FillGlyph 100
