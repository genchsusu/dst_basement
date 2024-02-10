-- Remove items from basement
local items = {"hound", "firehound", "icehound", "mutatedhound", "moonhound", "houndcorpse", "clayhound", "warg",
             "claywarg", "gingerbreadwarg"}

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
