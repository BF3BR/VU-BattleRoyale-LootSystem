import { InventoryState } from "./Types";
import { 
    InventoryActionTypes,
    UPDATE_INVENTORY,
    UPDATE_OVERLAY_LOOT,
    UPDATE_OVERLAY_LOOT_BOX
} from "./ActionTypes";

const initialState: InventoryState = {
    slots: [],
    overlayLoot: null,
    overlayLootBox: [],
    lootId: null,
};

const InventoryReducer = (
    state = initialState,
    action: InventoryActionTypes
): InventoryState => {
    switch (action.type) {
        case UPDATE_INVENTORY:
            return {
                ...state,
                slots: action.payload.slots,
            };
        case UPDATE_OVERLAY_LOOT:
            return {
                ...state,
                overlayLoot: action.payload.overlayLoot,
            };
        case UPDATE_OVERLAY_LOOT_BOX:
            return {
                ...state,
                overlayLootBox: action.payload.items,
                lootId: action.payload.lootId,
            };
        default:
            return state;
    }
};

export default InventoryReducer;
