# Avoid boxing a player in if they are still standing in the doorway.
$execute positioned ~$(min_x) ~ ~$(min_z) if entity @a[dx=$(dx),dy=2,dz=$(dz),gamemode=!spectator] run return 0
scoreboard players operation #owner hpww.diagon_alley.collider = @s aj.id
tag @s add hpww.diagon_alley.solid
execute positioned ~0.5 ~ ~0.5 summon minecraft:marker run function hpww:main/diagon_alley/internal/collider/init
