# The caller is the owner, and the execution position and facing are the session anchor.
scoreboard players operation #previous aj.id = aj.last_id aj.id
$execute rotated ~$(yaw) 0 run function aj:$(project)/summon {args:{}}
execute unless score aj.last_id aj.id > #previous aj.id run return fail
scoreboard players operation #opening_rig aj.id = aj.last_id aj.id
scoreboard players operation @s hpww.fg.rig = #opening_rig aj.id

tag @s add hpww.api.uuid_selector.linker
execute as @e[tag=aj.global.entity] if score @s aj.id = #opening_rig aj.id run function hpww:main/spells/function/api/uuid_selector/internal/link_to_tagged_player
tag @s remove hpww.api.uuid_selector.linker
$execute as @e[type=item_display,tag=aj.$(project).root,distance=..0.01] if score @s aj.id = #opening_rig aj.id run tag @s add hpww.fg.page_root

function hpww:main/field_guide/gui/internal/clear_page_state
scoreboard players set @s SettingsMenuStatus 1
scoreboard players reset @s hpww.fg.busy
$execute if data storage hpww:field_guide pages."$(page)"{page:"main"} at @s run function hpww:main/field_guide/gui/internal/on_open_main
$execute if data storage hpww:field_guide pages."$(page)"{page:"spell_wheel"} at @s run function hpww:main/field_guide/gui/spell_wheel_page/init
return 1
