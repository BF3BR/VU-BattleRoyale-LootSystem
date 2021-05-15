import React from 'react';
import { useDroppable } from '@dnd-kit/core';

export function Droppable(props: any) {
    const {setNodeRef} = useDroppable({
        id: props.id,
    });
        
    const style = {
        //background: active ? 'green' : 'red',
    };

    return (
        <div ref={setNodeRef} style={style} className={"item-slot " + props.type??""}>
            {props.children??""}
        </div>
    );
}

export default Droppable;
