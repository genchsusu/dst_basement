--------------------------------------------------------------------------
--[[ Add TechTree ]]
--------------------------------------------------------------------------
local TechTree = require("techtree")
TechTree.Create = function(t)
    t = t or {}
    for _, v in ipairs(TechTree.AVAILABLE_TECH) do
        t[v] = t[v] or 0
    end
    return t
end

table.insert(TechTree.AVAILABLE_TECH, "BASEMENT_TECH")
table.insert(TechTree.BONUS_TECH, "BASEMENT_TECH")
TECH.NONE.BASEMENT_TECH = 0
TECH.BASEMENT_TECH_ONE = { BASEMENT_TECH = 1 }

TUNING.PROTOTYPER_TREES.BASEMENT_TECH = TechTree.Create({
    BASEMENT_TECH = 1
})
for _, v in pairs(AllRecipes) do
    if v.level.BASEMENT_TECH == nil then
        v.level.BASEMENT_TECH = 0
    end
end

--------------------------------------------------------------------------
--[[ Add Recipe TAB ]]
--------------------------------------------------------------------------
local BASEMENT_TAB = {
    {
        filter_def = {
            name = "BASEMENT",
            atlas = "images/inventoryimages/basement.xml",
            image = "basement.tex",
            image_size = 64,
            custom_pos = nil,
            recipes = nil
        }
    }, 
    {
        prototyper_prefab = "basement_exit",
        data = {
            icon_atlas = "images/inventoryimages/basement.xml",
            icon_image = "basement.tex",
            is_crafting_station = true
        }
    }
}

for _, data in pairs(BASEMENT_TAB) do
    if data.filter_def then
        AddRecipeFilter(data.filter_def, data.sort)
    end
    if data.prototyper_prefab then
        AddPrototyperDef(data.prototyper_prefab,data.data)
    end
end

--------------------------------------------------------------------------
--[[ Add Recipe ]]
--------------------------------------------------------------------------
local blockedtiles = {
    ["8_12"] = true,
    ["8_8"] = true,
    ["12_8"] = true,
    ["12_12"] = true
}

local function walltestfn(pt, rot)
    local tx, ty, tz = TheWorld.Map:GetTileCenterPoint(pt.x, 0, pt.z)
    local basement = TheSim:FindEntities(pt.x, 0, pt.z, 70, {"basement_part", "basement_core"})[1]
    if basement == nil then
        return false
    else
        local bx, by, bz = TheWorld.Map:GetTileCenterPoint(basement.Transform:GetWorldPosition())
        if blockedtiles[Waffles.GetInteriorTileKey(bx - tx, 0, bz - tz)] then
            return false
        end
    end
    local pttile = Waffles.GetInteriorTileKey(pt.x, 0, pt.z)
    for i, v in ipairs(TheSim:FindEntities(tx, 0, tz, 3, nil,
        {"NOBLOCK", "FX", "INLIMBO", "DECOR", "player", "basement_part"})) do
        if Waffles.GetInteriorTileKey(v.Transform:GetWorldPosition()) == pttile then
            return false
        end
    end
    return true
end

local BASEMENT_Recipes = {
    {
        name = "basement_entrance_builder",
        ingredients = loadstring(GetModConfigData("recipe_ingredients"))(),
        level = TECH.NONE,
        config = {
            atlas = "images/inventoryimages/basement.xml",
            image = "basement.tex",
            testfn = function(pt, rot)
                if #TheSim:FindEntities(pt.x, 0, pt.z, 36, {"basement_part"}) > 0 then
                    return false
                end
                for x = -2.51, 2.51, 5.02 do
                    for z = -2.51, 2.51, 5.02 do
                        if not TheWorld.Map:IsPassableAtPoint(pt.x + x, 0, pt.z + z, false, true) and
                            (Point(TheWorld.Map:GetTileCenterPoint(pt.x, 0, pt.z)) ~= pt or
                                not TheWorld.Map:IsVisualGroundAtPoint(pt.x, 0, pt.z)) then
                            return false
                        end
                    end
                end
                return true
            end,
            min_spacing = 4,
            placer = "basement_entrance_placer"
        },
        filters = {"BASEMENT"}
    },
    {
        name = "basement_upgrade_wall",
        ingredients = {
            Ingredient("cutstone", 2), 
            Ingredient("nitre", 4)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            tag = "basement_upgradeuser",
            placer = "basement_upgrade_wall_placer",
            min_spacing = 0,
            atlas = "images/inventoryimages.xml",
            image = "wall_stone_item.tex",
            testfn = walltestfn
        },
        filters = {"BASEMENT"},
    },
    {
        name = "basement_upgrade_floor_1",
        ingredients = {
            Ingredient("cutstone", 2), 
            Ingredient("flint", 2)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            tag = "basement_upgradeuser",
            atlas = "images/inventoryimages.xml",
            image = "turf_rocky.tex",
        },
        filters = {"BASEMENT"},
    },
    {
        name = "basement_upgrade_floor_1",
        ingredients = {
            Ingredient("cutstone", 2), 
            Ingredient("flint", 2)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            tag = "basement_upgradeuser",
            atlas = "images/inventoryimages.xml",
            image = "turf_rocky.tex",
        },
        filters = {"BASEMENT"},
    },
    {
        name = "basement_upgrade_floor_2",
        ingredients = {
            Ingredient("boards", 4), 
            Ingredient("flint", 4)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            tag = "basement_upgradeuser",
            atlas = "images/inventoryimages.xml",
            image = "turf_woodfloor.tex",
        },
        filters = {"BASEMENT"},
        descoverride = "turf_woodfloor",
    },
    {
        name = "basement_upgrade_floor_3",
        ingredients = {
            Ingredient("marble", 4), 
            Ingredient("silk", 6)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            tag = "basement_upgradeuser",
            atlas = "images/inventoryimages.xml",
            image = "turf_checkerfloor.tex",
        },
        filters = {"BASEMENT"},
        descoverride = "turf_checkerfloor",
    },
    {
        name = "basement_upgrade_gunpowder",
        ingredients = {
            Ingredient("gunpowder", 3), 
            Ingredient("nitre", 6)
        },
        level = TECH.BASEMENT_TECH_ONE,
        config = {
            placer = "basement_upgrade_gunpowder_placer",
            min_spacing = 3.7,
            tag = "basement_upgradeuser_owner",
            atlas = "images/inventoryimages.xml",
            image = "gunpowder.tex",
        },
        filters = {"BASEMENT"},
    }
}

for _, data in pairs(BASEMENT_Recipes) do
    AddRecipe2(data.name, data.ingredients, data.level, data.config, data.filters)
    if data.descoverride ~= nil then
        STRINGS.RECIPE_DESC[data.name:upper()] = STRINGS.RECIPE_DESC[data.descoverride:upper()]
    end
end
