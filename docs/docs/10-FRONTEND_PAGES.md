# Frontend Pages Specification

**Project:** Transport & Mission Management System  
**Purpose:** Codex-ready frontend specification for Vue.js implementation  
**Target Stack:** Vue 3 + Vue Router + Pinia + TypeScript + Axios + VeeValidate/Zod (recommended)  
**Document Status:** DRAFT / CHANGEABLE  
**Source Basis:** Derived from the RFB process definitions for province/city registration, driver registration, vehicle registration, contract registration, mission request, driver attendance, dispatch assignment, mission execution, and finance/settlement.  

---

## 1. Document Goals

This document defines what pages the frontend must provide and how each page should behave so that Codex can generate:

- routes
- page components
- forms
- tables
- buttons/actions
- API integrations
- field validation
- role-based visibility
- modular, change-tolerant page structure

This specification is intentionally designed to be **changeable**. Any incomplete or ambiguous RFB requirement is marked as one of the following:

- `ASSUMPTION` = implemented default until business confirms
- `TODO` = intentionally left open for later completion
- `CONFIGURABLE` = should be implemented as metadata/feature flag/policy-driven behavior

---

## 2. Frontend Design Principles

1. **Route-first design**
   - Every business capability must map to a route.
   - Create routes in a way that supports future nested views and tabs.

2. **Metadata-driven forms and tables where feasible**
   - Dropdowns, enums, status badges, and permission gates should be configurable.
   - Table columns should support toggling and future extension.

3. **Role-aware UI**
   - Buttons, forms, and tabs must be conditionally rendered by permission.
   - UI hiding is not the only control; backend authorization still applies.

4. **Reusable building blocks**
   - FormPageShell
   - DataTablePageShell
   - EntityDrawer/Modal
   - ConfirmationDialog
   - AuditInfoPanel
   - AttachmentPlaceholder
   - ApprovalTimeline
   - StatusBadge

5. **Support incomplete RFB**
   - Where fields or rules are unclear, use placeholders and feature flags.
   - Avoid hardcoding organization-specific assumptions in page layout.

6. **Consistency**
   - List page + create/edit form pattern for master data.
   - Wizard or sectioned form for mission-heavy workflows.
   - Read-only summary panels for calculated or approved data.

---

## 3. Global Route Map

| Page | Route | Purpose |
|---|---|---|
| Login | `/login` | Authenticate user |
| Dashboard | `/dashboard` | Overview by role |
| Province/City Management | `/master-data/locations` | Manage provinces and cities |
| Driver Management | `/fleet/drivers` | Manage drivers |
| Vehicle Management | `/fleet/vehicles` | Manage vehicles |
| Contract Management | `/finance/contracts` | Manage contracts |
| Mission Request Form | `/missions/requests/new`, `/missions/requests/:id`, `/missions/requests/:id/edit` | Create/view/edit request |
| Mission Request List | `/missions/requests` | Search/filter mission requests |
| Mission Approval Inbox | `/missions/approvals/inbox` | Approve/reject pending missions |
| Dispatch Assignment Page | `/dispatch/assignments`, `/dispatch/assignments/:missionId` | Assign driver/vehicle |
| Mission Execution Page | `/execution/missions/:missionId` | Record attendance, km, timing, mission execution |
| Finance Calculation Page | `/finance/missions/:missionId/calculate` | Calculate mission cost |
| Monthly Settlement Page | `/finance/settlements`, `/finance/settlements/:year/:month` | Generate/review payroll settlement |
| Reports Page | `/reports` | Mission/driver/vehicle/cost reports |
| Profile / Session | `/profile` | User profile/session info |
| Access Denied | `/403` | Unauthorized page |
| Not Found | `/404` | Not found fallback |

**Note:** `Mission Request List` is included in addition to the requested pages because search/list access is necessary for navigation and operational usability.

---

## 4. Shared Frontend Conventions

### 4.1 Layout

- AppLayout with:
  - top navbar
  - left navigation sidebar
  - breadcrumb
  - page title + actions bar
  - notification/toast area
- Responsive behavior:
  - desktop-first for administrative use
  - tablet support required
  - mobile support optional unless requested later (`TODO`)

### 4.2 Form Conventions

- All forms support these modes when applicable:
  - `create`
  - `edit`
  - `view`
- Standard footer buttons:
  - Save Draft
  - Submit
  - Cancel
  - Reset
  - Back
- Required fields show visual indicator.
- Validation messages appear inline and at form summary level.
- Server-side validation messages must map to field-level display if possible.

