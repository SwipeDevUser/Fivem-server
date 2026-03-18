-- Business Payroll System
-- Manages employee hiring, wages, and payroll

print('^2[Core] Business Payroll System loading...^7')

local BusinessConfig = require 'config/business'

-- Employee records
local employees = {}
local employeeIdCounter = 0

-- Hire employee
exports('hireEmployee', function(businessId, playerId, position)
    if not DoesPlayerExist(playerId) then
        return false, 'Player does not exist'
    end
    
    if not position then
        position = 'employee'
    end
    
    local jobPosition = BusinessConfig.JobPositions[string.lower(position)]
    if not jobPosition then
        return false, 'Invalid position'
    end
    
    -- Check if already employed by this business
    for _, emp in pairs(employees) do
        if emp.businessId == businessId and emp.playerId == playerId then
            return false, 'Player already employed'
        end
    end
    
    -- Create employee record
    employeeIdCounter = employeeIdCounter + 1
    local employeeId = employeeIdCounter
    
    employees[employeeId] = {
        id = employeeId,
        businessId = businessId,
        playerId = playerId,
        playerName = GetPlayerName(playerId),
        position = position,
        salary = jobPosition.salary,
        hiredAt = os.time(),
        active = true,
        hoursWorked = 0,
        totalEarned = 0,
    }
    
    print('^2[Payroll] Hired employee ' .. GetPlayerName(playerId) .. ' at business ' .. businessId .. ' as ' .. jobPosition.name .. '^7')
    
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = 'Hired',
        description = 'You are now employed as ' .. jobPosition.name .. '\nSalary: $' .. jobPosition.salary,
        type = 'success',
    })
    
    return true, 'Employee hired', employeeId
end)

-- Fire employee
exports('fireEmployee', function(businessId, employeeId, ownerPlayerId)
    if not DoesPlayerExist(ownerPlayerId) then
        return false, 'Owner does not exist'
    end
    
    if not employees[employeeId] then
        return false, 'Employee not found'
    end
    
    local employee = employees[employeeId]
    
    if employee.businessId ~= businessId then
        return false, 'Employee not from this business'
    end
    
    employee.active = false
    
    print('^3[Payroll] Fired employee ' .. employee.playerName .. ' from business ' .. businessId .. '^7')
    
    if DoesPlayerExist(employee.playerId) then
        TriggerClientEvent('ox_lib:notify', employee.playerId, {
            title = 'Fired',
            description = 'You have been fired from your job',
            type = 'error',
        })
    end
    
    return true, 'Employee fired'
end)

-- Get business employees
exports('getBusinessEmployees', function(businessId)
    local businessEmployees = {}
    
    for _, emp in pairs(employees) do
        if emp.businessId == businessId and emp.active then
            table.insert(businessEmployees, {
                id = emp.id,
                playerId = emp.playerId,
                playerName = emp.playerName,
                position = emp.position,
                salary = emp.salary,
                hoursWorked = emp.hoursWorked,
                totalEarned = emp.totalEarned,
            })
        end
    end
    
    return businessEmployees, 'Business employees retrieved'
end)

-- Promote employee
exports('promoteEmployee', function(businessId, employeeId, newPosition, ownerPlayerId)
    if not DoesPlayerExist(ownerPlayerId) then
        return false, 'Owner does not exist'
    end
    
    if not employees[employeeId] then
        return false, 'Employee not found'
    end
    
    local jobPosition = BusinessConfig.JobPositions[string.lower(newPosition)]
    if not jobPosition then
        return false, 'Invalid position'
    end
    
    local employee = employees[employeeId]
    employee.position = newPosition
    employee.salary = jobPosition.salary
    
    print('^2[Payroll] Promoted employee ' .. employee.playerName .. ' to ' .. jobPosition.name .. '^7')
    
    return true, 'Employee promoted'
end)

-- Process employee paycheck
exports('payEmployee', function(businessId, employeeId, ownerPlayerId)
    if not DoesPlayerExist(ownerPlayerId) then
        return false, 'Owner does not exist'
    end
    
    if not employees[employeeId] then
        return false, 'Employee not found'
    end
    
    local employee = employees[employeeId]
    
    if employee.businessId ~= businessId then
        return false, 'Employee not from this business'
    end
    
    if not DoesPlayerExist(employee.playerId) then
        return false, 'Employee not online'
    end
    
    local xPlayer = exports.core:getPlayer(employee.playerId)
    if not xPlayer then
        return false, 'Player not found'
    end
    
    -- Add salary
    xPlayer.addMoney(employee.salary)
    employee.totalEarned = employee.totalEarned + employee.salary
    
    print('^2[Payroll] Paid employee ' .. employee.playerName .. ' $' .. employee.salary .. '^7')
    
    TriggerClientEvent('ox_lib:notify', employee.playerId, {
        title = 'Paycheck',
        description = 'You received $' .. employee.salary .. ' from ' .. BusinessConfig.GetBusiness('restaurant').label .. ' (example)',
        type = 'success',
    })
    
    return true, 'Payment processed'
end)

-- Process all payroll for business
exports('processBusinessPayroll', function(businessId, ownerPlayerId)
    if not DoesPlayerExist(ownerPlayerId) then
        return false, 'Owner does not exist'
    end
    
    local businessEmployees = exports('getBusinessEmployees', businessId)
    local totalPaid = 0
    
    for _, emp in ipairs(businessEmployees) do
        exports('payEmployee', businessId, emp.id, ownerPlayerId)
        totalPaid = totalPaid + emp.salary
    end
    
    print('^2[Payroll] Processed payroll for business ' .. businessId .. ' ($' .. totalPaid .. ')^7')
    
    return true, 'Payroll processed', totalPaid
end)

-- Get employee info
exports('getEmployeeInfo', function(employeeId)
    if not employees[employeeId] then
        return nil, 'Employee not found'
    end
    
    return employees[employeeId], 'Employee info retrieved'
end)

-- Get total payroll cost
exports('getTotalPayrollCost', function(businessId)
    local totalCost = 0
    
    for _, emp in pairs(employees) do
        if emp.businessId == businessId and emp.active then
            totalCost = totalCost + emp.salary
        end
    end
    
    return totalCost, 'Total payroll cost calculated'
end)

-- Work employee hours
exports('addEmployeeHours', function(employeeId, hours)
    if not employees[employeeId] then
        return false, 'Employee not found'
    end
    
    employees[employeeId].hoursWorked = employees[employeeId].hoursWorked + hours
    
    return true, 'Hours added'
end)

print('^2[Core] Business Payroll System loaded^7')
