require "__shared/Enums/ItemEnums"
local BRItemAmmoDefinition = require "ext.Shared.Items.Definitions.BRItemAmmoDefinition"

class "BRItemDefinition"

function BRItemDefinition:__init()
    self.m_Name = "Unnamed item"
    self.m_Description = ""
    self.m_Type = ItemType.Default
    self.m_Weight = 0.0
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0
    self.m_Mesh = nil
    self.m_HasAction = false
    self.m_UIIcon = nil
end

function BRItemDefinition:GetDefinitionId()
    return string.format("%s:%s", self.m_Type, self.m_Name)
end

function BRItemDefinition:Equals(p_Other)
    return self:GetDefinitionId() == p_Other:GetDefinitionId()
end
