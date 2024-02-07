require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lavaarena_portal_fx.zip")
}

local function PlayWallAnimation(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	x = math.floor(x)
	z = math.floor(z)
				
	local q1 = 4
	local q2 = 7
	local i = (((x % q1) * (x + 3) % q2) + ((z % q1) * (z + 3) % q2)) % 3 + 1
	
	inst.AnimState:PlayAnimation("full" .. (i == 1 and "A" or i == 2 and "B" or "C"))
end

local function updatewallplacer(inst)	
	local x, y, z = TheWorld.Map:GetTileCenterPoint(inst.Transform:GetWorldPosition())
	
	for i, v in ipairs(Waffles.CreatePositions("4x4", true, true)) do		
		local part = inst.parts[i]
		part.Transform:SetPosition(x + v.x + 0.5, 0, z + v.z + 0.5)
		PlayWallAnimation(part)
	end
	
	for i, v in ipairs(Waffles.CreatePositions("20x20", true, true, 4)) do
		local grid = inst.gridparts[i]
		local x, y, z = x + v.x + 2, 0, z + v.z + 2
		if TheWorld.Map:IsBasementAtPoint(x, y, z) then
			grid.Transform:SetPosition(x, y, z)
			grid.AnimState:SetScale(1, 1)
		else
			grid.AnimState:SetScale(0, 0)
		end
	end
end

local function onremovewallplacer(inst)
	for i, v in ipairs(inst.parts) do
		v:Remove()
	end
	for i, v in ipairs(inst.gridparts) do
		v:Remove()
	end
end

local function wallplacerdecor(inst)	
	inst.parts = {}		
	for i, v in ipairs(Waffles.CreatePositions("4x4", true, true)) do		
		local part = SpawnPrefab("wall_stone_item_placer")
		part.AnimState:OverrideMultColour(0, 0, 0, 0.5)
		part.AnimState:SetHaunted(true)
        inst.components.placer:LinkEntity(part)
		table.insert(inst.parts, part)
	end
	
	inst.gridparts = {}	
	for i, v in ipairs(Waffles.CreatePositions("20x20", true, true, 4)) do
		local grid = SpawnPrefab("gridplacer")
        inst.components.placer:LinkEntity(grid)
		table.insert(inst.gridparts, grid)
	end
	
	inst.components.placer.onupdatetransform = updatewallplacer
		
	inst:ListenForEvent("onremove", onremovewallplacer)
end

local GUNPOWDER_WINDUP_TIME = 0.8

local function OnFuseUpdate(inst)	
	inst.AnimState:OverrideShade(0.5 + math.random() * 0.5)
	inst.AnimState:SetScale(1 + math.random() * -0.08, 1 + math.random() * 0.08)
	if inst.Light ~= nil then
		inst.AnimState:SetAddColour(0.4 + math.random() * 0.2, 0.1, 0.1, 1)
		inst.Light:SetIntensity(0.65 + math.random() * 0.08)
		inst.Light:SetColour(1, math.random() * 0.4, 0)
		inst.Light:SetRadius(1 + math.random() * 0.15)
	end
end

local function DoErupt(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 20, nil, { "epic", "INLIMBO" }, { "_combat", "locomotor" })) do
		if v ~= inst and v.entity:IsVisible() and not (v.components.health ~= nil and v.components.health:IsDead()) then
			v:PushEvent("epicscare", { scarer = inst, duration = 4 })
		end
	end
	
	ShakeAllCameras(CAMERASHAKE.VERTICAL, 4, 0.01, 0.2, inst, 40)
end

local function WarnPlayersAboutCollapse(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 20, { "player" })) do
		if v.components.talker ~= nil then
			v.components.talker:Say(GetString(v, "ANNOUNCE_ANTLION_SINKHOLE"))
		end
	end
end

local function OnInit(inst)
	inst.components.burnable:StartWildfire()
	inst.components.propagator:StartSpreading()
	
	inst.ember = SpawnPrefab("gunpowder_ember_fx")
	inst.ember:ListenForEvent("onremove", function() inst.ember:KillFX() end, inst)
	inst.ember.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
	inst:DoPeriodicTask(2, DoErupt, GUNPOWDER_WINDUP_TIME)
	inst:DoPeriodicTask(TUNING.ATRIUM_GATE_DESTABILIZE_WARNING_TIME, WarnPlayersAboutCollapse, GUNPOWDER_WINDUP_TIME)
end

local function GetBasement(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	return TheSim:FindEntities(x, 0, z, 70, { "basement_part", "basement_core" })[1]
end

local function FallToPieces(burnable)
	Waffles.DespawnRecipe(burnable.inst, math.max(0.1, 1 - burnable.inst:GetTimeAlive() / 90))
end

local function DespawnBasement(inst)
	local basement = GetBasement(inst)
	
	inst:Remove()
	
	if basement ~= nil then
		basement:Remove()
	end
end

local function gunpowder()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddLight()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .5)
	
	inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(1, 0.3, 0)
    inst.Light:SetFalloff(.5)
    inst.Light:SetRadius(1)
	inst.Light:EnableClientModulation(true)

	inst.AnimState:SetBank("gunpowder")
	inst.AnimState:SetBuild("gunpowder")
	inst.AnimState:PlayAnimation("idle")
	
	inst.Transform:SetScale(1.25, 1.25, 1.25)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
	inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "miniearthquake")
		
	inst:SetPrefabNameOverride("gunpowder")
	
	if not TheNet:IsDedicated() then
		inst:DoPeriodicTask(2 * FRAMES, OnFuseUpdate, GUNPOWDER_WINDUP_TIME)
	end
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 115
	
	inst:AddComponent("unevenground")
    inst.components.unevenground.radius = 6
						
	MakeSmallPropagator(inst)
	inst.components.propagator.flashpoint = math.huge
		
	MakeSmallBurnable(inst)
	inst.components.burnable.canlight = false
	Waffles.Parallel(inst.components.burnable, "SmotherSmolder", FallToPieces)
		
	inst:DoTaskInTime(0, OnInit)
			
	inst.OnEntitySleep = DespawnBasement
	
	inst.persists = false
	
	return inst
