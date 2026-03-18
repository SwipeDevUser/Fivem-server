# Contraband Crafting System
## Complete Illegal Item Manufacturing Framework

Comprehensive crafting system for manufacturing illegal items including drugs, explosives, contraband goods, and specialized equipment on your FiveM server.

---

## Features

### 🏭 Crafting Locations
- 5 fully configured crafting locations across the map
- Each location has unique characteristics and access levels
- Visible map markers (blips) for navigation
- Radius-based auto-detection when players are near

**Available Locations:**
- Downtown Laboratory (Downtown Orlando)
- Warehouse Lab (Industrial District)
- Back Alley Kitchen (Riverside)
- Farmhouse Lab (Rural Area)
- Apartment Micro-Lab (Waterford Lakes)

### 🧪 Crafting Categories

#### Drugs (6 Recipes)
- **Crack Cocaine** - Entry level, fast crafting (5 min)
- **MDMA/Ecstasy** - Pills with time investment
- **Cannabis Oil** - Most profitable at scale
- **Methamphetamine** - Volatile, high level (7 min)
- **Heroin** - Complex processing
- **Fentanyl** - Extremely dangerous, expert only
- **LSD** - Advanced compound synthesis

#### Explosives (4 Recipes)
- **Petrol Bomb (Molotov)** - Quick crafting, basic training
- **Pipe Bomb** - Fragmentation device (3 min)
- **Dynamite Sticks** - Multiple charges per craft
- **C4 Block** - Military-grade explosive (5 min)

#### Contraband Goods (5 Recipes)
- **Counterfeit Currency** - High risk, high reward
- **Fake ID Cards** - Document forgery
- **Lockpick Kits** - Professional burglary tools
- **GPS Trackers** - Surveillance equipment
- **Signal Jammers** - Communications disruption

#### Ammunition (2 Recipes)
- **Armor Piercing Rounds** - Penetrate body armor
- **Subsonic Ammunition** - Suppressor-compatible

**Total: 20+ Crafting Recipes**

### 📊 Skill System

**5 Skill Levels:**
- **Level 0 (Beginner)** - Learning phase, 40% failure rate
- **Level 1 (Novice)** - 5 crafts completed, 30% failure rate
- **Level 2 (Intermediate)** - 20 crafts completed, 20% failure rate
- **Level 3 (Advanced)** - 50 crafts completed, 10% failure rate
- **Level 4 (Master)** - 100 crafts completed, 5% failure rate

**Skill Progression:**
- Gain 1 skill point per successful craft
- Level up notifications at milestones (10, 20, 30 points)
- Failure reduces success rate but costs no ingredients
- Master level unlocks all advanced recipes

### ⚠️ Risk & Police Detection

**Police Dispatch System:**
- 70% chance police are alerted when crafting
- Risk level = wanted level increase (1-5 stars)
- Minimum 2 officers respond to calls
- Detection radius affects police response timing
- Alert messages include recipe type and danger level

**Risk Levels by Recipe:**
- Low (50): Lockpicks, cannabis oil
- Medium (100-150): Crack, counterfeit, LSD
- High (200-250): C4, fentanyl, signal jammer

### 🎮 Gameplay Mechanics

**Crafting Process:**
1. Navigate to crafting location
2. Press E to open crafting menu
3. Select recipe with sufficient skill level
4. Purchase ingredients from inventory
5. Confirm crafting attempt
6. Complete animation without moving
7. Success/failure determination
8. Receive output or lose ingredients (on failure)

**Success Determination:**
- Based on player skill level
- Random chance modified by skill tier
- Master craftsmen almost never fail
- Failed crafts consume ingredients and waste time
- Cancelled crafts have 50% ingredient penalty

**Inventory Integration:**
- Required ingredients checked before crafting
- Automatic removal when crafting starts
- Output automatically added to inventory
- Inventory full notification prevents crafting

### 📈 Statistics Tracking

**Per-Player Statistics:**
- Total crafts attempted
- Successful crafts completed
- Failed crafts
- Police alerts triggered
- Skill level progression
- Favorite recipe tracking

**Administrative Commands:**
- `/craftskill` - Check current skill level
- `/recipes` - List available recipes
- `/resetcraft` - Reset crafting skill (admin)

### 🛡️ Anti-Cheat Features

- Movement detection cancels crafting
- Server-side ingredient verification
- Output validation before giving items
- Police detection has server-side randomization
- Skill progression server-validated
- Activity logging for suspicious patterns

### 🎯 Integration Points

