import React, { useEffect, useState } from "react";

import { connect } from "react-redux";
import { RootState } from "../store/RootReducer";

import { DndContext, DragOverlay } from '@dnd-kit/core';
import { Draggable } from './dnd/Draggable';
import { Droppable } from './dnd/Droppable';

import InventorySlot, { InventoryItem } from "../helpers/InventoryHelper";

import "./Inventory.scss";
import { sendToLua } from "../Helpers";

interface StateFromReducer {
    slots: any
}

type Props = StateFromReducer;

const Inventory: React.FC<Props> = ({
    slots
}) => {
    const [isHoldingCtrl, setIsHoldingCtrl] = useState<boolean>(false);

    const [splitModal, setSplitModal] = useState({
        id: null,
        show: false,
        maxQuantity: 60,
        value: 30,
    });

    const handleUserKeyDown = (event: any) => {
        if (event.keyCode === 17) {
            setIsHoldingCtrl(true);
        }
    }

    const handleUserKeyUp = (event: any) => {
        if (event.keyCode === 17) {
            setIsHoldingCtrl(false);
        }
    }

    useEffect(() => {
        document.addEventListener('keydown', handleUserKeyDown);
        document.addEventListener('keyup', handleUserKeyUp);

        return () => {
            document.removeEventListener('keydown', handleUserKeyDown);
            document.removeEventListener('keyup', handleUserKeyUp);
        };
    });

    const [isDragging, setIsDragging] = useState<any>(null);

    function handleDragStart(event: any) {
        const { active } = event;
        setIsDragging(active.data.current.currentSlot);
    }

    function handleDragEnd(event: any) {
        const { active, over } = event;
        setIsDragging(null);

        if (over !== null) {
            const slot = over.id;
            if (active.data.current.currentSlot.toString() !== slot) {
                if (slot === "item-drop") {
                    sendToLua('WebUI:DropItem', JSON.stringify({ item: active.id, quantity: slots[active.data.current.currentSlot].Quantity }));
                } else if(slot === "item-drop-split") {
                    if (slots[active.data.current.currentSlot].Quantity > 1) {
                        setSplitModal({
                            id: active.id,
                            show: true,
                            maxQuantity: slots[active.data.current.currentSlot].Quantity,
                            value: Math.floor(slots[active.data.current.currentSlot].Quantity / 2),
                        });
                    } else {
                        sendToLua('WebUI:DropItem', JSON.stringify({ item: active.id, quantity: slots[active.data.current.currentSlot].Quantity }));
                    }
                } else {
                    sendToLua('WebUI:MoveItem', JSON.stringify({ item: active.id, slot: slot }));
                }
            }
        }
    }

    const handleChange = (event: any) => {
        setSplitModal(prevState => ({
            id: prevState.id,
            show: prevState.show,
            maxQuantity: prevState.maxQuantity,
            value: event.target.value,
        }));
    }

    const getSlotItem = (slot: any, key: number) => {
        if (slot === undefined || slot === null || Object.keys(slot).length === 0) {
            return <>
                {getEmptySlot(key)}
            </>
        }

        return (
            <Draggable id={slot.Id} currentSlot={key}>
                <div>
                    {getSlotDrag(slot)}
                </div>
            </Draggable>
        )
    }

    const getSlotDrag = (slot: any) => {
        return (
            <>
                {slot.UIIcon !== null &&
                    <img src={"fb://" + slot.UIIcon} />
                }
                <div className="information">
                <span className="name">{slot.Name ?? ""}</span>
                    {slot.Quantity > 1 &&
                        <span className="count">{slot.Quantity ?? 1}</span>
                    }
                    <span className="ammoType">{slot.AmmoName ?? "-"}</span>
                    {(slot.CurrentDurability !== undefined && slot.Durability !== undefined) &&
                        <div className="progressWrapper">
                            <div className="progress" style={{ height: (slot.CurrentDurability / slot.Durability * 100) + "%" }}></div>
                        </div>
                    }
                </div>
                {slot.Tier !== undefined &&
                    <span className="weaponTier">
                        {slot.Tier === 1 &&
                            <img src="fb://UI/Art/Persistence/Ranks/Rank001" />
                        }
                        {slot.Tier === 2 &&
                            <img src="fb://UI/Art/Persistence/Ranks/Rank002" />
                        }
                        {slot.Tier === 3 &&
                            <img src="fb://UI/Art/Persistence/Ranks/Rank003" />
                        }
                    </span>
                }
            </>
        )
    }

    const getEmptySlot = (key: number) => {
        switch (key) {
            case 0:
                return (
                    <div className="empty-slot">
                        Primary Weapon
                    </div>
                );
            case 4:
                return (
                    <div className="empty-slot">
                        Secondary Weapon
                    </div>
                );
            case 1:
            case 5:
                return (
                    <div className="empty-slot">
                        Optics
                    </div>
                );
            case 2:
            case 6:
                return (
                    <div className="empty-slot">
                        Barrel
                    </div>
                );
            case 3:
            case 7:
                return (
                    <div className="empty-slot">
                        Other
                    </div>
                );
            case 8:
                return (
                    <div className="empty-slot">
                        Armor
                    </div>
                );
            case 9:
                return (
                    <div className="empty-slot">
                        Helmet
                    </div>
                );
            case 10:
                return (
                    <div className="empty-slot">
                        Gadget
                    </div>
                );
            default:
                return (
                    <div className="empty-slot">
                        Empty
                    </div>
                );
        }
    }

    return (
        <>
            <div className={"split-modal " + (splitModal.show?"show":"")}>
                <div className="split-modal-inner">

                    <div className="range-grid">
                        <button 
                            onClick={() => setSplitModal(prevState => ({
                                id: prevState.id,
                                show: prevState.show,
                                maxQuantity: prevState.maxQuantity,
                                value: 1,
                            }))}
                        >
                            MIN
                        </button>
                        <div>
                            <input 
                                type="range" 
                                min={1} 
                                max={splitModal.maxQuantity} 
                                value={splitModal.value} 
                                className="slider" 
                                id="myRange"
                                step={1}
                                onChange={handleChange}
                            />
                        </div>
                        <button 
                            onClick={() => setSplitModal(prevState => ({
                                id: prevState.id,
                                show: prevState.show,
                                maxQuantity: prevState.maxQuantity,
                                value: splitModal.maxQuantity,
                            }))}
                        >
                            MAX
                        </button>
                    </div>
                    <h1>{splitModal.value??0}</h1>
                    <div className="button-grid">
                        <button onClick={() => setSplitModal(prevState => ({
                            id: null,
                            show: false,
                            maxQuantity: prevState.maxQuantity,
                            value: prevState.value,
                        }))}>
                            Cancel
                        </button>
                        <button onClick={() => {
                            setSplitModal(prevState => ({
                                id: null,
                                show: false,
                                maxQuantity: prevState.maxQuantity,
                                value: prevState.value,
                            }));
                            sendToLua('WebUI:DropItem', JSON.stringify({ item: splitModal.id, quantity: splitModal.value }));
                        }}>
                            Drop
                        </button>
                    </div>
                </div>
            </div>
            <DndContext onDragEnd={handleDragEnd} onDragStart={handleDragStart}>
                <div id="Inventory" className="open">
                    <div className="InventoryWrapper">
                        <div className="card PrimaryWeaponBox">
                            <div className="card-header">
                                <h1>
                                    Primary Weapon
                                </h1>
                            </div>
                            <div className="card-content weapon-grid">
                                <Droppable id={0} type="weapon-slot">
                                    {getSlotItem(slots[0], 0)}
                                </Droppable>
                                <Droppable id={1}>
                                    {getSlotItem(slots[1], 1)}
                                </Droppable>
                                <Droppable id={2}>
                                    {getSlotItem(slots[2], 2)}
                                </Droppable>
                                <Droppable id={3}>
                                    {getSlotItem(slots[3], 3)}
                                </Droppable>
                            </div>
                        </div>

                        <div className="card SecondaryWeaponBox">
                            <div className="card-header">
                                <h1>
                                    Secondary Weapon - {JSON.stringify(isHoldingCtrl)}
                                </h1>
                            </div>
                            <div className="card-content weapon-grid">
                                <Droppable id={4} type="weapon-slot">
                                    {getSlotItem(slots[4], 4)}
                                </Droppable>
                                <Droppable id={5}>
                                    {getSlotItem(slots[5], 5)}
                                </Droppable>
                                <Droppable id={6}>
                                    {getSlotItem(slots[6], 6)}
                                </Droppable>
                                <Droppable id={7}>
                                    {getSlotItem(slots[7], 7)}
                                </Droppable>
                            </div>
                        </div>

                        <div className="gear-grid">
                            <div className="card">
                                <div className="card-header">
                                    <h1>
                                        Helmet
                                    </h1>
                                </div>
                                <div className="card-content">
                                    <Droppable id={9}>
                                        {getSlotItem(slots[9], 9)}
                                    </Droppable>
                                </div>
                            </div>
                            <div className="card">
                                <div className="card-header">
                                    <h1>
                                        Armor
                                    </h1>
                                </div>
                                <div className="card-content">
                                    <Droppable id={8}>
                                        {getSlotItem(slots[8], 8)}
                                    </Droppable>
                                </div>
                            </div>
                            <div className="card">
                                <div className="card-header">
                                    <h1>
                                        Gadget
                                    </h1>
                                </div>
                                <div className="card-content">
                                    <Droppable id={10}>
                                        {getSlotItem(slots[10], 10)}
                                    </Droppable>
                                </div>
                            </div>
                        </div>

                        <div className="card BackpackBox">
                            <div className="card-header">
                                <h1>
                                    Backpack
                                </h1>
                            </div>
                            <div className="card-content backpack-grid">
                                {slots.map((slot: any, key: number) => (
                                    <React.Fragment key={key}>
                                        {key >= 11 &&
                                            <Droppable key={key} id={key}>
                                                {getSlotItem(slots[key], key)}
                                            </Droppable>
                                        }
                                    </React.Fragment>
                                ))}
                            </div>
                        </div>
                    </div>
                    <div className="itemDrop">
                        <Droppable id="item-drop"></Droppable>
                        <Droppable id="item-drop-split"></Droppable>
                    </div>
                </div>
                <DragOverlay 
                    dropAnimation={null}
                    adjustScale={false}
                    style={{
                        background: "red",
                    }}
                >
                    {isDragging !== null && 
                        <div className="dragoverlay-object">
                            {getSlotDrag(slots[isDragging])}
                        </div>
                    }
                </DragOverlay>
            </DndContext>
        </>
    );
};

const mapStateToProps = (state: RootState) => {
    return {
        // InventoryReducer
        slots: state.InventoryReducer.slots,
    };
}
const mapDispatchToProps = (dispatch: any) => {
    return {};
}
export default connect(mapStateToProps, mapDispatchToProps)(Inventory);
