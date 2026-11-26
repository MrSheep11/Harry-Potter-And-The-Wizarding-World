# Brick 1 always starts over. Progress belongs to this player and this opening cycle.
execute if score #brick diagonalley_wall matches 1 run scoreboard players operation @s hpww.diagon_alley.rig = #tap_round hpww.diagon_alley.round
execute if score #brick diagonalley_wall matches 1 run scoreboard players set @s diagonalley_wall 0
execute unless score @s hpww.diagon_alley.rig = #tap_round hpww.diagon_alley.round run return run function hpww:main/diagon_alley/internal/reset_sequence
scoreboard players add @s diagonalley_wall 1
execute unless score @s diagonalley_wall = #brick diagonalley_wall run return run function hpww:main/diagon_alley/internal/reset_sequence
execute unless score @s diagonalley_wall matches 3 run return 0
function hpww:main/diagon_alley/internal/reset_sequence
return 1
