--------------------------------------------------------------------------
--[[ Basement Map ]]
--------------------------------------------------------------------------
local BASEMENT_TILES = {}

local function GetInteriorTileCenterPoint(x, y, z)
	if z ~= nil then
		return math.floor((x + 2) / 4) * 4, 0, math.floor((z + 2) / 4) * 4
	end
end

local function GetInteriorTileKey(...)
	local x, y, z = GetInteriorTileCenterPoint(...)
	return x .. "_" .. z
end

Waffles.GetInteriorTileKey = GetInteriorTileKey

local function IsBasementAtPoint(map, x, y, z)
	return BASEMENT_TILES[GetInteriorTileKey(x, y, z)] ~= nil
end


local function IsPassableAtPoint(passable, map, ...)
	return passable or map:IsBasementAtPoint(...)
end

local function GetTileCenterPoint(pos, map, ...)
	if #pos == 0 then
		return GetInteriorTileCenterPoint(...)
	end
end

local TELEBASES

local function DisableCoveredTelebases()
	for telebase in pairs(TELEBASES) do
		if telebase:IsInBasement() then
			TELEBASES[telebase] = nil
		end
	end
end

AddPrefabPostInit("world", function(inst)
	TELEBASES = Waffles.GetUpvalue(_G.FindNearestActiveTelebase, "TELEBASES")
	Waffles.Parallel(_G, "FindNearestActiveTelebase", DisableCoveredTelebases)
end)

require "components/map"

Map.IsBasementAtPoint = IsBasementAtPoint
Waffles.Sequence(Map, "IsPassableAtPoint", IsPassableAtPoint)
Waffles.Sequence(Map, "IsAboveGroundAtPoint", IsPassableAtPoint)
if Map.IsVisualGroundAtPoint ~= nil then
	Waffles.Sequence(Map, "IsVisualGroundAtPoint", IsPassableAtPoint)
end
Waffles.Sequence(Map, "GetTileCenterPoint", GetTileCenterPoint, true)

function Waffles.AddSyntTile(x, y, z, source)
	if TheWorld.Map:GetTileAtPoint(x, y, z) == GROUND.INVALID then
		BASEMENT_TILES[GetInteriorTileKey(x, y, z)] = source or true
	end
end

function Waffles.RemoveSyntTile(...)
	BASEMENT_TILES[GetInteriorTileKey(...)] = nil
end

if not TheNet:GetIsServer() then
	function Waffles.ClearSyntTiles()
		BASEMENT_TILES = {}
	end
end

--------------------------------------------------------------------------
--[[ Basement entityscript ]]
--------------------------------------------------------------------------
require "entityscript"

if EntityScript.SetEventMute == nil then
	local EventMuter = require "eventmuter"
	Waffles.Branch(EntityScript, "PushEvent", EventMuter.PushEvent)
	EntityScript.SetEventMute = EventMuter.SetEventMute
end

function EntityScript:IsInBasement()
	return TheWorld.Map:IsBasementAtPoint(self:GetPosition():Get())
end

--------------------------------------------------------------------------
--[[ Basement Forbidden Recipes]]
--------------------------------------------------------------------------

local function recipe_testfn_nobasement(success, pt, rot)
	return success ~= false and not TheWorld.Map:IsBasementAtPoint(pt:Get()) 
end

local function MakeRecipeInvalidInBasement(name)
	local recipe = AllRecipes[name]
	if recipe ~= nil then
		Waffles.Sequence(recipe, "testfn", recipe_testfn_nobasement)
	end
end

MakeRecipeInvalidInBasement("pighouse")
MakeRecipeInvalidInBasement("rabbithouse")

local function ACTIONS_JUMPIN_strfn(str, act)
	return str or act.target and act.target:HasTag("stairs") and "USE" or nil
end

Waffles.Sequence(ACTIONS.JUMPIN, "strfn", ACTIONS_JUMPIN_strfn)

