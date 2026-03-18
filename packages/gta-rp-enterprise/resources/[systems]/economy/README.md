# Economy System - Inflation & Job Management

A comprehensive economy system for GTA RP Enterprise featuring dynamic inflation management, salary adjustments, and price controls.

## Overview

The economy system maintains target inflation rates at **< 3% weekly** with automatic adjustments to player salaries and item prices based on calculated economic indicators.

### Key Features

- **Dynamic Inflation**: Exponential compounding with configurable target rates
- **Automatic Salary Adjustments**: Job salaries scale with inflation weekly
- **Price Multipliers**: Item prices adjust automatically across all categories
- **Economic Indicators**: Track total wealth, money supply, business revenue
- **Historical Analytics**: Store and analyze inflation trends over time
- **Admin Controls**: Commands to manually trigger updates and view stats

## Configuration

### Target Inflation Rate

```lua
Config.Inflation.targetRate = 3.0  -- 3% weekly (default)
```

**Formula**: `(1 + 0.03)^(1/52) - 1 ≈ 0.0573% per interval`

- **Weekly Compounding**: 3% target weekly = ~12.55% annually
- **Min/Max Constraints**: Rates clamped between -2% and 5%
- **Calculation Method**: Exponential (compound) or Linear (simple)

### Configuration File

```lua
-- resources/[systems]/economy/config.lua

Config = {
    Inflation = {
        targetRate = 3.0,              -- Target weekly inflation
        maxRate = 5.0,                 -- Maximum allowed
        minRate = -2.0,                -- Minimum allowed (deflation)
        updateInterval = 60000,        -- Update check (ms)
        calculationMethod = 'exponential',  -- or 'linear'
        enabled = true,
        logLevel = 'info'              -- 'debug', 'info', 'warn'
    },
    
    JobSalaries = {
        police = 5000,
        ems = 4500,
        mechanic = 4000,
        -- ... more jobs
    },
    
    Indicators = {
        trackPlayerWealth = true,
        trackMoneySupply = true,
        storeHistory = true,
        historyRetentionDays = 30
    }
}
```

## Exports

### Get Current Inflation Rate

```lua
local inflationData = exports.economy:getInflationRate()

-- Returns:
-- {
--   currentRate = 0.0573,           -- Current weekly rate
--   targetRate = 3.0,               -- Target rate
--   week = 42,                      -- Current week number
--   cumulativeInflation = 2.45      -- Total inflation since start
-- }
```

### Apply Inflation Manually

```lua
local updated = exports.economy:applyInflation()
-- Triggers weekly update immediately (admin use)
```

### Get Economy Statistics

```lua
local stats = exports.economy:getEconomyStats()

-- Returns historical data for analytics
-- Includes: total wealth, money supply, transactions, etc.
```

### Get Job Salary (Jobs System)

```lua
local baseSalary = exports.economy:getJobSalary('police')           -- 5000
local adjustedSalary = exports.economy:getAdjustedSalary('police')  -- 5002.87
local allSalaries = exports.economy:getAllJobSalaries()             -- All jobs with adjustments
```

### Pay Employee

```lua
exports.economy:payEmployee(playerId, 'police', amount)
-- Logs transaction to database and adds to player money
```

## Database Schema

### Tables

**economy_inflation**
- `id` - Primary key
- `week` - Week number
- `current_rate` - This week's inflation rate (%)
- `target_rate` - Target inflation rate (%)
- `cumulative_inflation` - Total inflation since epoch (%)
- `last_update` - Unix timestamp of last update
- `created_at` - Record creation time

**job_salaries**
- `id` - Primary key
- `job_name` - Job identifier (police, ems, etc.)
- `base_salary` - Original salary (no inflation)
- `current_salary` - Adjusted with current inflation
- `active` - Whether job is active

**item_prices**
- `id` - Primary key
- `item_name` - Item identifier
- `category` - Category (weapons, vehicles, food, etc.)
- `base_price` - Original price
- `current_price` - Adjusted with current inflation
- `price_multiplier` - Applied multiplier (1.0 + rate/100)
- `active` - Whether price is active

**inflation_history**
- `id` - Primary key
- `week` - Week number
- `inflation_rate` - Recorded rate
- `salary_multiplier` - Multiplier applied to salaries
- `price_multiplier` - Multiplier applied to prices
- `monthly_average` - Rolling monthly average

### Views

**vw_economy_status** - Live economy snapshot
```sql
SELECT * FROM vw_economy_status;
-- Shows current inflation, average salaries, transactions, etc.
```

## Network Events

### economy:addMoney (Client → Server)

Client requests money/payment from server:

```lua
-- Client-side
TriggerServerEvent('economy:addMoney', 5000)  -- Request $5000 payment

-- Server-side validates:
-- ✓ Amount is positive
-- ✓ Under $10,000 single transaction limit
-- ✓ Under $100,000 per-minute rate limit
-- ✓ Player is employed
-- ✓ Not suspicious frequency
```

**Exploit Detection:**
- Amounts > $10,000: **REJECTED** + Player kicked
- Rate limit exceeded: **REJECTED** + Audit logged
- Invalid job status: **REJECTED** + Player notified
- Suspicious patterns: **REJECTED** + Audit logged

**Success Response:**
- Money added to player account
- Notification sent to player
- Transaction logged to database

