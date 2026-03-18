# Business System: Inventory → Sales → Payroll → Expansion

Complete business management system for FiveM RP servers including inventory management, sales processing, employee payroll, and business expansions.

## System Architecture

```
Business Creation
    ↓
Inventory Management
    ↓
Sales Processing
    ↓
Employee Payroll
    ↓
Business Expansion & Upgrades
```

---

## 1. Business Management

### Overview
- Create and manage multiple businesses
- 5 business types (restaurant, nightclub, shop, garage, laundromat)
- Business accounts with deposits/withdrawals
- Complete financial tracking

### Business Types

| Type | Capital | Base Revenue | Max Employees | Examples |
|------|---------|--------------|---------------|----------|
| Restaurant | $50k | $500/sale | 10 | Food, Dining |
| Nightclub | $100k | $1000/sale | 15 | Entertainment |
| Shop | $30k | $300/sale | 5 | General Store |
| Garage | $75k | $800/sale | 8 | Auto Repair |
| Laundromat | $40k | $400/sale | 3 | Laundry |

### Business API Functions

```lua
-- Create new business
local success, msg, businessId = exports.core:createBusiness(playerId, 'restaurant', 'Tony\'s Restaurant')

-- Get business info
local info, msg = exports.core:getBusinessInfo(businessId)
-- Returns: {id, name, type, owner, balance, revenue, expenses, employees, level}

-- Get player businesses
local businesses, msg = exports.core:getPlayerBusinesses(playerId)

-- Deposit to business
local success, msg = exports.core:depositToBusinessAccount(businessId, playerId, 5000)

-- Withdraw from business
local success, msg = exports.core:withdrawFromBusinessAccount(businessId, playerId, 2000)

-- Get all businesses
local allBusinesses, msg = exports.core:getAllBusinesses()

-- Delete business
local success, msg = exports.core:deleteBusiness(businessId, playerId)
```

---

## 2. Inventory System

### Overview
- Track business inventory for items, supplies, food, etc.
- Capacity management
- Automatic restocking
- Per-item quantity tracking

### Inventory API Functions

```lua
-- Add item to inventory
local success, msg = exports.core:addBusinessInventory(businessId, 'food', 50)

-- Remove item from inventory
local success, msg = exports.core:removeBusinessInventory(businessId, 'food', 10)

-- Get full inventory
local inventory, msg = exports.core:getBusinessInventory(businessId)

-- Get specific item count
local count, msg = exports.core:getInventoryItemCount(businessId, 'food')

-- Check capacity
local canAdd, current, max = exports.core:checkInventoryCapacity(businessId, 500)

-- Restock item
local success, msg, restockCost = exports.core:restockBusinessInventory(businessId, 'food', 100, 5)

-- Clear inventory
local success, msg = exports.core:clearBusinessInventory(businessId)
```

---

## 3. Sales System

### Overview
- Process customer sales
- Revenue tracking (daily, weekly, monthly)
- Sale history with customer info
- Sales statistics and analytics

### Sales API Functions

```lua
-- Process sale
local success, msg, revenue = exports.core:processSale(businessId, customerId, 'burger', 2, 15)

-- Get sales history
local history, msg = exports.core:getSalesHistory(businessId, 20)

-- Get daily sales
local dailyTotal, msg = exports.core:getDailySales(businessId)

-- Get weekly sales
local weeklyTotal, msg = exports.core:getWeeklySales(businessId)

-- Get monthly sales
local monthlyTotal, msg = exports.core:getMonthlySales(businessId)

-- Get sales statistics
local stats, msg = exports.core:getSalesStatistics(businessId)
-- Returns: {totalSales, totalQuantity, totalTransactions, averageTransaction}

-- Clear sales history
local success, msg = exports.core:clearSalesHistory(businessId)
```

---

## 4. Payroll System

### Overview
- Hire and fire employees
- Multiple job positions with different salaries
- Promote employees
- Process individual or bulk payroll

### Employee Positions

| Position | Salary | Permissions |
|----------|--------|-------------|
| Owner | Profit % | Full access |
| Manager | $1,500 | Manage + Inventory |
| Employee | $500 | Sell items |
| Cashier | $550 | Sell + Inventory |
| Chef | $800 | Production |

