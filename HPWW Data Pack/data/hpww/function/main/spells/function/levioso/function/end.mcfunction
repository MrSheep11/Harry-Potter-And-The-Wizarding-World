tag @s remove levioso_active
scoreboard players reset @s hpww.levioso.caster0
scoreboard players reset @s hpww.levioso.caster1
scoreboard players reset @s hpww.levioso.caster2
scoreboard players reset @s hpww.levioso.caster3
scoreboard players reset @s hpww.levioso.combo_at
execute as @s run attribute @s air_drag_modifier base reset
execute as @s run attribute @s gravity base reset
scoreboard players set @s levioso_spell_active.hit_count 0
