require "__shared/Enums/ItemEnums"
-- require "__shared/Items/BRItemArmor"
-- require "__shared/Items/BRItemConsumable"
-- require "__shared/Items/BRItemAmmo"
-- require "__shared/Items/BRItemAttachment"
-- require "__shared/Items/BRItemWeapon"

class "BRItem"

function BRItem:__init(p_Definition)
    -- Unique Id for each item
    -- TODO: Find a better solution for generating unique id for each item
    self.m_Id = MathUtils:RandomGuid()

    -- Item's definition
    self.m_Definition = p_Definition
end

function BRItem:FromTable(p_Table)
    return BRItem()
end

function BRItem:AsTable()
    return {
        Id = self.m_Id,
        Type = self.m_Definition.m_Type,
        Name = self.m_Definition.m_Name
    }
end

function BRItem:UpdateFromTable()
    -- TODO Do we need this?
end

function BRItem:CreateFromTable(p_Table)
    if self.m_Definition.m_Type == ItemType.Armor then
        return BRItemArmor:CreateFromTable(p_Table)
    elseif self.m_Definition.m_Type == ItemType.Consumable then
        return BRItemConsumable:CreateFromTable(p_Table)
    elseif self.m_Definition.m_Type == ItemType.Ammo then
        return BRItemAmmo:CreateFromTable(p_Table)
    elseif self.m_Definition.m_Type == ItemType.Attachment then
        return BRItemAttachment:CreateFromTable(p_Table)
    elseif self.m_Definition.m_Type == ItemType.Weapon then
        return BRItemWeapon:CreateFromTable(p_Table)
    end

    return nil
end
