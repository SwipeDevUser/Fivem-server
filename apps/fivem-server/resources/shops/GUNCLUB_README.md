# Orlando Gun Club
## Premium Firearms & Accessories Dealer
**Est. 2010 - Your Trusted Firearms Dealer**

---

## Overview
Orlando Gun Club is a professional firearms retailer offering a complete selection of weapons, ammunition, accessories, and safety gear. Established in 2010, the store is known for expert staff, quality products, and a commitment to responsible firearm ownership.

**Motto:** "Safety First, Always" | "Your Trusted Firearms Dealer"

---

## Features

### 🔫 Product Categories

#### Pistols
- **9MM Pistol** - $500 | Reliable and popular choice
- **45 ACP Pistol** - $650 | Powerful stopping power
- **.357 Magnum Pistol** - $700 | Premium performance
- **.22 Pistol** - $400 | Training and sport shooting

#### Rifles
- **5.56 Rifle** - $1,200 | Military-spec platform
- **.308 Rifle** - $1,400 | Long-range capabilities
- **.223 Rifle** - $1,000 | Precision shooting
- **.22 Rifle** - $600 | Training and small game

#### Shotguns
- **12 Gauge Shotgun** - $800 | Versatile, powerful
- **20 Gauge Shotgun** - $700 | Reduced recoil
- **.410 Shotgun** - $600 | Lighter option

#### Ammunition
- **9MM Ammo Box** - $30
- **.45 ACP Ammo Box** - $35
- **.357 Magnum Ammo Box** - $40
- **5.56 Ammo Box** - $50
- **.308 Ammo Box** - $60
- **12 Gauge Shells** - $45
- **.22 Ammo Box** - $20

#### Tactical Accessories
- **Tactical Scope** - $250 | Professional optics
- **IWB Holster** - $80 | Inside-waistband carry
- **9MM Magazine** - $40 | Reliable storage
- **.45 Magazine** - $50 | Standard capacity
- **Rifle Sling** - $60 | Tactical sling system
- **Hard Case** - $150 | Secure storage
- **Cleaning Kit** - $75 | Professional maintenance
- **Ammo Pouch** - $45 | Convenient carrying

#### Safety Gear
- **Ear Protection** - $60 | Hearing safety
- **Eye Protection** - $50 | Ballistic rated
- **Shooting Gloves** - $45 | For comfort and control
- **Range Mat** - $35 | Practice surface

---

## Game Commands

### Open Orlando Gun Club
```
/gunclub
/occ
```

Both commands open the professional Orlando Gun Club interface with all categories visible.

---

## UI Features

### Main Interface
- **Professional Dark Red & Gold Theme** - High-contrast, easy to navigate
- **Category Navigation** - Left sidebar with 6 categories
- **Product Grid** - Browse items with clear pricing
- **Shopping Cart** - Track items being added
- **Real-time Total** - See current cart value

### Category Browsing
1. **Pistols** - Handgun selection
2. **Rifles** - Long gun platform
3. **Shotguns** - Shotgun options
4. **Ammunition** - All calibers
5. **Accessories** - Tactical gear
6. **Safety Gear** - Protection equipment

### Purchase Process
1. Select category from left panel
2. Click item to select (highlighted in red)
3. Click "Add to Cart" button
4. Repeat for multiple items
5. Click "Checkout" when ready

### Receipt System
- Displays all purchased items
- Shows itemized pricing with quantity
- Calculates 10% background check fee
- Professional receipt format
- "Thank you" message with safety reminder

---

## Pricing Structure

### Base Prices
- **Pistols:** $400 - $700
- **Rifles:** $600 - $1,400
- **Shotguns:** $600 - $800
- **Ammunition:** $20 - $60 per box
- **Accessories:** $40 - $250

### Fees
- **Background Check Fee:** 10% of subtotal
- **Final Total:** Subtotal + Background Check Fee

### Examples
- Pistol ($500) + Background Check (10%) = **$550 total**
- Complete Loadout ($2,500) + Background Check ($250) = **$2,750 total**

---

## Server Events

### Buying Single Items
```lua
TriggerServerEvent("gunclub:buyItem", itemName)
```

### Bulk Checkout
```lua
TriggerServerEvent("gunclub:checkout", cart)
```

Where `cart` is an array of items with `{name, price, quantity}`.

---

## Client Commands

### Open Store
```lua
/gunclub
/occ
```

### NUI Callbacks
- `buyGunClubItem` - Purchase single item
- `gunclubCheckout` - Bulk purchase
- `closeGunClub` - Close UI

---

## Branding

### Color Scheme
- **Primary:** Dark Red / Firebrick (#B22222)
- **Accent:** Gold (#FFD700)
- **Background:** Dark Gray (#2A2A2A)
- **Border:** Firebrick with Gold highlights

### Logo / Icon
🔫 Pistol emoji used throughout branding

### Taglines
- "Est. 2010 - Orlando's Premier Gun Club"
- "We Know Guns. We Know Service."
- "Your Trusted Firearms Dealer"
- "Safety First, Always"
- "Where Shooters Come First"
- "Expert Staff, Premium Selection"
- "Professional Grade Equipment"
- "Building Shooters Since 2010"

---

## Integration Points

### Inventory System
- Items added to player inventory on purchase
- Cash deducted from player cash slot
- Inventory full notification
- Real-time inventory updates

### Database
- Server-side purchase logging
- Transaction tracking with player ID
- Item modification on successful purchase

### Notifications
- 🔫 Emoji in all notifications
- "Safety First, Always" messaging
- Professional confirmation messages

---

## System Architecture

### Server-Side (`server/gunclub.lua`)
- Event handlers for purchases
- Inventory management
- Cash deduction logic
- Transaction verification
- Receipt generation

### Client-Side (`client/gunclub.lua`)
- Store UI control
- NUI message handling
- Command registration
- Event triggering

### Shared Resources (`shared/gunclub_config.lua`)
- Product definitions
- Pricing information
- Brand configuration
- Taglines and descriptions

### NUI Interface (`html/gunclub.html`)
- Professional store layout
- Category browsing
- Cart management
- Receipt display

---

## Safety & Compliance

**Orlando Gun Club operates under strict safety protocols:**

1. **Background Check Fee** - 10% fee covers check costs
2. **Safety Warnings** - All transactions include safety reminder
3. **Responsible Dealer** - Supports ethical firearm ownership
4. **Professional Staff** - Expert assistance available

---

## Future Enhancements

Potential additions:
- Firearm registration system
- License verification
- Layaway/financing options
- Loyalty program
- Expert consultation system
- Maintenance tracking
- Training courses

---

## Support

For issues or questions about Orlando Gun Club:
- Check inventory space before purchasing
- Ensure sufficient funds (including fees)
- Verify ammo compatibility with weapons
- Contact server administrators for caliber questions

**"We Know Guns. We Know Service."**

---

*Orlando Gun Club - Est. 2010*  
*Safety First, Always* 🔒
