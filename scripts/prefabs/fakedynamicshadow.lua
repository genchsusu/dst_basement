local function RemoveFakeDynamicShadow(target)
	if Waffles.Valid(target.dynamicshadowfake) then
		target.dynamicshadowfake:Remove()
	end
	target.dynamicshadowfake = nil
	target.DynamicShadow:Enable(true)
	
	target:RemoveEventCallback("newstate", RemoveFakeDynamicShadow)
end

local function UpdateShadow(params)
	while Waffles.Valid(params.target) do
		local x, y, z = params.target.Transform:GetWorldPosition()
		params.inst.Transform:SetPosition(x, 0, z)
			
		Yield()
	end	
	params.inst:Remove()
end

local function StartFX(inst, target, ...)
	RemoveFakeDynamicShadow(target)
	target.dynamicshadowfake = inst
	target:ListenForEvent("newstate", RemoveFakeDynamicShadow)
	
	target.DynamicShadow:Enable(false)
	inst.DynamicShadow:SetSize(...)
	
	StartThread(UpdateShadow, inst.GUID, { inst = inst, target = target })
end

local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
		
	inst:AddTag("FX")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
	
	inst.StartFX = StartFX
	
	return inst
end

return Prefab("fakedynamicshadow", fn)