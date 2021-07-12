require "__shared/Enums/ItemEnums"

class "BRItemDefinition"

function BRItemDefinition:__init()
    self.m_UId = nil
    self.m_Name = "Unnamed item"
    self.m_Description = ""
    self.m_Type = ItemType.Default
    self.m_Weight = 0.0
    self.m_Stackable = false
    self.m_MaxStack = nil
    self.m_Price = 0
    self.m_Mesh = nil
    self.m_Transform = LinearTransform(
        Vec3(1, 0, 0),
        Vec3(0, 1, 0),
        Vec3(0, 0, 1),
        Vec3(0, 0, 0)
    )
    self.m_HasAction = false
    self.m_UIIcon = nil
end

function BRItemDefinition:GetDefinitionId()
    return string.format("%s:%s", self.m_Type, self.m_UId)
end

function BRItemDefinition:Equals(p_Other)
    return self:GetDefinitionId() == p_Other:GetDefinitionId()
end
