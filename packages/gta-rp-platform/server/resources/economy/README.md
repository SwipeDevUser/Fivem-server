# Economy Resource

Player economy and banking system.

## Features

- Bank accounts
- ATM system
- Money management
- Transaction history

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure economy` to your `server.cfg`

## Commands

- `/balance` - Check account balance

## API

### Exports

- `addMoney(source, amount)` - Add money to player account
- `removeMoney(source, amount)` - Remove money from account
- `getMoney(source)` - Get player's current money
