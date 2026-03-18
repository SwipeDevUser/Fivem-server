# Police System Resource

A comprehensive police management system for GTA RP Enterprise with dispatch, arrest, fining, and law enforcement features.

## Features

- Police dispatch system
- Player arrest/jail system
- Fine system for violations
- Police station management
- Equipment and armory system
- Searchable checkpoints
- Radio communication
- Police records

## Dependencies

- `mysql-async` - For database operations
- `core` - Core framework
- `economy` - For fine/payment processing
- `jobs` - For job assignment

## Installation

1. Place in `server/resources/[systems]/police/`
2. Ensure dependency resources are loaded first
3. Add to `server.cfg`: `ensure police`
4. Configure `config.lua` with your server settings

## Configuration

Edit `config.lua` to customize:
- Police stations locations
- Jail locations and timeout
- Fine amounts
- Dispatch codes
- Radio channels
- Required permissions

## Commands

- `/police` - Open police menu
- `/dispatch [code] [message]` - Send dispatch
- `/jail [id] [minutes]` - Jail player
- `/fine [id] [amount]` - Fine player
- `/search [id]` - Search player

## Exports

```lua
-- Check if player is police
exports.police:IsPlayerPolice(source)

-- Jail player
exports.police:JailPlayer(source, minutes)

-- Fine player
exports.police:FinePlayer(source, amount)
```

## Database

The system uses the following tables:
- `police_records` - Arrest records
- `fines_issued` - Fine history
- `warrants` - Active warrants

## Support

For issues or feature requests, contact the development team.
