# Inventory Resource

Player inventory and item management system.

## Features

- Item storage and management
- Inventory UI
- Item slots
- Weight/capacity system

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure inventory` to your `server.cfg`

## Commands

- `/inventory` - Open inventory

## API

### Exports

- `addItem(source, item, count)` - Add item to player inventory
- `removeItem(source, item, count)` - Remove item from inventory
- `getInventory(source)` - Get player's inventory contents
