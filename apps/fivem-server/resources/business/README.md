# Business Resource

Business and commerce management system.

## Features

- Business ownership
- Shop system
- Employee management
- Profit tracking

## Setup

1. Ensure dependencies are loaded: `core`, `economy`
2. Add `ensure business` to your `server.cfg`

## Commands

- `/business` - Open business menu

## Dependencies

- core
- economy

## API

### Exports

- `createBusiness(name, category, owner)` - Create new business
- `addBusinessFunds(bizId, amount)` - Add funds to business
- `getBusinesses()` - Get all businesses
