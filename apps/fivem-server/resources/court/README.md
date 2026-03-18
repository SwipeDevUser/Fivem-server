# United States Supreme Court System
## Professional Trial & Evidence Management with Verdicts & Sentencing

**Est. 1789 - "In God We Trust"**

---

## Overview
The Supreme Court System is a comprehensive case management solution featuring trials, evidence submission and admission, witness testimony, judicial verdicts, and sentencing. The system maintains professional court procedures with proper evidence handling and multiple verdict options.

---

## Features

### 🛡️ Trial Management
- **Create Cases** - File new trials with defendant information
- **Case Types** - Criminal, Civil, Felony, Misdemeanor, Assault, Theft, Drug Possession, Weapons, DUI, Fraud
- **Multiple Charges** - Add and manage multiple charges per trial
- **Judge Assignment** - Assign judges to oversee cases
- **Trial Status Tracking** - Scheduled, In Progress, Awaiting Verdict, Concluded, Appealed, Closed

### 🔍 Evidence Management
- **Submit Evidence** - Multiple evidence types for prosecution and defense
- **Evidence Types**:
  - Physical Evidence
  - Testimony
  - Witness Statement
  - Security Footage
  - DNA Evidence
  - Financial Records
  - Digital Evidence
  - Photographs
  - Documents
  - Audio Recording
  - Forensic Report
  - Expert Report

- **Admissibility Review** - Judge can approve or reject evidence
- **Evidence Status** - Submitted, Admitted, or Rejected (with reasons)
- **Evidence Tracking** - Complete audit trail of all evidence

### 🎤 Witness Testimony
- **Record Statements** - Capture witness statements
- **Witness Identification** - Track who testified and when
- **Statement Documentation** - Full text records of testimony
- **Credibility Tracking** - Mark testimony credibility status

### ⚖️ Verdict System
- **Verdict Types**:
  - Guilty
  - Not Guilty
  - Acquitted
  - Charges Dismissed
  - Mistrial
  - Conviction
  - Plea Agreement

- **Jury Decision** - Verdict recorded with judge notes
- **Automatic Sentencing** - Sentences calculated based on crime type
- **Appeal System** - Defendants can appeal verdicts
- **Verdict Announcement** - Official notification to all parties

### 💰 Sentencing
- **Automatic Calculations** - Sentences based on crime severity:
  - Theft: 12 months
  - Assault: 24 months
  - Drug Possession: 18 months
  - Weapons Violation: 36 months
  - DUI: 6 months
  - Fraud: 30 months
  - Robbery: 60 months
  - Murder: 180 months
  - Manslaughter: 120 months
  - Kidnapping: 150 months

- **Fines System** - Financial penalties:
  - Theft: $5,000
  - Assault: $10,000
  - Drug Possession: $15,000
  - Weapons Violation: $20,000
  - DUI: $8,000
  - Fraud: $25,000
  - Robbery: $50,000
  - Murder: $100,000
  - Manslaughter: $75,000
  - Kidnapping: $80,000

- **Prison Time** - Jail sentences in months
- **Sentence Execution** - Automatic jail and fine deduction

### 📜 Court Rules
- Defendant right to legal representation
- Defendant right to remain silent
- All evidence must be admissible
- Jury presumption of innocence
- Prosecution must prove beyond reasonable doubt
- Right to cross-examination
- Right to appeal verdict

---

## Game Commands

### Open Supreme Court
```
/court              - Open Supreme Court interface
/supremecourt       - Alternative command
/trials             - View all active trials
/newtrial           - Quick new trial creation
/trialinfo          - Get specific trial information
```

---

## NUI Interface

### Supreme Court Dashboard
Professional court interface with 7 main sections:

1. **Dashboard** - Court overview and quick info
2. **New Trial** - File new cases
3. **All Trials** - Browse active trials
4. **Evidence** - Submit and manage evidence
5. **Testimony** - Record witness statements
6. **Verdicts** - Announce verdicts and execute sentences
7. **Rules** - View official court rules