--------------------------------------------------------------------------
--[[ Basement Constants ]]
--------------------------------------------------------------------------
TUNING.BASEMENT =
{
    LIMIT = GetModConfigData("basement_limit"),
    PERISH = GetModConfigData("basement_no_perish"),
    RAPID_GROWTH = GetModConfigData('rapid_growth'),
    MULTIPLE_HARVEST = GetModConfigData('multiple_harvest'),
    ALL_SEASONS_GROWTH = GetModConfigData('all_seasons_growth'),
	CEILING_HEIGHT = 6,
	SANITYAURA = 10,
	REMAINS_LOOT_PERCENT = 1,
	SHADE = 0.5,
}

--------------------------------------------------------------------------
--[[ Basement i18n ]]
--------------------------------------------------------------------------
Waffles.Merge(STRINGS, require("lang/strings_basements"))

local lang = GetModConfigData("language", true)
if lang then
	Waffles.Merge(STRINGS, require("lang/strings_basements_" .. lang:upper()))
end

--------------------------------------------------------------------------
--[[ Basement StategraphState ]]
--------------------------------------------------------------------------

local ToggleOffPhysics, ToggleOnPhysics

AddStategraphState("wilson", State
{
	name = "jumpout_ceiling",
	tags = { "doing", "busy", "canrotate", "nointerrupt", "nopredict", "nomorph" },

	onenter = function(inst)
		ToggleOffPhysics(inst)
		inst.components.locomotor:Stop()
		
		inst.AnimState:PlayAnimation("jumpout")
		inst.AnimState:SetTime(0.2)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		inst.Physics:Teleport(x, 4, z)
		inst.Physics:SetMotorVel(5, -8, 0)
		
		Waffles.PushFakeShadow(inst, 1.3, 0.6)
		
		inst.AnimState:SetMultColour(0, 0, 0, 1)
		inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 10 * FRAMES)
	end,

	timeline =
	{
		TimeEvent(10 * FRAMES, function(inst)
			inst.Physics:SetMotorVel(2, -8, 0)
		end),
		
		TimeEvent(15 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("nointerrupt")
			inst.Physics:SetMotorVel(0, -8, 0)
		end),
		
		TimeEvent(16 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
		end),
		
		TimeEvent(17 * FRAMES, function(inst)
			inst.Physics:SetMotorVel(0, -8, 0)
		end),
	},

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.Physics:Stop()
				inst.sg:GoToState("idle")
			end
		end),
	},
	
	onexit = function(inst)
		ToggleOnPhysics(inst)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x, 0, z)
	end,
})

AddStategraphPostInit("wilson", function(sg)
	if ToggleOffPhysics == nil then
		ToggleOffPhysics = Waffles.GetUpvalue(sg.states.jumpout.onenter, "ToggleOffPhysics")
		ToggleOnPhysics = Waffles.GetUpvalue(sg.states.jumpout.onexit, "ToggleOnPhysics")
	end
	
	Waffles.Branch(sg.states.jumpin, "onenter", function(onenter, inst, data, ...)
		if Waffles.Browse(data, "teleporter") and data.teleporter:HasTag("stairs") then
			inst.sg:GoToState("jump_stairs", data)
		else
			onenter(inst, data)
		end
	end)
end)

