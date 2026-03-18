-- Supreme Court Main Server Script
print("^3╔══════════════════════════════════════════╗^7")
print("^3║   UNITED STATES SUPREME COURT SYSTEM    ║^7")
print("^3║   Trials | Evidence | Verdicts           ║^7")
print("^3╚══════════════════════════════════════════╝^7")

local Config = require('shared.config')

print("^2[SUPREME COURT] Core System Initializing...^7")
print("^2[SUPREME COURT] Court: " .. Config.Court.name .. "^7")
print("^2[SUPREME COURT] Location: " .. Config.Court.location .. "^7")
print("^2[SUPREME COURT] Jurisdiction: " .. Config.Court.jurisdiction .. "^7")

-- Command to open court interface
RegisterCommand('court', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("court:openInterface", src)
end, false)

RegisterCommand('supremecourt', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("court:openInterface", src)
end, false)

RegisterCommand('trials', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("court:openTrials", src)
end, false)

-- New trial command (for admin/judge)
RegisterCommand('newtrial', function(source, args, rawCommand)
    local src = source
    
    if #args < 2 then
        TriggerClientEvent("core:notify", src, "⚖️ Usage: /newtrial [defendantName] [caseType]")
        return
    end
    
    local defendantName = args[1]
    local caseType = args[2]
    local judgeName = GetPlayerName(src)
    
    TriggerServerEvent("court:createTrial", defendantName, 0, caseType, {"Investigation pending"}, judgeName)
end, false)

-- Get trial info
RegisterCommand('trialinfo', function(source, args, rawCommand)
    local src = source
    
    if #args < 1 then
        TriggerClientEvent("core:notify", src, "⚖️ Usage: /trialinfo [trialId]")
        return
    end
    
    local trialId = args[1]
    TriggerServerEvent("court:getTrial", trialId)
end, false)

print("^2[SUPREME COURT] All systems online^7")
print("^2[SUPREME COURT] Ready for trials^7")
print("^2[SUPREME COURT] Type /court for Supreme Court interface^7")

-- Player disconnect - clean up trial references
AddEventHandler('playerDropped', function()
    local src = source
    print("^1[SUPREME COURT] Player " .. src .. " disconnected^7")
end)
