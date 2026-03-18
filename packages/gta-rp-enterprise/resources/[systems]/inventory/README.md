# Inventory System - Complete Documentation

A production-grade inventory management system for GTA RP Enterprise featuring weight management, item categories, metadata support, and full audit logging.

## Overview

The inventory system provides:
- **Weight-based inventory** (configurable max weight)
- **Slot-based storage** (configurable max slots)
- **Item categories** (weapons, food, medical, tools, documents, materials, misc)
- **Unique & stackable items**
- **Item effects** (health, stamina bonuses)
- **Drop & pickup** in-world items
- **Transfer between players**
- **Complete audit logging**
- **Admin commands**

## Features

### Core Functionality

- ✅ Add/remove items from inventory
- ✅ Query item existence and counts
- ✅ Calculate inventory weight
- ✅ Transfer items between players
- ✅ Drop items into world
- ✅ Pick up dropped items
- ✅ Use consumable items (food, medical)
- ✅ Equip weapons
- ✅ Sort and organize inventory
- ✅ Search items by name/category
- ✅ Inventory persistence (database)

### Security Features

- ✅ Server-side validation for all actions
- ✅ Weight limit enforcement
- ✅ Slot limit enforcement
- ✅ Exploit detection
- ✅ Complete audit trail
- ✅ IP tracking for admin review
- ✅ Action logging per user

### UI Features

- ✅ Inventory window (NUI/React)
- ✅ Weight indicator
- ✅ Category filters
- ✅ Search functionality
- ✅ Item descriptions
- ✅ Drag-and-drop (optional)
- ✅ Quick use buttons
- ✅ Drop confirmation

## Configuration

### Main Settings

`shared/config.lua`:

```lua
Config.Inventory = {
    maxWeight = 120000,   -- 120kg in grams
    maxSlots = 50,        -- Total item slots
    dropOnDeath = true,   -- Drop items when player dies
    dropOnDisconnect = false,
    useWeight = true,     -- Enable weight checking
    enableDrop = true,    -- Allow item drop
    enableSort = true,    -- Enable sorting
    enableSearch = true   -- Enable search
}
```

### Item Definition

Each item has:
- `name` - Internal identifier
- `label` - Display name
- `weight` - Weight in grams
- `category` - Item category
- `usable` - Can be used/consumed
- `unique` - Cannot be stacked
- `description` - Item description
- `effect` - Effects when consumed (health, stamina)

Example:
```lua
['burger'] = {
    name = 'burger',
    label = 'Hamburger',
    weight = 200,        -- 200g
    category = 'food',
    usable = true,
    shouldClose = true,
    description = 'A tasty hamburger',
    effect = {
        health = 10,
        stamina = 5
    }
}
```

## API Reference

### Add Item

```lua
exports.inventory:addItem(playerId, itemName, count, metadata)
-- Returns: boolean
-- Example:
exports.inventory:addItem(1, 'burger', 1)  -- Add burger
exports.inventory:addItem(1, 'burger', 3)  -- Add 3 burgers
```

### Remove Item

```lua
exports.inventory:removeItem(playerId, itemName, count)
-- Returns: boolean
-- Example:
exports.inventory:removeItem(1, 'burger', 1)  -- Remove 1 burger
```

### Check Item Existence

```lua
exports.inventory:hasItem(playerId, itemName, count)
-- Returns: boolean
-- Example:
if exports.inventory:hasItem(1, 'lockpick', 1) then
    -- Player has lockpick
end
```

### Get Item Info

```lua
exports.inventory:getItem(playerId, itemName)
-- Returns: item object {name, count, metadata}

exports.inventory:getItemInfo(itemName)
-- Returns: item definition {label, weight, category, usable, description, effect}
```

### Get Inventory

```lua
exports.inventory:getInventory(playerId)
-- Returns: table of items

exports.inventory:getWeight(playerId)
-- Returns: total weight in grams

exports.inventory:getInventoryPercentage(playerId)
-- Returns: percentage (0-100)
```

### Validate & Modify

```lua
exports.inventory:canAddItem(playerId, itemName, count)
-- Returns: boolean, reason

exports.inventory:clearInventory(playerId)
-- Returns: boolean

exports.inventory:sortInventory(playerId)
-- Returns: boolean
```

### Transfer Items

```lua
exports.inventory:transferItem(fromPlayerId, toPlayerId, itemName, count)
-- Returns: boolean, message

exports.inventory:dropItem(playerId, itemName, count)
-- Returns: boolean

exports.inventory:pickupItem(playerId, itemName, count)
-- Returns: boolean
```

### Search

```lua
exports.inventory:getItemsByCategory(category)
-- Returns: array of items

exports.inventory:searchItems(query)
-- Returns: array of matching items

exports.inventory:getSimilarItems(itemName)
-- Returns: array of items in same category
```

## Database Schema

### inventory
Stores player inventory items:
- `user_id` - Player identifier
- `character_id` - Character slot
- `item_name` - Item name
- `quantity` - Item count
- `metadata` - JSON metadata
- Unique constraint: (user_id, character_id, item_name)

### dropped_items
Tracks items dropped in world:
- `item_name` - Item name
- `quantity` - Amount dropped
- `position` - World coordinates {x, y, z}
- `heading` - Item heading
- `dropped_by` - Player who dropped
- `picked_up_by` - Player who picked up
- Auto-expires after 30 minutes

