-- Business System Client
print('^3[Business System] Client starting...^7')

local Config = require('shared.config')
local myBusinesses = {}
local currentBusiness = nil

RegisterNetEvent("business:infoLoaded")
AddEventHandler("business:infoLoaded", function(business)
    currentBusiness = business
    
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Business Info", business.name}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Owner", business.first_name .. " " .. business.last_name}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Balance", "$" .. business.balance}
    })
    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Status", business.status}
    })
end)

RegisterNetEvent("business:myBusinessesLoaded")
AddEventHandler("business:myBusinessesLoaded", function(businesses)
    myBusinesses = businesses

    if not businesses or #businesses == 0 then
        TriggerEvent("chat:addMessage", {
            color = {200, 200, 0},
            multiline = true,
            args = {"Businesses", "You don't own any businesses"}
        })
        return
    end

    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Businesses", "You own " .. #businesses .. " business(es)"}
    })

    for i, business in ipairs(businesses) do
        TriggerEvent("chat:addMessage", {
            color = {100, 200, 0},
            multiline = true,
            args = {"[" .. business.id .. "] " .. business.name, "Balance: $" .. business.balance}
        })
    end
end)

RegisterNetEvent("business:employeesLoaded")
AddEventHandler("business:employeesLoaded", function(employees)
    if not employees or #employees == 0 then
        TriggerEvent("chat:addMessage", {
            color = {200, 200, 0},
            multiline = true,
            args = {"Employees", "No employees"}
        })
        return
    end

    TriggerEvent("chat:addMessage", {
        color = {100, 200, 0},
        multiline = true,
        args = {"Employees", #employees .. " total employee(s)"}
    })

    for i, employee in ipairs(employees) do
        TriggerEvent("chat:addMessage", {
            color = {100, 200, 0},
            multiline = true,
            args = {"[" .. employee.id .. "] " .. employee.first_name .. " " .. employee.last_name, "Role: " .. employee.role}
        })
    end
end)

-- Create business
RegisterCommand("createbusiness", function(source, args, rawCommand)
    local businessName = args[1]
    local businessType = args[2]
    
    if not businessName or not businessType then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/createbusiness [name] [type]"}
        })
        return
    end

    TriggerServerEvent("business:create", businessName, businessType)
end, false)

-- Get business info
RegisterCommand("businessinfo", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    
    if not businessId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/businessinfo [business_id]"}
        })
        return
    end

    TriggerServerEvent("business:getInfo", businessId)
end, false)

-- List my businesses
RegisterCommand("mybusinesses", function(source, args, rawCommand)
    TriggerServerEvent("business:getMyBusinesses")
end, false)

-- Get employees
RegisterCommand("employees", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    
    if not businessId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/employees [business_id]"}
        })
        return
    end

    TriggerServerEvent("business:getEmployees", businessId)
end, false)

-- Hire employee
RegisterCommand("hire", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local playerId = tonumber(args[2])
    local role = args[3] or "Employee"
    
    if not businessId or not playerId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/hire [business_id] [player_id] [role]"}
        })
        return
    end

    TriggerServerEvent("business:hireEmployee", businessId, playerId, role)
end, false)

-- Fire employee
RegisterCommand("fire", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local employeeId = tonumber(args[2])
    
    if not businessId or not employeeId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/fire [business_id] [employee_id]"}
        })
        return
    end

    TriggerServerEvent("business:fireEmployee", businessId, employeeId)
end, false)

-- Deposit to business
RegisterCommand("businessdeposit", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if not businessId or not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/businessdeposit [business_id] [amount]"}
        })
        return
    end

    TriggerServerEvent("business:deposit", businessId, amount)
end, false)

-- Withdraw from business
RegisterCommand("businesswithdraw", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if not businessId or not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/businesswithdraw [business_id] [amount]"}
        })
        return
    end

    TriggerServerEvent("business:withdraw", businessId, amount)
end, false)

-- Pay employee
RegisterCommand("payemployee", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if not playerId or not amount then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/payemployee [player_id] [amount]"}
        })
        return
    end

    TriggerServerEvent("business:payEmployee", playerId, amount)
end, false)

-- Process payroll
RegisterCommand("payroll", function(source, args, rawCommand)
    local businessId = tonumber(args[1])
    
    if not businessId then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"Usage", "/payroll [business_id]"}
        })
        return
    end

    TriggerServerEvent("business:payroll", businessId)
end, false)

print('^3[Business System] Client ready^7')
