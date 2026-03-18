# Jobs Resource

Job system for FiveM server.

## Features

- Job assignment
- Job grades/ranks
- Job-specific permissions
- Duty system

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure jobs` to your `server.cfg`

## API

### Exports

- `setPlayerJob(source, job, grade)` - Assign job to player
- `getPlayerJob(source)` - Get player's current job