### 4.3 Table Conventions

- Server-side paging, filtering, and sorting
- Search input in top bar
- Export button placeholder (`TODO` if export behavior not finalized)
- Column chooser (`CONFIGURABLE`)
- Row-level actions dropdown
- Bulk selection for batch actions where relevant

### 4.4 Status / Badge Conventions

Status badges should be centrally mapped and themeable.

Examples:
- Draft
- PendingApproval
- Approved
- Rejected
- Assigned
- InProgress
- Completed
- CostCalculated
- Settled
- Active
- Inactive
- InsuranceExpired

### 4.5 Permission Handling

Use centralized permission checks:

- `canView(page)`
- `canCreate(entity)`
- `canEdit(entity)`
- `canDelete(entity)`
- `canApprove(entity)`
- `canCalculate(entity)`

Permissions should come from backend claims or a permission endpoint.

### 4.6 Configurable Areas

The following should be configurable instead of hardcoded:

- mission types
- travel types
- approval steps
- vehicle types
- contract pricing modes
- report filters
- branch restrictions
- table default columns
- dashboard cards

---

## 5. Page Specifications

---

# 5.1 Login Page

## Route
- `/login`

## Purpose
Authenticate user and initialize permissions/session.

## Role Access
- Public (unauthenticated users)

## Fields
- Username / Personnel Code / Email (`CONFIGURABLE` login identity mode)
- Password
- Remember Me
- Optional CAPTCHA (`TODO`)
- Optional organization selector if multi-tenant (`TODO`)

## Buttons
- Login
- Forgot Password (`TODO` if supported later)
- Clear / Reset

## API Calls
- `POST /api/v1/auth/login`
- Optional `POST /api/v1/auth/refresh`
- Optional `GET /api/v1/users/me`
- Optional `GET /api/v1/permissions/me`

## Validation
- Username required
- Password required
- Show generic invalid credentials message
- Lockout warning if backend returns lockout status (`TODO`)

## Table Columns
- None

## Actions
- Submit credentials
- Persist session/token
- Redirect by role to dashboard or intended route

## UI States
- Loading on submit
- Error banner for invalid login
- Session expired banner if redirected from expired session

## Changeability Notes
- Support SSO placeholder (`TODO`)
- Support multi-factor auth placeholder (`TODO`)

---

# 5.2 Dashboard

## Route
- `/dashboard`

## Purpose
Provide role-based overview and shortcuts.

## Role Access
- Admin
- Employee
- Manager
- Dispatcher
- Driver
- Finance
- ITOperator

## Widgets / Sections
- Mission summary cards
- Pending approvals card
- Pending dispatch assignments card
- Missions in progress card
- Insurance expiring soon card
- Monthly finance summary card
- Recent activity / audit snippet
- Quick actions panel

## Buttons
- Create Mission Request
- Open Approval Inbox
- Open Dispatch Assignments
- Open Finance Settlement
- View Reports

## API Calls
- `GET /api/v1/dashboard/summary`
- Optional specialized endpoints:
  - `GET /api/v1/dashboard/admin`
  - `GET /api/v1/dashboard/manager`
  - `GET /api/v1/dashboard/dispatcher`
  - `GET /api/v1/dashboard/finance`

## Validation
- No form validation
- Ensure widgets render safely even with missing backend data

## Table Columns
Possible recent activities table:
- DateTime
- Module
- Reference No
- Action
- User
- Status

## Actions
- Navigate to operational pages
- Refresh dashboard

## Changeability Notes
- Dashboard widgets should be metadata-driven by role.
- Cards and charts may change by organization.

---

# 5.3 Province / City Management

## Route
- `/master-data/locations`

## Purpose
Manage province and city reference data used in mission origin/destination selection.

## Role Access
- Admin
- ITOperator
- Optional read-only: Dispatcher, Manager (`CONFIGURABLE`)

## Page Layout
Two-tab or split layout:
- Provinces tab
- Cities tab

## Fields
### Province Form
- Name
- Code (`TODO` if needed)
- IsActive

### City Form
- Province
- Name
- Code (`TODO` if needed)
- IsActive

## Buttons
- Add Province
- Edit Province
- Deactivate Province
- Add City
- Edit City
- Deactivate City
- Import from file (`TODO`)
- Refresh

