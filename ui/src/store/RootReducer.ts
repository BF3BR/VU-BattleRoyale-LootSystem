
import { combineReducers } from "redux";
import InventoryReducer from "./inventory/Reducer";

export const RootReducer = combineReducers({
    InventoryReducer,
});

export type RootState = ReturnType<typeof RootReducer>;
