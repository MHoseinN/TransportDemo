# Finance Calculation Rules

## Document Metadata
- Document Name: `finance-calculation-rules.md`
- Project: Transport & Mission Management System
- Purpose: Define finance calculation rules in a Codex-ready format for implementation in backend services, validators, calculation engine, tests, and future policy changes.
- Status: `PARTIALLY_FINAL`
- Source Basis: RFB transport document + clarified formulas from analysis phase.
- Important Note: Some calculation rules may change later, and some organizations or travel types may require different formulas. This document is intentionally designed to support configurable calculation policies instead of hard-coded formulas.

---

## 1. Goal
This document defines how mission-related payable amounts must be calculated for drivers.

It covers:
- Urban mission calculation
- Outbound mission calculation
- Time and kilometer conversion rules
- Cost breakdown structure
- Validation constraints
- Numeric examples
- Extensibility model for future calculation changes

---

## 2. Design Principle: Configurable Calculation Policy

### 2.1 Why this matters
The RFB states the current calculation method, but it also leaves room for future change and different calculation models for different organizations and travel types.

Therefore, **the finance engine must not hard-code one fixed formula for all missions forever**.

### 2.2 Required implementation approach
The calculation engine should be policy-based.

Recommended design:
- `CalculationPolicy`
- `CalculationProfile`
- `MissionType`
- `TravelType`
- `Organization/Branch override`
- `Effective date range`

### 2.3 Recommended policy selection order
1. Mission-specific override policy
2. Branch-specific policy
3. Organization-specific policy
4. MissionType + TravelType policy
5. Default system policy

### 2.4 Codex implementation note
Backend should implement a strategy-like pattern, for example:
- `ICompensationCalculationStrategy`
- `UrbanHourlyCalculationStrategy`
- `OutboundKmSleepCalculationStrategy`
- Future strategies can be added without rewriting the whole finance module.

---

## 3. Calculation Scope
This document applies to:
- Mission cost calculation
- Driver payment calculation for executed missions
- Monthly settlement input generation

This document does **not** define:
- Tax calculation
- Insurance deduction calculation
- External accounting integration rules
- General payroll beyond transport missions

These items remain `TODO` and can be added later.

---

## 4. Key Terms

| Term | Meaning |
|---|---|
| Mission | A work trip/request that is approved and executed |
| Urban Mission | In-city mission; current RFB says hourly-based |
| Outbound Mission | Out-of-city mission; current RFB says kilometer + sleep based |
| AttendanceHours | Total payable hours from driver entry/exit for urban mission |
| TotalMissionHours | Total duration of mission from actual departure to actual return |
| TotalKm | Total traveled distance for mission |
| DrivingHours | Derived from distance rule: each 100 KM = 1 hour driving |
| SleepHours | Remaining non-driving time during outbound mission |
| StopCost | Payable cost related to stops/waiting |
| ExtraPayment | Any approved extra amount added to mission payment |
| Penalty | Any deduction approved for the mission |
| Contract | Active driver/vehicle financial agreement used for rate extraction |

---

## 5. Data Inputs Required for Calculation

### 5.1 Common inputs
| Field | Type | Required | Notes |
|---|---|---:|---|
| MissionId | uniqueidentifier | Yes | Target mission |
| MissionType | enum | Yes | Current known values: `Urban`, `Outbound`; future values must be supported |
| TravelType | enum | TODO | RFB mentions travel type, but exact billing effect is unclear |
| ContractId | uniqueidentifier | Yes | Active contract used for rates |
| CurrencyCode | nvarchar(10) | Yes | Example: IRR |
| BranchId | uniqueidentifier | Yes | For policy selection |
| OrganizationId | uniqueidentifier | TODO | If needed for organization-specific rules |

### 5.2 Urban mission inputs
| Field | Type | Required | Notes |
|---|---|---:|---|
| EntryTime | datetime2 | Yes | From driver attendance |
| ExitTime | datetime2 | Yes | From driver attendance |
| AttendanceHours | decimal(10,2) | Derived | ExitTime - EntryTime |
| HourlyRate | decimal(18,2) | Yes | From contract/policy |
| ExtraPayment | decimal(18,2) | No | Default = 0 |
| Penalty | decimal(18,2) | No | Default = 0 |

