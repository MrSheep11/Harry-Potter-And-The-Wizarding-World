# The Field Guide tick has already matched the player's nearby rig.
function #bs.view:as_aimed_entity {run:"function hpww:main/field_guide/gui/main_page/is_being_looked_at",with:{}}
execute as @e[type=interaction,tag=aj.field_guide_gui.interaction,distance=0..5,scores={hpww.interaction.is_being_looked_at=1..}] if score @s aj.id = #rig aj.id run function hpww:main/field_guide/gui/main_page/update_hover
