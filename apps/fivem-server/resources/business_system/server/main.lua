-- Business System Server
print('^3[Business System] Server starting...^7')

local Config = require('shared.config')
local Business = require('server.utils')

-- Create business
RegisterNetEvent("business:create")
AddEventHandler("business:create", function(name, businessType)
    local src = source
    local player = Core.GetPlayer(src)

    if not name or not businessType then
        TriggerClientEvent("core:notify", src, "Invalid business data")
        return
    end

    Core.DB.execute(
        "INSERT INTO businesses (name, owner_id, type, balance) VALUES (?, ?, ?, ?)",
        { name, player.id, businessType, Config.StartingBalance },
        function(result)
            if result then
                TriggerClientEvent("core:notify", src, "Business '" .. name .. "' created! Starting balance: $" .. Config.StartingBalance)
            end
        end
    )
end)

-- Get business info
RegisterNetEvent("business:getInfo")
AddEventHandler("business:getInfo", function(businessId)
    local src = source

    Core.DB.fetch(
        "SELECT b.*, u.first_name, u.last_name FROM businesses b LEFT JOIN users u ON b.owner_id = u.id WHERE b.id = ?",
        { businessId },
        function(result)
            if result and #result > 0 then
                TriggerClientEvent("business:infoLoaded", src, result[1])
            else
                TriggerClientEvent("core:notify", src, "Business not found")
            end
        end
    )
end)