### 5.3 Outbound mission inputs
| Field | Type | Required | Notes |
|---|---|---:|---|
| DepartureDateTime | datetime2 | Yes | Actual start |
| ReturnDateTime | datetime2 | Yes | Actual finish |
| TotalMissionHours | decimal(10,2) | Derived | Return - Departure |
| StartKm | int | Yes | Odometer or mission start |
| EndKm | int | Yes | Odometer or mission end |
| TotalKm | int | Derived | EndKm - StartKm |
| KmRate | decimal(18,2) | Yes | From contract/policy |
| SleepRate | decimal(18,2) | Yes | From contract/policy |
| StopCost | decimal(18,2) | No | Default = 0 |
| ExtraPayment | decimal(18,2) | No | Default = 0 |
| Penalty | decimal(18,2) | No | Default = 0 |

### 5.4 TODO inputs from RFB ambiguity
| Field | Status | Description |
|---|---|---|
| ReturnCost / GoingCost as separate contract rates | TODO | RFB mentions مبلغ رفت و مبلغ برگشت in contract, but current clarified formula emphasizes `KmRate`. Final usage needs business confirmation. |
| StopHours vs StopCost | TODO | RFB mentions توقفی. Need exact calculation rule: fixed amount, hourly rate, manual entry, or policy-based. |
| Penalty source | TODO | Need to confirm whether penalty is manual entry only or rule-driven. |
| Extra payment source | TODO | Need to confirm whether it is manual approval only or rule-driven. |
| TravelType effect | TODO | RFB references travel type but exact impact on calculation is unclear. |

---

## 6. Contract Rates Required

### 6.1 Minimum required rate set
Every active contract used in finance calculation must expose the following values:

| Rate | Required | Used In |
|---|---:|---|
| HourlyRate | Yes | Urban |
| KmRate | Yes | Outbound |
| SleepRate | Yes | Outbound |
| StopRate or StopRule | TODO | Optional / pending clarification |
| PenaltyRule | No | Usually manual / policy-based |
| ExtraPaymentRule | No | Usually manual / approval-based |

### 6.2 Contract fallback rule
If the mission has an assigned contract, that contract must be used.
If no mission-specific contract is assigned:
1. Use active driver-vehicle contract
2. If none exists, fail calculation

---

## 7. Calculation Profiles

## 7.1 Profile: UrbanHourly_V1
- Status: `FINAL_FOR_CURRENT_RFB`
- Applies To: Urban missions
- Formula Basis: Driver attendance hours × hourly rate

### Formula
```text
Total = (AttendanceHours * HourlyRate) + ExtraPayment - Penalty
```

### Minimum version
If extra payment and penalty are not used in a mission:
```text
Total = AttendanceHours * HourlyRate
```

### Derived values
```text
AttendanceHours = ExitTime - EntryTime
```

### Validation
- `ExitTime` must be greater than `EntryTime`
- `AttendanceHours` must be greater than 0
- `HourlyRate` must be greater than or equal to 0
- `Penalty` cannot be negative
- `ExtraPayment` cannot be negative

### Notes
- Current RFB says urban missions are calculated hourly based on entry and exit registration.
- Number of urban trips during the attendance period does not change the calculation if policy remains attendance-based.
- If later a different urban policy is introduced (for example per-mission urban calculation), a new policy profile must be added instead of replacing this one blindly.

---

## 7.2 Profile: OutboundKmSleep_V1
- Status: `FINAL_FOR_CURRENT_RFB_WITH_ASSUMPTIONS`
- Applies To: Outbound missions
- Formula Basis: Kilometer cost + sleep cost + stop cost + extra payment - penalty

### Core formulas
```text
DrivingHours = TotalKm / 100
SleepHours = TotalMissionHours - DrivingHours
KmCost = TotalKm * KmRate
SleepCost = SleepHours * SleepRate
Total = KmCost + SleepCost + StopCost + ExtraPayment - Penalty
```

