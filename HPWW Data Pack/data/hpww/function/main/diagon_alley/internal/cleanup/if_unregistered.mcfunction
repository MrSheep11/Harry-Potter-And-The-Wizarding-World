# Check AJ's saved root registration, so a temporarily unloaded root still owns its hitboxes.
$execute unless data storage animated_java:data "$(rig)".data.root_uuid run kill @s
