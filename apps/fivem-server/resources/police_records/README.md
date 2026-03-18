# Police Criminal Records System

A comprehensive criminal records management system for FiveM servers featuring warrants, arrest history, plate lookups, and a professional React-based UI.

## Features

### 1. Criminal Records Management
- Track criminal history and status (clean, wanted, incarcerated)
- Store charges and mugshot information
- Automatically update status based on warrants/arrests

### 2. Warrants System
- Issue warrants with customizable reasons
- Track warrant amounts and severity
- Automatically flag wanted players
- Revoke warrants as needed

### 3. Arrest History
- Record all arrests with details (reason, jail time, fine)
- Track arresting officer
- Historical record keeping for legal references

### 4. Vehicle Plate Lookup
- Search vehicles by license plate
- Display owner information
- Track vehicle status (registered, stolen, wanted)

### 5. Player Search
- Search by first and last name
- Quick access to criminal records
- View all matching records with statuses

### 6. React NUI Interface
- Tab-based UI for easy navigation
- Real-time record updates
- Color-coded status indicators
- Professional police database styling

## Commands

### Basic Search
```
/playersearch [first_name] [last_name] - Search for a player's criminal record
/record [player_id] - Get criminal record for specific player
/arrests [player_id] - View arrest history for a player
```

### Warrants
```
/warrant [player_id] [reason] [amount] - Issue a warrant for a player
/wanted [player_id] - Check if player has active warrants
```

### Vehicle Information
```
/platelookup [plate] - Look up vehicle by license plate
```

### Open UI
```
/police - Open the Police Records UI
```

## Database Tables

### criminal_records
- Stores main criminal record information
- Tracks charges, mugshots, and current status
- Links to user accounts

### warrants
- Active and revoked warrant records
- Issue dates and reasons
- Bail amounts

### arrest_history
- Complete arrest logs
- Arresting officer information
- Jail time and fine amounts

### vehicle_plates
- Vehicle registration information
- Ownership tracking
- Vehicle status (registered/stolen/wanted)

### charges
- Individual criminal charges
- Severity levels (felony/misdemeanor/infraction)
- Resolution status

## Integration

This system integrates with:
- Core police resource for ticket/jail systems
- Inventory system for fines/payments
- User database for identification

## Usage Examples

```lua
-- Issue warrant for player 5
/warrant 5 Armed Robbery 5000

-- Check if wanted
/wanted 5

-- Search for a player
/playersearch John Doe

-- Lookup vehicle
/platelookup ABC123

-- View arrest history
/arrests 5
```

## Customization

Edit `shared/config.lua` to customize:
- Police station locations
- Warrant severity levels
- Available charges
- Station garage locations
