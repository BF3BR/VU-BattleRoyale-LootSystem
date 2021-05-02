import React from "react";
import Inventory from "./components/Inventory";

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

    return (
        <>
            <Inventory />
        </>
    );
};

export default App;

declare global {
    interface Window {

    }
}
