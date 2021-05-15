ClientCommands = 
{
    errInvalidCommand = "Invalid command",

    Give = function(p_Args)
        -- If we have any arguments, ignore them
        if #p_Args == 0 then
            return ClientCommands.errInvalidCommand
        end

        -- Get the local player
        local s_LocalPlayer = PlayerManager:GetLocalPlayer()
        if s_LocalPlayer == nil then
            return ClientCommands.errInvalidCommand
        end

        -- Check to see if the player is alive
        if s_LocalPlayer.alive == false then
            return ClientCommands.errInvalidCommand
        end

        -- Get the local soldier instance
        local s_LocalSoldier = s_LocalPlayer.soldier
        if s_LocalSoldier == nil then
            return ClientCommands.errInvalidCommand
        end

        NetEvents:Send(InventoryNetEvent.InventoryGiveCommand, p_Args)

        return "Item given."        
    end,
}
