import { 
    InventoryActionTypes,
    UPDATE_INVENTORY,
    UPDATE_OVERLAY_LOOT,
    UPDATE_OVERLAY_LOOT_BOX
} from "./ActionTypes";

export function updateInventory(slots: any[]): InventoryActionTypes {
    return {
        type: UPDATE_INVENTORY,
        payload: { slots },
    };
}

export function updateOverlayLoot(overlayLoot: any): InventoryActionTypes {
    return {
        type: UPDATE_OVERLAY_LOOT,
        payload: { overlayLoot },
    };
}

export function updateOverlayLootBox(lootId: string|null, items: any[]): InventoryActionTypes {
    return {
        type: UPDATE_OVERLAY_LOOT_BOX,
        payload: { lootId, items },
    };
}
