# Police System Resource

Comprehensive police management system for FiveM servers.

## Features

- Player cuffing/uncuffing
- Player searching
- Arrest system with jail time
- Fine system
- Dispatch system
- Police commands
- NUI interface

## Setup

1. Ensure dependencies are loaded: `core`, `ox_lib`
2. Add `ensure police_system` to your `server.cfg`
3. Configure police jobs in your core resource

## Configuration

Edit `config/config.lua` to customize:
- Police job name
- Police stations locations
- Dispatch codes
- Animation settings

## Commands

- `/policemenu` - Open police management menu
- `/cuff [id]` - Cuff/uncuff player
- `/search [id]` - Search player
- `/arrest [id] [minutes]` - Arrest player with jail time
- `/fine [id] [amount]` - Fine player

## Dependencies

- core
- ox_lib

## API Exports

### Server-side

```lua
-- Cuff player
exports('cuffPlayer', function(playerId, targetId)

-- Search player
exports('searchPlayer', function(playerId, targetId)

-- Arrest player
exports('arrestPlayer', function(playerId, targetId, jailtimeMinutes)

-- Fine player
exports('finePlayer', function(playerId, targetId, amount)
```

## Permissions

Police commands require the player to have the job `police`.

## UI

The police system includes a NUI interface for managing players with dedicated sections for:
- Cuffing/searching
- Arresting with jail time
- Fining

Access via `/policemenu` command.
