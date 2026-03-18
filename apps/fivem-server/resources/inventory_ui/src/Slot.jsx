import React from "react";

export default function Slot({ item, slot }) {

    const handleDragStart = (e) => {
        e.dataTransfer.setData("slot", slot);
    };

    const handleDrop = (e) => {
        const from = e.dataTransfer.getData("slot");

        fetch(`https://${GetParentResourceName()}/moveItem`, {
            method: "POST",
            body: JSON.stringify({
                fromSlot: parseInt(from),
                toSlot: slot
            })
        });
    };

    return (
        <div
            className="slot"
            draggable
            onDragStart={handleDragStart}
            onDrop={handleDrop}
            onDragOver={(e) => e.preventDefault()}
        >
            {item && (
                <>
                    <img src={`icons/${item.name}.png`} />
                    <span>{item.count}</span>
                </>
            )}
        </div>
    );
}
