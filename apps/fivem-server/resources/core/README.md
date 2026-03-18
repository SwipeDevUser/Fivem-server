# Core Resource

Core server functionality and utilities for FiveM.

## Features

- Player management
- Server health checks
- Event handling
- Configuration management
- Logging integration

## Setup

1. Ensure this resource is placed in `resources/` folder
2. Add `ensure core` to your `server.cfg`
3. Configure environment variables as needed

## Environment Variables

- `debug`: Enable/disable debug mode (default: false)
- `server_name`: Server display name (default: FiveM Server)
- `sv_maxclients`: Maximum player slots (default: 32)

## Configuration

Edit `shared/config.lua` to customize core settings.

## API

### Events

- `playerReady` - Triggered when a player is ready after spawning
- `playerConnecting` - Triggered when a player is connecting
- `playerJoined` - Triggered when a player has successfully joined
- `playerDropped` - Triggered when a player disconnects

## Health Check Endpoints

- `GET /health` - Basic health check (returns OK)
- `GET /health/deep` - Deep health check with server statistics

## Logging

Check server console for logs with `[Core]` prefix.