### Payroll API Functions

```lua
-- Hire employee
local success, msg, empId = exports.core:hireEmployee(businessId, playerId, 'cashier')

-- Fire employee
local success, msg = exports.core:fireEmployee(businessId, empId, ownerPlayerId)

-- Get business employees
local employees, msg = exports.core:getBusinessEmployees(businessId)

-- Promote employee
local success, msg = exports.core:promoteEmployee(businessId, empId, 'manager', ownerPlayerId)

-- Pay single employee
local success, msg = exports.core:payEmployee(businessId, empId, ownerPlayerId)

-- Process all payroll
local success, msg, totalPaid = exports.core:processBusinessPayroll(businessId, ownerPlayerId)

-- Get employee info
local empInfo, msg = exports.core:getEmployeeInfo(empId)

-- Get total payroll cost
local totalCost, msg = exports.core:getTotalPayrollCost(businessId)

-- Add work hours
local success, msg = exports.core:addEmployeeHours(empId, 8)
```

---

## 5. Expansion System

### Overview
- Multiple expansion types for business improvement
- Revenue multipliers, cost reductions
- Employee slot expansion
- Security/robbery risk reduction

### Available Expansions

| Expansion | Cost | Bonus | Type |
|-----------|------|-------|------|
| Hiring | $10k | +5 employees | Capacity |
| Marketing | $15k | +20% revenue | Revenue |
| Inventory | $8k | +50% storage | Capacity |
| Quality | $20k | +30% revenue | Revenue |
| Location | $50k | +50% revenue | Revenue |
| Automation | $30k | -15% costs | Cost |
| Security | $25k | -50% robbery | Security |

### Expansion API Functions

```lua
-- Check if has expansion
local hasIt = exports.core:hasExpansion(businessId, 'marketing')

-- Purchase expansion
local success, msg, expData = exports.core:purchaseExpansion(businessId, 'marketing', ownerPlayerId)

-- Get purchased expansions
local expansions, msg = exports.core:getBusinessExpansions(businessId)

-- Get available expansions
local available, msg = exports.core:getAvailableExpansions(businessId)

-- Get expansion info  
local expInfo, msg = exports.core:getExpansionInfo('marketing')

-- Calculate business level
local level = exports.core:calculateBusinessLevel(businessId)

-- Get expansion cost
local cost = exports.core:getExpansionCost('marketing')

-- Get total expansion spending
local totalSpent, msg = exports.core:getTotalExpansionCost(businessId)

-- Get expansion benefits (multipliers)
local benefits, msg = exports.core:getExpansionBenefits(businessId)

-- Remove expansion (debugging)
local success, msg = exports.core:removeExpansion(businessId, 'marketing')
```

---

## Usage Examples

### Example 1: Create and Setup Business

```lua
RegisterCommand('startbusiness', function(source, args, rawCommand)
    local businessType = args[1] or 'restaurant'
    local businessName = args[2] or 'My Business'
    
    -- Create business
    local success, msg, businessId = exports.core:createBusiness(source, businessType, businessName)
    
    if success then
        print('^2[Business] Created: ' .. businessName .. ' (ID: ' .. businessId .. ')^7')
        
        -- Deposit starting capital
        exports.core:depositToBusinessAccount(businessId, source, 10000)
        
        -- Add inventory
        exports.core:addBusinessInventory(businessId, 'food', 100)
        exports.core:addBusinessInventory(businessId, 'drinks', 100)
        
        print('^2[Business] Business setup complete^7')
    end
end)
```

### Example 2: Process Sale

```lua
RegisterCommand('makesale', function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local itemName = args[2] or 'burger'
    local qty = tonumber(args[3]) or 1
    
    -- Deduct from inventory
    local hasItem = exports.core:removeBusinessInventory(businessId, itemName, qty)
    
    if hasItem then
        -- Process sale
        local success, msg, revenue = exports.core:processSale(businessId, source, itemName, qty, 15)
        
        if success then
            print('^2[Sales] Sale completed: $' .. revenue .. '^7')
        end
    end
end)
```

### Example 3: Manage Employees