end

local function DoEmit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	for k = 1, math.random(4) do
		SpawnPrefab("basement_explosion_particle"):StartFX("torchfire_rag", x, y, z, 3)
	end
	inst:DoTaskInTime(math.random() * 1.5, DoEmit)
end

local function KillFX(inst)
	inst.AnimState:PlayAnimation("portal_pst")
	inst:ListenForEvent("animover", inst.Remove)
end

local function ember()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBuild("lavaarena_portal_fx")
    inst.AnimState:SetBank("lavaportal_fx")
	inst.AnimState:HideSymbol("black")
	inst.AnimState:HideSymbol("vortex_loop")
	--inst.AnimState:OverrideMultColour(0, 0, 0, 1)
    inst.AnimState:PlayAnimation("portal_pre")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(1)
		
	inst:AddTag("FX")
	
	if not TheNet:IsDedicated() then		
		inst:DoTaskInTime(GUNPOWDER_WINDUP_TIME, DoEmit)
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.AnimState:PushAnimation("portal_loop")
	
	inst.KillFX = KillFX

	inst.persists = false

	return inst
end

local function placerember()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst.AnimState:SetBuild("lavaarena_portal_fx")
    inst.AnimState:SetBank("lavaportal_fx")
	inst.AnimState:HideSymbol("black")
	inst.AnimState:HideSymbol("vortex_loop")
	inst.AnimState:SetScale(0.6, 0.6)
	inst.AnimState:SetLightOverride(1)
	inst.AnimState:OverrideMultColour(0.33, 0.33, 0, 1)
	inst.AnimState:SetPercent("portal_loop", 0.95)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(1)
		
	inst:AddTag("CLASSIFIED")
	inst:AddTag("NOCLICK")
	inst:AddTag("placer")
	--[[Non-networked entity]]
	inst.entity:SetCanSleep(false)
	inst.persists = false

	return inst
end

local function gunpowderplacerdecor(inst)		
	inst.AnimState:Pause()
	inst.AnimState:OverrideMultColour(0.75, 0.75, 0, 1)
	
	OnFuseUpdate(inst)
	
	inst.components.placer:LinkEntity(inst:SpawnChild("basement_upgrade_gunpowder_placer_fx"))
end

local function PushUpgrade(inst, cb, ...)
	local basement = GetBasement(inst)
	if basement ~= nil then
		basement:PushEvent("onupgrade", { source = inst, cb = cb, arg = { ... } })
	end
end

local TOBYTE =
{
	rocky = 1,
	wood = 2,
	checker = 3,
}

local function applyrebuildupgrade(inst, source)
	local sx, sy, sz = source.Transform:GetWorldPosition()
	local ix, iy, iz = inst.Transform:GetWorldPosition()
	inst:SetBasementTile(sx - ix, sz - iz, false, nil, true)
end

local function applyfloorupgrade(inst, source, anim, isrocky)	
	inst.state.isrocky:set(not not isrocky)
	inst.state.flooring:set(TOBYTE[anim])
end

local UPGRADE_DATA =
{
	wall =
	{
		type = "rebuild",
		arg = { applyrebuildupgrade },
		placer = { "gunpowder", "gunpowder", "idle", nil, nil, nil, 0, nil, nil, wallplacerdecor },
	},
	
	floor_1 =
	{
		type = "floor",
		arg = { applyfloorupgrade, "rocky", true },
	},
	
	floor_2 =
	{
		type = "floor",
		arg = { applyfloorupgrade, "wood", false },
	},
	
	floor_3 =
	{
		type = "floor",
		arg = { applyfloorupgrade, "checker", true },
	},
}

local function OnBuiltFn(inst)	
	PushUpgrade(inst, unpack(UPGRADE_DATA[inst.prefab:gsub("basement_upgrade_", "")].arg))
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	
	inst:AddTag("CLASSIFIED")
	
	--[[Non-networked entity]]
	inst.persists = false
	
	--Auto-remove if not spawned by builder
	inst:DoTaskInTime(0, inst.Remove)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.OnBuiltFn = OnBuiltFn
	
	return inst
end

local upgrades = {}
for name, data in pairs(UPGRADE_DATA) do
	local prefab = "basement_upgrade_" .. name
	table.insert(upgrades, Prefab(prefab, fn))
	if data.placer ~= nil then
		table.insert(upgrades, MakePlacer(prefab .. "_placer", unpack(data.placer)))
	end
end

return Prefab("basement_upgrade_gunpowder", gunpowder),
	MakePlacer("basement_upgrade_gunpowder_placer", "gunpowder", "gunpowder", "idle", nil, nil, nil, 1.25, nil, nil, gunpowderplacerdecor),
	Prefab("gunpowder_ember_fx", ember, assets),
	Prefab("basement_upgrade_gunpowder_placer_fx", placerember, assets),
	unpack(upgrades)