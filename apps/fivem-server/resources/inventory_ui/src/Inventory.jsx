import React from "react";
import Slot from "./Slot";

export default function Inventory({ items }) {
    const slots = Array.from({ length: 20 });

    return (
        <div className="inventory">
            {slots.map((_, i) => (
                <Slot key={i} item={items[i]} slot={i} />
            ))}
        </div>
    );
}
