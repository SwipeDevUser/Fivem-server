-- Supreme Court Configuration

Config = {}

Config.Court = {
    name = "United States Supreme Court",
    location = "Downtown Courthouse",
    jurisdiction = "State & Federal",
    color = {25, 25, 112},  -- Midnight Blue
    accentColor = {184, 134, 11}  -- Dark Goldenrod
}

Config.JudgeRanks = {
    "Chief Justice",
    "Associate Justice",
    "Senior Judge",
    "Presiding Judge",
    "Magistrate"
}

Config.CaseTypes = {
    "Criminal",
    "Civil",
    "Felony",
    "Misdemeanor",
    "Assault",
    "Theft",
    "Drug Possession",
    "Weapons Violation",
    "DUI",
    "Fraud",
    "Contract Dispute",
    "Property Dispute"
}

Config.VerdictTypes = {
    "Guilty",
    "Not Guilty",
    "Charges Dismissed",
    "Acquitted",
    "Convicted",
    "Mistrial",
    "Plea Agreement",
    "Pending"
}

Config.Sentences = {
    -- Months for different crimes
    theft = 12,
    assault = 24,
    drugPossession = 18,
    weapons = 36,
    dui = 6,
    fraud = 30,
    robbery = 60,
    murder = 180,
    manslaughter = 120,
    kidnapping = 150
}

Config.Fines = {
    theft = 5000,
    assault = 10000,
    drugPossession = 15000,
    weapons = 20000,
    dui = 8000,
    fraud = 25000,
    robbery = 50000,
    murder = 100000,
    manslaughter = 75000,
    kidnapping = 80000
}

Config.EvidenceTypes = {
    "Physical Evidence",
    "Testimony",
    "Witness Statement",
    "Security Footage",
    "DNA Evidence",
    "Financial Records",
    "Digital Evidence",
    "Photographs",
    "Documents",
    "Audio Recording",
    "Forensic Report",
    "Expert Report"
}

Config.RulesOfCourt = {
    "Defendant has right to legal representation",
    "Defendant has right to remain silent",
    "All evidence must be admissible",
    "Jury presumption of innocence until proven guilty",
    "Prosecution must prove beyond reasonable doubt",
    "Right to cross-examination",
    "Right to appeal verdict"
}

Config.TrialStages = {
    "Preliminary Hearing",
    "Evidence Presentation",
    "Witness Testimony",
    "Cross-Examination",
    "Closing Arguments",
    "Jury Deliberation",
    "Verdict Announcement",
    "Sentencing"
}

-- Trial Status
Config.TrialStatus = {
    "Scheduled",
    "In Progress",
    "Awaiting Verdict",
    "Concluded",
    "Appealed",
    "Closed"
}

return Config
