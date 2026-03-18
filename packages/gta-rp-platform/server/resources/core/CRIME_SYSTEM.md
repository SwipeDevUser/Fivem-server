# Crime → Laundering → Spending System

Complete criminal framework for FiveM RP servers including crime commission, money laundering, and illegal spending.

## System Architecture

```
Crime Committed (Dirty Money)
    ↓
Money Laundering (Convert to Clean Money)
    ↓
Crime Spending (Purchase Criminal Items)
```

---

## 1. Crime System

### Overview
- 8 different crime types with varying rewards and risks
- Cooldowns to prevent spam
- Police response requirement
- Risk of arrest with consequences
- Criminal organizations
- Crime history tracking

### Available Crimes

| Crime | Reward | Risk | Min Police | Cooldown |
|-------|--------|------|-----------|----------|
| Robbery | $5,000 | High | 2 | 5 min |
| Drug Dealing | $2,000 | Medium | 1 | 1 min |
| Car Theft | $8,000 | High | 3 | 10 min |
| Bank Robbery | $50,000 | Extreme | 5 | 1 hour |
| Hacking | $3,000 | Medium | 2 | 3 min |
| Forgery | $4,000 | Medium | 1 | 2 min |
| Blackmail | $6,000 | High | 2 | 4 min |
| Kidnapping | $15,000 | Extreme | 4 | 20 min |

### Risk Levels & Consequences

**Low Risk:**
- Wanted Level: 1
- Arrest Chance: 5%
- Jail Time: 10 min

**Medium Risk:**
- Wanted Level: 2
- Arrest Chance: 15%
- Jail Time: 30 min

**High Risk:**
- Wanted Level: 3
- Arrest Chance: 30%
- Jail Time: 60 min

**Extreme Risk:**
- Wanted Level: 4
- Arrest Chance: 50%
- Jail Time: 120 min

### Crime API Functions

```lua
-- Commit a crime
local success, msg = exports.core:commitCrime(playerId, 'robbery')

-- Custom reward
local success, msg = exports.core:commitCrime(playerId, 'robbery', 7500)

-- Get player crime status
local status, msg = exports.core:getPlayerCrimeStatus(playerId)
-- Returns: {totalCrimes, dirtyMoney, cleanMoney, crimeLevel, wantedLevel, organization}

-- Get crime history
local history, msg = exports.core:getCrimeHistory(playerId, 10)

-- Add dirty money (alternative method)
local success, msg = exports.core:addDirtyMoney(playerId, 5000)

-- Get dirty money
local dirtyAmount, msg = exports.core:getDirtyMoney(playerId)

-- Join criminal organization
local success, msg = exports.core:joinOrganization(playerId, 'bloods')

-- Get all organizations
local orgs, msg = exports.core:getAllOrganizations()
```

### Criminal Organizations

- **Bloods** - South Los Santos (Red)
- **Crips** - Central Los Santos (Blue)
- **Vagos** - East Los Santos (Yellow)
- **Cartel** - Countryside (Green)
- **Yakuza** - Downtown (Magenta)

---

## 2. Money Laundering System

### Overview
- 5 laundering methods with different rates and fees
- Time-based conversion process
- Dirty money → Clean money conversion
- Commission/fees on each transaction
- Laundering history tracking

### Laundering Methods

| Method | Rate | Fee | Duration | Risk |
|--------|------|-----|----------|------|
| Casino Gambling | 85% | 15% | 60s | Low |
| Legitimate Business | 80% | 20% | 120s | Low |
| Real Estate | 75% | 25% | 180s | Medium |
| Nightclub | 70% | 30% | 90s | Medium |
| Restaurant | 78% | 22% | 150s | Low |

**Example:** Launder $10,000 via Casino (85% rate) = $8,500 clean money ($1,500 fee)

### Laundering API Functions

```lua
-- Start money laundering
local success, msg = exports.core:startLaundering(playerId, 'casino', 10000)

-- Complete laundering (auto-called at end of duration)
local success, msg = exports.core:completeLaundering(playerId)

-- Cancel laundering (returns dirty money)
local success, msg = exports.core:cancelLaundering(playerId)

-- Get laundering status
local status, msg = exports.core:getLaunderingStatus(playerId)
-- Returns: {method, dirtyAmount, cleanAmount, fee, progress, remaining, location}

-- Get laundering history
local history, msg = exports.core:getLaunderingHistory(playerId, 10)

-- Get all laundering methods
local methods, msg = exports.core:getAllLaunderingMethods()

-- Get specific method info
local methodInfo, msg = exports.core:getLaunderingMethodInfo('casino')
```

---

## 3. Crime Spending System

### Overview
- 5 spending categories for criminal items
- Purchase weapons, equipment, safehouses, vehicles, services
- Spending history tracking
- Statistics by category

### Spending Categories

**Weapons & Ammunition:**
- Pistol: $1,000
- Rifle: $3,000
- Shotgun: $2,500
- Sniper: $5,000
- SMG: $2,000
- Grenades: $500
- Armor Piercing Ammo: $800

**Safehouses & Stash:**
- Budget Safehouse: $50,000
- Standard Safehouse: $150,000
- Luxury Safehouse: $500,000
- Underground Bunker: $1,000,000
- Money Stash: $10,000

**Criminal Vehicles:**
- Getaway Car: $25,000
- Modified Bike: $35,000
- Armored SUV: $100,000
- Helicopter: $500,000
- Boat: $75,000

**Crime Equipment:**
- Lockpick Set: $500
- Hacking Device: $5,000
- Disguise: $2,000
- Suppressors: $1,500
- Body Armor: $3,000
- Surveillance Camera: $4,000

