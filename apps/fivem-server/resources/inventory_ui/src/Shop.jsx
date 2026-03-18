import React, { useState } from "react";

export default function Shop({ shop, shopId }) {
    const [cart, setCart] = useState([]);
    const [stage, setStage] = useState("browse"); // browse, register, receipt

    if (!shop) return null;

    function addToCart(item) {
        const existing = cart.find(i => i.name === item.name);
        
        if (existing) {
            setCart(cart.map(i => 
                i.name === item.name ? { ...i, quantity: i.quantity + 1 } : i
            ));
        } else {
            setCart([...cart, { ...item, quantity: 1 }]);
        }
    }

    function removeFromCart(itemName) {
        setCart(cart.filter(i => i.name !== itemName));
    }

    function updateQuantity(itemName, quantity) {
        if (quantity <= 0) {
            removeFromCart(itemName);
        } else {
            setCart(cart.map(i =>
                i.name === itemName ? { ...i, quantity } : i
            ));
        }
    }

    function getTotal() {
        return cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    }

    function checkout() {
        const cartData = cart.map(item => ({
            name: item.name,
            price: item.price,
            quantity: item.quantity
        }));

        fetch(`https://${GetParentResourceName()}/buyItems`, {
            method: "POST",
            body: JSON.stringify({
                items: cartData
            })
        });
        setStage("receipt");
    }

    if (stage === "browse") {
        return (
            <div className="shop">
                <h2>{shop.label}</h2>
                <p className="shop-subtitle">Browse our shelves</p>

                <div className="shelves">
                    {shop.items.map((item, i) => (
                        <div key={i} className="shelf-item">
                            <span className="item-name">{item.name}</span>
                            <span className="item-price">${item.price}</span>
                            <button onClick={() => addToCart(item)}>
                                Grab
                            </button>
                        </div>
                    ))}
                </div>

                {cart.length > 0 && (
                    <button className="register-btn" onClick={() => setStage("register")}>
                        Go to Register ({cart.length} items)
                    </button>
                )}
            </div>
        );
    }

    if (stage === "register") {
        return (
            <div className="shop">
                <h2>Register - {shop.label}</h2>
                <p className="shop-subtitle">Review your purchase</p>

                <div className="cart">
                    {cart.map((item, i) => (
                        <div key={i} className="cart-item">
                            <span>{item.name}</span>
                            <div className="quantity-control">
                                <button onClick={() => updateQuantity(item.name, item.quantity - 1)}>-</button>
                                <span>{item.quantity}</span>
                                <button onClick={() => updateQuantity(item.name, item.quantity + 1)}>+</button>
                            </div>
                            <span className="item-subtotal">${item.price * item.quantity}</span>
                            <button className="remove-btn" onClick={() => removeFromCart(item.name)}>Remove</button>
                        </div>
                    ))}
                </div>

                <div className="total">
                    <span>Total:</span>
                    <span>${getTotal()}</span>
                </div>

                <div className="register-actions">
                    <button className="back-btn" onClick={() => setStage("browse")}>Back to Browse</button>
                    <button className="pay-btn" onClick={checkout}>Pay ${getTotal()}</button>
                </div>
            </div>
        );
    }

    if (stage === "receipt") {
        const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        const tax = Math.floor(subtotal * 0.07);
        const receiptTotal = subtotal + tax;

        return (
            <div className="shop">
                <h2>Receipt</h2>
                <p className="receipt-title">Thank you for shopping at {shop.label}!</p>

                <div className="receipt-items">
                    {cart.map((item, i) => (
                        <div key={i} className="receipt-item">
                            <span>{item.quantity}x {item.name}</span>
                            <span>${item.price * item.quantity}</span>
                        </div>
                    ))}
                </div>

                <div className="receipt-breakdown">
                    <div className="receipt-line">
                        <span>Subtotal:</span>
                        <span>${subtotal}</span>
                    </div>
                    <div className="receipt-line">
                        <span>Tax (7%):</span>
                        <span>${tax}</span>
                    </div>
                    <div className="receipt-total">
                        <span>Total Paid:</span>
                        <span>${receiptTotal}</span>
                    </div>
                </div>

                <button className="close-btn" onClick={() => window.history.back()}>Close</button>
            </div>
        );
    }
}

