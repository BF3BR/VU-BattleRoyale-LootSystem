import { InventoryState } from "./Types";
import InventorySlot from "../../helpers/InventoryHelper";
import { 
    InventoryActionTypes,
    UPDATE_INVENTORY
} from "./ActionTypes";

const initialState: InventoryState = {
    slots: [],
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
        default:
            return state;
    }
};

export default InventoryReducer;
