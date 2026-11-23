# Read ownership before switching from the interaction to the actual clicker.
execute unless score @s hpww.api.UUID_Linked matches 1.. run return fail
scoreboard players operation #click hpww.api.UUID0 = @s hpww.api.UUID0
scoreboard players operation #click hpww.api.UUID1 = @s hpww.api.UUID1
scoreboard players operation #click hpww.api.UUID2 = @s hpww.api.UUID2
scoreboard players operation #click hpww.api.UUID3 = @s hpww.api.UUID3
scoreboard players operation #clicked_rig aj.id = @s aj.id
$execute on $(relation) if entity @s[type=player] if score @s hpww.fg.rig = #clicked_rig aj.id unless score @s hpww.fg.busy matches 1 if score @s spell_uuid_0 = #click hpww.api.UUID0 if score @s spell_uuid_1 = #click hpww.api.UUID1 if score @s spell_uuid_2 = #click hpww.api.UUID2 if score @s spell_uuid_3 = #click hpww.api.UUID3 at @s run $(command)
