-- Supreme Court Trial Management System
print('^2[SUPREME COURT] Trial Management System Initializing...^7')

local Config = require('shared.config')
local Utils = require('shared.utils')

-- Trial database
local Trials = {}
local TrialCounter = 0

-- Create a new trial
RegisterNetEvent("court:createTrial")
AddEventHandler("court:createTrial", function(defendantName, defendantId, caseType, charges, judgeName)
    local src = source
    
    -- Validate case type
    if not Utils.IsValidCaseType(caseType) then
        TriggerClientEvent("core:notify", src, "⚖️ Invalid case type")
        return
    end
    
    -- Create trial record
    local trial = Utils.CreateTrialRecord(defendantName, caseType, charges, judgeName)
    trial.defendantId = defendantId
    trial.createdBy = src
    
    Trials[trial.id] = trial
    TrialCounter = TrialCounter + 1
    
    print("^5[SUPREME COURT] New trial created: " .. trial.id .. " | Defendant: " .. defendantName .. " | Judge: " .. judgeName .. "^7")
    
    TriggerClientEvent("core:notify", src, "⚖️ Supreme Court: Trial " .. trial.id .. " has been created")
    TriggerClientEvent("court:updateTrials", -1, Trials)
    
    return trial.id
end)

-- File charge
RegisterNetEvent("court:fileCharge")
AddEventHandler("court:fileCharge", function(trialId, chargeDescription)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    table.insert(trial.charges, chargeDescription)
    
    TriggerClientEvent("core:notify", src, "⚖️ Supreme Court: Charge filed - " .. chargeDescription)
    TriggerClientEvent("court:updateTrial", -1, trial)
    
    print("^5[SUPREME COURT] Charge filed on trial " .. trialId .. ": " .. chargeDescription .. "^7")
end)

-- Submit evidence
RegisterNetEvent("court:submitEvidence")
AddEventHandler("court:submitEvidence", function(trialId, evidenceType, description, notes)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    local evidence = {
        type = evidenceType,
        description = description,
        submittedBy = GetPlayerName(src),
        submittedAt = os.time(),
        notes = notes
    }
    
    local evidenceId = Utils.AddEvidenceToTrial(trial, evidence)
    
    if evidenceId then
        TriggerClientEvent("core:notify", src, "🔍 Evidence submitted: " .. evidenceId)
        TriggerClientEvent("court:updateTrial", -1, trial)
        
        print("^5[SUPREME COURT] Evidence submitted on trial " .. trialId .. ": " .. evidenceId .. " (" .. evidenceType .. ")^7")
    else
        TriggerClientEvent("core:notify", src, "⚖️ Failed to submit evidence")
    end
end)

-- Get trial details
RegisterNetEvent("court:getTrial")
AddEventHandler("court:getTrial", function(trialId)
    local src = source
    
    local trial = Trials[trialId]
    if trial then
        TriggerClientEvent("court:receiveTrial", src, trial)
    else
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
    end
end)

-- Get all trials
RegisterNetEvent("court:getAllTrials")
AddEventHandler("court:getAllTrials", function()
    local src = source
    TriggerClientEvent("court:receiveTrials", src, Trials)
end)

-- Judge approves evidence
RegisterNetEvent("court:approveEvidence")
AddEventHandler("court:approveEvidence", function(trialId, evidenceId)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if Utils.ApproveEvidence(trial, evidenceId) then
        TriggerClientEvent("core:notify", src, "⚖️ Evidence admitted to trial")
        TriggerClientEvent("court:updateTrial", -1, trial)
        
        print("^2[SUPREME COURT] Evidence " .. evidenceId .. " admitted to trial " .. trialId .. "^7")
    else
        TriggerClientEvent("core:notify", src, "⚖️ Failed to approve evidence")
    end
end)

-- Judge rejects evidence
RegisterNetEvent("court:rejectEvidence")
AddEventHandler("court:rejectEvidence", function(trialId, evidenceId, reason)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if Utils.RejectEvidence(trial, evidenceId, reason) then
        TriggerClientEvent("core:notify", src, "⚖️ Evidence rejected from trial: " .. reason)
        TriggerClientEvent("court:updateTrial", -1, trial)
        
        print("^1[SUPREME COURT] Evidence " .. evidenceId .. " rejected from trial " .. trialId .. " | Reason: " .. reason .. "^7")
    else
        TriggerClientEvent("core:notify", src, "⚖️ Failed to reject evidence")
    end
end)

-- Add witness testimony
RegisterNetEvent("court:addTestimony")
AddEventHandler("court:addTestimony", function(trialId, witnessName, statement)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if Utils.AddTestimony(trial, witnessName, statement) then
        TriggerClientEvent("core:notify", src, "🎤 Testimony recorded from witness: " .. witnessName)
        TriggerClientEvent("court:updateTrial", -1, trial)
        
        print("^5[SUPREME COURT] Testimony added to trial " .. trialId .. " from witness: " .. witnessName .. "^7")
    else
        TriggerClientEvent("core:notify", src, "⚖️ Failed to record testimony")
    end
end)

-- Get admissible evidence
RegisterNetEvent("court:getAdmissibleEvidence")
AddEventHandler("court:getAdmissibleEvidence", function(trialId)
    local src = source
    
    local trial = Trials[trialId]
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    local admissible = Utils.GetAdmissibleEvidence(trial)
    TriggerClientEvent("court:receiveAdmissibleEvidence", src, admissible)
end)

print("^2[SUPREME COURT] Trial Management System Ready^7")

-- Export for other resources
exports('GetTrial', function(trialId)
    return Trials[trialId]
end)

exports('GetAllTrials', function()
    return Trials
end)

exports('GetTrialCount', function()
    return TrialCounter
end)
