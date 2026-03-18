# Gameplay Features & Systems

## Core Systems

### Identity System
- Character creation during first login
- Customizable appearance (clothing, hair, tattoos)
- Character management (multiple characters per account)
- Character deletion with data retention

### Economy System
- **Jobs** provide legal income (police, EMS, taxi, etc.)
- **Payroll** system: Auto-payment every 30 minutes
- **Expenses**: Daily/weekly/monthly bills
- **Purchases**: Transaction history tracking
- **Dirty Money**: Criminal income that must be laundered

### Business System
```
Create Business → Stock Inventory → Process Sales → Pay Employees → Expand Business
```

**5 Business Types:**
- Restaurant ($50k startup, $500/sale)
- Nightclub ($100k startup, $1000/sale)
- Shop ($30k startup, $300/sale)
- Garage ($75k startup, $800/sale)
- Laundromat ($40k startup, $400/sale)

**Expansions Available:**
1. **Hiring** ($10k) - Add 5 employee slots
2. **Marketing** ($15k) - +20% revenue
3. **Inventory** ($8k) - +50% storage
4. **Quality** ($20k) - +30% revenue
5. **Location** ($50k) - +50% revenue
6. **Automation** ($30k) - -15% costs
7. **Security** ($25k) - -50% robbery risk

### Criminal System
**8 Crime Types:**
- Store Robbery: $5k-$10k reward
- House Burglary: $15k-$25k reward
- Vehicle Theft: $3k-$8k reward
- Armory Heist: $50k reward
- Bank Robbery: $100k reward (high risk)
- Drug Trafficking: $8k-$20k/run
- Contract Killing: $25k-$75k
- Gang Warfare: Varies by size

**Money Laundering:**
- 5 methods available
- Duration: 60-180 seconds
- Clean rate: 70-85%
- Risk: Police can intercept

**5 Criminal Organizations:**
- The Mafia
- Street Gangs
- Cartels
- Merchant Republic
- Cult

### Job System

**Available Jobs:**
- **Police** (5 grades)
- **EMS** (5 grades)
- **Firefighter** (5 grades)
- **Taxi Driver** (3 grades)
- **Mechanic** (5 grades)

**Job Features:**
- Salary based on grade
- Duty system (clock in/out)
- Job permissions
- Rank progression
- Uniform system

### Properties & Housing
- **Apartments**: $10k-$50k
- **Houses**: $50k-$500k
- **Commercial**: $100k-$1M
- Rental system for landlords
- Customizable interiors

### Inventory System
- Item weight limits
- Item categories (weapons, tools, drugs, etc.)
- Trading between players
- Drop system on death
- Sell to NPC merchants

## Admin Features

### Command System
```lua
/warn <id> [reason] - Warn player
/kick <id> [reason] - Kick player
/ban <id> [reason] - Ban permanently
/tban <id> <minutes> [reason] - Temporary ban
/mute <id> [duration] - Mute player
/jail <id> <minutes> [reason] - Jail player
/tp <id> - Teleport to player
/bring <id> - Bring player to you
/setjob <id> <job> <grade> - Set player job
/addmoney <id> <amount> - Add money to player
/givevehicle <model> - Spawn vehicle
/announce [message] - Server announcement
```

### Log Viewer
- Admin actions logged
- Player death logs
- Crime statistics
- Sale history
- Ban records
- Chat logs

## Customization

### Configuration Files
Located in `server/configs/` or `resources/core/config/`:

```
business.lua     - Business types, expansions, jobs
crime.lua        - Crimes, laundering methods, organizations
jobs.lua         - Job definitions, grades, salaries
roles.lua        - Admin roles and permissions
```

### Adding Business Types
```lua
-- In config/business.lua
Businesses.customType = {
    label = 'My Business',
    type = 'retail',
    baseCapital = 75000,
    baseRevenue = 700,
    maxEmployees = 12,
    inventory = {
        items = 200,
        supplies = 100,
    },
}
```

### Adding New Jobs
```lua
-- In config/jobs.lua
Jobs.custom_job = {
    label = 'Custom Job',
    grades = {
        [0] = {name = 'Rookie', salary = 400},
        [1] = {name = 'Veteran', salary = 600},
    }
}
```

### Adding Crimes
```lua
-- In config/crime.lua
Crimes.custom_crime = {
    label = 'Custom Crime',
    reward = 15000,
    riskLevel = 'high',
    cooldown = 600,
}
```

## Gameplay Balance

### Income Sources
- **Jobs**: $400-$3000 per paycheck (30-min cycle)
- **Business Sales**: $300-$1000 per sale
- **Crimes**: $3k-$100k per heist
- **Laundering**: Risk vs reward conversion
- **Trading**: Player-to-player commerce

### Expense System
- **Daily Bills**: $100-$500
- **Weekly Costs**: $500-$2000
- **Monthly Taxes**: Player/business percentage
- **Lawyer Fees**: $5000 if arrested

### Progression
- Level up through activities
- Unlock better jobs at higher level
- Better crime opportunities
- Discounts on purchases

## Events & Competitions

### Server Events
- Weekly racing competitions
- Monthly crime waves
- Seasonal events
- Holiday specials
- Community events

### Leaderboards
- Most money earned
- Most crimes committed
- Successful businesses
- Player kills (PvP)
- Playtime ranking

## Social Features

- Discord integration
- In-game chat (local, job, org, admin)
- Friend system
- Marriage/pairing
- Gang/org membership
- Faction wars

## Reporting & Moderation

### Player Reports
- In-game report command
- Report history tracking
- Auto-escalation to admins
- Appeal system

### Ticket System
- Support tickets
- Bug reports
- Appeal submissions
- Feedback channel

---

**Version:** 1.0.0  
**Last Updated:** March 2026