AddStategraphState("wilson", State
{
	name = "jump_stairs",
	tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

	onenter = function(inst, data)
		ToggleOffPhysics(inst)
		inst.components.locomotor:Stop()
		
		inst.sg.statemem.target = data.teleporter
		inst.sg.statemem.teleportarrivestate = "jumpout"
		
		inst.AnimState:PlayAnimation("jump_pre")
		
		Waffles.PushFakeShadow(inst, 1.3, 0.6)
	end,

	timeline =
	{
		TimeEvent(5 * FRAMES, function(inst)
			inst.sg:AddStateTag("nointerrupt")
		
			inst.AnimState:PlayAnimation("jumpout")
			inst.AnimState:SetTime(0.15)
			inst.Physics:SetMotorVel(1 / inst.Transform:GetScale() * 4, 5, 0)
			
			if inst.components.inventory:IsHeavyLifting() then
				inst:PushEvent("encumberedwalking")
			end
		end),
		
		TimeEvent(16 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
		end),
		
		TimeEvent(20 * FRAMES, function(inst)
			inst.Physics:SetMotorVel(0, 0, 0)
			local turn = (math.random() < 0.5 and -1 or 1) * 90
			inst.Transform:SetRotation(inst.Transform:GetRotation() + turn)
			inst.AnimState:PushAnimation("jump_pre")
		end),
		
		TimeEvent(31 * FRAMES, function(inst)
			inst.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 6 * FRAMES)
		end),
		
		TimeEvent(33 * FRAMES, function(inst)
			inst.AnimState:PlayAnimation("jumpout")
			inst.AnimState:SetTime(0.15)
		end),
		
		TimeEvent(35 * FRAMES, function(inst)
			inst.Physics:SetMotorVel(1 / inst.Transform:GetScale() * 3, 6, 0)
		end),
		
		TimeEvent(41 * FRAMES, function(inst)
			inst.Physics:SetMotorVel(0, 0, 0)
			if inst.sg.statemem.target ~= nil
			and	inst.sg.statemem.target:IsValid()
			and	inst.sg.statemem.target.components.teleporter ~= nil then
				inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
				if inst.sg.statemem.target.components.teleporter:Activate(inst) then
					inst.sg.statemem.isteleporting = true
					inst.components.health:SetInvincible(true)
					if inst.components.playercontroller ~= nil then
						inst.components.playercontroller:Enable(false)
					end
					inst:Hide()
					inst.DynamicShadow:Enable(false)
					return
				end
			end
			inst.sg:GoToState("jumpout")
		end),
	},
	
	onexit = function(inst)
		inst.Physics:Stop()
		ToggleOnPhysics(inst)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x, 0, z)
		
		if inst.components.colourtweener:IsTweening() then
			inst.components.colourtweener:EndTween()
		end
		inst.AnimState:SetMultColour(1, 1, 1, 1)
		
		if inst.sg.statemem.isteleporting then
			inst.components.health:SetInvincible(false)
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:Enable(true)
			end
			inst:Show()
			inst.DynamicShadow:Enable(true)
		elseif inst.sg.statemem.target ~= nil
		and inst.sg.statemem.target:IsValid()
		and inst.sg.statemem.target.components.teleporter ~= nil then
			inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
		end
	end,
})

--------------------------------------------------------------------------
--[[ Telestaff ]]
--------------------------------------------------------------------------

local function TelestaffSpellRedirect(spell, inst, ...)
	if inst:IsInBasement() then
		if TheWorld:HasTag("cave") then
			TheWorld:PushEvent("ms_miniquake", { rad = 3, num = 5, duration = 1.5, target = inst })
		else
			SpawnPrefab("thunder_close")
		end
		if inst.components.finiteuses ~= nil then
			inst.components.finiteuses:Use(1)
		end
	else
		spell(inst, ...)
	end
end

AddPrefabPostInit("telestaff", function(inst)
	Waffles.Branch(inst.components.spellcaster, "spell", TelestaffSpellRedirect)
end)

if TheNet:GetIsServer() and not TheNet:IsDedicated() then
	Waffles.Sequence(EntityScript, "GetIsWet", function(iswet, self)
		if self:IsInBasement() then
			local replica = self.replica.inventoryitem or self.replica.moisture
			if replica ~= nil then
				return replica:IsWet()
			end
			return self:HasTag("wet")
		end
	end)
end

