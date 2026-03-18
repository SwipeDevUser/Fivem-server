-- Economy System - Client-side Salary & Payment Handler

-- ========================================
-- REQUEST PAYMENT (Client initiates)
-- ========================================

function RequestJobPayment(amount)
    -- Validate amount
    if not amount or amount <= 0 then
        TriggerEvent('chat:addMessage', {
            args = {'Economy', 'Invalid payment amount'},
            color = {255, 0, 0}
        })
        return
    end
    
    -- Send request to server
    TriggerServerEvent('economy:addMoney', amount)
end

-- ========================================
-- SALARY COMMAND
-- ========================================

TriggerEvent('chat:addMessage', {
    args = {'Tip', 'Use /salary to request your job payment'}
})

-- Register /salary command
RegisterCommand('salary', function(source, args, rawCommand)
    TriggerServerEvent('economy:addMoney', 0)  -- Request server to pay salary
end, false)

-- ========================================
-- DISPLAY ADJUSTED SALARIES
-- ========================================

RegisterCommand('salaries', function(source, args, rawCommand)
    TriggerEvent('chat:addMessage', {
        args = {'Salaries', 'Loading job salaries...'}
    })
end, false)

-- ========================================
-- EVENT: PAYMENT RECEIVED
-- ========================================

AddEventHandler('chat:addMessage', function(args)
    if args.args and args.args[1] == 'Bank' then
        -- Play sound or notification
        PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
    end
end)

-- ========================================
-- PERFORMANCE MONITORING
-- ========================================

local LastPaymentTime = 0
local PaymentCooldown = 30000  -- 30 second cooldown between requests

function CanRequestPayment()
    local currentTime = GetGameTimer()
    if currentTime - LastPaymentTime >= PaymentCooldown then
        LastPaymentTime = currentTime
        return true
    end
    return false
end

-- Override request function to include cooldown
local OriginalRequestPayment = RequestJobPayment
function RequestJobPayment(amount)
    if not CanRequestPayment() then
        TriggerEvent('chat:addMessage', {
            args = {'System', 'Please wait before requesting another payment'},
            color = {255, 150, 0}
        })
        return
    end
    OriginalRequestPayment(amount)
end

-- ========================================
-- EXPORTS FOR OTHER RESOURCES
-- ========================================

exports('requestJobPayment', RequestJobPayment)
exports('canRequestPayment', CanRequestPayment)
