import React, { useEffect, useState } from "react";
import Inventory from "./Inventory";
import Shop from "./Shop";

export default function App() {
    const [inventory, setInventory] = useState([]);
    const [shop, setShop] = useState(null);

    useEffect(() => {
        window.addEventListener("message", (event) => {
            if (event.data.type === "updateInventory") {
                setInventory(event.data.data);
            }
            if (event.data.type === "openShop") {
                setShop(event.data.shop);
            }
        });
    }, []);

    return (
        <div className="app">
            {shop ? (
                <Shop shop={shop} shopId={Object.keys(shop)[0]} />
            ) : (
                <Inventory items={inventory} />
            )}
        </div>
    );
}
