require "__shared/Enums/ItemEnums"

class "BRItem"

function BRItem:__init(p_Id, p_Definition)
    -- Unique Id for each item
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- Item's definition
    self.m_Definition = p_Definition
end

function BRItem:AsTable()
    return {
        Id = self.m_Id,
        Type = self.m_Definition.m_Type,
        Name = self.m_Definition.m_Name
    }
end

function BRItem:CreateFromTable(p_Table)
    if p_Table.Type == ItemType.Armor then
        return BRItemArmor:CreateFromTable(p_Table)
    elseif p_Table.Type == ItemType.Consumable then
        return BRItemConsumable:CreateFromTable(p_Table)
    elseif p_Table.Type == ItemType.Ammo then
        return BRItemAmmo:CreateFromTable(p_Table)
    elseif p_Table.Type == ItemType.Attachment then
        return BRItemAttachment:CreateFromTable(p_Table)
    elseif p_Table.Type == ItemType.Weapon then
        return BRItemWeapon:CreateFromTable(p_Table)
    end

    return nil
end
