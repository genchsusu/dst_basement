-- Init utils
modimport("scripts/waffles")
-- PrefabFiles
table.insert(PrefabFiles, "basement")
table.insert(PrefabFiles, "basement_upgrades")
table.insert(PrefabFiles, "basement_explosion")
table.insert(PrefabFiles, "fakedynamicshadow")
table.insert(PrefabFiles, "sparkle_fx")
table.insert(PrefabFiles, "basement_lake")
if TheNet:GetIsServer() then
	table.insert(PrefabFiles, "basement_debug")
end
-- Assets
table.insert(Assets, Asset("ATLAS", "images/inventoryimages/lake.xml"))
table.insert(Assets, Asset("ATLAS", "images/inventoryimages/basement.xml"))
-- MiniMap icon
AddMinimapAtlas("images/inventoryimages/basement.xml")



modimport("main/basement")
modimport("main/tech")
-- modules
modimport("main/modules/farm_plant")

-- Compatibility
-- For uncompromising
local uncompromising = "workshop-2039181790"
if Waffles.IsModLoaded(uncompromising) then
    print("Basements: Uncompromising detected, applying compatibility")
    modimport("main/modules/uncompromising")
end