## API Calls
- `GET /api/v1/provinces`
- `POST /api/v1/provinces`
- `GET /api/v1/provinces/{id}`
- `PUT /api/v1/provinces/{id}`
- `PATCH /api/v1/provinces/{id}/status`
- `GET /api/v1/cities`
- `POST /api/v1/cities`
- `GET /api/v1/cities/{id}`
- `PUT /api/v1/cities/{id}`
- `PATCH /api/v1/cities/{id}/status`

## Validation
- Province name required and unique
- City name required
- Province required for city
- Prevent duplicate city name within same province

## Table Columns
### Provinces Table
- Name
- Code
- IsActive
- CreatedAt
- UpdatedAt
- Actions

### Cities Table
- Name
- Province
- Code
- IsActive
- CreatedAt
- UpdatedAt
- Actions

## Actions
- Create/update location
- Activate/deactivate records
- Search/filter by province/city name

## Changeability Notes
- Country support may be added later (`TODO`)
- Geo hierarchy may expand beyond province/city (`CONFIGURABLE`)

---

# 5.4 Driver Management

## Route
- `/fleet/drivers`
- `/fleet/drivers/new`
- `/fleet/drivers/:id`
- `/fleet/drivers/:id/edit`

## Purpose
Register, view, update, and track drivers.

## Role Access
- Admin
- Dispatcher
- Optional: Finance read-only
- Optional: Manager read-only

## Fields
### Identity
- FirstName
- LastName
- FatherName
- NationalCode
- BirthCertificateNo
- BirthPlace
- BirthDate

### Contact
- Mobile

### Driving / Employment
- LicenseNo
- BranchId
- Representation / Agency (`TODO` from legacy wording if separate from branch)
- DriverType (`CONFIGURABLE`: personal, organizational, contractor)
- IsActive

### Insurance / Compliance
- InsuranceExpireDate
- InsuranceWarningEnabled
- DriverLicenseExpireDate (`TODO` if needed)
- Notes

### Audit
- CreatedAt / UpdatedAt (read-only)

## Buttons
- Save
- Save & New
- Activate/Deactivate
- View History
- View Missions
- View Attendance
- Back

## API Calls
- `GET /api/v1/drivers`
- `POST /api/v1/drivers`
- `GET /api/v1/drivers/{id}`
- `PUT /api/v1/drivers/{id}`
- `PATCH /api/v1/drivers/{id}/status`
- `GET /api/v1/drivers/{id}/missions`
- `GET /api/v1/drivers/{id}/attendance`
- `GET /api/v1/drivers/available`

## Validation
- FirstName required
- LastName required
- NationalCode required, exact length based on backend rules
- LicenseNo required
- Branch required
- InsuranceExpireDate format valid if provided
- Prevent duplicate active driver with same NationalCode

## Table Columns
- FullName
- NationalCode
- LicenseNo
- Branch
- Mobile
- InsuranceExpireDate
- InsuranceStatus
- IsActive
- CurrentAvailability
- CreatedAt
- Actions

## Actions
- Create/edit/deactivate driver
- Filter by name, branch, insurance status, active status
- Open related mission/attendance history

## Changeability Notes
- Insurance model is partially ambiguous in RFB; keep insurance fields modular.
- Separate tabs may be added later for documents, attachments, compliance, history.

---

# 5.5 Vehicle Management

## Route
- `/fleet/vehicles`
- `/fleet/vehicles/new`
- `/fleet/vehicles/:id`
- `/fleet/vehicles/:id/edit`

## Purpose
Register, view, update, and track vehicles.

## Role Access
- Admin
- Dispatcher
- Optional: Finance read-only

## Fields
### Core
- VehicleType
- Model
- Color
- ChassisNo
- PlateNo
- OwnershipType (Personal / Organizational / Contractor)
- BranchId (`TODO` if required organizationally)
- IsActive

### Insurance
- ThirdPartyInsuranceExpireDate
- BodyInsuranceExpireDate
- InsuranceWarningEnabled (`CONFIGURABLE`)

### Operational
- Capacity (`TODO`)
- FuelType (`TODO`)
- Notes

## Buttons
- Save
- Save & New
- Activate/Deactivate
- View Assignment History
- View Mission History
- Back

## API Calls
- `GET /api/v1/vehicles`
- `POST /api/v1/vehicles`
- `GET /api/v1/vehicles/{id}`
- `PUT /api/v1/vehicles/{id}`
- `PATCH /api/v1/vehicles/{id}/status`
- `GET /api/v1/vehicles/available`
- `GET /api/v1/vehicles/{id}/missions`

## Validation
- VehicleType required
- Model required
- ChassisNo required and unique
- PlateNo required and unique
- OwnershipType required
- Insurance dates valid if present

