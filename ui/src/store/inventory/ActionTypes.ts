export const UPDATE_INVENTORY = "UPDATE_INVENTORY";
export const UPDATE_OVERLAY_LOOT = "UPDATE_OVERLAY_LOOT";
export const UPDATE_OVERLAY_LOOT_BOX = "UPDATE_OVERLAY_LOOT_BOX";

interface UpdateInventory {
    type: typeof UPDATE_INVENTORY;
    payload: { slots: any[] };
}

interface UpdateOverlayLoot {
    type: typeof UPDATE_OVERLAY_LOOT;
    payload: { overlayLoot: any };
}

interface UpdateOverlayLootBox {
    type: typeof UPDATE_OVERLAY_LOOT_BOX;
    payload: { lootId: string|null, items: any[] };
}

export type InventoryActionTypes = 
    | UpdateInventory
    | UpdateOverlayLoot
    | UpdateOverlayLootBox
;
