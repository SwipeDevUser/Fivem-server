# Business Ownership & Management System

A comprehensive business management system for FiveM servers featuring business creation, employee management, and balance tracking.

## Features

### 1. Business Creation
- Create businesses with custom names and types
- Initial capital requirement ($50,000 default)
- Automatic balance initialization
- Business status tracking (active/inactive/bankrupt)

### 2. Employee Management
- Hire employees with role assignment
- Assign custom roles (Manager, Supervisor, etc.)
- Set employee salaries
- Fire employees from business
- Track employee hire dates

### 3. Financial Management
- Business balance tracking
- Deposit cash to business
- Withdraw cash from business
- Transaction history and logging
- Owner-only authorization

### 4. Business Information
- View detailed business information
- Track owner details
- Check business status
- View establishment dates
- Balance checking

## Commands

### Business Management
```
/createbusiness [name] [type] - Create a new business
/mybusinesses - List all your businesses
/businessinfo [id] - Get business information
```

### Employee Management
```
/employees [business_id] - List business employees
/hire [business_id] [player_id] [role] - Hire an employee
/fire [business_id] [employee_id] - Fire an employee
```

### Financial Operations
```
/businessdeposit [business_id] [amount] - Deposit cash to business
/businesswithdraw [business_id] [amount] - Withdraw cash from business
```

## Database Tables

### businesses
- Main business records
- Owner information
- Balance and status tracking
- Type and timestamps

### business_employees
- Employee roster
- Role assignments
- Salary tracking
- Hire dates

### business_transactions
- Financial transaction logs
- Deposits and withdrawals
- Salary payments
- Transaction descriptions

### business_logs
- Audit logs
- Action tracking
- Business activity history
- Player interactions

## Configuration

Edit `shared/config.lua` to customize:
- Business types
- Employee roles
- Starting capital amount
- Maximum employees per business
- Business locations

## Usage Examples

```lua
-- Create a new restaurant business
/createbusiness "Luigi's Pizza" "Restaurant"

-- View your businesses
/mybusinesses

-- Get business info (ID 1)
/businessinfo 1

-- Hire player 5 as Manager to business 1
/hire 1 5 Manager

-- Deposit $5000 to business 1
/businessdeposit 1 5000

-- Withdraw $2000 from business 1
/businesswithdraw 1 2000

-- List employees
/employees 1

-- Fire employee 3 from business 1
/fire 1 3
```

## Integration

This system integrates with:
- Core inventory for cash management
- User database for player identification
- Business logging for audit trails

## Authorization

- Only business owners can:
  - Hire/fire employees
  - Withdraw funds
  - Manage business settings
- Employees can be authorized to:
  - Deposit funds
  - View business information
  - Clock in/out for work
