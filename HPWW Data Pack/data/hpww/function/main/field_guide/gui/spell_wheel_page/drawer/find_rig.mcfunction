scoreboard players set #rig aj.id -1
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=item_display,tag=aj.fg_spell_wheel.root,tag=!hpww.fg.closing,distance=0..3]",function:"hpww:main/field_guide/gui/internal/capture_rig"}
execute if score #rig aj.id matches -1 run return fail
return 1
