import { 
    InventoryActionTypes,
    UPDATE_INVENTORY,
} from "./ActionTypes";

export function updateInventory(slots: any[]): InventoryActionTypes {
    return {
        type: UPDATE_INVENTORY,
        payload: { slots },
    };
}