**Integrates With:**
- Core inventory system
- Police dispatch system
- Player data persistence
- Animation system
- Chat notification system
- Economy system (profit tracking)

---

## Configuration

### Adding New Recipes

Edit `config.lua` and add to `Config.Recipes`:

```lua
{
    id = "unique_id",
    name = "Item Name",
    category = "drugs",  -- or explosives, contraband, tools, ammunition
    time = 180,  -- seconds
    level = 1,  -- skill requirement
    ingredients = {
        {item = "item_name", amount = 1},
        {item = "item_name2", amount = 2}
    },
    output = {item = "output_item", amount = 1},
    risk = 100,  -- police alert level
    profit = 500,  -- estimated profit
    description = "Recipe description"
}
```

### Adding New Crafting Locations

Edit `config.lua` and add to `Config.CraftingLocations`:

```lua
{
    name = "Location Name",
    location = "District Name",
    coords = {x, y, z},
    blip = {sprite = 227, color = 1, scale = 0.8},
    access_level = 0,  -- 0 = public
    description = "Location description"
}
```

### Adjusting Police Detection

In `config.lua`, modify `Config.PoliceDetection`:

```lua
Config.PoliceDetection = {
    enabled = true,
    detection_radius = 150.0,  -- Distance radius
    dispatch_chance = 70,  -- % chance police respond
    alert_wanted_level = 2,  -- Wanted level given
    minimum_officers_responding = 2  -- Officers sent
}
```

---

## Commands

### Player Commands
- `/craftskill` - Display current crafting skill level
- `/recipes` - List all available recipes with skill requirements
- **E key near location** - Open crafting menu

### Admin Commands
- `/resetcraft` - Reset your crafting skill and statistics

---

## Usage Examples

### Beginner Player
1. Find location (GPS marker shows on map)
2. Approach and press E
3. Select "Crack Cocaine" (Level 0)
4. Confirm with ingredients
5. Stand still for 5 minutes while crafting
6. Receive 5 crack packages on success (60% chance)

### Advanced Player
1. Check `/craftskill` - Shows "Intermediate"
2. Go to warehouse location
3. Craft methamphetamine (7 minute, complex)
4. Only 20% failure chance at skill level 2
5. Gain 1 skill point toward "Advanced"
6. Police may dispatch (70% chance) with 2-3 officers

---

## Profit Analysis

### Low-Risk Activities
- Cannabis oil: 300 profit, 50 risk
- Subsonic ammo: 500 profit, 80 risk
- Lockpicks: 300 profit, 40 risk

### Medium-Risk Activities
- Crack cocaine: 500 profit, 100 risk
- MDMA pills: 600 profit, 80 risk
- Fake IDs: 500 profit, 80 risk

### High-Risk Activities
- Methamphetamine: 800 profit, 150 risk
- Heroin: 900 profit, 120 risk
- C4 Explosive: 1500 profit, 250 risk

**Business Strategy:**
- Beginners: Start with cannabis oil (low risk, steady income)
- Intermediate: Scale to methamphetamine (better profit margin)
- Advanced: Create C4 blocks (highest profit, significant police presence)

---

## Technical Details

### File Structure
```
contraband_crafting/
├── fxmanifest.lua          -- Resource manifest
├── config.lua              -- Configuration file
├── server.lua              -- Server-side logic
├── client.lua              -- Client-side logic
└── README.md               -- Documentation
```

### Events
- `contraband_crafting:playerLoaded` - Player initialized
- `contraband_crafting:startCrafting` - Begin crafting
- `contraband_crafting:cancelCrafting` - Stop crafting
- `contraband_crafting:performCrafting` - Animation trigger
- `contraband_crafting:craftingComplete` - Completion handler

### Exports
- `GetRecipes()` - Returns all recipes
- `GetCraftingLocations()` - Returns location data
- `GetPlayerStats(identifier)` - Player statistics
- `GetPlayerCraftingSkill(src)` - Current skill level

---

## System Requirements

- Core framework (modified for your framework)
- Inventory system integration
- Police dispatch system
- Animation system
- Chat notification system

---

## Version

**Version 1.0.0** - Initial release
- 20+ crafting recipes
- 5 crafting locations
- Full skill progression system
- Police detection & dispatch
- Statistics tracking
- Anti-cheat measures

---

## Support & Customization

All recipes, locations, and mechanics can be customized in `config.lua`. No code modifications necessary for most changes.

**Remember:** This is a roleplay system. Use responsibly and enforce proper server rules regarding illegal activities.

---

*Contraband Crafting System - Bringing Underground Economy to Life* 🏭💊⚗️
