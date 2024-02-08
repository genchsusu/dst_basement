require "prefabutil"
local assets =
{
    Asset("ANIM", "anim/oasis_tile.zip"),
    Asset("ANIM", "anim/splash.zip"),
    Asset("MINIMAP_IMAGE", "oasis"),
}

local prefabs =
{
    "pondfish",
}

local function OnDig(inst)
    inst:Remove()
end

local function placerdecor(parent)		
	local inst = CreateEntity()

	inst:AddTag("CLASSIFIED")
	inst:AddTag("NOCLICK")
	inst:AddTag("placer")
	--[[Non-networked entity]]
	inst.entity:SetCanSleep(false)
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("oasis_tile")
	inst.AnimState:SetBuild("oasis_tile")
	inst.AnimState:PlayAnimation("idle_closed")
	inst.AnimState:SetLightOverride(1)

	inst.entity:SetParent(parent.entity)
	parent.components.placer:LinkEntity(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.Transform:SetRotation(45)

    MakeObstaclePhysics(inst, 6)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)

    inst.AnimState:SetBuild("oasis_tile")
    inst.AnimState:SetBank("oasis_tile")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(-3)

    inst.MiniMapEntity:SetIcon("oasis.png")

    inst:AddTag("structure")
    inst:AddTag("watersource")
    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("allow_casting")

    if not TheNet:IsDedicated() then
        inst:AddComponent("pointofinterest")
        inst.components.pointofinterest:SetHeight(320)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst.entity:AddLight()
    inst.Light:SetRadius(2.5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)
    inst.Light:Enable(true)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(OnDig)
    inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("fishable")
    inst.components.fishable.maxfish = TUNING.OASISLAKE_MAX_FISH
    inst.components.fishable:SetRespawnTime(TUNING.OASISLAKE_FISH_RESPAWN_TIME / 10)
    inst.components.fishable:SetGetFishFn(function() return "pondfish" end)
    inst.components.fishable:Unfreeze()

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("watersource")
    inst.components.watersource.available = true

    return inst
end

return Prefab("basement_lake", fn, assets, prefabs),
    MakePlacer("basement_lake_placer", "oasis_tile", "oasis_tile", "idle", nil, nil, nil, nil, nil, nil, placerdecor)