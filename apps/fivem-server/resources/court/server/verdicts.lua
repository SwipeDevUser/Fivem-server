-- Supreme Court Verdict & Sentencing System
print('^2[SUPREME COURT] Verdict & Sentencing System Initializing...^7')

local Config = require('shared.config')
local Utils = require('shared.utils')

-- Set verdict
RegisterNetEvent("court:setVerdict")
AddEventHandler("court:setVerdict", function(trialId, verdict, notes)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if not Utils.IsValidVerdict(verdict) then
        TriggerClientEvent("core:notify", src, "⚖️ Invalid verdict")
        return
    end
    
    Utils.SetVerdict(trial, verdict, notes)
    
    TriggerClientEvent("core:notify", src, "⚖️ Verdict Set: " .. verdict)
    TriggerClientEvent("court:updateTrial", -1, trial)
    
    print("^3[SUPREME COURT] VERDICT: " .. verdict .. " | Trial: " .. trialId .. " | Defendant: " .. trial.defendant .. "^7")
    
    -- Notify defendant
    if trial.defendantId then
        TriggerClientEvent("court:verdictAnnounced", trial.defendantId, trial)
    end
end)

-- Get sentence
RegisterNetEvent("court:getSentence")
AddEventHandler("court:getSentence", function(trialId)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if not trial.verdict then
        TriggerClientEvent("core:notify", src, "⚖️ Verdict not yet announced")
        return
    end
    
    local sentenceInfo = {
        months = trial.sentence or 0,
        fine = trial.fine or 0,
        verdict = trial.verdict.verdict,
        charges = trial.charges
    }
    
    TriggerClientEvent("court:receiveSentence", src, sentenceInfo)
end)

-- Execute sentence
RegisterNetEvent("court:executeSentence")
AddEventHandler("court:executeSentence", function(trialId)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if not trial.verdict then
        TriggerClientEvent("core:notify", src, "⚖️ No verdict announced")
        return
    end
    
    -- If guilty
    if trial.verdict.verdict == "Guilty" or trial.verdict.verdict == "Convicted" then
        -- Jail time
        local jailMonths = trial.sentence or 12
        
        -- Fine
        local fine = trial.fine or 5000
        
        -- Execute sentence
        if trial.defendantId then
            TriggerClientEvent("court:sentenceExecuted", trial.defendantId, {
                months = jailMonths,
                fine = fine,
                reason = table.concat(trial.charges, ", ")
            })
        end
        
        TriggerClientEvent("core:notify", src, "⚖️ Sentence executed: " .. jailMonths .. " months prison, $" .. fine .. " fine")
        
        print("^1[SUPREME COURT] SENTENCE EXECUTED: " .. jailMonths .. " months + $" .. fine .. " fine | Defendant: " .. trial.defendant .. "^7")
    else
        TriggerClientEvent("core:notify", src, "⚖️ Defendant found not guilty - released")
        print("^2[SUPREME COURT] Defendant acquitted: " .. trial.defendant .. "^7")
    end
    
    trial.status = "Closed"
end)

-- Appeal verdict
RegisterNetEvent("court:appealVerdict")
AddEventHandler("court:appealVerdict", function(trialId, appealReason)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    if not trial.verdict then
        TriggerClientEvent("core:notify", src, "⚖️ Cannot appeal verdict that hasn't been announced")
        return
    end
    
    trial.status = "Appealed"
    trial.appeal = {
        reason = appealReason,
        appealedAt = os.time(),
        appealedBy = GetPlayerName(src),
        status = "Pending Review"
    }
    
    TriggerClientEvent("core:notify", src, "⚖️ Appeal filed: " .. appealReason)
    TriggerClientEvent("court:updateTrial", -1, trial)
    
    print("^3[SUPREME COURT] APPEAL FILED: Trial " .. trialId .. " | Reason: " .. appealReason .. "^7")
end)

-- Dismiss charges
RegisterNetEvent("court:dismissCharges")
AddEventHandler("court:dismissCharges", function(trialId, reason)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    trial.status = "Concluded"
    trial.verdict = {
        verdict = "Charges Dismissed",
        date = os.time(),
        reason = reason,
        decidedBy = "Judge"
    }
    
    TriggerClientEvent("core:notify", src, "⚖️ Supreme Court: Charges dismissed - " .. reason)
    TriggerClientEvent("court:updateTrial", -1, trial)
    
    if trial.defendantId then
        TriggerClientEvent("court:chargesDismissed", trial.defendantId, reason)
    end
    
    print("^2[SUPREME COURT] CHARGES DISMISSED: Trial " .. trialId .. " | Reason: " .. reason .. "^7")
end)

-- Mistrial
RegisterNetEvent("court:declareMistrial")
AddEventHandler("court:declareMistrial", function(trialId, reason)
    local src = source
    
    local Trials = exports['court']:GetAllTrials()
    local trial = Trials[trialId]
    
    if not trial then
        TriggerClientEvent("core:notify", src, "⚖️ Trial not found")
        return
    end
    
    trial.status = "Concluded"
    trial.verdict = {
        verdict = "Mistrial",
        date = os.time(),
        reason = reason,
        decidedBy = "Judge"
    }
    
    TriggerClientEvent("core:notify", src, "⚖️ Supreme Court: Mistrial declared - " .. reason)
    TriggerClientEvent("court:updateTrial", -1, trial)
    
    print("^3[SUPREME COURT] MISTRIAL DECLARED: Trial " .. trialId .. " | Reason: " .. reason .. "^7")
end)

print("^2[SUPREME COURT] Verdict & Sentencing System Ready^7")
