local function OnSaveDebugPoint(inst, data)
	data.entrance_pos = inst.entrance_pos
end

local function OnLoadDebugPoint(inst, data)
	inst.entrance_pos = data and data.entrance_pos
end

local function ReturnPlayersToLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local pos = inst.entrance_pos or { 0, 0, 0 }
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 70, { "player" })) do
		if TheWorld.Map:IsPassableAtPoint(v.Transform:GetWorldPosition()) then
			print(string.format("[Basement Debug Player Rescuer @(%s, %s, %s)] Removing itself because a new basement is built nearby.", x, y, z))
			inst:Remove()
			return
		else
			v.Transform:SetPosition(unpack(pos))
		end
	end
end

local function playerrescuer()
	local inst = CreateEntity()
		
	inst.entity:AddTransform()
	
	inst:AddTag("basement_part")
	inst:AddTag("basement_debug_playerrescuer")
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", inst.Remove)
	
	inst.OnSave = OnSaveDebugPoint
	inst.OnLoad = OnLoadDebugPoint
	inst.OnEntityWake = ReturnPlayersToLand
	
	return inst
end

local function UpdateDebugLight(inst, phase)
	if phase == "night" then
		inst:DoTaskInTime(3, inst.Remove)
	else
		local parent = inst.entity:GetParent()
		if TheWorld.basement_debug_lighting == nil
		or parent and parent:IsInBasement() then
			inst:Remove()
		end
	end
end

local function ClearTrace(inst)
	local parent = inst.entity:GetParent()
	if parent ~= nil then
		parent._debuglight = nil
	end
end

local function light()
	local inst = CreateEntity()
	
	inst.persists = false
	
	inst.entity:AddTransform()
	inst.entity:AddLight()
	
	inst.Light:SetRadius(0.5)
	inst.Light:SetIntensity(1)
	inst.Light:SetFalloff(1)
	inst.Light:SetColour(1, 1, 1)
	inst.Light:Enable(true)
		
	inst:AddTag("CLASSIFIED")
	inst:AddTag("basement_part")
		
	inst:WatchWorldState("phase", UpdateDebugLight)
	inst:DoPeriodicTask(0, UpdateDebugLight)
	inst:ListenForEvent("onremove", ClearTrace)
		
	return inst
end

local function GetLightningStrikeRedirectPosition(inst)
	local entrance = Waffles.Browse(inst, "parent", "basement", "entrance")
	local offset = Point(math.random() * 15, 0, math.random() * 15)
	return Waffles.Valid(entrance) and (entrance:GetPosition() + offset) or offset
end

local function lightningrod()
	local inst = CreateEntity()
	
	inst.persists = false
	
	inst.entity:AddTransform()
	
	inst:AddTag("basement_part")
	inst:AddTag("lightningrod")
		
	inst.GetPosition = GetLightningStrikeRedirectPosition
			
	return inst
end

return Prefab("basement_debug_playerrescuer", playerrescuer),
	Prefab("basement_debug_light", light),
	Prefab("basement_debug_lightningrod", lightningrod)