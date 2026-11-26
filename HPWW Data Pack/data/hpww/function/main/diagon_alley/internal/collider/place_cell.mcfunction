# Record only air that this collider replaces, including the original air type.
$execute if block ~ ~ ~ minecraft:air run data modify entity @s data.cells.c$(cell) set value "air"
$execute if block ~ ~ ~ minecraft:cave_air run data modify entity @s data.cells.c$(cell) set value "cave_air"
$execute if block ~ ~ ~ minecraft:void_air run data modify entity @s data.cells.c$(cell) set value "void_air"
$execute if data entity @s data.cells.c$(cell) run setblock ~ ~ ~ minecraft:barrier
