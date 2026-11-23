function hpww:main/spells/function/api/uuid_selector/api/check_uuid {entity:"@e[type=item_display,tag=aj.fg_spell_wheel.bone.exit,limit=1,sort=nearest]"}
execute unless score @s hpww.api.UUID_Selector matches 1 run return fail

function hpww:main/field_guide/api/close
