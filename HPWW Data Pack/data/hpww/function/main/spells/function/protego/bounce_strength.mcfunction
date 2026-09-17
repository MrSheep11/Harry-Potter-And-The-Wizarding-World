# $x, $y, and $z contain the entity's impact motion (scaled by 10,000).
scoreboard players operation $strength player_motion.api.launch = $x player_motion.api.launch
execute if score $strength player_motion.api.launch matches ..-1 run scoreboard players operation $strength player_motion.api.launch *= #constant.-1 player_motion.internal.const
execute if score $y player_motion.api.launch matches ..-1 run scoreboard players operation $y player_motion.api.launch *= #constant.-1 player_motion.internal.const
execute if score $z player_motion.api.launch matches ..-1 run scoreboard players operation $z player_motion.api.launch *= #constant.-1 player_motion.internal.const
scoreboard players operation $strength player_motion.api.launch += $y player_motion.api.launch
scoreboard players operation $strength player_motion.api.launch += $z player_motion.api.launch
execute if score $strength player_motion.api.launch matches ..4999 run scoreboard players set $strength player_motion.api.launch 5000
execute if score $strength player_motion.api.launch matches 25001.. run scoreboard players set $strength player_motion.api.launch 25000
