import React from "react";
import Inventory from "./components/Inventory";

import "./App.scss";

const App: React.FC = () => {

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
        /*dispatch(updatePlayerPosition({
            x: p_DataJson.x,
            y: p_DataJson.y,
            z: p_DataJson.z,
        }));*/
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
