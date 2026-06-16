# Domain Model — Transport & Mission Management System

## Purpose
This document translates the PRD, ERD, Business Rules, and workflow documents into a Codex-ready domain model.

## 1. Bounded Contexts

### 1.1 Identity & Organization Context
Responsibilities:
- Users
- Roles
- Branches
- Organization units
- Authentication / authorization scope

Core entities:
- User
- Role
- UserRole
- Branch
- OrganizationUnit
- RefreshToken

### 1.2 Master Data Context
Responsibilities:
- Provinces
- Cities
- Lookup-like geographic data

Core entities:
- Province
- City

### 1.3 Fleet Context
Responsibilities:
- Driver registration
- Vehicle registration
- Availability state
- Insurance validity tracking

Core entities:
- Driver
- Vehicle
- DriverAttendance

### 1.4 Contract Context
Responsibilities:
- Contract registration
- Pricing and finance basis
- Calculation policies

Core entities:
- Contract
- CalculationPolicy

### 1.5 Mission Context
Responsibilities:
- Mission request
- Approval workflow
- Status management
- Passenger records
- Assignment

Core entities:
- Mission
- MissionPassenger
- MissionApproval
- MissionStatusHistory
- MissionAssignment

### 1.6 Execution Context
Responsibilities:
- Mission start / completion
- Kilometer logging
- Stop logging
- Real execution record

Core entities:
- MissionExecution
- MissionExecutionStop

### 1.7 Finance Context
Responsibilities:
- Cost calculation
- Settlement
- Payroll preparation

Core entities:
- MissionCost
- MonthlySettlement
- MonthlySettlementItem

### 1.8 Audit & Integration Context
Responsibilities:
- Audit trail
- External workflow mapping

Core entities:
- AuditLog
- ChargoonWorkflowMapping

## 2. Aggregate Roots

### Mission Aggregate
Root: `Mission`
Children:
- MissionPassenger
- MissionApproval
- MissionStatusHistory
- MissionAssignment (reference-bound child in workflow terms)

Key invariants:
- A mission must have a valid origin and destination
- A mission must be approved before dispatch
- Mission state transitions must follow the state machine
- A settled mission cannot be edited

### Driver Aggregate
Root: `Driver`
Children:
- DriverAttendance

Key invariants:
- National code must be unique
- License number must be unique
- Inactive drivers cannot be assigned
- Driver overlap is not allowed for active missions

### Vehicle Aggregate
Root: `Vehicle`

Key invariants:
- Plate number / chassis rules must be unique according to schema
- Vehicle with expired insurance cannot be assigned
- Retired / inactive vehicles cannot be assigned

### Contract Aggregate
Root: `Contract`

Key invariants:
- Contract validity dates must be consistent
- At most one active contract per driver + vehicle pair
- Calculation must use the correct active contract

### Execution Aggregate
Root: `MissionExecution`
Children:
- MissionExecutionStop

Key invariants:
- Execution cannot exist before assignment
- Start and end mileage must be valid
- Stop/penalty/extra-payment entries must be categorized

### Settlement Aggregate
Root: `MonthlySettlement`
Children:
- MonthlySettlementItem

Key invariants:
- Settled or paid records are immutable
- Settlement totals must equal the sum of settlement items

## 3. Core Relationships
- Branch has many Users
- Branch has many Drivers
- Province has many Cities
- Driver has many Contracts
- Vehicle has many Contracts
- Mission references origin and destination province/city
- Mission has many approvals
- Mission may have many passengers
- Mission has zero or one active assignment at a point in time
- MissionAssignment links Mission, Driver, Vehicle, and Contract
- MissionAssignment has one or more execution records depending on policy (current default: one execution record)
- MissionExecution has one cost record
- MonthlySettlement has many settlement items

## 4. Value Objects / Conceptual Types
These may remain flat DTOs in V1, but should be modeled as value objects in domain logic if useful:
- MoneyAmount
- DateRange
- MissionRoute
- TravelWindow
- MileageRange
- ApprovalDecision
- ResourceAvailabilitySnapshot

## 5. Domain Events
Recommended event list:
- MissionRequested
- MissionSubmittedForApproval
- MissionApproved
- MissionRejected
- DriverAssigned
- VehicleAssigned
- MissionStarted
- MissionEntryRecorded
- MissionExitRecorded
- MissionMileageRecorded
- MissionExecuted
- MissionCostCalculated
- MonthlySettlementGenerated
- PayrollCalculated

## 6. Domain Services
Recommended services:
- MissionApprovalService
- DispatchService
- MissionExecutionService
- FinanceCalculationService
- SettlementService
- AvailabilityService
- InsuranceValidationService
- MissionNumberGenerator

## 7. Open Questions / TODO
- Whether Mission and MissionRequest should remain one table or two separate roots in implementation
- Whether representation must become a first-class entity
- Whether mission execution can be reopened after finance calculation
- Whether branch isolation rules apply to all roles or only some roles
- Whether air travel requires a separate aggregate or only a travel type policy
