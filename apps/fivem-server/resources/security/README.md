# Security Resource

Security, anti-cheat, and ban management system.

## Features

- Ban management
- Anti-cheat detection
- Exploit protection
- Player verification

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure security` to your `server.cfg`

## API

### Exports

- `banPlayer(playerId, reason)` - Ban player from server
- `isPlayerBanned(identifier)` - Check if player is banned
- `unbanPlayer(identifier)` - Unban player

## Security Features

- Player connection verification
- Ban checking on join
- Exploit logging
- Resource monitoring
