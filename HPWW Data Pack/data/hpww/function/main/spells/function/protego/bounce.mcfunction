# This function runs as the collider. Its execution position is the Protego
# display, and its rotation points from the caster to the collider in 3D.
execute if entity @s[type=arrow] run return run function hpww:main/spells/function/protego/bounce_arrow
execute if entity @s[type=spectral_arrow] run return run function hpww:main/spells/function/protego/bounce_arrow

# Convert the shield-to-collider direction into a 3D unit vector.
scoreboard players set $strength player_motion.api.launch 10000
execute store result storage player_motion:math strength double 0.0001 run scoreboard players get $strength player_motion.api.launch
execute as d4bd74a7-4e82-4a07-8850-dfc4d89f9e2f in minecraft:overworld positioned 0.0 0.0 0.0 run function player_motion:internal/math/looking_to_xyz with storage player_motion:math
execute store result score #protego_normal_x player_motion.api.launch run data get storage player_motion:math motion[0] 10000
execute store result score #protego_normal_y player_motion.api.launch run data get storage player_motion:math motion[1] 10000
execute store result score #protego_normal_z player_motion.api.launch run data get storage player_motion:math motion[2] 10000

# A negative collider dot product means it moved into Protego. A positive
# caster dot product means the caster moved into the collider.
execute store result score #protego_target_x player_motion.api.launch run data get entity @s Motion[0] 10000
execute store result score #protego_target_y player_motion.api.launch run data get entity @s Motion[1] 10000
execute store result score #protego_target_z player_motion.api.launch run data get entity @s Motion[2] 10000
scoreboard players operation #protego_target_dot player_motion.api.launch = #protego_target_x player_motion.api.launch
scoreboard players operation #protego_target_dot player_motion.api.launch *= #protego_normal_x player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch = #protego_target_y player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch *= #protego_normal_y player_motion.api.launch
scoreboard players operation #protego_target_dot player_motion.api.launch += #protego_dot_part player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch = #protego_target_z player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch *= #protego_normal_z player_motion.api.launch
scoreboard players operation #protego_target_dot player_motion.api.launch += #protego_dot_part player_motion.api.launch

execute store result score #protego_owner_x player_motion.api.launch run data get entity @a[tag=protego_owner_check,limit=1,sort=nearest] Motion[0] 10000
execute store result score #protego_owner_y player_motion.api.launch run data get entity @a[tag=protego_owner_check,limit=1,sort=nearest] Motion[1] 10000
execute store result score #protego_owner_z player_motion.api.launch run data get entity @a[tag=protego_owner_check,limit=1,sort=nearest] Motion[2] 10000
scoreboard players operation #protego_owner_dot player_motion.api.launch = #protego_owner_x player_motion.api.launch
scoreboard players operation #protego_owner_dot player_motion.api.launch *= #protego_normal_x player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch = #protego_owner_y player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch *= #protego_normal_y player_motion.api.launch
scoreboard players operation #protego_owner_dot player_motion.api.launch += #protego_dot_part player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch = #protego_owner_z player_motion.api.launch
scoreboard players operation #protego_dot_part player_motion.api.launch *= #protego_normal_z player_motion.api.launch
scoreboard players operation #protego_owner_dot player_motion.api.launch += #protego_dot_part player_motion.api.launch

# At 10,000-scaled motion, 1,000,000 is an approach speed of 0.01 blocks/tick.
execute if score #protego_target_dot player_motion.api.launch matches ..-1000000 run function hpww:main/spells/function/protego/bounce_target
execute if score #protego_owner_dot player_motion.api.launch matches 1000000.. as @a[tag=protego_owner_check,limit=1,sort=nearest] run function hpww:main/spells/function/protego/bounce_owner

# If two entities are already embedded, they may have no measurable approach
# speed. Within this close range, launch both apart as an overlap safeguard.
execute if entity @s[distance=..0.8] if score #protego_target_dot player_motion.api.launch matches -999999..999999 if score #protego_owner_dot player_motion.api.launch matches -999999..999999 run function hpww:main/spells/function/protego/bounce_target
execute if entity @s[distance=..0.8] if score #protego_target_dot player_motion.api.launch matches -999999..999999 if score #protego_owner_dot player_motion.api.launch matches -999999..999999 as @a[tag=protego_owner_check,limit=1,sort=nearest] run function hpww:main/spells/function/protego/bounce_owner