### Required guard clauses
```text
If SleepHours < 0 then SleepHours = 0
If TotalKm < 0 then calculation must fail
If TotalMissionHours < 0 then calculation must fail
```

### Derived values
```text
TotalKm = EndKm - StartKm
TotalMissionHours = ReturnDateTime - DepartureDateTime
```

### Validation
- `ReturnDateTime` must be greater than `DepartureDateTime`
- `EndKm` must be greater than or equal to `StartKm`
- `KmRate` must be greater than or equal to 0
- `SleepRate` must be greater than or equal to 0
- `StopCost` must be greater than or equal to 0
- `ExtraPayment` must be greater than or equal to 0
- `Penalty` must be greater than or equal to 0

### Notes
- The 100 KM = 1 hour rule is directly based on the clarified requirement.
- `DrivingHours` is a derived operational value, not manually entered.
- `SleepHours` is the remaining payable non-driving time under the current model.
- If business later decides to use ceiling/floor/round for driving hours, that change must be versioned in a new policy profile.

---

## 8. Numeric Precision and Rounding

### 8.1 Current recommendation
Until the business gives a final rounding policy, use:
- Monetary fields: `decimal(18,2)`
- Time fields in hours: `decimal(10,2)`
- Kilometer fields: integer or decimal depending on final odometer precision

### 8.2 Recommended default rounding policy
- `AttendanceHours`: round to 2 decimals
- `TotalMissionHours`: round to 2 decimals
- `DrivingHours`: round to 2 decimals
- `SleepHours`: round to 2 decimals
- Monetary totals: round to 2 decimals

### 8.3 TODO: rounding confirmation needed
The following remain open and must be confirmed later:
- Should `DrivingHours = TotalKm / 100` use exact decimal, floor, ceiling, or nearest rounding?
- Should attendance hours be rounded by minute, quarter-hour, half-hour, or exact decimal?
- Should settlement totals be rounded at line-item level or final aggregate level?

Status: `TODO`

---

## 9. Numeric Examples

## 9.1 Example A: Urban mission
### Inputs
```text
AttendanceHours = 6
HourlyRate = 100,000
ExtraPayment = 0
Penalty = 0
```

### Calculation
```text
Total = (6 * 100,000) + 0 - 0
Total = 600,000
```

### Result
```text
Urban mission total = 600,000
```

---

## 9.2 Example B: Outbound mission (base example)
### Inputs
```text
TotalKm = 300
TotalMissionHours = 10
KmRate = 5,000
SleepRate = 100,000
StopCost = 0
ExtraPayment = 0
Penalty = 0
```

### Calculation
```text
DrivingHours = 300 / 100 = 3
SleepHours = 10 - 3 = 7
KmCost = 300 * 5,000 = 1,500,000
SleepCost = 7 * 100,000 = 700,000
Total = 1,500,000 + 700,000 + 0 + 0 - 0 = 2,200,000
```

### Result
```text
Outbound mission total = 2,200,000
```

---

## 9.3 Example C: Outbound mission with stop cost and penalty
### Inputs
```text
TotalKm = 450
TotalMissionHours = 14
KmRate = 6,000
SleepRate = 120,000
StopCost = 300,000
ExtraPayment = 100,000
Penalty = 150,000
```

### Calculation
```text
DrivingHours = 450 / 100 = 4.5
SleepHours = 14 - 4.5 = 9.5
KmCost = 450 * 6,000 = 2,700,000
SleepCost = 9.5 * 120,000 = 1,140,000
Total = 2,700,000 + 1,140,000 + 300,000 + 100,000 - 150,000
Total = 4,090,000
```

### Result
```text
Outbound mission total = 4,090,000
```

---

## 9.4 Example D: Outbound mission where total mission hours are lower than derived driving hours
### Inputs
```text
TotalKm = 500
TotalMissionHours = 4
KmRate = 5,000
SleepRate = 100,000
StopCost = 0
ExtraPayment = 0
Penalty = 0
```