### inventory_history
Complete audit trail:
- `action_type` - add, remove, transfer, drop, use
- `quantity` - Amount affected
- `from_user_id` / `to_user_id` - Transfer details
- `reason` - Why action occurred

### item_definitions
Item catalog:
- Cached version of config items
- Synced on resource start
- Used for weight/validation

### inventory_stats
Quick lookup statistics:
- Total items and weight per player
- Use/drop/transfer counts
- Updated on each action

## Events

### Server Events

```lua
-- Triggered when item is used
RegisterNetEvent('inventory:useItem')

-- Triggered when item is dropped
RegisterNetEvent('inventory:dropItemServer')

-- Triggered to equip weapon
RegisterNetEvent('inventory:equipWeapon')

-- Triggered to unequip weapon
RegisterNetEvent('inventory:unequipWeapon')
```

### Client Events

```lua
-- Inventory updated
RegisterNetEvent('inventory:setInventory')

-- Play animation
RegisterNetEvent('inventory:playAnimation')

-- Add health/stamina
RegisterNetEvent('inventory:addHealth')
RegisterNetEvent('inventory:addStamina')

-- Weapon management
RegisterNetEvent('inventory:giveWeapon')
RegisterNetEvent('inventory:removeWeapon')
```

## Commands

### Player Commands

```
/inventory          -- Toggle inventory UI
/inv                -- Show inventory stats
/clearinv           -- Clear inventory (debug)
```

### Admin Commands

```
/giveitem [name] [count] [playerId]    -- Give item to player
/removeitem [name] [count] [playerId]  -- Remove item from player
```

## Usage Examples

### Give Player Burger

```lua
exports.inventory:addItem(playerId, 'burger', 1)
```

### Check If Has Lockpick

```lua
if exports.inventory:hasItem(playerId, 'lockpick', 1) then
    print('Player has lockpick')
end
```

### Transfer Item Between Players

```lua
local success, message = exports.inventory:transferItem(player1, player2, 'cash', 500)
if success then
    print('Transferred $500')
else
    print('Transfer failed: ' .. message)
end
```

### Drop Food Item

```lua
exports.inventory:dropItem(playerId, 'burger', 1)
```

### Get Weight Percentage

```lua
local percentage = exports.inventory:getInventoryPercentage(playerId)
print(string.format('Inventory %d%% full', percentage))
```

### Use Lockpick

```lua
TriggerServerEvent('inventory:useItem', 'lockpick')
```

### Get All Food Items

```lua
local foodItems = exports.inventory:getItemsByCategory('food')
for _, item in ipairs(foodItems) do
    print(item.label)  -- Hamburger, Pizza, Water, Coffee, Donuts
end
```

## Installation

### 1. Database Setup

```bash
mysql -u user -p database < database/migrations/004_inventory_system.sql
```

### 2. Add to server.cfg

```
ensure core
ensure economy
ensure inventory
```

### 3. Ensure Dependencies

- mysql-async
- core framework
- economy system

## Weight System

Total weight calculation:
```
Total = SUM(item_weight * item_quantity)
```

Example:
- Burger (200g) × 3 = 600g
- Pistol (1100g) × 1 = 1100g
- **Total: 1700g**

Over the 120kg limit:
- Add operations fail with "Inventory too heavy"
- Transfer operations blocked
- Drop operations succeed

## Item Effects

When consuming food/medical items:

```lua
effect = {
    health = 10,      -- Add 10 HP
    stamina = 5       -- Add 5% stamina
}
```

Health capped at max (100 HP by default)
Stamina capped at 100%

## Unique Items

Items with `unique = true` cannot be stacked:
- ID Card
- Driver's License

Trying to add second ID results in separate inventory slot

## Admin Review

Query exploit attempts:

```sql
SELECT * FROM inventory_logs
WHERE action = 'exploit'
ORDER BY created_at DESC;
```

View inventory history by player:

```sql
SELECT * FROM inventory_history
WHERE user_id = 'steam:123456'
ORDER BY created_at DESC
LIMIT 50;
```

## Troubleshooting

### Inventory Not Saving

1. Check MySQL connection
2. Verify inventory table exists
3. Check server console for errors
4. Ensure user_id in database

### Items Not Adding

1. Verify item exists in config
2. Check inventory weight limit
3. Check inventory slot limit
4. Look for "Inventory too heavy" message

### UI Not Appearing

1. Verify NUI files exist
2. Check that ui page is loaded
3. Test with `/inventory` command
4. Check browser console (F12)

## Performance

- Indexed on user_id for fast lookups
- Inventory cached in memory
- Saved to DB on disconnect
- Efficient weight calculations
- View-based quick statistics

## Security Notes

- All item operations logged
- IP tracking for admin review
- Weight/slot enforcement server-side
- No client-side item modification
- Complete audit trail maintained
- Dropped items have timeout (anti-spam)

## Future Enhancements

- [ ] Drag-and-drop UI
- [ ] Backpack/container items
- [ ] Item durability system
- [ ] Rarity/quality system
- [ ] Custom item icons
- [ ] Weapon attachments
- [ ] Batch operations
- [ ] Inventory filters

## Support

For issues or feature requests, refer to main project documentation.
