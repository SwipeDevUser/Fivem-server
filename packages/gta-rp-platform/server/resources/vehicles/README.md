# Vehicles Resource

Vehicle management and spawning system.

## Features

- Vehicle spawning
- Vehicle ownership
- Parking system
- Vehicle customization

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure vehicles` to your `server.cfg`

## Commands

- `/car [model]` - Spawn a vehicle

## API

### Exports

- `spawnVehicle(source, model, x, y, z, heading)` - Spawn vehicle
- `deleteVehicle(vehId)` - Delete vehicle
- `getVehicles()` - Get active vehicles
