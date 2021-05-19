import React from "react";
import { Tooltip } from "react-lightweight-tooltip";

const InventoryTooltip: React.FC<any> = ({ children, content }) => {
    return (
        <Tooltip
            content={content}
            styles={{
                wrapper: {
                    position: 'relative' as 'relative',
                    display: "flex",
                    zIndex: 98,
                    width: "100%",
                    margin: "0",
                },
                tooltip: {
                    background: "#000",
                    position: 'absolute' as 'absolute',
                    zIndex: 99,
                    top: "0",
                    bottom: "auto",
                    left: 'calc(100% + .5vw)',
                    marginBottom: '0',
                    padding: '1vw',
                    textAlign: "left",
                    transform: "none",
                    minWidth: "10vw",
                    maxWidth: "10vw",
                    pointerEvents: "none",
                },
                content: {
                    background: "transparent",
                    color: '#fff',
                    fontSize: '.85vw',
                    textAlign: "left",
                    display: "flex",
                    flexFlow: "column",
                    padding: "0",
                },
                arrow: {
                    position: 'absolute' as 'absolute',
                    width: '0',
                    height: '0',
                    bottom: 'auto',
                    top: "1vw",
                    left: '0',
                    marginLeft: '-1vw',
                    borderLeft: 'solid transparent .5vw',
                    borderRight: '0.5vw solid rgb(0, 0, 0)',
                    borderTop: 'solid transparent .5vw',
                    borderBottom: 'solid transparent .5vw',
                },
                gap: {
                    display: "none",
                },
            }}
        >
            {children}
        </Tooltip>
    );
}

export default InventoryTooltip;
