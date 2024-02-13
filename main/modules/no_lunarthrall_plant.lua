-- Remove items from basement
local items = {"lunarthrall_plant", "lunarthrall_plant_gestalt", "lunarthrall_plant_vine_end"}

for _, v in ipairs(items) do --
    AddPrefabPostInit(v, function(inst)
        if TheWorld.ismastersim then
            inst:DoPeriodicTask(1, function(inst)
                if inst:IsInBasement() then
                    inst:Remove()
                end
            end)
        end
    end)
end
