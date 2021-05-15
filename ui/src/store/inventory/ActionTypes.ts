export const UPDATE_INVENTORY = "UPDATE_INVENTORY";

interface UpdateInventory {
    type: typeof UPDATE_INVENTORY;
    payload: { slots: any[] };
}

export type InventoryActionTypes = 
    | UpdateInventory
;
