# Logging Resource

Server and application logging system.

## Features

- Structured logging
- Log levels (DEBUG, INFO, WARN, ERROR)
- Timestamped logs
- Module-based logging

## Setup

1. Ensure dependencies are loaded: `core`
2. Add `ensure logging` to your `server.cfg`

## API

### Exports

- `debug(module, message)` - Log debug message
- `info(module, message)` - Log info message
- `warn(module, message)` - Log warning message
- `error(module, message)` - Log error message

## Usage Example

```lua
local logging = exports.logging

logging:info('MyModule', 'Starting service')
logging:warn('MyModule', 'Configuration missing')
logging:error('MyModule', 'Service failed')
```
