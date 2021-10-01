import React from "react";

import { useDispatch } from "react-redux";
import { updateCloseLootPickup, updateInventory, updateOverlayLoot } from "./store/inventory/Actions";

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

    window.SyncCloseLootPickupData = (p_DataJson: any) => {
        if (p_DataJson === null || p_DataJson.length === undefined) {
            dispatch(updateCloseLootPickup([]));
            return;
        }
        
        let tempData: any = [];
        p_DataJson.forEach((loot: any, key: number) => {
            if (loot.Items.length > 0) {
                loot.Items.forEach((item: any, key: number) => {
                    item.lootId = loot.Id;
                    tempData.push(item);
                });
            }
        });

        dispatch(updateCloseLootPickup(tempData));
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
        SyncCloseLootPickupData: (p_DataJson: any) => void;
    }
}
