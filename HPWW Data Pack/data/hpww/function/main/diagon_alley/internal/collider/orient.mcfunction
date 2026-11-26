# The visual insert spans three columns, one block in front of the rig origin.
execute if entity @s[y_rotation=-45..45] rotated 0 0 positioned ^ ^0.5 ^1 align xyz run return run function hpww:main/diagon_alley/internal/collider/place {min_x:-1,min_z:0,dx:2,dz:0}
execute if entity @s[y_rotation=45..135] rotated 90 0 positioned ^ ^0.5 ^1 align xyz run return run function hpww:main/diagon_alley/internal/collider/place {min_x:0,min_z:-1,dx:0,dz:2}
execute if entity @s[y_rotation=-135..-45] rotated -90 0 positioned ^ ^0.5 ^1 align xyz run return run function hpww:main/diagon_alley/internal/collider/place {min_x:0,min_z:-1,dx:0,dz:2}
execute rotated 180 0 positioned ^ ^0.5 ^1 align xyz run function hpww:main/diagon_alley/internal/collider/place {min_x:-1,min_z:0,dx:2,dz:0}
