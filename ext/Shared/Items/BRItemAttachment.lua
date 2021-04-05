require "__shared/Items/BRItem"

local m_AttachmentDefinitions = require "__shared/Items/Definitions/BRItemAttachmentDefinition"

class("BRItemAttachment", BRItem)

function BRItemAttachment:__init(p_Uid, p_Definition)
    BRItem.__init(self, p_Uid, p_Definition)
end

function BRItemAttachment:AsTable()
    return BRItem.AsTable(self)
end

function BRItemAttachment:CreateFromTable(p_Table)
    return BRItemAttachment(p_Table.Uid, m_AttachmentDefinitions[p_Table.Name])
end

--==============================
-- Attachment related functions
--==============================
