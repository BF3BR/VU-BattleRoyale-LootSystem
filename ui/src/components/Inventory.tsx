import React, { useState } from "react";


import { connect } from "react-redux";
import { RootState } from "../store/RootReducer";

import { DndContext } from '@dnd-kit/core';
import { Draggable } from './dnd/Draggable';
import { Droppable } from './dnd/Droppable';

import InventorySlot, { InventoryItem } from "../helpers/InventoryHelper";

import skull from "../assets/img/skull.svg";
import dummyweapon from "../assets/img/dummyweapon.png";

import "./Inventory.scss";

interface StateFromReducer {
    /*primaryWeapon: {
        weaponSlot: InventorySlot,
        attachmentSlot1: InventorySlot,
        attachmentSlot2: InventorySlot,
        attachmentSlot3: InventorySlot,
    },
    secondaryWeapon: {
        weaponSlot: InventorySlot,
        attachmentSlot1: InventorySlot,
        attachmentSlot2: InventorySlot,
        attachmentSlot3: InventorySlot,
    },
    backpack: Array<InventorySlot>,
    ammo: Array<InventorySlot>,*/
    slots: any
}

type Props = StateFromReducer;

const Inventory: React.FC<Props> = ({
    slots
}) => {
    //const [parent, setParent] = useState(null);

    function handleDragEnd(event: any) {
        const { active, over } = event;

        console.log(over);
        
        if (over && 
            (over.data.current.accepts !== undefined && over.data.current.accepts.includes(active.data.current.type)) && 
            (over.data.current.item === undefined || over.data.current.item?.id !== active.id)
        ) {
            alert("ok");
        }
    }

    const getSlotItem = (slot: any) => {
        if (slot === undefined || slot === null || Object.keys(slot).length === 0) {
            return <></>
        }

        return (
            <Draggable id={slot.Id}>
                {slot.UIIcon !== null &&
                    <img src={"fb://" + slot.UIIcon} />
                }
                <span className="name">{slot.Name??""}</span>
                <span className="count">{slot.Quantity??1}</span>
                <span className="ammoType">{"TODO: 5.56mm"}</span>
            </Draggable>
        )
    }

    return (
        <>
            <DndContext onDragEnd={handleDragEnd}>
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
                                    {getSlotItem(slots[0])}
                                </Droppable>
                                <Droppable id={1}>
                                    {getSlotItem(slots[1])}
                                </Droppable>
                                <Droppable id={2}>
                                    {getSlotItem(slots[2])}
                                </Droppable>
                                <Droppable id={3}>
                                    {getSlotItem(slots[3])}
                                </Droppable>
                            </div>
                        </div>

                        <div className="card SecondaryWeaponBox">
                            <div className="card-header">
                                <h1>
                                    Secondary Weapon
                                </h1>
                            </div>
                            <div className="card-content weapon-grid">
                                <Droppable id={4} type="weapon-slot">
                                    {getSlotItem(slots[4])}
                                </Droppable>
                                <Droppable id={5}>
                                    {getSlotItem(slots[5])}
                                </Droppable>
                                <Droppable id={6}>
                                    {getSlotItem(slots[6])}
                                </Droppable>
                                <Droppable id={7}>
                                    {getSlotItem(slots[7])}
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
                                        {getSlotItem(slots[9])}
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
                                        {getSlotItem(slots[8])}
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
                                        {getSlotItem(slots[10])}
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
                                                {getSlotItem(slots[key])}
                                            </Droppable>
                                        }
                                    </React.Fragment>
                                ))}
                                {/*<div className="item-holder">
                                    <img src={skull} />
                                    <span className="count">60</span>
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                    <span className="count">120</span>
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>
                                <div className="item-holder">
                                    <img src={skull} />
                                </div>*/}
                                {/*parent === null ? draggableMarkup : null*/}

                                {/*backpack.map((inventorySlot: InventorySlot) => (
                                    <Droppable 
                                        key={inventorySlot.id} 
                                        id={inventorySlot.id}
                                        accepts={inventorySlot.accepts}
                                        item={inventorySlot.item}
                                    >
                                        {/*inventorySlot.item ? draggableItem(inventorySlot.item) : 'Empty'
                                    </Droppable>
                                ))*/}
                            </div>
                        </div>
                    </div>
                    <div className="itemDrop">
                        <Droppable id="item-drop"></Droppable>
                    </div>
                </div>
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
