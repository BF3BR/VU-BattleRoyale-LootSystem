import React from "react";

import { useDispatch } from "react-redux";
import { updateInventory } from "./store/inventory/Actions";

import Inventory from "./components/Inventory";
import LootOverlay from "./components/LootOverlay";

import "./App.scss";

const App: React.FC = () => {
    const dispatch = useDispatch();

    /*
    * Debug
    */
    let debugMode: boolean = false;
    if (!navigator.userAgent.includes('VeniceUnleashed')) {
        if (window.location.ancestorOrigins === undefined || window.location.ancestorOrigins[0] !== 'webui://main') {
            debugMode = true;
        }
    }

    window.SyncInventory = (p_DataJson: any) => {
        dispatch(updateInventory(p_DataJson));
        console.log(p_DataJson);
    }

    return (
        <>
            <Inventory />
            {/*<LootOverlay 
                loot={{
                    AmmoName: "5.56mm",
                    Description: "The AK-74M is the latest modernized version of the classic AK-47.",
                    Id: "825A4C3E-925F-4823-9A99-3E8DDDDB8B70",
                    Name: "AK-74M",
                    Price: 0,
                    Quantity: 1,
                    Tier: 3,
                    Type: 2,
                    UIIcon: "UI/Art/Persistence/Weapons/Fancy/ak74m",
                    UId: "weapon-ak74m",
                }}
            />
            <LootOverlay
                loot={{
                    Description: "A large medkit, it's gonna refill 50% of your health.",
                    Id: "C5318A9E-BCC7-8152-E2F3-8B9C733787EB",
                    Name: "Large Medkit",
                    Price: 0,
                    Quantity: 1,
                    TimeToApply: 5,
                    Type: 5,
                    UIIcon: "UI/Art/Persistence/KitItem/Fancy/medkit",
                    UId: "consumable-large-medkit",
                }}
            />*/}
        </>
    );
};

export default App;

declare global {
    interface Window {
        SyncInventory: (p_DataJson: any) => void;
    }
}