**Criminal Services:**
- Lawyer Retainer: $20,000
- Document Forger: $10,000
- Contact Cleaner: $15,000
- Witness Intimidation: $25,000
- Information Broker: $30,000

### Crime Spending API Functions

```lua
-- Buy crime item
local success, msg = exports.core:buyCrimeItem(playerId, 'weapons', 'Pistol')

-- Get spending options (all categories)
local options, msg = exports.core:getCrimeSpendingOptions()

-- Get specific category
local category, msg = exports.core:getCrimeSpendingOptions('weapons')

-- Get item price
local price, msg = exports.core:getCrimeItemPrice('weapons', 'Pistol')

-- Get crime purchase history
local history, msg = exports.core:getCrimePurchaseHistory(playerId, 10)

-- Get purchases by category
local purchases, msg = exports.core:getCrimePurchasesByCategory(playerId, 'weapons')

-- Get total spending
local totalSpent, msg = exports.core:getTotalCrimeSpending(playerId)

-- Get spending by category
local spending, msg = exports.core:getSpendingByCategory(playerId)

-- Get crime spending stats
local stats, msg = exports.core:getCrimeSpendingStats(playerId)
-- Returns: {totalSpent, purchaseCount, byCategory}
```

---

## Usage Examples

### Example 1: Commit a Crime

```lua
RegisterCommand('rob', function(source, args, rawCommand)
    local success, message = exports.core:commitCrime(source, 'robbery')
    
    if success then
        print('^2[Crime] Robbery successful! ' .. message .. '^7')
    else
        print('^1[Crime] Robbery failed: ' .. message .. '^7')
    end
end)
```

### Example 2: Launder Money

```lua
RegisterCommand('launder', function(source, args, rawCommand)
    local amount = tonumber(args[1]) or 5000
    local method = args[2] or 'casino'
    
    local success, message = exports.core:startLaundering(source, method, amount)
    
    if success then
        print('^3[Laundering] Processing: ' .. message .. '^7')
    end
end)
```

### Example 3: Monitor Laundering Progress

```lua
CreateThread(function()
    while true do
        Wait(5000)
        
        local status = exports.core:getLaunderingStatus(PlayerId())
        
        if status then
            print('^3[Laundering] Progress: ' .. status.progress .. '% (' .. status.remaining .. 's remaining)^7')
        end
    end
end)
```

### Example 4: Purchase Weapons

```lua
RegisterCommand('buygun', function(source, args, rawCommand)
    local weaponType = args[1] or 'Pistol'
    
    local success, msg = exports.core:buyCrimeItem(source, 'weapons', weaponType)
    
    if success then
        print('^2[Shop] Purchase successful: ' .. msg .. '^7')
    end
end)
```

### Example 5: Check Crime Stats

```lua
RegisterCommand('crimestats', function(source, args, rawCommand)
    local status, _ = exports.core:getPlayerCrimeStatus(source)
    
    if status then
        print('^3=== Crime Statistics ===^7')
        print('Total Crimes: ' .. status.totalCrimes)
        print('Dirty Money: $' .. status.dirtyMoney)
        print('Clean Money: $' .. status.cleanMoney)
        print('Crime Level: ' .. status.crimeLevel)
        print('Wanted Level: ' .. status.wantedLevel)
        if status.organization then
            print('Organization: ' .. status.organization)
        end
    end
end)
```

### Example 6: Spending Overview

```lua
RegisterCommand('spending', function(source, args, rawCommand)
    local stats, _ = exports.core:getCrimeSpendingStats(source)
    
    if stats then
        print('^3=== Crime Spending Summary ===^7')
        print('Total Spent: $' .. stats.totalSpent)
        print('Total Purchases: ' .. stats.purchaseCount)
        print('^2By Category:^7')
        for category, amount in pairs(stats.byCategory) do
            print('  ' .. category .. ': $' .. amount)
        end
    end
end)
```

---

## Crime Flow Example

### Typical Criminal Journey

```
1. Join Organization (Bloods)
   ├─ Commit Crime: Drug Dealing ($2,000 dirty)
   ├─ Commit Crime: Robbery ($5,000 dirty)
   └─ Total: $7,000 dirty money
   
2. Launder Money
   ├─ Start: Launder $7,000 via Casino (85% rate)
   ├─ Fee: $1,050 (15% cut)
   └─ Receive: $5,950 clean money
   
3. Spend Money
   ├─ Buy Pistol: $1,000
   ├─ Buy Body Armor: $3,000
   ├─ Buy Hacking Device: $5,000
   └─ Total Spent: $9,000
   
4. Repeat Cycle
   └─ More crimes → More dirty money → Launder → Spend
```

---

## Risk & Reward Balance

**Low Risk (Drug Dealing):**
- $2,000 reward
- 5% arrest chance
- 1 minute cooldown
- Small rewards, easily repeatable

**Medium Risk (Robbery):**
- $5,000 reward
- 15% arrest chance
- 5 minute cooldown
- Balanced risk/reward

**High Risk (Car Theft):**
- $8,000 reward
- 30% arrest chance
- 10 minute cooldown
- Substantial rewards, significant risk

**Extreme Risk (Bank Robbery):**
- $50,000 reward
- 50% arrest chance
- 1 hour cooldown
- Massive money, massive risk

---

## Features Summary

✅ **8 Crime Types** with varying rewards  
✅ **Crime Cooldowns** prevent spam  
✅ **5 Organizations** to join  
✅ **Risk System** with arrest mechanics  
✅ **Dirty Money Tracking** per player  
✅ **5 Laundering Methods** with fees  
✅ **Time-based Conversion** (60-180 seconds)  
✅ **25+ Illegal Items** to purchase  
✅ **Complete History** for all transactions  
✅ **Real-time Statistics** and progress tracking  

