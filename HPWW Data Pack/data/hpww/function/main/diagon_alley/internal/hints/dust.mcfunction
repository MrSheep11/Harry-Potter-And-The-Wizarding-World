# Rear hitboxes sit farther out to stay clickable past the actual barrier depth.
$execute store result score #hint_viewer hpww.diagon_alley.rig run data get entity @s Pos[$(axis)] 10
$execute if score #hint_rear hpww.diagon_alley.rig matches 0 if score #hint_viewer hpww.diagon_alley.rig $(front) #hint_plane hpww.diagon_alley.rig rotated ~ 0 positioned ^ ^0.22 ^-0.16 run particle minecraft:dust{color:[1.0,1.0,1.0],scale:0.4} ~ ~ ~ 0.055 0.065 0.055 0 3 normal @s
$execute if score #hint_rear hpww.diagon_alley.rig matches 1 if score #hint_viewer hpww.diagon_alley.rig $(rear) #hint_plane hpww.diagon_alley.rig rotated ~ 0 positioned ^ ^0.22 ^-0.15 run particle minecraft:dust{color:[1.0,1.0,1.0],scale:0.4} ~ ~ ~ 0.055 0.065 0.055 0 3 normal @s