local function SpawnSinkholeRedirect(SpawnSinkhole, self, pt, ...)
	if TheWorld.Map:IsBasementAtPoint(pt.x, 0, pt.z) then
		local fx = SpawnPrefab("cavein_debris")
		fx.Transform:SetScale(1, 0.25 + math.random() * 0.07, 1)
		fx.Transform:SetPosition(pt.x, 0, pt.z)
	else
		SpawnSinkhole(self, pt, ...)
	end
end

AddComponentPostInit("sinkholespawner", function(self, inst)
	Waffles.Branch(self, "SpawnSinkhole", SpawnSinkholeRedirect)
end)

local function OverrideCaveinDebris(inst)
	if inst:IsInBasement() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local fx = SpawnPrefab("cavein_debris")
		fx.Transform:SetScale(1, 0.25 + math.random() * 0.07, 1)
		fx.Transform:SetPosition(x, 0, z)
		
		if inst:HasTag("FX") then
			inst:Hide()
		else
			inst:Remove()
		end
	end
end

AddPrefabPostInit("cavein_boulder", function(inst)
	inst:ListenForEvent("startfalling", OverrideCaveinDebris)
end)

AddPrefabPostInit("warningshadow", function(inst)
	StartThread(OverrideCaveinDebris, inst.GUID, inst)
end)

local function BedrollOnSleep(inst)
	if inst:IsInBasement() then
		local fn = Waffles.Browse(inst, "worldstatewatching", "phase", 1)
		if fn ~= nil then
			inst:StopWatchingWorldState("phase", fn)
		end
	end
end

local function BedrollPostInit(inst)
	Waffles.Parallel(inst.components.sleepingbag, "onsleep", BedrollOnSleep, true)
end

AddPrefabPostInit("bedroll_straw", BedrollPostInit)
AddPrefabPostInit("bedroll_furry", BedrollPostInit)

--------------------------------------------------------------------------
--[[ Basement World State ]]
--------------------------------------------------------------------------

local BASEMENT_WORLD_STATE =
{	
	DATA =
	{
		moisture = 0,
		moistureceil = 0,
		wetness	= 0,
		pop	= 0,
		snowlevel = 0,
		
		phase =	"day",
		cavephase =	"day",
		moonphase = "new",
		
		season = "autumn",
		iswinter = false,	
		isspring = false,
		issummer = false,
		isautumn = true,
		
		precipitation = "none",
		issnowing = false,
		issnowcovered = false,
		israining = false,
		iswet = false,
		
		isday = true,
		isdusk = false,
		isnight = false,
		iscaveday = true,
		iscavedusk = false,	
		iscavenight	= false,
	},
	
	STACK = 0,
	
	DWELLERS =
	{
		fireflies = true,
		pumpkin_lantern = true,
		mushroom_farm = true,
	},
}

Waffles.BasementWorldState = BASEMENT_WORLD_STATE

function Waffles.PushBasementWorldState()
	BASEMENT_WORLD_STATE.STACK = BASEMENT_WORLD_STATE.STACK + 1
	if BASEMENT_WORLD_STATE.STACK > 1 then
		return
	end
	local override = {}
	for k, v in pairs(TheWorld.state) do
		if BASEMENT_WORLD_STATE.DATA[k] ~= nil then
			override[k] = BASEMENT_WORLD_STATE.DATA[k]
		else
			override[k] = v
		end
	end

	Waffles.Replace(TheWorld, "state", override)
end

function Waffles.PopBasementWorldState()
	BASEMENT_WORLD_STATE.STACK = math.max(BASEMENT_WORLD_STATE.STACK - 1, 0)
	if BASEMENT_WORLD_STATE.STACK > 1 then
		return
	end
	Waffles.Replace(TheWorld, "state")
end

Waffles.Branch(_G, "SpawnSaveRecord", function(SpawnSaveRecord, saved, ...)
	if saved.prefab ~= nil
	and BASEMENT_WORLD_STATE.DWELLERS[saved.prefab]
	and TheWorld.Map:GetTileAtPoint(saved.x or 0, saved.y or 0, saved.z or 0) == GROUND.INVALID then
		Waffles.PushBasementWorldState()
		local inst = SpawnSaveRecord(saved, ...)
		Waffles.PopBasementWorldState()
		if inst ~= nil then
			inst.spawnedinbasement = true
		end
		return inst
	end
	return SpawnSaveRecord(saved, ...)
end)