## Events

### economy:weeklyInflationUpdate

Fired when weekly inflation is applied:

```lua
AddEventHandler('economy:weeklyInflationUpdate', function(inflationData)
    print(string.format('Week %d: Rate %.2f%%', 
        inflationData.week, 
        inflationData.current_rate))
end)
```

### economy:salariesAdjusted

Fired when job salaries are adjusted:

```lua
AddEventHandler('economy:salariesAdjusted', function(multiplier, count)
    print(string.format('Adjusted %d salaries by %.4f', count, multiplier))
end)
```

### economy:pricesAdjusted

Fired when item prices are adjusted:

```lua
AddEventHandler('economy:pricesAdjusted', function(multiplier, count)
    print(string.format('Adjusted %d prices by %.4f', count, multiplier))
end)
```

## How Inflation Works

### Weekly Calculation

1. **Get Target Rate**: 3% weekly (configurable)
2. **Calculate Multiplier**: `(1 + 0.03)^(1/52) - 1 ≈ 0.0573%`
3. **Apply to Salaries**: Each job salary × 1.000573
4. **Apply to Prices**: Each item price × 1.000573
5. **Store History**: Record rates and multipliers

### Example: 3% Weekly Over One Year

- **Week 1**: Salary $1,000 → $1,000.57
- **Week 4**: Salary $1,000 → $1,002.29 (compounded)
- **Week 26**: Salary $1,000 → $1,051.26 (mid-year)
- **Week 52**: Salary $1,000 → $1,125.53 (annual)

**Annual Equivalent**: ~12.55% inflation

## Usage Examples

### Check Current Inflation

```lua
local inflation = exports.economy:getInflationRate()
TriggerClientEvent('chat:addMessage', -1, {
    args = {'Economy', string.format('Current Inflation: %.2f%%', inflation.currentRate)}
})
```

### Get Player's Adjusted Salary

```lua
TriggerEvent('chat:addMessage', -1, {
    args = {'Info', string.format('Police Salary: $%d', 
        exports.economy:getAdjustedSalary('police'))}
})
```

### Manual Inflation Update (Admin)

```lua
-- Trigger immediately (development/testing)
local result = exports.economy:applyInflation()
print(string.format('Applied inflation. New rate: %.2f%%', result.currentRate))
```

## Security & Exploit Detection

### Transaction Validation

The economy system includes built-in exploit detection:

**Thresholds:**
- **Single Transaction Limit**: $10,000 max per request
- **Rate Limit**: $100,000 max per minute per player
- **Frequency Check**: Max 5 transactions per minute

**Checks Performed:**
1. Positive amount validation
2. Single transaction ceiling
3. Rate limiting (1-minute window)
4. Frequency pattern detection
5. Player employment status verification

### Exploit Logging

All suspicious transactions are logged to `exploit_logs` table with:
- Player name and Steam ID
- Transaction amount and reason
- IP address
- Timestamp
- Admin review tracking

**Example Logged Reasons:**
- `exceeds_single_transaction_limit`
- `exceeds_rate_limit`
- `suspicious_frequency`
- `invalid_amount`

### Remediation

Detected exploits result in:
1. Immediate player kick
2. Audit log entry
3. Admin notification
4. Optional permanent ban

## Installation

### 1. Run Migrations

```bash
# Apply schema (includes exploit_logs table)
mysql -u username -p database_name < database/migrations/003_economy_inflation.sql

# Seed data
mysql -u username -p database_name < database/migrations/003_economy_inflation_seed.sql
```

### 2. Add to server.cfg

```
ensure core
ensure economy
```

### 3. Ensure Dependencies

- mysql-async
- core framework

## Configuration Tuning

### For Higher Inflation (5% weekly)

```lua
Config.Inflation.targetRate = 5.0
```

### For Deflation (-2% weekly)

```lua
Config.Inflation.targetRate = -2.0
```

### For Linear (Non-Compound) Inflation

```lua
Config.Inflation.calculationMethod = 'linear'
```

### For Production (Real 7-Day Cycle)

```lua
Config.Inflation.updateInterval = 604800000  -- 7 days in milliseconds
```

## Querying Economy Data

### Get Inflation History

```sql
SELECT * FROM inflation_history 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY week DESC;
```

### Get Average Salary

```sql
SELECT AVG(current_salary) as avg_salary 
FROM job_salaries 
WHERE active = 1;
```

### Check Price by Category

```sql
SELECT category, AVG(current_price) as avg_price
FROM item_prices
WHERE active = 1
GROUP BY category;
```

### View Live Economy Status

```sql
SELECT * FROM vw_economy_status;
```

## Troubleshooting

### Inflation Not Updating

1. Check `Config.Inflation.enabled = true`
2. Verify MySQL connection in `server.cfg`
3. Check server console for errors: `^1[ERROR]^7`
4. Ensure resource is in correct load order (after core)

### Salaries Not Adjusting

1. Verify `job_salaries` table is populated
2. Check that jobs are marked `active = 1`
3. Ensure core framework is loaded first

### Prices Not Changing

1. Verify `item_prices` table has entries
2. Check that items are marked `active = 1`
3. Confirm MySQL queries execute without errors

## Support

For issues or feature requests, refer to the main project documentation or contact the development team.
