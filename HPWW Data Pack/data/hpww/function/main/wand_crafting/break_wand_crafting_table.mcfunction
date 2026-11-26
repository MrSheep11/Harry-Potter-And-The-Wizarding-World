execute unless entity @s[type=item_display,tag=hpww.wand_crafting_table_block] run return 0
tag @s remove hpww.wand_crafting_table_block
kill @s
loot spawn ~ ~0.5 ~ loot hpww:wand_crafting_table

kill @n[type=item, nbt={OnGround:0b, Age:0s, Item:{id:"minecraft:oak_planks"}}]

kill @n[type=armor_stand, tag=wand_crafting_table_detector]
