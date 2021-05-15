import React from "react";

import { useDispatch } from "react-redux";
import { updateInventory } from "./store/inventory/Actions";

import Inventory from "./components/Inventory";

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
        </>
    );
};

export default App;

declare global {
    interface Window {
        SyncInventory: (p_DataJson: any) => void;
    }
}
