execute unless score @s hpww.levioso.combo_at matches 0.. run return 0
execute store result score #elapsed hpww.levioso.combo_at run time query gametime
scoreboard players operation #elapsed hpww.levioso.combo_at -= @s hpww.levioso.combo_at
# The time query wraps at 2147483647; the combo lasts 100 game ticks.
execute if score #elapsed hpww.levioso.combo_at matches ..-1 run scoreboard players add #elapsed hpww.levioso.combo_at 2147483647
execute unless score #elapsed hpww.levioso.combo_at matches 0..99 run return 0

execute store result score #depulso hpww.levioso.caster0 run data get storage hpww:trail_storage out.caster_uuid[0]
execute store result score #depulso hpww.levioso.caster1 run data get storage hpww:trail_storage out.caster_uuid[1]
execute store result score #depulso hpww.levioso.caster2 run data get storage hpww:trail_storage out.caster_uuid[2]
execute store result score #depulso hpww.levioso.caster3 run data get storage hpww:trail_storage out.caster_uuid[3]

execute unless score @s hpww.levioso.caster0 = #depulso hpww.levioso.caster0 run return 0
execute unless score @s hpww.levioso.caster1 = #depulso hpww.levioso.caster1 run return 0
execute unless score @s hpww.levioso.caster2 = #depulso hpww.levioso.caster2 run return 0
execute unless score @s hpww.levioso.caster3 = #depulso hpww.levioso.caster3 run return 0

scoreboard players reset @s hpww.levioso.combo_at
tag @s add hpww.levioso.combo_target
execute as @a[tag=!hpww.levioso.combo_target] if score @s spell_uuid_0 = #depulso hpww.levioso.caster0 if score @s spell_uuid_1 = #depulso hpww.levioso.caster1 if score @s spell_uuid_2 = #depulso hpww.levioso.caster2 if score @s spell_uuid_3 = #depulso hpww.levioso.caster3 at @s run function hpww:main/spells/function/api/level/add_xp {amount:10}
tag @s remove hpww.levioso.combo_target
