# PRD — Transport & Mission Management System

## Document Metadata
- Version: 1.0-draft
- Status: Changeable / Codex-ready
- Source Basis: RFB + derived analysis documents
- Important Note: Some parts of the RFB are incomplete or ambiguous. Those areas must remain configurable or marked as TODO during implementation.

## 1. Product Overview

### 1.1 Purpose
This system manages the full lifecycle of transportation and mission operations:
- Driver and vehicle management
- Financial and operational contract management
- Mission request registration
- Driver and vehicle assignment
- Mission execution tracking (time and mileage)
- Cost and payroll calculation
- Monthly settlement

### 1.2 Problem Statement
Current issues in the organization include:
- Lack of integration between mission, driver, and vehicle data
- Manual cost and payroll calculations
- Low transparency in resource allocation
- Weak reporting capability
- Weak insurance and contract control
- Legacy Windows-based workflow that needs migration to web

### 1.3 Goals
- Digitize the entire mission workflow
- Eliminate manual calculations
- Migrate from Windows-based operation to web-based operation
- Increase transparency in resource allocation
- Automate payroll and cost calculations
- Provide accurate management reports

## 2. Stakeholders & Users
- Admin
- Employee (mission requester)
- Manager (approver)
- Dispatcher
- Driver
- Finance
- IT Operator

## 3. Core Domain
### 3.1 Entities
#### Core
- Mission
- MissionRequest
- MissionAssignment
- MissionExecution

#### Fleet
- Driver
- Vehicle
- DriverAttendance

#### Finance
- Contract
- MissionCost
- Settlement

#### Organization
- User
- Role
- Branch
- OrganizationUnit

#### Geography
- Province
- City

### 3.2 Mission State Machine
`Draft -> PendingApproval -> Approved -> Rejected -> Assigned -> InProgress -> Completed -> CostCalculated -> Settled`

## 4. Business Processes
### 4.1 Mission Lifecycle
1. Employee creates mission request
2. System validates request data
3. Manager approves or rejects the request
4. Dispatcher assigns driver and vehicle
5. Driver executes mission
6. System records kilometer and time data
7. Finance calculates mission cost
8. Monthly settlement is generated

### 4.2 Dispatch Rules
- Only active drivers may be assigned
- Only vehicles with valid insurance may be assigned
- Driver and vehicle overlaps are not allowed
- Driver availability is mandatory

### 4.3 Execution Rules
- Entry and exit times are mandatory
- Start and end kilometer values are mandatory
- Sleep calculation rule currently uses `100 KM = 1 driving hour`
- Multiple stops may be recorded

### 4.4 Finance Rules
#### Urban Mission
- Calculated hourly

#### Outbound Mission
- Distance × contract rate
- Sleep cost
- Stop cost
- Penalty
- Extra payment

## 5. Functional Requirements
### 5.1 Mission Module
- Create mission request
- Edit mission request
- Approve / reject mission
- View mission status
- Search missions

### 5.2 Dispatch Module
- Assign driver
- Assign vehicle
- Validate availability
- Validate insurance

### 5.3 Execution Module
- Record entry time
- Record exit time
- Record mileage
- Calculate duration
- Complete mission execution

### 5.4 Finance Module
- Calculate mission cost
- Apply contract rules
- Calculate sleep hours
- Generate monthly payroll
- Generate settlement reports

### 5.5 Fleet Module
- Register driver
- Register vehicle
- Update insurance status
- Track availability

### 5.6 User Management
- Role-based access control
- User assignment to branch / org unit

## 6. API Requirements (High Level)
### Mission API
- `POST /missions`
- `POST /missions/{id}/approve`
- `POST /missions/{id}/reject`
- `GET /missions/{id}`

### Dispatch API
- `POST /dispatch/assign`

### Execution API
- `POST /execution/start`
- `POST /execution/record-km`
- `POST /execution/complete`

### Finance API
- `POST /finance/calculate`
- `GET /finance/payroll`

## 7. System Architecture
### 7.1 Suggested Architecture
- ASP.NET Core (.NET 8)
- Clean Architecture
- CQRS + MediatR
- Modular Monolith ready for microservice split
- Optional event-driven integration (RabbitMQ / Kafka) in later phases

### 7.2 Services / Modules
- Mission Service
- Dispatch Service
- Execution Service
- Finance Service
- User Service

## 8. Data Requirements
### 8.1 Core Tables
- Missions
- MissionRequests / approval records
- MissionAssignments
- MissionExecutions
- Drivers
- Vehicles
- Contracts
- Settlements

### 8.2 Constraints
- Unique mission number
- Drivers cannot have overlapping active missions
- Vehicles cannot be double-assigned
- Insurance must be valid before assignment

## 9. Reporting Requirements
- Mission history
- Driver performance
- Vehicle utilization
- Monthly payroll report
- Per-mission cost breakdown

## 10. Non-Functional Requirements
### Performance
- Support at least 10,000 missions/day

### Security
- Role-based access control
- Full audit log for critical actions

### Reliability
- No data loss in mission execution
- Transaction-safe financial calculations

### Scalability
- Modular codebase ready for future service separation

## 11. Business Constraints
- All missions must be approved before dispatch
- No assignment without valid insurance
- Settled financial data is immutable

## 12. MVP Scope
### Phase 1
- Mission request
- Approval
- Dispatch
- Execution

### Phase 2
- Finance calculation
- Payroll

### Phase 3
- Reporting
- Optimization

## 13. Open Items / TODO
- Chargoon workflow mapping details
- Full representation / branch hierarchy rules
- Exact approval chain depth and fallback rules
- Organization-specific finance variants
- Special travel types and custom policies
