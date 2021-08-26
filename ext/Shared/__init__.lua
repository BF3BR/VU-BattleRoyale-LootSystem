class "VuBattleRoyaleLootSystemShared"

require "__shared/Enums/Attachments"

require "__shared/Utils/Logger"

require "__shared/Utils/PostReloadEvent"

function VuBattleRoyaleLootSystemShared:__init()
    -- TODO: Move this to the main BR mod
    Events:Subscribe("Level:LoadResources", function()
        ResourceManager:MountSuperBundle("spchunks")
        ResourceManager:MountSuperBundle("levels/coop_003/coop_003")
    end)
    
    -- TODO: Move this to the main BR mod
    Hooks:Install("ResourceManager:LoadBundles", 100, function(hook, bundles, compartment)
        if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
            bundles = {
                bundles[1],
                "levels/coop_003/coop_003",
                "levels/coop_003/ab03_parent",
            }
            hook:Pass(bundles, compartment)
        end
    end)
end

return VuBattleRoyaleLootSystemShared()
