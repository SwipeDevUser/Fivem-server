# Job → Paycheck → Expenses → Purchases System

Complete economic system for player employment, income, financial obligations, and transactions.

## System Architecture

```
Job Assignment
    ↓
Paycheck (Salary)
    ↓
Expenses (Bills & Obligations)
    ↓
Purchases (Transactions)
```

---

## 1. Job System

### Overview
- 5+ job types (police, EMS, firefighter, taxi, mechanic, unemployed)
- Grade-based hierarchy with permissions
- Salary varies by job and grade

### Jobs Configuration

Edit `config/jobs.lua` to customize jobs:

```lua
police = {
    label = 'Police Officer',
    description = 'Enforce the law and protect citizens',
    type = 'government',
    grades = {
        [0] = {
            name = 'Cadet',
            salary = 500,
            permissions = {'police.basic'},
        },
        -- More grades...
    },
}
```

### Job API Functions

```lua
-- Set player job
local success, msg = exports.core:setPlayerJob(playerId, 'police', 2)

-- Get player job
local job, msg = exports.core:getPlayerJob(playerId)
-- Returns: {name, grade, label, salary, rank, permissions}

-- Check job permission
local canSearch = exports.core:hasJobPermission(playerId, 'police.search')

-- Promote player
local success, msg = exports.core:promotePlayer(playerId)

-- Demote player
local success, msg = exports.core:demotePlayer(playerId)

-- Get all jobs
local jobs, msg = exports.core:getAllJobs()

-- Get job info
local jobInfo, msg = exports.core:getJobInfo('police')

-- Remove job (set to unemployed)
local success, msg = exports.core:removePlayerJob(playerId)
```

---

## 2. Paycheck System

### Overview
- Automatic paycheck processing every 30 minutes
- Salary based on job and grade
- Notifications on payment received

### Paycheck API Functions

```lua
-- Start automated payroll
local success, msg = exports.core:startPayroll()

-- Stop payroll
local success, msg = exports.core:stopPayroll()

-- Manual paycheck (for admins)
local success, msg = exports.core:manualPaycheck(playerId)

-- Get last paycheck
local paycheck, msg = exports.core:getLastPaycheck(playerId)

-- Get payroll summary
local summary, msg = exports.core:getPayrollSummary()
-- Returns: {active, nextPaycheckIn, totalPlayers, paychecksProcessed}
```

### Paycheck Configuration

Edit `server/paycheck.lua`:

```lua
local PAYCHECK_INTERVAL = 30 * 60 * 1000  -- 30 minutes (in milliseconds)
```

---

## 3. Expenses System

### Overview
- Daily, weekly, and monthly bills
- Automatic deduction from player account
- Notifications on payment
- Custom player expenses

### Default Expenses

- **Rent**: $500/day
- **Food**: $100/day
- **Insurance**: $200/week
- **Phone Bill**: $50/month

### Expenses API Functions

```lua
-- Start automated expenses system
local success, msg = exports.core:startExpenses()

-- Stop expenses
local success, msg = exports.core:stopExpenses()

-- Get player expenses
local expenses, msg = exports.core:getPlayerExpenses(playerId)
-- Returns: {lastPaid, nextDue, daily, weekly, monthly, total}

-- Get all global expenses
local expensesList, msg = exports.core:getAllExpenses()

-- Add custom expense for player
local success, msg = exports.core:addPlayerExpense(playerId, 'Loan', 200, 'daily')
```

### Expenses Configuration

Edit `server/expenses.lua` or `config/jobs.lua`:

```lua
GlobalExpenses = {
    {
        name = 'Expense Name',
        amount = 500,
        description = 'Description',
        interval = 'daily',  -- 'daily', 'weekly', 'monthly'
    },
}
```

---

## 4. Purchase System

### Overview
- Player transactions and purchases
- Payment method selection (cash/bank)
- Purchase history tracking
- Refund processing
- Active purchase management

### Purchase Types

- Vehicle
- Property
- Business
- Item
- Service

### Purchase API Functions

```lua
-- Get player balance
local balance, msg = exports.core:getPlayerBalance(playerId)
-- Returns: {cash, bank, total}

-- Make a purchase
local success, msg = exports.core:makePurchase(playerId, {
    item = 'Motorcycle',
    price = 5000,
    paymentMethod = 'bank',  -- 'cash' or 'bank'
    type = 'vehicle',
    description = 'Used motorcycle',
    seller = 'Bike Shop',
})

-- Get purchase history (last 10)
local history, msg = exports.core:getPurchaseHistory(playerId, 10)

-- Get purchases by type
local vehicles, msg = exports.core:getPurchasesByType(playerId, 'vehicle')

-- Get total spending
local totalSpent, msg = exports.core:getTotalSpending(playerId)

-- Process refund
local success, msg = exports.core:processPurchaseRefund(playerId, purchaseIndex)

-- Create active purchase (for ongoing transactions)
local success, purchaseId = exports.core:createActivePurchase(playerId, 'Car', 25000, sellerPlayerId)

-- Confirm active purchase
local success, msg = exports.core:confirmActivePurchase(purchaseId)

-- Cancel active purchase
local success, msg = exports.core:cancelActivePurchase(purchaseId)
```

---

## Usage Examples

### Example 1: Employment System

