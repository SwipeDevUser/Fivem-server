-- Supreme Court Client Script
print("^3[SUPREME COURT] Client Initialized^7")

local Config = require('shared.config')

function OpenCourtInterface()
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "openCourt",
        courtName = Config.Court.name,
        location = Config.Court.location,
        caseTypes = Config.CaseTypes,
        evidenceTypes = Config.EvidenceTypes
    })
end

function OpenTrialsView()
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "openTrials"
    })
    
    TriggerServerEvent("court:getAllTrials")
end

-- Commands
RegisterCommand('court', function()
    OpenCourtInterface()
end, false)

RegisterCommand('supremecourt', function()
    OpenCourtInterface()
end, false)

RegisterCommand('trials', function()
    OpenTrialsView()
end, false)

-- NUI Callbacks
RegisterNUICallback('createTrial', function(data, cb)
    TriggerServerEvent('court:createTrial', data.defendantName, data.defendantId or 0, data.caseType, data.charges, data.judgeName)
    cb({})
end)

RegisterNUICallback('submitEvidence', function(data, cb)
    TriggerServerEvent('court:submitEvidence', data.trialId, data.evidenceType, data.description, data.notes)
    cb({})
end)

RegisterNUICallback('approveEvidence', function(data, cb)
    TriggerServerEvent('court:approveEvidence', data.trialId, data.evidenceId)
    cb({})
end)

RegisterNUICallback('rejectEvidence', function(data, cb)
    TriggerServerEvent('court:rejectEvidence', data.trialId, data.evidenceId, data.reason)
    cb({})
end)

RegisterNUICallback('addTestimony', function(data, cb)
    TriggerServerEvent('court:addTestimony', data.trialId, data.witnessName, data.statement)
    cb({})
end)

RegisterNUICallback('setVerdict', function(data, cb)
    TriggerServerEvent('court:setVerdict', data.trialId, data.verdict, data.notes)
    cb({})
end)

RegisterNUICallback('executeSentence', function(data, cb)
    TriggerServerEvent('court:executeSentence', data.trialId)
    cb({})
end)

RegisterNUICallback('appealVerdict', function(data, cb)
    TriggerServerEvent('court:appealVerdict', data.trialId, data.appealReason)
    cb({})
end)

RegisterNUICallback('dismissCharges', function(data, cb)
    TriggerServerEvent('court:dismissCharges', data.trialId, data.reason)
    cb({})
end)

RegisterNUICallback('declareMistrial', function(data, cb)
    TriggerServerEvent('court:declareMistrial', data.trialId, data.reason)
    cb({})
end)

RegisterNUICallback('closeCourt', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- Receive trial data from server
RegisterNetEvent('court:receiveTrial')
AddEventHandler('court:receiveTrial', function(trial)
    SendNUIMessage({
        type = "displayTrial",
        trial = trial
    })
end)

RegisterNetEvent('court:receiveTrials')
AddEventHandler('court:receiveTrials', function(trials)
    SendNUIMessage({
        type = "displayTrials",
        trials = trials
    })
end)

RegisterNetEvent('court:updateTrial')
AddEventHandler('court:updateTrial', function(trial)
    SendNUIMessage({
        type = "updateTrial",
        trial = trial
    })
end)

RegisterNetEvent('court:receiveAdmissibleEvidence')
AddEventHandler('court:receiveAdmissibleEvidence', function(evidence)
    SendNUIMessage({
        type = "displayAdmissibleEvidence",
        evidence = evidence
    })
end)

RegisterNetEvent('court:verdictAnnounced')
AddEventHandler('court:verdictAnnounced', function(trial)
    SendNUIMessage({
        type = "verdictAnnounced",
        verdict = trial.verdict.verdict,
        charges = trial.charges
    })
    
    TriggerEvent('chat:addMessage', {
        color = {220, 20, 60},
        multiline = true,
        args = {"SUPREME COURT", "Verdict Announced: " .. trial.verdict.verdict},
    })
end)

RegisterNetEvent('court:sentenceExecuted')
AddEventHandler('court:sentenceExecuted', function(sentenceData)
    SendNUIMessage({
        type = "sentenceExecuted",
        sentence = sentenceData
    })
    
    TriggerEvent('chat:addMessage', {
        color = {220, 20, 60},
        multiline = true,
        args = {"SUPREME COURT", "Sentenced to " .. sentenceData.months .. " months prison and $" .. sentenceData.fine .. " fine"},
    })
end)

RegisterNetEvent('court:chargesDismissed')
AddEventHandler('court:chargesDismissed', function(reason)
    SendNUIMessage({
        type = "chargesDismissed",
        reason = reason
    })
    
    TriggerEvent('chat:addMessage', {
        color = {34, 139, 34},
        multiline = true,
        args = {"SUPREME COURT", "Your charges have been dismissed: " .. reason},
    })
end)

print("^3[SUPREME COURT] Client Ready^7")
