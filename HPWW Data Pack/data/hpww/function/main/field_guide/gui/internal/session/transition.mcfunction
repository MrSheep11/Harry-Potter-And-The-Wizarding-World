# Wait for Animated Java to finish, including tweening. Never interrupt an opening.
$execute as @e[type=item_display,tag=hpww.fg.page_root,tag=!aj.$(project).animation.$(opening).playing,tag=!aj.$(project).animation.$(closing).playing,distance=..0.01] if score @s aj.id = #rig aj.id at @s run function hpww:main/field_guide/gui/internal/session/close_page {project:"$(project)",closing:"$(closing)"}
