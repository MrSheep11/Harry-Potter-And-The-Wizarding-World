# Run as the owner. Filter by UUID before removing every anchor, including old duplicates.
scoreboard players set @s SettingsMenuStatus 0
function hpww:main/field_guide/gui/internal/clear_page_state
advancement revoke @s only hpww:blocks/main_wand/right_click_settings_button

function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=item_display,tag=hpww.fg.page_root,tag=!hpww.fg.closing]",function:"hpww:main/field_guide/gui/internal/close_root"}
# Existing worlds may have roots left from before pages were registered.
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=item_display,tag=aj.fg_spell_wheel.root,tag=!hpww.fg.page_root,tag=!hpww.fg.closing]",function:"hpww:main/field_guide/gui/internal/close_root"}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=item_display,tag=aj.field_guide_gui.root,tag=!hpww.fg.page_root,tag=!hpww.fg.closing]",function:"hpww:main/field_guide/gui/internal/close_root"}
function hpww:main/spells/function/api/uuid_selector/api/as_at_linked_entities {entities:"@e[type=marker,tag=hpww.fg_marker_binded]",function:"hpww:main/field_guide/gui/kill_marker"}
