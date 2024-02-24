--------------------------------------------------------------------------
--[[ all_season_farm_plant ]]
--------------------------------------------------------------------------
-- Configs
local enable_all_seasons_growth = GetModConfigData('enable_all_seasons_growth')
--------------------------------------------------------------------------
local PlantDefs = require("prefabs/farm_plant_defs").PLANT_DEFS

local all_seasons = {autumn = true, winter = true, spring = true, summer = true}
local function SetAllSeasonsGrowth(prefab)
    prefab.good_seasons = all_seasons
end

local function DoModification(prefab)
    AddPrefabPostInit(prefab, function(inst)
        -- dig_up
        if inst.components.workable then
            local old_onfinish = inst.components.workable.onfinish
            inst.components.workable.onfinish = function(...)
                SpawnPrefab("farm_soil").Transform:SetPosition(inst.Transform:GetWorldPosition())
                old_onfinish(...)
            end
        end

        -- burnt
        if inst.components.burnable then
            local old_onburnt = inst.components.burnable.onburnt
            inst.components.burnable:SetOnBurntFn(function(...)
                SpawnPrefab("farm_soil").Transform:SetPosition(inst.Transform:GetWorldPosition())
                old_onburnt(...)
            end)
        end
    end)
end

for _, v in pairs(PlantDefs) do
    if v.prefab then
        if enable_all_seasons_growth then
            SetAllSeasonsGrowth(v)
        end
        if not v.is_randomseed then
            DoModification(v.prefab)
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