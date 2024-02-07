-- Init utils
modimport("scripts/waffles")
-- PrefabFiles
table.insert(PrefabFiles, "basement")
table.insert(PrefabFiles, "basement_upgrades")
table.insert(PrefabFiles, "basement_explosion")
table.insert(PrefabFiles, "fakedynamicshadow")
table.insert(PrefabFiles, "sparkle_fx")
if TheNet:GetIsServer() then
	table.insert(PrefabFiles, "basement_debug")
end
-- Assets
table.insert(Assets, Asset("ATLAS", "images/inventoryimages/basement.xml"))
-- MiniMap icon
AddMinimapAtlas("images/inventoryimages/basement.xml")



modimport("main/basement")
modimport("main/tech")
-- modules
modimport("main/modules/farm_plant")
modimport("main/modules/no_hound")
modimport("main/modules/no_witherable")
