# Housing Resource

Housing and property management system.

## Features

- Property ownership
- Interior management
- Storage system
- Property customization

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure housing` to your `server.cfg`

## Commands

- `/properties` - View available properties

## API

### Exports

- `registerProperty(name, location, price)` - Register new property
- `setPropertyOwner(propId, owner)` - Set property owner
- `getProperties()` - Get all properties