### Color Scheme
- **Primary**: Dark Blue/Midnight Blue (#1a1a2e)
- **Accent**: Gold/Dark Goldenrod (#b8860b)
- **Background**: Navy (#0f3460)
- **Text**: Light Gray (#e0e0e0)

### Design
- Professional legal document aesthetic
- Seal symbol (⚖️) in header
- Elegant serif font (Georgia)
- Clear sectional organization
- Responsive layout

---

## Server Events

### Trial Management
```lua
-- Create new trial
TriggerServerEvent('court:createTrial', defendantName, defendantId, caseType, charges, judgeName)

-- File charge
TriggerServerEvent('court:fileCharge', trialId, chargeDescription)

-- Get trial
TriggerServerEvent('court:getTrial', trialId)

-- Get all trials
TriggerServerEvent('court:getAllTrials')
```

### Evidence Management
```lua
-- Submit evidence
TriggerServerEvent('court:submitEvidence', trialId, evidenceType, description, notes)

-- Approve evidence (Judge)
TriggerServerEvent('court:approveEvidence', trialId, evidenceId)

-- Reject evidence (Judge)
TriggerServerEvent('court:rejectEvidence', trialId, evidenceId, reason)

-- Get admissible evidence
TriggerServerEvent('court:getAdmissibleEvidence', trialId)
```

### Testimony
```lua
-- Add witness testimony
TriggerServerEvent('court:addTestimony', trialId, witnessName, statement)
```

### Verdicts & Sentencing
```lua
-- Set verdict
TriggerServerEvent('court:setVerdict', trialId, verdict, notes)

-- Get sentence
TriggerServerEvent('court:getSentence', trialId)

-- Execute sentence
TriggerServerEvent('court:executeSentence', trialId)

-- Appeal verdict
TriggerServerEvent('court:appealVerdict', trialId, appealReason)

-- Dismiss charges
TriggerServerEvent('court:dismissCharges', trialId, reason)

-- Declare mistrial
TriggerServerEvent('court:declareMistrial', trialId, reason)
```

---

## Trial Workflow

### 1. File Case
- Defendant name
- Case type
- Initial charges
- Judge assignment

### 2. Submit Evidence
- Physical evidence
- Witness statements
- Documentation
- Expert reports

### 3. Judge Review
- Approve admissible evidence
- Reject inadmissible evidence
- Request additional evidence

### 4. Testimony
- Witness takes stand
- Statement recorded
- Cross-examination

### 5. Verdict
- Jury deliberation
- Verdict announcement (Guilty/Not Guilty/Dismissed)
- Judge pronouncement

### 6. Sentencing
- If guilty: jail time + fines
- If not guilty: release
- If dismissed: charges dropped

### 7. Appeal (Optional)
- File appeal with reason
- Case reopened for review

---

## Evidence Types

| Evidence Type | Best For | Admissibility |
|---|---|---|
| Physical Evidence | Crime scene | Usually admitted |
| DNA Evidence | Identity verification | High reliability |
| Security Footage | Timeline establishment | Usually admitted |
| Documents | Financial/legal proof | High reliability |
| Forensic Report | Scientific analysis | Expert testimony |
| Witness Statement | First-hand account | Submitted by witnesses |
| Audio Recording | Conversation proof | May be challenged |
| Digital Evidence | Computer/email proof | Technical authentication |

---

## Sentence Examples

### Theft Case
- Crime: Theft
- Base Sentence: 12 months
- Fine: $5,000
- Total: 12 months prison + $5,000 fine

### Felony Weapon Violation
- Crime: Weapons Violation
- Base Sentence: 36 months
- Fine: $20,000
- Total: 36 months prison + $20,000 fine

### Drug Possession
- Crime: Drug Possession
- Base Sentence: 18 months
- Fine: $15,000
- Total: 18 months prison + $15,000 fine

---

## System Architecture

### Server-Side
- **trials.lua** - Trial creation and management
- **verdicts.lua** - Verdict announcement and sentencing
- **main.lua** - Core initialization and commands

### Client-Side
- **main.lua** - UI controls and event handling

### Shared Resources
- **config.lua** - Court configuration and case types
- **utils.lua** - Trial utilities and evidence management

### NUI Interface
- **court.html** - Professional Supreme Court interface

---

## Integration Points

### With Inventory System
- Fines deducted from player cash
- Items can be evidence

### With Police System
- Cases can reference police records
- Warrants can trigger trials

### With Jail System
- Sentences automatically jail defendant
- Duration set by supreme court verdict

### With Banking System
- Fine payments processed through bank

---

## Admin Features

- Create trials as judge
- Approve/reject evidence
- Announce verdicts
- Execute sentences
- Manage appeals
- Dismiss charges
- Declare mistrials

---

## Safety & Compliance

**Procedural Safeguards:**
1. Evidence must be properly submitted
2. All evidence must be admissible
3. Judge must review and approve
4. Witness testimony documented
5. Verdict must follow evidence
6. Sentences calculated by system
7. Appeal rights guaranteed

---

## Future Enhancements

- Multiple judge assignments
- Jury selection system
- Expert witness testimony
- Plea bargain system
- Bail system
- Case statistics/reporting
- Historical case archive
- Legal precedent tracking

---

## Support

For issues or questions about the Supreme Court System:
- Ensure all participants are present
- Verify trial ID before operations
- Check evidence admissibility before verdict
- Contact server administration for appeals

---

**United States Supreme Court**
*Established 1789*
**"In God We Trust"**

⚖️ Justice for All ⚖️
