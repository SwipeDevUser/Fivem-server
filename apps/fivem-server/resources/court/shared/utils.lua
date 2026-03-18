-- Court System Utilities

local Utils = {}

function Utils.FormatDate(timestamp)
    return os.date("%B %d, %Y at %H:%M", timestamp)
end

function Utils.GenerateTrialID()
    return "TRIAL-" .. os.time() .. "-" .. math.random(1000, 9999)
end

function Utils.GenerateEvidenceID()
    return "EV-" .. os.time() .. "-" .. math.random(10000, 99999)
end

function Utils.ValidateEvidence(evidence)
    if not evidence.type or not evidence.description or not evidence.submittedBy then
        return false
    end
    return true
end

function Utils.CalculateSentence(crimeType)
    local Config = require('shared.config')
    local baseTime = Config.Sentences[crimeType] or 12
    return baseTime
end

function Utils.CalculateFine(crimeType)
    local Config = require('shared.config')
    local baseFine = Config.Fines[crimeType] or 5000
    return baseFine
end

function Utils.IsValidVerdict(verdict)
    local Config = require('shared.config')
    for _, v in ipairs(Config.VerdictTypes) do
        if v == verdict then
            return true
        end
    end
    return false
end

function Utils.IsValidCaseType(caseType)
    local Config = require('shared.config')
    for _, ct in ipairs(Config.CaseTypes) do
        if ct == caseType then
            return true
        end
    end
    return false
end

function Utils.FormatEvidence(evidence)
    return {
        id = evidence.id or Utils.GenerateEvidenceID(),
        type = evidence.type,
        description = evidence.description,
        submittedBy = evidence.submittedBy,
        submittedAt = evidence.submittedAt or os.time(),
        status = evidence.status or "Submitted",
        admissible = evidence.admissible or false,
        notes = evidence.notes or ""
    }
end

function Utils.CreateTrialRecord(defendant, caseType, charges, judge)
    return {
        id = Utils.GenerateTrialID(),
        defendant = defendant,
        caseType = caseType,
        charges = charges,
        judge = judge,
        createdAt = os.time(),
        status = "Scheduled",
        evidence = {},
        testimony = {},
        verdict = nil,
        sentence = nil,
        fine = nil
    }
end

function Utils.AddEvidenceToTrial(trial, evidence)
    if not Utils.ValidateEvidence(evidence) then
        return false
    end
    
    local formattedEvidence = Utils.FormatEvidence(evidence)
    table.insert(trial.evidence, formattedEvidence)
    return formattedEvidence.id
end

function Utils.ApproveEvidence(trial, evidenceId)
    for _, evidence in ipairs(trial.evidence) do
        if evidence.id == evidenceId then
            evidence.admissible = true
            evidence.status = "Admitted"
            return true
        end
    end
    return false
end

function Utils.RejectEvidence(trial, evidenceId, reason)
    for _, evidence in ipairs(trial.evidence) do
        if evidence.id == evidenceId then
            evidence.admissible = false
            evidence.status = "Rejected"
            evidence.notes = reason
            return true
        end
    end
    return false
end

function Utils.GetAdmissibleEvidence(trial)
    local admissible = {}
    for _, evidence in ipairs(trial.evidence) do
        if evidence.admissible then
            table.insert(admissible, evidence)
        end
    end
    return admissible
end

function Utils.AddTestimony(trial, witness, statement)
    if not witness or not statement then
        return false
    end
    
    table.insert(trial.testimony, {
        witness = witness,
        statement = statement,
        timestamp = os.time(),
        credibility = "Pending"
    })
    
    return true
end

function Utils.SetVerdict(trial, verdict, notes)
    if not Utils.IsValidVerdict(verdict) then
        return false
    end
    
    trial.verdict = {
        verdict = verdict,
        date = os.time(),
        notes = notes,
        decidedBy = "Jury"
    }
    
    trial.status = "Concluded"
    
    if verdict == "Guilty" or verdict == "Convicted" then
        trial.sentence = Utils.CalculateSentence(trial.caseType)
        trial.fine = Utils.CalculateFine(trial.caseType)
    end
    
    return true
end

return Utils
