# The caster approached the collider. This context retains the shield-to-target
# rotation, so negate that vector to push the caster back from the collision.
execute store result score $x player_motion.api.launch run data get entity @s Motion[0] 10000
execute store result score $y player_motion.api.launch run data get entity @s Motion[1] 10000
execute store result score $z player_motion.api.launch run data get entity @s Motion[2] 10000
function hpww:main/spells/function/protego/bounce_strength

execute store result storage player_motion:math strength double 0.0001 run scoreboard players get $strength player_motion.api.launch
execute as d4bd74a7-4e82-4a07-8850-dfc4d89f9e2f in minecraft:overworld positioned 0.0 0.0 0.0 run function player_motion:internal/math/looking_to_xyz with storage player_motion:math
execute store result score $x player_motion.api.launch run data get storage player_motion:math motion[0] 10000
execute store result score $y player_motion.api.launch run data get storage player_motion:math motion[1] 10000
execute store result score $z player_motion.api.launch run data get storage player_motion:math motion[2] 10000
scoreboard players operation $x player_motion.api.launch *= #constant.-1 player_motion.internal.const
scoreboard players operation $y player_motion.api.launch *= #constant.-1 player_motion.internal.const
scoreboard players operation $z player_motion.api.launch *= #constant.-1 player_motion.internal.const
function hpww:main/spells/function/protego/bounce_player
