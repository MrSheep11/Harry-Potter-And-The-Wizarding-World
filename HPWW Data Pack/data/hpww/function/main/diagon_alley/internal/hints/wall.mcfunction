# The nearby hitboxes carry their own rig ID, even when walls overlap.
function hpww:main/diagon_alley/internal/round/ensure
scoreboard players operation #hint_round hpww.diagon_alley.round = @s hpww.diagon_alley.round
scoreboard players operation #hint_wall hpww.diagon_alley.rig = @s aj.id
execute if entity @s[y_rotation=-45..45] run return run function hpww:main/diagon_alley/internal/hints/locate_faces {axis:2,offset:"add",front:"<=",rear:">"}
execute if entity @s[y_rotation=45..135] run return run function hpww:main/diagon_alley/internal/hints/locate_faces {axis:0,offset:"remove",front:">=",rear:"<"}
execute if entity @s[y_rotation=-135..-45] run return run function hpww:main/diagon_alley/internal/hints/locate_faces {axis:0,offset:"add",front:"<=",rear:">"}
function hpww:main/diagon_alley/internal/hints/locate_faces {axis:2,offset:"remove",front:">=",rear:"<"}