```lua
-- Command to hire player
RegisterCommand('hire', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local jobName = args[2] or 'unemployed'
    local grade = tonumber(args[3]) or 0
    
    if not targetId then
        print('Usage: /hire [id] [job] [grade]')
        return
    end
    
    local success, msg = exports.core:setPlayerJob(targetId, jobName, grade)
    if success then
        print('^2[Jobs] ' .. GetPlayerName(targetId) .. ' hired as ' .. jobName .. '^7')
    end
end)
```

### Example 2: Job-Based Access Control

```lua
-- Only allow police to use search command
RegisterCommand('search', function(source, args, rawCommand)
    local hasPermission = exports.core:hasJobPermission(source, 'police.search')
    
    if not hasPermission then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You do not have permission to search',
            type = 'error'
        })
        return
    end
    
    -- Search logic here
end)
```

### Example 3: Automatic Payroll

```lua
-- Initialize payroll on server start
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'core' then
        Wait(2000)
        exports.core:startPayroll()
        exports.core:startExpenses()
        print('^2[Economy] Payroll and expenses systems active^7')
    end
end)
```

### Example 4: Income from Jobs

```lua
-- Job-based income (e.g., taxi driver earning from fares)
RegisterCommand('farecomplete', function(source, args, rawCommand)
    local fare = tonumber(args[1]) or 100
    
    local job, _ = exports.core:getPlayerJob(source)
    
    if job.name == 'taxi' then
        local xPlayer = exports.core:getPlayer(source)
        xPlayer.addMoney(fare)
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Fare Completed',
            description = 'You earned $' .. fare,
            type = 'success'
        })
    end
end)
```

### Example 5: Purchase History

```lua
-- View purchase history
RegisterCommand('purchases', function(source, args, rawCommand)
    local limit = tonumber(args[1]) or 5
    local history, msg = exports.core:getPurchaseHistory(source, limit)
    
    print('^2=== Purchase History (Last ' .. limit .. ') ===^7')
    for i, purchase in ipairs(history) do
        print('^3[' .. i .. ']^7 ' .. purchase.item .. ' - $' .. purchase.price .. 
              ' (' .. os.date('%Y-%m-%d', purchase.timestamp) .. ')')
    end
end)
```

### Example 6: Custom Business Transactions

```lua
-- Shop system with purchases
RegisterCommand('buy', function(source, args, rawCommand)
    local itemName = args[1]
    local itemPrice = tonumber(args[2])
    
    if not itemName or not itemPrice then
        print('Usage: /buy [item] [price]')
        return
    end
    
    local success, msg = exports.core:makePurchase(source, {
        item = itemName,
        price = itemPrice,
        paymentMethod = 'cash',
        type = 'item',
        description = 'Shop purchase',
        seller = 'General Store',
    })
    
    if success then
        -- Give item to player
        print('^2[Shop] Purchase successful!^7')
    end
end)
```

### Example 7: Balance Checking

```lua
-- Check player balance
RegisterCommand('balance', function(source, args, rawCommand)
    local balance, _ = exports.core:getPlayerBalance(source)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Account Balance',
        description = 'Cash: $' .. balance.cash .. '\nBank: $' .. balance.bank .. '\nTotal: $' .. balance.total,
        type = 'info'
    })
end)
```

---

## Payment Flow

### Player Earning Money
1. Job assigned with salary
2. Payroll runs every 30 minutes
3. Salary added to player cash
4. Notification sent to player

### Player Paying Bills
1. Expenses system checks daily
2. Calculates total bills (daily + periodic)
3. Deducts from player cash
4. Notification sent if insufficient funds

### Player Making Purchase
1. Customer specifies item and price
2. System checks payment method balance
3. If sufficient funds, money is deducted
4. Purchase recorded in history
5. Confirmation notification sent

---

## Economic Flow Summary

```
┌─────────────────────────────────────────────┐
│          PLAYER JOINS SERVER                │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│   Assigned Job (Job Hierarchy)              │
│   - Job Name                                │
│   - Grade/Rank                              │
│   - Salary Amount                           │
└──────────────┬──────────────────────────────┘
               │
               ▼ (Every 30 minutes)
┌─────────────────────────────────────────────┐
│   Paycheck Processed                        │
│   - Salary added to cash                    │
│   - Notification sent                       │
└──────────────┬──────────────────────────────┘
               │
               ▼ (Daily check)
┌─────────────────────────────────────────────┐
│   Expenses Deducted                         │
│   - Rent, food, insurance, bills            │
│   - Total removed from cash                 │
│   - Warning if insufficient funds           │
└──────────────┬──────────────────────────────┘
               │
               ▼ (On-demand)
┌─────────────────────────────────────────────┐
│   Purchases Made                            │
│   - Item bought                             │
│   - Money deducted (cash/bank)              │
│   - History recorded                        │
│   - Can refund                              │
└─────────────────────────────────────────────┘
```

---

## Features Summary

✅ **5 Job Types** with grades and permissions  
✅ **Automatic Payroll** every 30 minutes  
✅ **Dynamic Expenses** (daily, weekly, monthly)  
✅ **Purchase History** tracking  
✅ **Refund System** for transactions  
✅ **Payment Methods** (cash/bank selection)  
✅ **Real-time Notifications** for all transactions  
✅ **Balance Checking** anytime  
✅ **Customizable** jobs, salaries, and expenses  

