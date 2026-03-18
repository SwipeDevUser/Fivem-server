import React from "react";

export default function Hotbar({ items }) {
    return (
        <div className="hotbar">
            {items.slice(0, 5).map((item, i) => (
                <div key={i} className="hotbar-slot">
                    {item?.name}
                </div>
            ))}
        </div>
    );
}
