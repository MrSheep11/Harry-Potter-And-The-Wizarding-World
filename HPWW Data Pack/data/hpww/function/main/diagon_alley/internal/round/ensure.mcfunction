# Negative round IDs cannot collide with a player's old positive AJ rig ID.
execute unless score @s hpww.diagon_alley.round matches ..-1 store result score @s hpww.diagon_alley.round run scoreboard players remove #next hpww.diagon_alley.round 1