```lua
RegisterCommand('hirestaff', function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local targetId = tonumber(args[2])
    local position = args[3] or 'employee'
    
    -- Hire employee
    local success, msg, empId = exports.core:hireEmployee(businessId, targetId, position)
    
    if success then
        print('^2[Business] Hired employee: ' .. GetPlayerName(targetId) .. '^7')
    end
end)

RegisterCommand('payemployees', function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    
    -- Process all payroll
    local success, msg, totalPaid = exports.core:processBusinessPayroll(businessId, source)
    
    if success then
        print('^2[Payroll] Paid $' .. totalPaid .. ' to all employees^7')
    end
end)
```

### Example 4: Business Expansion

```lua
RegisterCommand('expandbusiness', function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local expansion = args[2] or 'marketing'
    
    -- Purchase expansion
    local success, msg, expData = exports.core:purchaseExpansion(businessId, expansion, source)
    
    if success then
        print('^2[Expansion] ' .. msg .. ': ' .. expData.name .. '^7')
        
        -- Check new level
        local newLevel = exports.core:calculateBusinessLevel(businessId)
        print('^2[Expansion] Business now level ' .. newLevel .. '^7')
    end
end)
```

### Example 5: Business Analytics

```lua
RegisterCommand('businessstats', function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    
    local info, _ = exports.core:getBusinessInfo(businessId)
    local daily, _ = exports.core:getDailySales(businessId)
    local expenses, _ = exports.core:getTotalPayrollCost(businessId)
    local expansions, _ = exports.core:getBusinessExpansions(businessId)
    
    print('^3=== ' .. info.name .. ' ===^7')
    print('Balance: $' .. info.balance)
    print('Today Revenue: $' .. daily)
    print('Payroll Cost: $' .. expenses)
    print('Expansions: ' .. #expansions)
    print('Employees: ' .. info.employees .. '/' .. info.maxEmployees)
end)
```

---

## Business Flow Example

### Complete Business Lifecycle

```
1. CREATION
   ├─ Player has $50k+ capital
   ├─ Creates restaurant business
   └─ Gets Business ID #1
   
2. SETUP
   ├─ Stock inventory (food, drinks)
   ├─ Hire employees (Manager, Cashiers)
   └─ Set prices per item
   
3. OPERATIONS
   ├─ Customers make sales
   ├─ Revenue added to business account
   ├─ Employee hours tracked
   └─ Inventory automatically deducted
   
4. PAYROLL (Weekly)
   ├─ Owner initiates payroll
   ├─ Each employee receives salary
   ├─ Funds deducted from business account
   └─ Notifications sent to employees
   
5. EXPANSION
   ├─ Owner buys "Marketing" expansion ($15k)
   ├─ Revenue now 20% higher
   ├─ Business level increases
   ├─ More customers attracted
   └─ Repeat cycle with higher income
   
6. GROWTH
   ├─ Buy more expansions
   ├─ Hire more employees
   ├─ Expand inventory capacity
   └─ Business becomes profitable venture
```

---

## Financial Example

### Daily Revenue Calculation

```
Base Sale = 2 burgers × $15 = $30
Daily Sales = 50 transactions = $1,500

Without Expansions:
└─ Daily Revenue: $1,500

With Expansions (Marketing + Quality + Location):
├─ Marketing: ×1.2
├─ Quality: ×1.3
├─ Location: ×1.5
└─ Total Multiplier: 1.2 × 1.3 × 1.5 = 2.34
└─ Revenue: $1,500 × 2.34 = $3,510/day

Monthly Revenue: $3,510 × 30 = $105,300
Staff Payroll: 8 employees × $500 × 30 = $120,000
Net Profit: $105,300 - $120,000 = -$14,700 (need more expansion!)
```

---

## Features Summary

✅ **5 Business Types** with different capital requirements  
✅ **Inventory Management** with capacity tracking  
✅ **Sales Processing** with revenue tracking  
✅ **Employee System** with 5 position types  
✅ **Payroll Processing** individual or bulk  
✅ **7 Expansions** with various benefits  
✅ **Revenue Multipliers** up to 2.34x  
✅ **Complete Analytics** (daily/weekly/monthly)  
✅ **Business Levels** based on expansions  
✅ **Financial Tracking** deposits/withdrawals  