### Calculation
```text
DrivingHours = 500 / 100 = 5
SleepHours = 4 - 5 = -1
Guard clause => SleepHours = 0
KmCost = 500 * 5,000 = 2,500,000
SleepCost = 0 * 100,000 = 0
Total = 2,500,000
```

### Result
```text
Outbound mission total = 2,500,000
```

### Note
This is an exception-safe calculation. The engine must not produce a negative sleep cost.

---

## 10. Breakdown Structure to Store Per Mission
Every calculated mission should store a detailed breakdown.

### 10.1 Recommended breakdown fields
| Field | Type | Required | Description |
|---|---|---:|---|
| CalculationPolicyCode | nvarchar(100) | Yes | Example: `UrbanHourly_V1` |
| AttendanceHours | decimal(10,2) | No | Urban only |
| TotalMissionHours | decimal(10,2) | No | Outbound or future types |
| TotalKm | decimal(10,2) | No | Outbound or future types |
| DrivingHours | decimal(10,2) | No | Outbound only |
| SleepHours | decimal(10,2) | No | Outbound only |
| HourlyRate | decimal(18,2) | No | Urban |
| KmRate | decimal(18,2) | No | Outbound |
| SleepRate | decimal(18,2) | No | Outbound |
| HourlyCost | decimal(18,2) | No | Urban |
| KmCost | decimal(18,2) | No | Outbound |
| SleepCost | decimal(18,2) | No | Outbound |
| StopCost | decimal(18,2) | No | Optional |
| ExtraPayment | decimal(18,2) | No | Optional |
| Penalty | decimal(18,2) | No | Optional |
| TotalAmount | decimal(18,2) | Yes | Final total |
| CurrencyCode | nvarchar(10) | Yes | Example: IRR |
| CalculationVersion | int | Yes | Start with 1 |
| IsManualAdjustmentApplied | bit | Yes | Default false |
| CalculationNotes | nvarchar(max) | No | Human-readable note |

### 10.2 Why breakdown is required
Codex must implement storage of line-item calculation details so that:
- Finance can audit the result
- Reports can explain totals
- Policy changes can be compared historically
- Settlement recalculation can be controlled safely

---

## 11. Validation Rules

## 11.1 Pre-calculation validation rules
| Rule ID | Description |
|---|---|
| FIN-VAL-001 | Mission must exist |
| FIN-VAL-002 | Mission must be in executed/completed state before final finance calculation |
| FIN-VAL-003 | Assigned contract must exist |
| FIN-VAL-004 | MissionType must be recognized by a registered calculation policy |
| FIN-VAL-005 | Required rates must exist on contract or policy |
| FIN-VAL-006 | Required operational fields must exist (entry/exit for urban, km and actual times for outbound) |
| FIN-VAL-007 | Monetary values must not be negative except final deductions represented in `Penalty` |

## 11.2 Post-calculation validation rules
| Rule ID | Description |
|---|---|
| FIN-POST-001 | TotalAmount must be greater than or equal to 0 |
| FIN-POST-002 | SleepHours must be greater than or equal to 0 |
| FIN-POST-003 | TotalKm must be greater than or equal to 0 |
| FIN-POST-004 | Stored breakdown must match final total |
| FIN-POST-005 | Settled records must become immutable |

---

## 12. Future Change Model

### 12.1 Expected future changes
The business has already indicated that calculation rules may change or differ by travel type. The system must support changes like:
- New mission types
- New travel types
- Different formulas per organization
- Fixed-fee trips
- Mixed models (hourly + km)
- Separate going/return billing
- Different sleep-hour conversion rules
- Waiting time billed by hour instead of direct cost

### 12.2 Required extensibility rules
1. Every calculation must store its policy code and version.
2. Policies must be additive/versioned, not overwritten blindly.
3. Historical mission calculations must continue to reference the policy that was active at calculation time.
4. New policy deployment must not mutate settled financial records.
5. If recalculation is needed, it must create a new calculation version or revision log.

### 12.3 Recommended policy configuration model
Conceptual model:
```text
CalculationPolicy
- Code
- Name
- AppliesToMissionType
- AppliesToTravelType (nullable)
- AppliesToBranchId (nullable)
- EffectiveFrom
- EffectiveTo
- FormulaType
- ParametersJson
- IsActive
- Version
```

