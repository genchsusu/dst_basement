-- Remove hound from basement
local items = {"hound", "firehound", "icehound", "mutatedhound", "moonhound", "houndcorpse", "clayhound", "warg",
             "claywarg", "gingerbreadwarg"}

table.insert(items, "snowpile") -- In order to be compatible with uncompromising
table.insert(items, "snowmong") -- In order to be compatible with uncompromising

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
