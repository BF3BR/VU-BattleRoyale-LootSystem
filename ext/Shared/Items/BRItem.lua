require "__shared/Enums/ItemEnums"

class "BRItem"

function BRItem:__init(p_Id, p_Definition, p_Quantity)
    -- Unique Id for each item
    self.m_Id = p_Id ~= nil and p_Id or tostring(MathUtils:RandomGuid())

    -- Item's definition
    self.m_Definition = p_Definition

    -- Item's quantity
    self.m_Quantity = p_Quantity ~= nil and p_Quantity or 1
end

function BRItem:AsTable()
    local s_Table = {
        Id = self.m_Id,
        Type = self.m_Definition.m_Type,
        UId = self.m_Definition.m_UId,
    }

    if self.m_Definition.m_Stackable then
        s_Table.Quantity = self.m_Quantity
    end

    return s_Table
end

function BRItem:CreateFromTable(p_Table)
    if p_Table.Type == ItemType.Armor then
        return BRItemArmor:CreateFromTable(p_Table)
    elseif p_Table.Type == ItemType.Helmet then
        return BRItemHelmet:CreateFromTable(p_Table)
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