## Table Columns
- PlateNo
- VehicleType
- Model
- Color
- OwnershipType
- ThirdPartyInsuranceExpireDate
- BodyInsuranceExpireDate
- InsuranceStatus
- IsActive
- Availability
- Actions

## Actions
- Create/edit/deactivate vehicle
- Filter by plate/model/type/status/insurance
- Open assignment history

## Changeability Notes
- Future maintenance module may add tabs for maintenance, accidents, inspections.

---

# 5.6 Contract Management

## Route
- `/finance/contracts`
- `/finance/contracts/new`
- `/finance/contracts/:id`
- `/finance/contracts/:id/edit`

## Purpose
Manage driver-vehicle contracts and pricing rules.

## Role Access
- Admin
- Finance
- Optional: Dispatcher read-only

## Fields
### Parties
- DriverId
- VehicleId

### Dates
- StartDate
- EndDate

### Pricing
- HourlyRate
- KmRate
- SleepRate
- GoingAmount (`TODO` legacy field, clarify whether separate from km`)
- ReturningAmount (`TODO` legacy field)
- StopRate / StopCostMode (`TODO`)
- PenaltyPolicy (`TODO`)
- ExtraPaymentPolicy (`TODO`)

### Contract Status
- Status (Draft / Active / Expired / Cancelled)
- HasInsurance flag (`legacy note says may be unused`)
- Notes

## Buttons
- Save
- Save Draft
- Activate Contract
- Expire Contract
- Cancel Contract
- Clone Contract
- Back

## API Calls
- `GET /api/v1/contracts`
- `POST /api/v1/contracts`
- `GET /api/v1/contracts/{id}`
- `PUT /api/v1/contracts/{id}`
- `PATCH /api/v1/contracts/{id}/status`
- `GET /api/v1/contracts/active`

## Validation
- Driver required
- Vehicle required
- StartDate required
- EndDate must be after StartDate
- At least one pricing mode must be defined
- Prevent overlapping active contracts for same driver/vehicle pair

## Table Columns
- ContractNo / Id
- Driver
- Vehicle
- StartDate
- EndDate
- HourlyRate
- KmRate
- SleepRate
- Status
- CreatedAt
- Actions

## Actions
- Create/edit/activate/cancel contract
- Filter by driver, vehicle, status, date range
- Clone contract for renewal

## Changeability Notes
- Contract pricing model must remain extensible because financial rules may change.
- UI should support additional pricing blocks without restructuring the page.

---

# 5.7 Mission Request Form

## Route
- `/missions/requests/new`
- `/missions/requests/:id`
- `/missions/requests/:id/edit`

## Purpose
Create or edit a mission request.

## Role Access
- Employee
- Admin
- Optional: Dispatcher on behalf of requester (`CONFIGURABLE`)

## Layout
Multi-section form or stepper:
1. Requester Info
2. Mission Basics
3. Origin / Destination
4. Timing
5. Participants
6. Reason / Description
7. Review & Submit

## Fields
### Requester
- RequesterUserId (auto-filled for self-service; selectable for admin)
- BranchId (derived or selectable; `CONFIGURABLE`)
- OrganizationUnitId (derived or selectable; `TODO`)

### Mission Basics
- MissionType (Urban / Outbound / other future options)
- TravelType (Ground / Air / other)
- IsRoundTrip (`TODO` if separate from travel type)
- Priority (`TODO`)

### Timing
- StartDateTime
- EndDateTime
- RequestedDuration (`calculated or optional`, `TODO`)

### Location
- OriginProvinceId
- OriginCityId
- OriginAddress
- DestinationProvinceId
- DestinationCityId
- DestinationAddress

### Participants
- PassengerUserIds[]
- MainPassengerCount (`TODO` if needed)

### Narrative
- Reason
- Description
- Attachments (`TODO`)

### Read-only / Derived
- MissionNo (after save)
- Status
- Approval summary

## Buttons
- Save Draft
- Submit Request
- Update Draft
- Cancel Request (`CONFIGURABLE` if allowed before approval)
- Back
- Print / Export (`TODO`)

## API Calls
- `GET /api/v1/lookups/mission-types`
- `GET /api/v1/lookups/travel-types`
- `GET /api/v1/provinces`
- `GET /api/v1/cities?provinceId={id}`
- `GET /api/v1/users/search`
- `POST /api/v1/missions`
- `GET /api/v1/missions/{id}`
- `PUT /api/v1/missions/{id}`
- `POST /api/v1/missions/{id}/submit`
- `POST /api/v1/missions/{id}/cancel` (`TODO` if enabled)

## Validation
- MissionType required
- TravelType required
- StartDateTime required
- EndDateTime required
- StartDateTime must be before EndDateTime
- OriginProvince/City required
- DestinationProvince/City required
- Reason required (`ASSUMPTION`)
- At least one requester/participant context must exist

## Table Columns
If used in related list or subpanel:
- Passenger Name
- Personnel Code
- Organization Unit
- Actions

## Actions
- Save draft
- Submit request for approval
- Add/remove participants
- View approval status after submission

## Changeability Notes
- Approval flow is dependent on Chargoon/organizational chart and may change.
- Travel options and mission classification should be lookup-driven.
- Attachment support should remain optional.

---

# 5.8 Mission Approval Inbox

## Route
- `/missions/approvals/inbox`
- `/missions/approvals/:missionId`

## Purpose
Allow authorized approvers to review mission requests and approve/reject them.

## Role Access
- Manager
- Admin
- Optional higher-level approvers from organizational chart (`CONFIGURABLE`)

## Page Layout
- Inbox/list view on left or top
- Request detail + approval actions on right or detail route
- Approval history/timeline panel

## Filters
- Pending only
- Date range
- Branch
- Requester
- MissionType
- TravelType
- Current approval step

## Fields (Detail)
- Mission summary
- Requester details
- Timing
- Origin/Destination
- Reason/Description
- Participants
- Approval chain / timeline
- Current status

## Buttons
- Approve
- Reject
- Return for correction (`TODO` if supported)
- View full details
- Refresh inbox
- Bulk approve (`TODO`)

## API Calls
- `GET /api/v1/approvals/inbox`
- `GET /api/v1/missions/{id}`
- `GET /api/v1/missions/{id}/approvals`
- `POST /api/v1/missions/{id}/approve`
- `POST /api/v1/missions/{id}/reject`
- `POST /api/v1/missions/{id}/return` (`TODO`)

## Validation
- Only pending items can be approved/rejected
- Comment required on rejection (`ASSUMPTION` recommended)
- Ensure optimistic concurrency / latest status before action

## Table Columns
- MissionNo
- Requester
- Branch
- MissionType
- TravelType
- StartDateTime
- EndDateTime
- CurrentStep
- Status
- SubmittedAt
- Actions

## Actions
- Review and decide
- Open detail drawer/page
- Filter pending workload

## Changeability Notes
- Approval levels may be dynamic by organizational chart.
- Page must support variable number of approval steps.

---

# 5.9 Dispatch Assignment Page

## Route
- `/dispatch/assignments`
- `/dispatch/assignments/:missionId`

## Purpose
Assign driver and vehicle to approved missions.

## Role Access
- Dispatcher
- Admin
- Optional Manager read-only

## Page Layout
- Left: pending missions awaiting dispatch
- Center: mission summary
- Right/below: available driver/vehicle panels

## Fields
### Mission Summary (Read-only)
- MissionNo
- Requester
- MissionType
- TravelType
- Date/Time
- Origin/Destination
- Reason
- Status

### Assignment Inputs
- DriverId
- VehicleId
- ContractId
- AssignmentComment
- PlannedDepartureDateTime (`TODO`)
- PlannedReturnDateTime (`TODO`)

### Resource Panels
- Driver availability
- Vehicle availability
- Insurance status indicators
- Current assignment conflicts

## Buttons
- Assign Driver
- Assign Vehicle
- Confirm Assignment
- Reassign
- Unassign (`TODO` if allowed)
- Refresh Resources
- Back

## API Calls
- `GET /api/v1/dispatch/pending-missions`
- `GET /api/v1/missions/{id}`
- `GET /api/v1/drivers/available`
- `GET /api/v1/vehicles/available`
- `GET /api/v1/contracts/active?driverId={id}&vehicleId={id}`
- `POST /api/v1/dispatch/assign`
- `POST /api/v1/dispatch/reassign`
- `GET /api/v1/dispatch/assignments/{missionId}`

## Validation
- Mission must be Approved before assignment
- Driver required
- Vehicle required
- Driver must be available
- Vehicle must be available
- Vehicle insurance must be valid
- Contract must exist if required by backend policy

## Table Columns
### Pending Missions
- MissionNo
- Requester
- MissionType
- StartDateTime
- Destination
- Status
- Actions

### Drivers Table
- DriverName
- Branch
- Availability
- InsuranceStatus
- CurrentMission
- Actions

### Vehicles Table
- PlateNo
- Model
- Availability
- InsuranceStatus
- CurrentMission
- Actions

## Actions
- View mission detail
- Select driver/vehicle
- Confirm assignment after warning dialog
- Reassign if issue found later

## Changeability Notes
- The RFB explicitly mentions confirmation message before final assignment; UI must include confirmation dialog.
- Future support may allow multiple passengers but still one driver + one vehicle per mission unless business changes.

---

# 5.10 Mission Execution Page

## Route
- `/execution/missions/:missionId`

## Purpose
Record real mission execution data including attendance, start/end times, and mileage.

## Role Access
- Dispatcher
- Driver (`CONFIGURABLE` self-entry or assisted entry)
- Admin
- Finance read-only

## Layout
Sectioned page:
1. Mission & assignment summary
2. Attendance block
3. Travel timing block
4. Mileage block
5. Cost input supplements
6. Execution summary

## Fields
### Summary (Read-only)
- MissionNo
- Driver
- Vehicle
- Contract
- MissionType
- Origin/Destination
- Scheduled Start/End

### Attendance / Timing
- AttendanceDate
- EntryTime
- ExitTime
- DepartureDateTime
- ReturnDateTime

### Mileage
- StartKm / DepartureKm
- EndKm / ReturnKm
- TotalKm (calculated)

### Additional Cost Inputs
- StopCost
- PenaltyAmount
- ExtraPaymentAmount
- NoPayment flag / WithoutPayment
- Notes

### Derived Values (Read-only after calculation)
- TotalDurationHours
- DrivingHours
- SleepHours
- ExecutionStatus

## Buttons
- Save Partial
- Record Entry Time
- Record Exit Time
- Record Mileage
- Recalculate
- Complete Execution
- Back

## API Calls
- `GET /api/v1/missions/{id}`
- `GET /api/v1/dispatch/assignments/{missionId}`
- `GET /api/v1/execution/missions/{missionId}`
- `POST /api/v1/execution/start`
- `POST /api/v1/execution/entry`
- `POST /api/v1/execution/exit`
- `POST /api/v1/execution/mileage`
- `PUT /api/v1/execution/missions/{missionId}`
- `POST /api/v1/execution/complete`

## Validation
- Mission must be assigned before execution entry
- EntryTime and ExitTime required for attendance-based calculation where applicable
- EndKm must be greater than or equal to StartKm
- ReturnDateTime must be after DepartureDateTime
- Completion not allowed if critical execution fields missing

## Table Columns
If subtable/history is shown:
- AttendanceDate
- EntryTime
- ExitTime
- StartKm
- EndKm
- TotalKm
- UpdatedBy
- UpdatedAt

## Actions
- Save partial progress
- Track time and km
- Finalize execution
- Send finalized data to finance

## Changeability Notes
- Some organizations may have multiple attendance records per day; UI must support repeating attendance rows if enabled.
- Legacy RFB notes that certain old fields such as kilometer in attendance may be unused; keep modular separation between attendance and execution km.

---

# 5.11 Finance Calculation Page

## Route
- `/finance/missions/:missionId/calculate`

## Purpose
Review execution data and calculate financial result for a mission.

## Role Access
- Finance
- Admin
- Optional Manager read-only

## Layout
- Mission summary
- Contract pricing panel
- Execution values panel
- Calculation breakdown panel
- Final total panel

## Fields
### Read-only Inputs
- MissionNo
- Driver
- Vehicle
- MissionType
- Contract summary
- Start/End time
- TotalMissionHours
- TotalKm

### Editable / Review Inputs
- StopCost
- PenaltyAmount
- ExtraPaymentAmount
- SleepHoursOverride (`CONFIGURABLE` / protected)
- Notes

### Derived Values
- AttendanceHours
- DrivingHours
- SleepHours
- KmCost
- HourlyCost
- SleepCost
- TotalCost
- CalculationPolicyVersion

## Buttons
- Calculate
- Recalculate
- Save Calculation
- Approve Calculation (`TODO` if finance approval flow added)
- Send to Settlement Queue
- Back

## API Calls
- `GET /api/v1/missions/{id}`
- `GET /api/v1/execution/missions/{missionId}`
- `GET /api/v1/contracts/active?driverId={id}&vehicleId={id}`
- `POST /api/v1/finance/calculate`
- `GET /api/v1/finance/missions/{id}/cost`
- `PUT /api/v1/finance/missions/{id}/cost` (`TODO` if recalculation persists via update)

## Validation
- Execution record required before calculation
- Contract required if policy depends on contract
- Numeric fields cannot be negative unless explicitly allowed by policy
- Recalculation after settlement should be blocked

## Table Columns
If breakdown table shown:
- Component
- Formula
- Input Value
- Rate
- Amount
- Notes

## Actions
- Calculate/recalculate mission cost
- Review cost breakdown
- Save result for settlement

## Changeability Notes
- Financial rules may change later.
- UI should not hardcode only one formula path; it should render by calculation policy returned from backend when possible.

---

# 5.12 Monthly Settlement Page

## Route
- `/finance/settlements`
- `/finance/settlements/:year/:month`

## Purpose
Generate and review monthly driver payroll/settlement.

## Role Access
- Finance
- Admin
- Optional Manager read-only

## Layout
- Filter panel
- Settlement generation actions
- Settlement table
- Driver detail drawer/page

## Filters
- Year
- Month
- Branch
- Driver
- Status (Draft / Generated / Approved / Settled)

## Fields
### Generate Settlement Form
- Year
- Month
- BranchId (`TODO` if branch-level settlement needed)
- DriverIds[] (`optional for partial generation`)
- RebuildExisting flag (`CONFIGURABLE`)
- Notes

### Read-only Totals
- Total Missions Count
- Total Attendance Amount
- Total Km Amount
- Total Sleep Amount
- Total Penalty
- Total Extra Payment
- Final Payable

## Buttons
- Generate Settlement
- Recalculate
- View Driver Detail
- Export Excel (`TODO` if finalized)
- Mark as Settled
- Back

## API Calls
- `GET /api/v1/finance/settlements?year={y}&month={m}`
- `POST /api/v1/finance/settlement/generate`
- `GET /api/v1/finance/payroll?year={y}&month={m}`
- `GET /api/v1/finance/settlements/{id}`
- `POST /api/v1/finance/settlements/{id}/settle` (`TODO` if supported)

## Validation
- Year required
- Month required
- Prevent generation for invalid period
- Prevent duplicate final settlement unless rebuild is explicitly allowed
- Prevent edits after settled state

## Table Columns
- DriverName
- Branch
- Year
- Month
- MissionAmount
- AttendanceAmount
- PenaltyAmount
- ExtraPaymentAmount
- TotalPayable
- Status
- Actions

## Actions
- Generate settlement batch
- Review per-driver breakdown
- Export result
- Mark final

## Changeability Notes
- Settlement approval workflow may later require multi-step finance review.
- Export format and payroll integration are still changeable.

---

# 5.13 Reports Page

## Route
- `/reports`
- Optional nested routes:
  - `/reports/missions`
  - `/reports/drivers`
  - `/reports/vehicles`
  - `/reports/costs`
  - `/reports/settlements`

## Purpose
Provide analytics and operational reports.

## Role Access
- Admin
- Manager
- Finance
- Dispatcher (limited operational reports)
- Optional Employee read-only to own missions (`TODO`)

## Report Types
- Mission History Report
- Driver Performance Report
- Vehicle Utilization Report
- Cost Breakdown Report
- Monthly Payroll Report
- Insurance Expiry Report (`recommended`)
- Audit / Activity Report (`optional`)

## Common Filters
- Date range
- Branch
- Driver
- Vehicle
- MissionType
- TravelType
- Status
- ApprovalStatus

## Buttons
- Search
- Reset Filters
- Export Excel (`TODO`)
- Export PDF (`TODO`)
- Save View (`CONFIGURABLE`)

## API Calls
- `GET /api/v1/reports/missions`
- `GET /api/v1/reports/drivers`
- `GET /api/v1/reports/vehicles`
- `GET /api/v1/reports/costs`
- `GET /api/v1/reports/settlements`
- `GET /api/v1/reports/insurance-expiry` (`recommended`)

## Validation
- Ensure valid date ranges
- Enforce role-based data scope (own / branch / all)
- Limit export sizes if needed (`CONFIGURABLE`)

## Table Columns
### Mission Report
- MissionNo
- Requester
- Driver
- Vehicle
- MissionType
- StartDateTime
- EndDateTime
- Origin
- Destination
- Status
- TotalCost

### Driver Report
- DriverName
- Branch
- MissionCount
- AttendanceHours
- TotalKm
- TotalPayable

### Vehicle Report
- PlateNo
- Model
- MissionCount
- TotalKm
- UtilizationRate (`TODO` formula)

### Cost Report
- MissionNo
- Driver
- KmCost
- SleepCost
- StopCost
- PenaltyAmount
- ExtraPayment
- TotalCost

## Actions
- Search/filter
- Open detail pages from report rows
- Export data

## Changeability Notes
- Reporting requirements are expected to grow; route/module structure should support adding new reports without redesigning the root page.

---

## 6. Navigation / Menu Guidance

### Suggested Menu Structure
- Dashboard
- Master Data
  - Locations
- Fleet
  - Drivers
  - Vehicles
- Finance
  - Contracts
  - Mission Calculations
  - Monthly Settlements
- Missions
  - Mission Requests
  - Approval Inbox
- Dispatch
  - Assignments
- Execution
- Reports

### Menu Visibility by Role
- Employee: Dashboard, Mission Requests, own mission tracking (optional)
- Manager: Dashboard, Approval Inbox, Reports
- Dispatcher: Dashboard, Drivers, Vehicles, Assignments, Execution, operational reports
- Finance: Dashboard, Contracts, Calculations, Settlements, Reports
- Admin: all
- ITOperator: Login, Dashboard, Locations, Users/roles if implemented separately

---

## 7. Common Error / Empty / Loading States

All pages should implement standardized UX for:

- loading state
- empty data state
- permission denied state
- backend validation error state
- generic server error state
- stale data/concurrency warning

Standard components recommended:
- `PageLoader`
- `InlineFieldError`
- `EmptyStateCard`
- `PermissionDeniedCard`
- `RetryPanel`

---

## 8. Form and Table Reuse Opportunities for Codex

Codex should create reusable components for:

- `BaseEntityListPage`
- `BaseEntityFormPage`
- `StatusBadge`
- `EntityLookupSelect`
- `ServerDataTable`
- `AuditMetaPanel`
- `ApprovalTimeline`
- `CalculationBreakdownTable`
- `RoleGuard`
- `PermissionButton`

---

## 9. Integration / Lookup Endpoints Recommended for Frontend

The frontend will benefit from dedicated lookup endpoints:

- `GET /api/v1/lookups/mission-types`
- `GET /api/v1/lookups/travel-types`
- `GET /api/v1/lookups/vehicle-types`
- `GET /api/v1/lookups/ownership-types`
- `GET /api/v1/lookups/roles`
- `GET /api/v1/lookups/branches`
- `GET /api/v1/lookups/org-units`
- `GET /api/v1/lookups/statuses?module={module}`

These should be designed to support future backend-driven UI configuration.

---

## 10. Open Questions / TODO from RFB

1. Are branch and representation/agency distinct entities or the same concept?
2. Is air travel fully supported in mission execution, or only request-level classification?
3. Can an employee cancel or edit a request after submission but before first approval?
4. Does settlement require explicit final approval before being locked?
5. Should drivers directly access execution pages, or only dispatch/admin users enter data?
6. Are attachments and scanned documents required for mission, vehicle, driver, or contract records?
7. Are stop cost, penalty, and extra payment fixed inputs or policy-driven derived values?
8. Is export to Excel mandatory in MVP for reports and settlements?
9. Is there a dedicated page for users/roles, or is identity managed externally?
10. How deep and dynamic is the Chargoon approval integration?

These open items should not block scaffolding. Codex should implement placeholders where backend contracts are marked TODO.

---

## 11. Implementation Notes for Codex

Codex should generate the frontend using the following structure:

- `src/router/modules/*.ts`
- `src/pages/**`
- `src/components/**`
- `src/stores/**`
- `src/api/**`
- `src/types/**`
- `src/composables/**`
- `src/permissions/**`

Suggested pattern per page:

- Page component
- Local form schema
- API module
- Page-specific table columns definition
- Permission guards
- Unit tests for validation and page rendering (if test scope included)

Codex should prefer composability and modularity over page-level monoliths.

---

## 12. Minimum Deliverables Expected from Frontend Implementation

1. working route structure
2. login flow
3. dashboard shell
4. CRUD list/form pages for locations, drivers, vehicles, contracts
5. mission request creation/view/edit flow
6. approval inbox and decision flow
7. dispatch assignment flow
8. mission execution flow
9. finance calculation flow
10. monthly settlement flow
11. report pages with filters and server-side tables
12. role-based menu and page/button visibility

---

## 13. Final Notes

This document is intended to be **stable enough for scaffolding** and **flexible enough for later RFB completion**.

When business rules change, prefer updating:
- lookup endpoints
- backend policy responses
- role/permission mapping
- page metadata

instead of rewriting page structure.

