import React from "react";

import { useDispatch } from "react-redux";
import { updateInventory, updateOverlayLoot, updateOverlayLootBox } from "./store/inventory/Actions";

import Inventory from "./components/Inventory";
import Overlay from "./components/Overlay";

import "./App.scss";

const App: React.FC = () => {
    const dispatch = useDispatch();

    window.SyncInventory = (p_DataJson: any) => {
        //console.log(p_DataJson);
        dispatch(updateInventory(p_DataJson));
    }

    window.SyncOverlayLoot = (p_DataJson: any) => {
        //console.log(p_DataJson);
        dispatch(updateOverlayLoot(p_DataJson));
    }

    window.SyncOverlayLootBox = (p_LootPickupId: string|null, p_DataJson: any) => {
        let data = p_DataJson;
        if (p_DataJson === null) {
            data = [];
        }
        dispatch(updateOverlayLootBox(p_LootPickupId, data));
    }

    return (
        <>
            <Inventory />
            <Overlay />
        </>
    );
};

export default App;

declare global {
    interface Window {
        SyncInventory: (p_DataJson: any) => void;
        SyncOverlayLoot: (p_DataJson: any) => void;
        SyncOverlayLootBox: (p_LootPickupId: string|null, p_DataJson: any) => void;
    }
}
