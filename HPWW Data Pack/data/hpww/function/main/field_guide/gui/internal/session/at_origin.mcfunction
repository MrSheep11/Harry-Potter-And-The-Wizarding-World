# Exact coordinates, including integers in X/Z, must not be centered on blocks.
$execute unless dimension $(dimension) unless data storage hpww:field_guide sessions."$(session)"{exit:1b} run function hpww:main/field_guide/gui/internal/session/request_close {session:$(session)}
$execute in $(dimension) positioned 0.0 0.0 0.0 positioned ~$(x) ~$(y) ~$(z) rotated $(yaw) 0 run function hpww:main/field_guide/gui/internal/session/step {session:$(session)}
