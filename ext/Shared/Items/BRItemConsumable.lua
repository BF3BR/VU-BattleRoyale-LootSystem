require "__shared/Items/BRItem"
require "__shared/Utils/Timers"

local m_ConsumableDefinitions = require "__shared/Items/Definitions/BRItemConsumableDefinition"
local m_Logger = Logger("BRItemConsumable", true)

class("BRItemConsumable", BRItem)

function BRItemConsumable:__init(p_Id, p_Definition, p_Quantity)
    BRItem.__init(self, p_Id, p_Definition, p_Quantity)

    self.m_Timer = nil
end

function BRItemConsumable:CreateFromTable(p_Table)
    return BRItemConsumable(p_Table.Id, m_ConsumableDefinitions[p_Table.UId], p_Table.Quantity)
end

--==============================
-- Consumable related functions
--==============================

function BRItemConsumable:Use()
    -- check if already using this item
    if self.m_Timer ~= nil then
        return
    end

    -- start timer for the action
    self.m_Timer = g_Timers:Timeout(self.m_Definition.m_TimeToApply, self, self.OnComplete)

    -- inform player that the action started
    self:SendNetEvent("BRItemConsumable:ActionStarted")
end

function BRItemConsumable:OnCancel()
    -- check if item is not in use
    if self.m_Timer == nil then
        return
    end

    -- destroy timer
    self.m_Timer:Destroy()

    -- inform player that the action was canceled
    self:SendNetEvent("BRItemConsumable:ActionCanceled")
end

function BRItemConsumable:OnComplete()
    -- check if item is not in use
    if self.m_Timer == nil then
        return
    end

    -- execute action and reduce item's quantity
    self:ApplyAction()
    self.m_Quantity = self.m_Quantity - 1

    -- inform player that the action was completed
    self:SendNetEvent("BRItemConsumable:ActionCompleted")

    -- destroy item if needed
    if self.m_Quantity < 1 then
        Events:DispatchLocal("BRItem:DestroyItem", self.m_Id)
    end
end

function BRItemConsumable:ApplyAction()
    local s_Player = self:GetParentPlayer()
    if s_Player == nil or s_Player.soldier == nil then
        return
    end

    -- update player's health
    s_Player.soldier.health = math.min(100, s_Player.soldier.health + self.m_Definition.m_HealthToRegen)
end

function BRItemConsumable:SendNetEvent(p_Name)
    -- get player and spectators
    local s_Receivers = {}

    -- TODO add player (owner)
    -- TODO add spectators

    -- check for any receivers
    if #s_Receivers < 1 then
        return
    end

    -- send event to each receiver
    for _, l_Receiver in ipairs(s_Receivers) do
        NetEvents:SendToLocal(p_Name, l_Receiver, self.m_Id)
    end
end

function BRItemConsumable:Destroy()
    -- Destroy timer
    if self.m_Timer ~= nil then
        self.m_Timer:Destroy()
        self.m_Timer = nil
    end
end
