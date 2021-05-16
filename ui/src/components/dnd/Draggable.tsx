import React from 'react';
import { useDraggable } from '@dnd-kit/core';

export function Draggable(props: any) {
    const {attributes, listeners, setNodeRef, transform} = useDraggable({
        id: props.id,
        data: {
            currentSlot: props.currentSlot,
        },
    });
    
    return (
        <button ref={setNodeRef} {...listeners} {...attributes} className="draggable">
            {props.children}
        </button>
    );
}

export default Draggable;