AddStategraphPostInit("wilson", function(sg)
	local function GenericInBasementBranch(fn, inst, ...)
		if inst:IsInBasement() then
			Waffles.PushBasementWorldState()
			fn(inst)
			Waffles.PopBasementWorldState()
		else
			fn(inst)
		end
	end
	
	Waffles.Branch(sg.states.bedroll, "onenter", GenericInBasementBranch)
	Waffles.Branch(sg.states.bedroll.events.animqueueover, "fn", GenericInBasementBranch)
end)

--------------------------------------------------------------------------
--[[ Basement Plant ]]
--------------------------------------------------------------------------

-- Allow to plant
local old_CanPlantAtPoint = Map.CanPlantAtPoint
Map.CanPlantAtPoint = function(self,x,y,z,...)
    return old_CanPlantAtPoint(self,x,y,z,...) or TheWorld.Map:IsBasementAtPoint(x, y, z)
end

-- Allow to till soil
local old_CanTillSoilAtPoint = Map.CanTillSoilAtPoint
Map.CanTillSoilAtPoint = function(self, x, y, z,ignore_tile_type,...)
    if TheWorld.Map:IsBasementAtPoint(x, y, z) then
        return old_CanTillSoilAtPoint(self, x,y,z,true,...)
    else
        return old_CanTillSoilAtPoint(self, x,y,z,ignore_tile_type,...)
    end
end

-- Give nutrients to farm_soil
AddComponentPostInit("farming_manager", function(self, inst)
    if not TheWorld.ismastersim then
		return
	end
	local old_GetTileNutrients=self.GetTileNutrients
    self.GetTileNutrients=function(self,x,y,...)
        local tileInfo = GetTileInfo(TheWorld.Map:GetTile(x, y))
        if tileInfo == nil then
            return 100,100,100
        end
        return old_GetTileNutrients(self,x,y,...)
	end
end)

-- Enable farm_plow_item to be deployed in basement
local farm_soil_grid = GetModConfigData('farm_soil_grid')
local function item_ondeploy(inst, pt, deployer)
    local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())
    
    -- Deploy the num x num grid of farm soil
    local gridSize = farm_soil_grid or 3
    local offset = (gridSize - 1) * 1.25 / 2

    for dx = -offset, offset, 1.25 do
        for dz = -offset, offset, 1.25 do
            SpawnPrefab("farm_soil").Transform:SetPosition(cx + dx, cy, cz + dz)
        end
    end

	inst.components.finiteuses:Use(1)

    if inst:IsValid() then
        -- Save the item state, remove it, and then recreate it at the deployment location
        local saveRecord = inst:GetSaveRecord()
        inst:Remove()

        if saveRecord then
            local item = SpawnSaveRecord(saveRecord)
            item.Transform:SetPosition(cx, cy, cz)
        end
    end
end

AddPrefabPostInit("farm_plow_item", function(inst)
    local old_custom = inst._custom_candeploy_fn
    if old_custom then
        inst._custom_candeploy_fn = function(...)
            if inst:IsInBasement() then
                if farm_soil_grid then
                    return true
                else
                    return false
                end
            else
                return old_custom(...)
            end
        end
    end

    if not inst.components.deployable then
        inst:AddComponent("deployable")
    end

    local old_ondeploy = inst.components.deployable.ondeploy
    inst.components.deployable.ondeploy = function(inst, pt, deployer)
        if TheWorld.Map:IsBasementAtPoint(pt:Get()) then
            item_ondeploy(inst, pt, deployer)
        else
            old_ondeploy(inst, pt, deployer)
        end
    end
end)
