--------------------------------------------------------------------------
--[[ all_season_farm_plant ]]
--------------------------------------------------------------------------
-- Configs
local enable_all_seasons_growth = GetModConfigData('enable_all_seasons_growth')
--------------------------------------------------------------------------
local PlantDefs = require("prefabs/farm_plant_defs").PLANT_DEFS

local all_seasons = {autumn = true, winter = true, spring = true, summer = true}
for _, v in pairs(PlantDefs) do
    if v.prefab then
        if enable_all_seasons_growth then
            v.good_seasons = all_seasons
        end
    end
end

-- Remove defender
TUNING.FARM_PLANT_DEFENDER_SEARCH_DIST = 0

-- Remove useless
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
for _, v in pairs(WEED_DEFS) do
    if not v.data_only then --allow mods to skip our prefab constructor.
        AddPrefabPostInit(v.prefab, function (inst)
            if TheWorld.ismastersim then
                inst:ListenForEvent("on_planted", function (inst,data)
                    if data.in_soil then
                        SpawnAt("farm_soil",inst:GetPosition())
                    end
                    inst:Remove()
                end)
            end
        end)
    end
end