-- Business Utilities
local Business = {}

function Business.Sale(businessId, amount, description)
    if not businessId or not amount or amount <= 0 then
        return false
    end

    Core.DB.execute(
        "UPDATE businesses SET balance = balance + ? WHERE id = ?",
        { amount, businessId }
    )

    -- Log transaction
    Core.DB.execute(
        "INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, 'deposit', ?, ?)",
        { businessId, amount, description or 'Sale' }
    )

    return true
end

function Business.Expense(businessId, amount, description)
    if not businessId or not amount or amount <= 0 then
        return false
    end

    -- Check balance
    Core.DB.fetch(
        "SELECT balance FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 and result[1].balance >= amount then
                Core.DB.execute(
                    "UPDATE businesses SET balance = balance - ? WHERE id = ?",
                    { amount, businessId }
                )

                -- Log transaction
                Core.DB.execute(
                    "INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, 'withdrawal', ?, ?)",
                    { businessId, amount, description or 'Expense' }
                )

                return true
            end
            return false
        end
    )
end

function Business.GetBalance(businessId)
    Core.DB.fetch(
        "SELECT balance FROM businesses WHERE id = ?",
        { businessId },
        function(result)
            if result and #result > 0 then
                return result[1].balance
            end
            return 0
        end
    )
end

function Business.AddLog(businessId, playerId, action, details)
    Core.DB.execute(
        "INSERT INTO business_logs (business_id, player_id, action, details) VALUES (?, ?, ?, ?)",
        { businessId, playerId, action, details }
    )
end

function Business.PayEmployee(targetId, amount, businessId)
    if not targetId or not amount or amount <= 0 then
        return false
    end

    local player = Core.GetPlayer(targetId)
    if not player then
        return false
    end

    player.addMoney("bank", amount)

    -- Log transaction
    Core.DB.execute(
        "INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, 'withdrawal', ?, ?)",
        { businessId or 0, amount, 'Employee Payment - Player ' .. targetId }
    )

    return true
end

function Business.ProcessPayroll(businessId, employees)
    if not businessId or not employees or #employees == 0 then
        return false
    end

    local totalPayroll = 0
    for _, employee in ipairs(employees) do
        totalPayroll = totalPayroll + (employee.salary or 0)
    end

    -- Process individual payments
    for _, employee in ipairs(employees) do
        if employee.salary and employee.salary > 0 then
            local player = Core.GetPlayer(employee.player_id)
            if player then
                player.addMoney("bank", employee.salary)
            end
        end
    end

    -- Deduct from business
    Core.DB.execute(
        "UPDATE businesses SET balance = balance - ? WHERE id = ?",
        { totalPayroll, businessId }
    )

    -- Log payroll
    Core.DB.execute(
        "INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, 'withdrawal', ?, ?)",
        { businessId, totalPayroll, 'Payroll - ' .. #employees .. ' employees' }
    )

    return true
end