### 12.4 Example future policy parameters
```json
{
  "drivingHoursPerKmDivisor": 100,
  "roundingMode": "Exact2Decimals",
  "allowNegativeSleepHours": false,
  "urbanCalculationBasis": "AttendanceHours",
  "outboundIncludesStopCost": true,
  "outboundIncludesPenalty": true
}
```

---

## 13. Pseudocode for Codex

## 13.1 Urban calculation pseudocode
```text
function calculateUrbanMission(input):
    validate input.EntryTime exists
    validate input.ExitTime exists
    validate input.ExitTime > input.EntryTime
    validate input.HourlyRate >= 0

    attendanceHours = roundTo2Hours(diffInHours(input.EntryTime, input.ExitTime))
    total = (attendanceHours * input.HourlyRate) + input.ExtraPayment - input.Penalty

    if total < 0:
        total = 0

    return breakdown
```

## 13.2 Outbound calculation pseudocode
```text
function calculateOutboundMission(input):
    validate input.DepartureDateTime exists
    validate input.ReturnDateTime exists
    validate input.ReturnDateTime > input.DepartureDateTime
    validate input.EndKm >= input.StartKm
    validate input.KmRate >= 0
    validate input.SleepRate >= 0

    totalKm = input.EndKm - input.StartKm
    totalMissionHours = roundTo2Hours(diffInHours(input.DepartureDateTime, input.ReturnDateTime))
    drivingHours = roundTo2Hours(totalKm / 100)
    sleepHours = totalMissionHours - drivingHours

    if sleepHours < 0:
        sleepHours = 0

    kmCost = totalKm * input.KmRate
    sleepCost = sleepHours * input.SleepRate
    total = kmCost + sleepCost + input.StopCost + input.ExtraPayment - input.Penalty

    if total < 0:
        total = 0

    return breakdown
```

---

## 14. Test Cases Required for Implementation

### 14.1 Urban tests
- Urban calculation with normal attendance hours
- Urban calculation with extra payment
- Urban calculation with penalty
- Urban calculation where final result would go negative
- Urban calculation with invalid entry/exit order

### 14.2 Outbound tests
- Outbound calculation with normal km and sleep
- Outbound calculation with stop cost
- Outbound calculation with penalty
- Outbound calculation where sleep becomes negative
- Outbound calculation with invalid km range
- Outbound calculation with invalid time range
- Outbound calculation with zero km

### 14.3 Policy/version tests
- Same mission type with different branch policy
- Historical record remains unchanged after policy update
- Settlement uses the stored breakdown, not recalculated values unless explicitly requested

---

## 15. Open Questions / TODO

| TODO ID | Description |
|---|---|
| FIN-TODO-001 | Confirm whether `TravelType` affects billing directly |
| FIN-TODO-002 | Confirm whether `GoingAmount` and `ReturningAmount` should be used in formulas |
| FIN-TODO-003 | Confirm exact stop-cost calculation model |
| FIN-TODO-004 | Confirm exact rounding model for `DrivingHours` |
| FIN-TODO-005 | Confirm whether finance can manually override calculated values |
| FIN-TODO-006 | Confirm whether branch/organization-specific formulas exist now or only in future |
| FIN-TODO-007 | Confirm whether multiple attendance records in one day affect urban mission billing |
| FIN-TODO-008 | Confirm whether sleep hours can be capped by policy |
| FIN-TODO-009 | Confirm whether penalties are per mission, per stop, or per settlement |
| FIN-TODO-010 | Confirm tax/deduction handling outside mission cost |

---

## 16. Final Implementation Guidance for Codex
1. Implement finance calculation as a strategy-based service.
2. Store detailed breakdown, not only final amount.
3. Store policy code and version with every calculation.
4. Use strict validation before calculation.
5. Never allow settled amounts to be silently recalculated.
6. Keep TODO points externally configurable and easy to extend.
7. Prefer additive policy versioning over changing current logic in place.

