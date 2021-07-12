import InventorySlot from "../../helpers/InventoryHelper";

export interface InventoryState {
    slots: Array<any>,
    overlayLoot: any,
    overlayLootBox: Array<any>,
    lootId: string|null;
}