-- Get player businesses
RegisterNetEvent("business:getMyBusinesses")
AddEventHandler("business:getMyBusinesses", function()
    local src = source

    local query = "SELECT * FROM businesses WHERE owner_id = ? ORDER BY established_at DESC"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { src }, function(result)
            TriggerClientEvent("business:myBusinessesLoaded", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
    local player = Core.GetPlayer(src)

    Core.DB.fetch(
        "SELECT * FROM businesses WHERE owner_id = ? ORDER BY established_at DESC",
        { player.id },
        function(result)
            TriggerClientEvent("business:myBusinessesLoaded", src, result or {})
        end
    )not businessId or not playerId or not role then
        TriggerClientEvent("core:notify", src, "Invalid employee data")
        return
    end

    -- Check if player owns business
    local checkQuery = "SELECT owner_id FROM businesses WHERE id = ?"
    
    if exports and exports['oxmysql'] then
    Core.DB.fetch(
        "SELECT owner_id FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 and result[1].owner_id == Core.GetPlayer(src).id then
                -- Hire employee
                Core.DB.execute(
                    "INSERT INTO business_employees (business_id, player_id, role) VALUES (?, ?, ?)",
                    { businessId, playerId, role },
                    function()
                        TriggerClientEvent("core:notify", src, "Employee hired!")
                    end
                )
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end
    )business employees
RegisterNetEvent("business:getEmployees")
AddEventHandler("business:getEmployees", function(businessId)
    local src = source

    local query = "SELECT be.*, u.first_name, u.last_name FROM business_employees be LEFT JOIN users u ON be.player_id = u.id WHERE business_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(query, { businessId }, function(result)
            TriggerClientEvent("business:employeesLoaded", src, result or {})
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(query, { businessId }, function(result)
            TriggerClientEvent("business:employeesLoaded", src, result or {})
        end)
    Core.DB.fetch(
        "SELECT be.*, u.first_name, u.last_name FROM business_employees be LEFT JOIN users u ON be.player_id = u.id WHERE business_id = ?",
        { businessId },
        function(result)
            TriggerClientEvent("business:employeesLoaded", src, result or {})
        end
    )
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(checkQuery, { businessId }, function(result)
            if result and #result > 0 and result[1].owner_id == src then
                -- Fire employee
                local fireQuery = "DELETE FROM business_employees WHERE id = ? AND business_id = ?"
                exports['oxmysql']:execute(fireQuery, { employeeId, businessId })
                
                TriggerClientEvent("core:notify", src, "Employee fired!")
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end)
    Core.DB.fetch(
        "SELECT owner_id FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 and result[1].owner_id == Core.GetPlayer(src).id then
                -- Fire employee
                Core.DB.execute(
                    "DELETE FROM business_employees WHERE id = ? AND business_id = ?",
                    { employeeId, businessId },
                    function()
                        TriggerClientEvent("core:notify", src, "Employee fired!")
                    end
                )
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end
    )Check if player is employee or owner
    local authQuery = "SELECT owner_id FROM businesses WHERE id = ? AND owner_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(authQuery, { businessId, src }, function(result)

    if not businessId or not amount or amount <= 0 then
        TriggerClientEvent("core:notify", src, "Invalid deposit data")
        return
    end

    -- Check if player is authorized
    Core.DB.fetch(
        "SELECT owner_id FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 and result[1].owner_id == Core.GetPlayer(src).id then
                -- Update business balance
                Core.DB.execute(
                    "UPDATE businesses SET balance = balance + ? WHERE id = ?",
                    { amount, businessId },
                    function()
                        -- Log transaction
                        Core.DB.execute(
                            "INSERT INTO business_transactions (business_id, type, amount, made_by) VALUES (?, 'deposit', ?, ?)",
                            { businessId, amount, Core.GetPlayer(src).id }
                        )
                        TriggerClientEvent("core:notify", src, "Deposited $" .. amount .. " to business")
                    end
                )
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end
    )

    -- Check if player owns business
    local authQuery = "SELECT owner_id, balance FROM businesses WHERE id = ? AND owner_id = ?"
    
    if exports and exports['oxmysql'] then
        exports['oxmysql']:fetch(authQuery, { businessId, src }, function(result)
            if result and #result > 0 then
                if result[1].balance < amount then
                    TriggerClientEvent("core:notify", src, "Insufficient business funds")
                    return
                end

                -- Add cash to inventory
                local success = Core.AddItem(src, 'cash', amount)
                
                if not success then
                    TriggerClientEvent("core:notify", src, "Inventory full")
                    return
                end

                -- Remove from business
                local updateQuery = "UPDATE businesses SET balance = balance - ? WHERE id = ?"
                exports['oxmysql']:execute(updateQuery, { amount, businessId })

                -- Log transaction
                local logQuery = "INSERT INTO business_transactions (business_id, type, amount, made_by) VALUES (?, 'withdrawal', ?, ?)"
                exports['oxmysql']:execute(logQuery, { businessId, amount, src })

                TriggerClientEvent("core:notify", src, "Withdrew $" .. amount .. " from business")
                TriggerClientEvent("inventory:update", src, Core.GetInventory(src).slots)
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end)
    elseif exports and exports['ghmattimysql'] then
        exports['ghmattimysql']:execute(authQuery, { businessId, src }, function(result)
            if result and #result > 0 then
                if result[1].balance < amount then
                    TriggerClientEvent("core:notify", src, "Insufficient business funds")
                    return
                end

                local success = Core.AddItem(src, 'cash', amount)
                
                if not success then
                    TriggerClientEvent("core:notify", src, "Inventory full")
                    return
                end

                local updateQuery = "UPDATE businesses SET balance = balance - ? WHERE id = ?"
                exports['ghmattimysql']:execute(updateQuery, { amount, businessId })

                local logQuery = "INSERT INTO business_transactions (business_id, type, amount, made_by) VALUES (?, 'withdrawal', ?, ?)"

    if not businessId or not amount or amount <= 0 then
        TriggerClientEvent("core:notify", src, "Invalid withdrawal data")
        return
    end

    -- Check if player owns business
    Core.DB.fetch(
        "SELECT owner_id, balance FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 and result[1].owner_id == Core.GetPlayer(src).id then
                if result[1].balance < amount then
                    TriggerClientEvent("core:notify", src, "Insufficient business funds")
                    return
                end

                -- Remove from business
                Core.DB.execute(
                    "UPDATE businesses SET balance = balance - ? WHERE id = ?",
                    { amount, businessId },
                    function()
                        -- Log transaction
                        Core.DB.execute(
                            "INSERT INTO business_transactions (business_id, type, amount, made_by) VALUES (?, 'withdrawal', ?, ?)",
                            { businessId, amount, Core.GetPlayer(src).id }
                        )
                        TriggerClientEvent("core:notify", src, "Withdrew $" .. amount .. " from business")
                    end
                )
            else
                TriggerClientEvent("core:notify", src, "Not authorized")
            end
        end
    )
end)

-- Pay employee
RegisterNetEvent("business:payEmployee")
AddEventHandler("business:payEmployee", function(target, amount)
    local src = source

    if not target or not amount or amount <= 0 then
        TriggerClientEvent("core:notify", src, "Invalid payment data")
        return
    end

    local player = Core.GetPlayer(target)
    if not player then
        TriggerClientEvent("core:notify", src, "Player not found")
        return
    end

    player.addMoney("bank", amount)

    -- Log transaction
    Core.DB.execute(
        "INSERT INTO business_transactions (business_id, type, amount, made_by, description) VALUES (?, 'withdrawal', ?, ?, ?)",
        { 0, amount, Core.GetPlayer(src).id, 'Employee Salary - Player ' .. target }
    )

    TriggerClientEvent("core:notify", src, "Paid $" .. amount .. " to Player " .. target)
    TriggerClientEvent("core:notify", target, "Received $" .. amount .. " salary from business")
end)

-- Pay all employees (bulk payroll)
RegisterNetEvent("business:payroll")
AddEventHandler("business:payroll", function(businessId)
    local src = source

    if not businessId then
        TriggerClientEvent("core:notify", src, "Invalid business ID")
        return
    end

    -- Check if player owns business
    Core.DB.fetch(
        "SELECT owner_id, balance FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if not result or #result == 0 or result[1].owner_id ~= Core.GetPlayer(src).id then
                TriggerClientEvent("core:notify", src, "Not authorized")
                return
            end

            -- Get all employees with salaries
            Core.DB.fetch(
                "SELECT be.id, be.player_id, be.salary FROM business_employees be WHERE be.business_id = ? AND be.salary > 0",
                { businessId },
                function(employees)
                    if not employees or #employees == 0 then
                        TriggerClientEvent("core:notify", src, "No employees to pay")
                        return
                    end

                    local totalPayroll = 0
                    for _, employee in ipairs(employees) do
                        totalPayroll = totalPayroll + employee.salary
                    end

                    -- Check business has enough funds
                    if result[1].balance < totalPayroll then
                        TriggerClientEvent("core:notify", src, "Insufficient business funds. Need $" .. totalPayroll)
                        return
                    end

                    -- Process payroll
                    for _, employee in ipairs(employees) do
                        local player = Core.GetPlayer(employee.player_id)
                        if player then
                            player.addMoney("bank", employee.salary)
                        end
                    end

                    -- Deduct from business
                    Core.DB.execute(
                        "UPDATE businesses SET balance = balance - ? WHERE id = ?",
                        { totalPayroll, businessId },
                        function()
                            -- Log transaction
                            Core.DB.execute(
                                "INSERT INTO business_transactions (business_id, type, amount, made_by, description) VALUES (?, 'withdrawal', ?, ?, ?)",
                                { businessId, totalPayroll, Core.GetPlayer(src).id, 'Payroll - ' .. #employees .. ' employees' }
                            )

                            TriggerClientEvent("core:notify", src, "Payroll processed! Paid $" .. totalPayroll .. " to " .. #employees .. " employee(s)")
                        end
                    )
                end
            )
        end
    )
end)

print('^3[Business System] Server ready^7')

-- Export business utilities for other resources
exports('BusinessSale', Business.Sale)
exports('BusinessExpense', Business.Expense)
exports('BusinessGetBalance', Business.GetBalance)
exports('BusinessAddLog', Business.AddLog)