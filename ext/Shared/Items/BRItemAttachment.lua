require "__shared/Items/BRItem"

local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"

class("BRItemAttachment", BRItem)

function BRItemAttachment:__init(p_Id, p_Definition, p_Quantity)
    BRItem.__init(self, p_Id, p_Definition, p_Quantity)
end

function BRItemAttachment:CreateFromTable(p_Table)
    return BRItemAttachment(p_Table.Id, m_AttachmentDefinitions[p_Table.Name], p_Table.Quantity)
end

--==============================
-- Attachment related functions
--==============================
