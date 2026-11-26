execute unless block ~ ~ ~ minecraft:barrier run return 0
$execute if data entity @s data.cells{c$(cell):"air"} run return run setblock ~ ~ ~ minecraft:air
$execute if data entity @s data.cells{c$(cell):"cave_air"} run return run setblock ~ ~ ~ minecraft:cave_air
$execute if data entity @s data.cells{c$(cell):"void_air"} run setblock ~ ~ ~ minecraft:void_air
