--------------------------------------------------------------------------
--[[ all_season_farm_plant ]]
--------------------------------------------------------------------------
-- Configs
local enable_all_seasons_growth = GetModConfigData('enable_all_seasons_growth')
local enable_quick_grow = GetModConfigData('enable_quick_grow')
local enable_replant = GetModConfigData('enable_replant')
local enable_oversized_never_rotten = GetModConfigData('enable_oversized_never_rotten')
local always_oversized = GetModConfigData('always_oversized')
--------------------------------------------------------------------------
local PlantDefs = require("prefabs/farm_plant_defs").PLANT_DEFS
local all_seasons = {autumn = true, winter = true, spring = true, summer = true}
local State = {seed = true, sprout = true, small = true, med = true}

local function SetAllSeasonsGrowth(prefab)
    prefab.good_seasons = all_seasons
end

local function DoModification(prefab)
    AddPrefabPostInit(prefab, function(inst)
        -- QuickGrow and replant
        if inst.components.growable and inst.components.growable.stages then
            local stages = deepcopy(inst.components.growable.stages)

            if enable_quick_grow then
                for _, v in pairs(stages) do
                    if v.name and State[v.name] then
                        v.time = function(inst) return 0 end
                    end
                end
            end 

            -- Replant
            if enable_replant then
                local MakePickableFunc, _ = Waffles.FindUpvalue(stages[1].fn, "MakePickable")
                local _, index = Waffles.FindUpvalue(MakePickableFunc, "OnPicked")
                if index then
                    local function OnPicked(inst, doer)
                        local x, y, z = inst.Transform:GetWorldPosition()
                        if TheWorld.Map:GetTileAtPoint(x, y, z) == WORLD_TILES.FARMING_SOIL then
                            local soil = SpawnPrefab("farm_soil")
                            soil.Transform:SetPosition(x, y, z)
                            soil:PushEvent("breaksoil")
                        end
                    
                        local plant_name = "farm_plant_" .. inst.plant_def.product
                        local new_plant = SpawnPrefab(plant_name)
                        if new_plant ~= nil then
                            new_plant.Transform:SetPosition(inst.Transform:GetWorldPosition())
                        end
                    end
                    debug.setupvalue(MakePickableFunc, index, OnPicked)
                end  
            end

            -- growth
            if enable_oversized_never_rotten then
                local old_grow_fn = stages[6].fn
                local PlayStageAnimFunc, _ = Waffles.FindUpvalue(stages[6].fn, "PlayStageAnim")
                stages[6].fn = function(...)
                    old_grow_fn(...)
                    inst:RemoveTag("farm_plant_killjoy")
                    inst:RemoveTag("pickable_harvest_str")
                    -- Replace rotten with full anim
                    if PlayStageAnimFunc then
                        PlayStageAnimFunc(inst, inst.is_oversized and "oversized" or "full")
                    end
                end
            end

            inst.components.growable.stages = stages
            inst.force_oversized = true
            inst.components.growable:StartGrowing()
            inst.components.growable:Pause()
        end

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

        -- Remove stress
        if always_oversized then
            if inst.components.farmplantstress ~= nil then
                inst.components.farmplantstress.stressors = {}
                inst.components.farmplantstress.stressors_testfns = {}
                inst.components.farmplantstress.stressor_fns = {}
            end
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