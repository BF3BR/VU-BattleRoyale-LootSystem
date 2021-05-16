import React from 'react';
import { useDroppable } from '@dnd-kit/core';

export function Droppable(props: any) {
    const { setNodeRef, isOver } = useDroppable({
        id: props.id.toString(),
    });

    return (
        <div ref={setNodeRef} className={"item-slot " + (props?.type !== undefined ? props.type : "") + " " + (isOver ? "isOver" : "")}>
            {props.children??""}
        </div>
    );
}

export default Droppable;
