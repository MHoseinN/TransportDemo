# Business Rules — Transport & Mission Management System

## Document Purpose
This document defines implementable business rules for the Transport & Mission Management System in a format suitable for Codex, backend validation, workflow enforcement, and QA. Each rule is written so that it can be translated directly into application/service validation logic, domain policies, controller guards, and test cases.

## Source of Truth
These rules are derived from the RFB / analysis document for the transportation and mission order system, including the processes for province/city registration, vehicle registration, driver registration, contract registration, mission request, driver attendance, driver/vehicle assignment, mission execution and kilometer logging, and monthly financial calculations. Some parts of the RFB are incomplete or ambiguous; those rules are explicitly marked as `TODO` or `ASSUMPTION` for later completion. 

## Rule Status Markers
- **FINAL**: Clearly supported by the RFB and safe to implement.
- **ASSUMPTION**: Reasonable implementation choice based on RFB context; confirm later.
- **TODO**: RFB is incomplete/ambiguous. Leave configuration hooks/placeholders in code.

## Error Code Convention
Recommended format:
- `MASTERDATA_*`
- `AUTH_*`
- `DRIVER_*`
- `VEHICLE_*`
- `CONTRACT_*`
- `MISSION_*`
- `APPROVAL_*`
- `DISPATCH_*`
- `ATTENDANCE_*`
- `EXECUTION_*`
- `FINANCE_*`
- `SETTLEMENT_*`
- `REPORT_*`
- `AUDIT_*`

## Validation Point Convention
Recommended .NET validation points:
- `ProvinceService.*`
- `CityService.*`
- `DriverService.*`
- `VehicleService.*`
- `ContractService.*`
- `MissionService.*`
- `ApprovalService.*`
- `DispatchService.*`
- `DriverAttendanceService.*`
- `MissionExecutionService.*`
- `FinanceService.*`
- `SettlementService.*`

---

# 1) Master Data & Organization Rules

## BR-MASTERDATA-001
- **Status**: FINAL
- **Title**: Branch master data must exist before driver registration
- **Description**: A driver cannot be registered unless the branch master data already exists in the system.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `MASTERDATA_BRANCH_REQUIRED`
- **Error Message**: `Branch must exist before driver registration.`

## BR-MASTERDATA-002
- **Status**: FINAL
- **Title**: Branch master data must exist before mission request workflow
- **Description**: Mission workflow depends on branch/organizational data being present.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MASTERDATA_BRANCH_REQUIRED`
- **Error Message**: `Branch master data must exist before mission request can be created.`

## BR-MASTERDATA-003
- **Status**: FINAL
- **Title**: Province and city must be selected from predefined lists
- **Description**: Province and city values must come from predefined dropdown/master data and free-text values are invalid.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MASTERDATA_CITY_INVALID`
- **Error Message**: `Province and city must be selected from predefined values.`

## BR-MASTERDATA-004
- **Status**: FINAL
- **Title**: Detailed address does not replace province/city selection
- **Description**: Recording a detailed address is mandatory in addition to origin/destination province and city.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_ADDRESS_REQUIRED`
- **Error Message**: `Detailed address must be provided in addition to province and city.`

## BR-MASTERDATA-005
- **Status**: FINAL
- **Title**: Invalid or incomplete location data must block mission submission
- **Description**: Mission requests with invalid or incomplete location data cannot be submitted into approval workflow.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.SubmitMissionRequest()`
- **Error Code**: `MISSION_LOCATION_INCOMPLETE`
- **Error Message**: `Mission request cannot be submitted with incomplete location information.`

## BR-MASTERDATA-006
- **Status**: ASSUMPTION
- **Title**: Province and city names must be unique within their logical scope
- **Description**: Province names are globally unique; city names are unique per province.
- **Applies To**: Province, City
- **Validation Point**: `ProvinceService.CreateProvince()`, `CityService.CreateCity()`
- **Error Code**: `MASTERDATA_DUPLICATE_NAME`
- **Error Message**: `Duplicate province/city name is not allowed.`

## BR-MASTERDATA-007
- **Status**: TODO
- **Title**: Country-level geographic hierarchy is undefined
- **Description**: The RFB only mentions province and city. If country or region is required later, master data and rules must be extended.
- **Applies To**: Province, City
- **Validation Point**: `N/A`
- **Error Code**: `N/A`
- **Error Message**: `TODO: Extend hierarchy if country/region becomes required.`

## BR-MASTERDATA-008
- **Status**: FINAL
- **Title**: Organizational approval chain is prerequisite for mission approval
- **Description**: Approval routing must follow the organization chart / Chargoon hierarchy until the transportation desk receives the request.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.BuildApprovalChain()`
- **Error Code**: `APPROVAL_CHAIN_NOT_CONFIGURED`
- **Error Message**: `Approval chain is not configured for the requester organizational unit.`

## BR-MASTERDATA-009
- **Status**: TODO
- **Title**: Chargoon mapping strategy is not fully specified
- **Description**: Exact mapping to Chargoon organizational roles is not fully defined in the RFB and must be configurable.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.ResolveApproversFromOrgChart()`
- **Error Code**: `APPROVAL_ORG_MAPPING_MISSING`
- **Error Message**: `Approval hierarchy mapping is incomplete.`

---

# 2) Identity, Access, and Role Rules

## BR-AUTH-001
- **Status**: FINAL
- **Title**: Only authenticated users can access operational APIs
- **Description**: All driver, vehicle, mission, dispatch, execution, and finance APIs require authentication.
- **Applies To**: All protected resources
- **Validation Point**: API middleware / authorization policy
- **Error Code**: `AUTH_UNAUTHORIZED`
- **Error Message**: `Authentication is required.`

## BR-AUTH-002
- **Status**: FINAL
- **Title**: Role-based authorization must be enforced
- **Description**: Access to create, approve, assign, calculate, and report operations must be limited to authorized roles.
- **Applies To**: All protected resources
- **Validation Point**: API middleware / authorization policy
- **Error Code**: `AUTH_FORBIDDEN`
- **Error Message**: `You do not have permission to perform this action.`

## BR-AUTH-003
- **Status**: ASSUMPTION
- **Title**: Mission requester can edit only before submission or before first approval action
- **Description**: A requester may edit a mission while it is Draft or ReturnedForCorrection, but not after approval processing has started.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.UpdateMissionRequest()`
- **Error Code**: `MISSION_EDIT_NOT_ALLOWED`
- **Error Message**: `Mission cannot be edited after approval workflow has started.`

## BR-AUTH-004
- **Status**: FINAL
- **Title**: Only authorized approvers may approve or reject missions
- **Description**: A mission can only be approved or rejected by the currently assigned approver in the chain.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.Approve()`, `ApprovalService.Reject()`
- **Error Code**: `APPROVAL_NOT_ASSIGNED_TO_USER`
- **Error Message**: `Current user is not the assigned approver for this step.`

## BR-AUTH-005
- **Status**: FINAL
- **Title**: Only authorized dispatch operators may assign driver and vehicle
- **Description**: Assignment operations are restricted to transportation/dispatch roles.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_FORBIDDEN`
- **Error Message**: `Only authorized transportation operators can assign mission resources.`

## BR-AUTH-006
- **Status**: FINAL
- **Title**: Only authorized finance roles may finalize mission cost and settlements
- **Description**: Financial calculations and settlement generation are restricted to finance roles.
- **Applies To**: MissionCost, Settlement
- **Validation Point**: `FinanceService.*`, `SettlementService.*`
- **Error Code**: `FINANCE_FORBIDDEN`
- **Error Message**: `Only authorized finance users can perform this action.`

---

# 3) Driver Rules

## BR-DRIVER-001
- **Status**: FINAL
- **Title**: Driver registration requires mandatory identity fields
- **Description**: National code, identity document fields, branch, and driving license information are mandatory.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `DRIVER_REQUIRED_FIELDS_MISSING`
- **Error Message**: `Required driver identity fields are missing.`

## BR-DRIVER-002
- **Status**: FINAL
- **Title**: Driver national code must be unique
- **Description**: A driver cannot be registered more than once with the same national code.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `DRIVER_NATIONAL_CODE_DUPLICATE`
- **Error Message**: `A driver with this national code already exists.`

## BR-DRIVER-003
- **Status**: ASSUMPTION
- **Title**: Driving license number should be unique
- **Description**: Driving license number is treated as a unique identifier to prevent duplicate registrations.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `DRIVER_LICENSE_DUPLICATE`
- **Error Message**: `A driver with this license number already exists.`

## BR-DRIVER-004
- **Status**: FINAL
- **Title**: Driver insurance date must be valid when provided
- **Description**: If an insurance expiration date is stored for the driver, it must be a valid date and not inconsistent with system rules.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`, `DriverService.UpdateDriver()`
- **Error Code**: `DRIVER_INSURANCE_DATE_INVALID`
- **Error Message**: `Driver insurance date is invalid.`

## BR-DRIVER-005
- **Status**: FINAL
- **Title**: Driver cannot be registered with incomplete mandatory information
- **Description**: The system must reject driver registration if required identity or contact fields are incomplete.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `DRIVER_INCOMPLETE_DATA`
- **Error Message**: `Driver cannot be registered with incomplete information.`

## BR-DRIVER-006
- **Status**: FINAL
- **Title**: Driver must belong to a branch
- **Description**: Driver registration requires assignment to a valid branch.
- **Applies To**: Driver
- **Validation Point**: `DriverService.CreateDriver()`
- **Error Code**: `DRIVER_BRANCH_REQUIRED`
- **Error Message**: `Driver must be assigned to a valid branch.`

## BR-DRIVER-007
- **Status**: FINAL
- **Title**: Driver availability is required for dispatch
- **Description**: Only drivers marked available and not already engaged in overlapping active assignments may be selected.
- **Applies To**: Driver, MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DRIVER_NOT_AVAILABLE`
- **Error Message**: `Selected driver is not available for assignment.`

## BR-DRIVER-008
- **Status**: ASSUMPTION
- **Title**: Inactive drivers cannot be assigned
- **Description**: Drivers marked inactive, soft-deleted, suspended, or out of service cannot be assigned.
- **Applies To**: Driver, MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DRIVER_INACTIVE`
- **Error Message**: `Inactive driver cannot be assigned.`

## BR-DRIVER-009
- **Status**: TODO
- **Title**: Driver insurance blocking behavior is unclear
- **Description**: The RFB mentions driver insurance warning and insurance control, but whether expired driver insurance blocks assignment or only warns is not fully explicit.
- **Applies To**: Driver, MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DRIVER_INSURANCE_POLICY`
- **Error Message**: `TODO: Confirm whether expired driver insurance is blocking or warning-only.`

---

# 4) Vehicle Rules

## BR-VEHICLE-001
- **Status**: FINAL
- **Title**: Vehicle registration requires mandatory vehicle identification fields
- **Description**: Chassis number, plate number, model, and color are mandatory.
- **Applies To**: Vehicle
- **Validation Point**: `VehicleService.CreateVehicle()`
- **Error Code**: `VEHICLE_REQUIRED_FIELDS_MISSING`
- **Error Message**: `Required vehicle fields are missing.`

## BR-VEHICLE-002
- **Status**: ASSUMPTION
- **Title**: Vehicle plate number must be unique
- **Description**: Plate number should uniquely identify a registered vehicle.
- **Applies To**: Vehicle
- **Validation Point**: `VehicleService.CreateVehicle()`
- **Error Code**: `VEHICLE_PLATE_DUPLICATE`
- **Error Message**: `A vehicle with this plate number already exists.`

## BR-VEHICLE-003
- **Status**: ASSUMPTION
- **Title**: Chassis number must be unique
- **Description**: Chassis number should be unique per vehicle registration.
- **Applies To**: Vehicle
- **Validation Point**: `VehicleService.CreateVehicle()`
- **Error Code**: `VEHICLE_CHASSIS_DUPLICATE`
- **Error Message**: `A vehicle with this chassis number already exists.`

## BR-VEHICLE-004
- **Status**: FINAL
- **Title**: Vehicle insurance dates must be valid
- **Description**: Third-party and body insurance dates must be valid and consistent with official records when provided.
- **Applies To**: Vehicle
- **Validation Point**: `VehicleService.CreateVehicle()`, `VehicleService.UpdateVehicle()`
- **Error Code**: `VEHICLE_INSURANCE_DATE_INVALID`
- **Error Message**: `Vehicle insurance dates are invalid.`

## BR-VEHICLE-005
- **Status**: FINAL
- **Title**: Expired or missing vehicle insurance triggers warning/error
- **Description**: The system must detect missing or expired vehicle insurance and show a warning/error based on assignment workflow.
- **Applies To**: Vehicle, MissionAssignment
- **Validation Point**: `VehicleService.ValidateVehicleForAssignment()`, `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `VEHICLE_INSURANCE_INVALID`
- **Error Message**: `Vehicle insurance is missing or expired.`

## BR-VEHICLE-006
- **Status**: FINAL
- **Title**: Vehicle cannot be assigned to multiple overlapping missions
- **Description**: A vehicle already allocated to an active mission within an overlapping time range cannot be assigned again.
- **Applies To**: Vehicle, MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `VEHICLE_ALREADY_ASSIGNED`
- **Error Message**: `Vehicle is already assigned to another active mission.`

## BR-VEHICLE-007
- **Status**: ASSUMPTION
- **Title**: Inactive or unhealthy vehicles cannot be assigned
- **Description**: Vehicles marked inactive, soft-deleted, or not service-ready cannot be selected.
- **Applies To**: Vehicle, MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `VEHICLE_NOT_SERVICE_READY`
- **Error Message**: `Vehicle is not ready for service.`

---

# 5) Contract Rules

## BR-CONTRACT-001
- **Status**: FINAL
- **Title**: Contract registration requires mandatory core fields
- **Description**: Driver, vehicle, start date, end date, and pricing fields must be provided.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`
- **Error Code**: `CONTRACT_REQUIRED_FIELDS_MISSING`
- **Error Message**: `Required contract fields are missing.`

## BR-CONTRACT-002
- **Status**: FINAL
- **Title**: Contract start date must be before end date
- **Description**: Contract validity period must be logically ordered.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`, `ContractService.UpdateContract()`
- **Error Code**: `CONTRACT_DATE_RANGE_INVALID`
- **Error Message**: `Contract start date must be before end date.`

## BR-CONTRACT-003
- **Status**: FINAL
- **Title**: Contract amounts must be stored accurately
- **Description**: Contract monetary fields must be entered accurately according to the agreement and cannot be null if required by calculation type.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`
- **Error Code**: `CONTRACT_RATE_INVALID`
- **Error Message**: `Contract rates are missing or invalid.`

## BR-CONTRACT-004
- **Status**: FINAL
- **Title**: Driver payroll calculation depends on contract data
- **Description**: Monthly driver payroll and mission cost calculations must use the contract rates linked to the relevant driver/vehicle.
- **Applies To**: Contract, MissionCost, Settlement
- **Validation Point**: `FinanceService.CalculateMissionCost()`, `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `CONTRACT_REQUIRED_FOR_CALCULATION`
- **Error Message**: `A valid contract is required for calculation.`

## BR-CONTRACT-005
- **Status**: ASSUMPTION
- **Title**: Only one active contract per driver-vehicle pair may overlap in time
- **Description**: The same driver-vehicle pair cannot have multiple overlapping active contracts.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`
- **Error Code**: `CONTRACT_OVERLAP_NOT_ALLOWED`
- **Error Message**: `Overlapping active contracts for the same driver and vehicle are not allowed.`

## BR-CONTRACT-006
- **Status**: ASSUMPTION
- **Title**: Negative pricing values are invalid
- **Description**: Hourly, distance, stop, sleep, penalty ceiling, and extra-payment rates must not be negative.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`, `ContractService.UpdateContract()`
- **Error Code**: `CONTRACT_NEGATIVE_RATE`
- **Error Message**: `Contract rates cannot be negative.`

## BR-CONTRACT-007
- **Status**: TODO
- **Title**: Insurance status on contract is ambiguous
- **Description**: RFB mentions contract insurance status but also states it may be non-functional in old system. Keep the field configurable and do not hard-code calculation logic against it until confirmed.
- **Applies To**: Contract
- **Validation Point**: `ContractService.CreateContract()`
- **Error Code**: `CONTRACT_INSURANCE_POLICY_TODO`
- **Error Message**: `TODO: Confirm contract insurance business role.`

---

# 6) Mission Request Rules

## BR-MISSION-001
- **Status**: FINAL
- **Title**: Mission must be approved before dispatch
- **Description**: A mission cannot be assigned to a driver or vehicle unless its status is Approved.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `MISSION_NOT_APPROVED`
- **Error Message**: `Mission must be approved before dispatch.`

## BR-MISSION-002
- **Status**: FINAL
- **Title**: Mission request requires origin and destination details
- **Description**: Origin and destination province/city/address are mandatory for mission submission.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_LOCATION_REQUIRED`
- **Error Message**: `Origin and destination details are required.`

## BR-MISSION-003
- **Status**: FINAL
- **Title**: Mission request requires start and end time
- **Description**: Mission start and end date-time must be supplied for every mission request.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_TIME_REQUIRED`
- **Error Message**: `Mission start and end date/time are required.`

## BR-MISSION-004
- **Status**: FINAL
- **Title**: Mission start time must be before end time
- **Description**: Time interval for mission request must be logically valid.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`, `MissionService.UpdateMissionRequest()`
- **Error Code**: `MISSION_TIME_RANGE_INVALID`
- **Error Message**: `Mission start time must be before end time.`

## BR-MISSION-005
- **Status**: FINAL
- **Title**: Mission request requires requester identity
- **Description**: Mission request must be linked to a valid requester user/employee.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_REQUESTER_REQUIRED`
- **Error Message**: `Mission requester is required.`

## BR-MISSION-006
- **Status**: FINAL
- **Title**: Mission reason is mandatory
- **Description**: Mission reason/purpose must be recorded before submission.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_REASON_REQUIRED`
- **Error Message**: `Mission reason is required.`

## BR-MISSION-007
- **Status**: FINAL
- **Title**: Mission request enters approval workflow after submission
- **Description**: After successful submission, the mission must be routed into the configured hierarchical approval chain.
- **Applies To**: MissionRequest, MissionApproval
- **Validation Point**: `MissionService.SubmitMissionRequest()`
- **Error Code**: `MISSION_APPROVAL_ROUTE_FAILED`
- **Error Message**: `Mission request could not be routed for approval.`

## BR-MISSION-008
- **Status**: FINAL
- **Title**: Any rejection in the approval chain rejects the whole mission request
- **Description**: If any manager in the configured approval path rejects the request, the whole request is rejected and the workflow ends.
- **Applies To**: MissionApproval, MissionRequest
- **Validation Point**: `ApprovalService.Reject()`
- **Error Code**: `MISSION_REJECTED_BY_APPROVER`
- **Error Message**: `Mission request was rejected in the approval workflow.`

## BR-MISSION-009
- **Status**: FINAL
- **Title**: Companion passengers may be attached to mission request
- **Description**: If the mission includes additional employees, they must be selected from registered staff members and stored as companions/passengers.
- **Applies To**: MissionPassenger
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_PASSENGER_INVALID`
- **Error Message**: `Mission passenger must reference a valid employee.`

## BR-MISSION-010
- **Status**: ASSUMPTION
- **Title**: Mission number must be system-generated and unique
- **Description**: Each mission request receives a unique mission number for search, tracking, and reporting.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_NUMBER_DUPLICATE`
- **Error Message**: `Generated mission number is not unique.`

## BR-MISSION-011
- **Status**: FINAL
- **Title**: Mission type must be one of configured values
- **Description**: Mission type must be selected from supported types such as hourly/daily or urban/outbound according to configured reference data.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_TYPE_INVALID`
- **Error Message**: `Mission type is invalid.`

## BR-MISSION-012
- **Status**: FINAL
- **Title**: Travel type must be one of configured values
- **Description**: Travel type such as land/air must be selected from allowed values.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_TRAVEL_TYPE_INVALID`
- **Error Message**: `Travel type is invalid.`

## BR-MISSION-013
- **Status**: TODO
- **Title**: Mission duration derivation is unclear
- **Description**: RFB references duration but does not define whether it is stored explicitly, derived from start/end time, or both.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.CreateMissionRequest()`
- **Error Code**: `MISSION_DURATION_POLICY_TODO`
- **Error Message**: `TODO: Confirm mission duration storage policy.`

---

# 7) Approval Rules

## BR-APPROVAL-001
- **Status**: FINAL
- **Title**: Approval must follow hierarchical order
- **Description**: Approval steps must execute in sequence according to the organizational hierarchy.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.Approve()`
- **Error Code**: `APPROVAL_ORDER_INVALID`
- **Error Message**: `Approval cannot be completed out of order.`

## BR-APPROVAL-002
- **Status**: FINAL
- **Title**: Next approver becomes active only after previous approval succeeds
- **Description**: The next step in the approval chain is activated only when the current step is approved.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.Approve()`
- **Error Code**: `APPROVAL_NEXT_STEP_INVALID`
- **Error Message**: `Next approval step cannot be activated before current approval is completed.`

## BR-APPROVAL-003
- **Status**: FINAL
- **Title**: Rejected mission cannot continue in approval chain
- **Description**: Once any approval step rejects the mission, remaining approval steps are cancelled/closed and no further approval action is allowed.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.Reject()`
- **Error Code**: `APPROVAL_ALREADY_TERMINATED`
- **Error Message**: `Approval workflow has already been terminated.`

## BR-APPROVAL-004
- **Status**: ASSUMPTION
- **Title**: Approval comments are mandatory on rejection
- **Description**: Rejection should capture a reason/comment for auditability and user feedback.
- **Applies To**: MissionApproval
- **Validation Point**: `ApprovalService.Reject()`
- **Error Code**: `APPROVAL_REJECTION_COMMENT_REQUIRED`
- **Error Message**: `Rejection comment is required.`

## BR-APPROVAL-005
- **Status**: ASSUMPTION
- **Title**: Approved mission status changes to Approved only after final approval step
- **Description**: Interim approvals update the step state, but the mission itself becomes Approved only after all required steps are approved.
- **Applies To**: MissionRequest, MissionApproval
- **Validation Point**: `ApprovalService.Approve()`
- **Error Code**: `APPROVAL_FINALIZATION_INVALID`
- **Error Message**: `Mission cannot be marked Approved before all approval steps are completed.`

---

# 8) Dispatch / Assignment Rules

## BR-DISPATCH-001
- **Status**: FINAL
- **Title**: Only approved missions may enter dispatch
- **Description**: Dispatch selection of driver and vehicle is allowed only for missions already approved.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_MISSION_NOT_APPROVED`
- **Error Message**: `Only approved missions may be dispatched.`

## BR-DISPATCH-002
- **Status**: FINAL
- **Title**: Driver and vehicle must be selected from service-ready lists
- **Description**: Assignment must use only drivers and vehicles listed as ready for service.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_RESOURCE_NOT_SERVICE_READY`
- **Error Message**: `Selected resource is not ready for service.`

## BR-DISPATCH-003
- **Status**: FINAL
- **Title**: Vehicle insurance validity must be checked before assignment
- **Description**: Vehicle cannot be assigned if insurance is expired or otherwise invalid.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_VEHICLE_INSURANCE_INVALID`
- **Error Message**: `Vehicle insurance must be valid before assignment.`

## BR-DISPATCH-004
- **Status**: FINAL
- **Title**: Driver availability must be checked before assignment
- **Description**: Driver must be available for the mission time range and not reserved/assigned elsewhere.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_DRIVER_UNAVAILABLE`
- **Error Message**: `Driver is unavailable for the selected mission.`

## BR-DISPATCH-005
- **Status**: FINAL
- **Title**: One mission can have only one driver and one vehicle
- **Description**: Each mission accepts exactly one assigned driver and one assigned vehicle at a time.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_SINGLE_ASSIGNMENT_ONLY`
- **Error Message**: `Mission can only have one active driver and one active vehicle assignment.`

## BR-DISPATCH-006
- **Status**: FINAL
- **Title**: Assignment requires explicit user confirmation
- **Description**: Final assignment commit must occur only after explicit user confirmation in the UI/application workflow.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.ConfirmAssignment()`
- **Error Code**: `DISPATCH_CONFIRMATION_REQUIRED`
- **Error Message**: `Assignment confirmation is required.`

## BR-DISPATCH-007
- **Status**: ASSUMPTION
- **Title**: Reassignment is allowed before mission execution starts
- **Description**: Assigned driver/vehicle may be changed before mission start, subject to audit trail and availability checks.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.ReassignDriverAndVehicle()`
- **Error Code**: `DISPATCH_REASSIGN_NOT_ALLOWED`
- **Error Message**: `Reassignment is not allowed after mission execution has started.`

## BR-DISPATCH-008
- **Status**: ASSUMPTION
- **Title**: Assignment must reference calculation contract when required
- **Description**: Where calculations depend on a specific driver/vehicle contract, dispatch must resolve and persist the contract link.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_CONTRACT_NOT_FOUND`
- **Error Message**: `No valid contract found for the selected driver and vehicle.`

---

# 9) Driver Attendance Rules

## BR-ATTENDANCE-001
- **Status**: FINAL
- **Title**: Driver attendance requires driver, date, entry time, and exit time
- **Description**: Attendance records must store the selected driver, attendance date, entry time, and exit time.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.CreateAttendanceRecord()`
- **Error Code**: `ATTENDANCE_REQUIRED_FIELDS_MISSING`
- **Error Message**: `Attendance record requires driver, date, entry time, and exit time.`

## BR-ATTENDANCE-002
- **Status**: FINAL
- **Title**: Entry time and exit time must reflect reality
- **Description**: Attendance times must be recorded accurately according to actual driver presence.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.CreateAttendanceRecord()`
- **Error Code**: `ATTENDANCE_TIME_INVALID`
- **Error Message**: `Attendance time values are invalid.`

## BR-ATTENDANCE-003
- **Status**: ASSUMPTION
- **Title**: Exit time must be after entry time within one attendance segment
- **Description**: For a single attendance segment, exit time cannot be earlier than entry time.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.CreateAttendanceRecord()`
- **Error Code**: `ATTENDANCE_TIME_RANGE_INVALID`
- **Error Message**: `Exit time must be after entry time.`

## BR-ATTENDANCE-004
- **Status**: FINAL
- **Title**: Duplicate attendance entries for the same driver/time should trigger warning/error
- **Description**: If a record already exists for the same date and overlapping time range, the system must prevent or warn against duplication.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.CreateAttendanceRecord()`
- **Error Code**: `ATTENDANCE_DUPLICATE`
- **Error Message**: `Attendance record overlaps with an existing record.`

## BR-ATTENDANCE-005
- **Status**: FINAL
- **Title**: Multiple attendance records per driver per day are allowed
- **Description**: The system must allow more than one attendance segment per driver per date.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.CreateAttendanceRecord()`
- **Error Code**: `N/A`
- **Error Message**: `N/A`

## BR-ATTENDANCE-006
- **Status**: FINAL
- **Title**: Attendance modifications are restricted
- **Description**: Delete or correction of attendance records may only be performed by authorized personnel.
- **Applies To**: DriverAttendance
- **Validation Point**: `DriverAttendanceService.UpdateAttendanceRecord()`, `DriverAttendanceService.DeleteAttendanceRecord()`
- **Error Code**: `ATTENDANCE_MODIFICATION_FORBIDDEN`
- **Error Message**: `Only authorized users may modify attendance records.`

## BR-ATTENDANCE-007
- **Status**: FINAL
- **Title**: Urban hourly payroll uses attendance records
- **Description**: For urban/hourly operations, attendance entry/exit records are used in end-of-month calculations.
- **Applies To**: DriverAttendance, Settlement
- **Validation Point**: `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `ATTENDANCE_REQUIRED_FOR_HOURLY_SETTLEMENT`
- **Error Message**: `Attendance data is required for hourly settlement calculation.`

---

# 10) Mission Execution Rules

## BR-EXECUTION-001
- **Status**: FINAL
- **Title**: Mission execution requires prior mission registration and assignment
- **Description**: Execution data cannot be recorded unless the mission exists and a driver/vehicle has been assigned.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_PREREQUISITE_MISSING`
- **Error Message**: `Mission execution requires an existing mission and active assignment.`

## BR-EXECUTION-002
- **Status**: FINAL
- **Title**: Execution requires outbound and return date/time records
- **Description**: Mission execution must record departure and return date/time values.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_TIME_REQUIRED`
- **Error Message**: `Departure and return time are required.`

## BR-EXECUTION-003
- **Status**: ASSUMPTION
- **Title**: Return time must not be before departure time
- **Description**: Return date/time must be later than or equal to departure date/time.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_TIME_RANGE_INVALID`
- **Error Message**: `Return time must not be before departure time.`

## BR-EXECUTION-004
- **Status**: FINAL
- **Title**: Start and end odometer values are required
- **Description**: Kilometer values for departure and return must be recorded from vehicle odometer.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_ODOMETER_REQUIRED`
- **Error Message**: `Start and end odometer values are required.`

## BR-EXECUTION-005
- **Status**: ASSUMPTION
- **Title**: End odometer must not be lower than start odometer
- **Description**: Return odometer cannot be less than departure odometer.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_ODOMETER_RANGE_INVALID`
- **Error Message**: `End odometer must be greater than or equal to start odometer.`

## BR-EXECUTION-006
- **Status**: FINAL
- **Title**: Execution cannot be completed with incomplete mandatory data
- **Description**: Missing required time, kilometer, or linked assignment data must block completion.
- **Applies To**: MissionExecution
- **Validation Point**: `MissionExecutionService.CompleteExecution()`
- **Error Code**: `EXECUTION_INCOMPLETE_DATA`
- **Error Message**: `Mission execution cannot be completed with incomplete data.`

## BR-EXECUTION-007
- **Status**: FINAL
- **Title**: Mission cost recalculation is allowed before settlement
- **Description**: The system may recalculate mission cost while the execution remains editable and not settled.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `FinanceService.RecalculateMissionCost()`
- **Error Code**: `EXECUTION_RECALCULATION_NOT_ALLOWED`
- **Error Message**: `Mission cost cannot be recalculated after settlement.`

## BR-EXECUTION-008
- **Status**: FINAL
- **Title**: Optional charge categories may be recorded during execution
- **Description**: Stop cost, penalty, and extra payment are supported execution cost inputs.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `MissionExecutionService.CreateOrUpdateExecution()`
- **Error Code**: `EXECUTION_COST_COMPONENT_INVALID`
- **Error Message**: `One or more execution cost components are invalid.`

## BR-EXECUTION-009
- **Status**: TODO
- **Title**: 'Without payment' option needs confirmation
- **Description**: The old system had an option similar to 'without salary/payment'; exact semantics must be confirmed before hard validation is written.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `MissionExecutionService.CompleteExecution()`
- **Error Code**: `EXECUTION_WITHOUT_PAYMENT_POLICY_TODO`
- **Error Message**: `TODO: Confirm without-payment behavior.`

---

# 11) Financial Calculation Rules

## BR-FINANCE-001
- **Status**: FINAL
- **Title**: Urban missions are calculated hourly based on attendance
- **Description**: For the center-services model described in the RFB, urban missions are calculated on an hourly basis using entry/exit attendance hours, not the count of missions performed within those hours.
- **Applies To**: DriverAttendance, Settlement
- **Validation Point**: `FinanceService.CalculateUrbanCompensation()`, `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `FINANCE_URBAN_ATTENDANCE_REQUIRED`
- **Error Message**: `Urban compensation requires attendance-based hourly data.`

## BR-FINANCE-002
- **Status**: FINAL
- **Title**: Outbound missions are calculated based on kilometers traveled
- **Description**: For outbound missions, total traveled kilometers are multiplied by the kilometer rate defined in the contract.
- **Applies To**: MissionExecution, Contract, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_KM_RATE_REQUIRED`
- **Error Message**: `Outbound mission calculation requires a valid kilometer rate.`

## BR-FINANCE-003
- **Status**: FINAL
- **Title**: Driving hours are derived as one hour per 100 kilometers
- **Description**: For outbound missions, each 100 kilometers is counted as one hour of driving time.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_DRIVING_HOUR_FORMULA_ERROR`
- **Error Message**: `Driving hours could not be derived using the configured formula.`

## BR-FINANCE-004
- **Status**: FINAL
- **Title**: Sleep hours equal total mission hours minus derived driving hours
- **Description**: Remaining mission time after deducting derived driving hours is treated as sleep time for outbound calculation.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_SLEEP_HOUR_FORMULA_ERROR`
- **Error Message**: `Sleep hours could not be derived using the configured formula.`

## BR-FINANCE-005
- **Status**: ASSUMPTION
- **Title**: Sleep hours cannot be negative
- **Description**: If derived sleep time becomes negative due to inconsistent input, the calculation must fail instead of silently clamping.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_SLEEP_HOUR_NEGATIVE`
- **Error Message**: `Derived sleep hours cannot be negative.`

## BR-FINANCE-006
- **Status**: FINAL
- **Title**: Sleep compensation uses contract sleep rate
- **Description**: Derived sleep hours must be multiplied by the contract sleep rate.
- **Applies To**: Contract, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_SLEEP_RATE_REQUIRED`
- **Error Message**: `Sleep rate is required for outbound mission calculation.`

## BR-FINANCE-007
- **Status**: FINAL
- **Title**: Additional cost components must be included in mission cost
- **Description**: Stop cost, penalty, and extra payment must be included where provided by the execution record and calculation policy.
- **Applies To**: MissionExecution, MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_COST_COMPONENT_MISSING`
- **Error Message**: `Mission cost calculation is missing one or more required components.`

## BR-FINANCE-008
- **Status**: FINAL
- **Title**: Mission cost must be persisted after successful calculation
- **Description**: After calculation, the system must store the resulting mission cost for later settlement and reporting.
- **Applies To**: MissionCost
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_COST_PERSISTENCE_FAILED`
- **Error Message**: `Mission cost could not be stored.`

## BR-FINANCE-009
- **Status**: ASSUMPTION
- **Title**: Rounding policy must be centralized
- **Description**: Monetary rounding must use one centrally configured policy to avoid mismatch across reports and settlement.
- **Applies To**: MissionCost, Settlement
- **Validation Point**: `FinanceService.*`, `SettlementService.*`
- **Error Code**: `FINANCE_ROUNDING_POLICY_MISSING`
- **Error Message**: `Financial rounding policy is not configured.`

## BR-FINANCE-010
- **Status**: TODO
- **Title**: Other organization calculation models are incomplete
- **Description**: The RFB indicates there are other organizational calculation models beyond the center-services model, but the section is incomplete. Calculation strategy must therefore be configurable and extensible.
- **Applies To**: FinancePolicy, MissionCost, Settlement
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_POLICY_MODEL_INCOMPLETE`
- **Error Message**: `Calculation policy is incomplete for this organization.`

---

# 12) Settlement and Payroll Rules

## BR-SETTLEMENT-001
- **Status**: FINAL
- **Title**: Monthly settlement aggregates mission and/or attendance data
- **Description**: End-of-month settlement must aggregate all relevant mission costs and/or attendance-based earnings for the driver within the selected period.
- **Applies To**: Settlement
- **Validation Point**: `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `SETTLEMENT_INPUT_DATA_MISSING`
- **Error Message**: `Settlement cannot be generated because required input data is missing.`

## BR-SETTLEMENT-002
- **Status**: FINAL
- **Title**: Settlement period is monthly
- **Description**: Payroll/settlement generation operates on a monthly period.
- **Applies To**: Settlement
- **Validation Point**: `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `SETTLEMENT_PERIOD_INVALID`
- **Error Message**: `Settlement period must be monthly.`

## BR-SETTLEMENT-003
- **Status**: ASSUMPTION
- **Title**: One finalized settlement per driver per month
- **Description**: Only one finalized settlement should exist for a driver for the same year/month unless a formal reversal/reopen process is implemented.
- **Applies To**: Settlement
- **Validation Point**: `SettlementService.GenerateMonthlySettlement()`
- **Error Code**: `SETTLEMENT_ALREADY_FINALIZED`
- **Error Message**: `A finalized settlement already exists for this driver and month.`

## BR-SETTLEMENT-004
- **Status**: FINAL
- **Title**: Settled financial records become immutable
- **Description**: Once settlement is finalized, underlying financial records must not be modified through ordinary operations.
- **Applies To**: MissionCost, Settlement
- **Validation Point**: `FinanceService.UpdateMissionCost()`, `SettlementService.FinalizeSettlement()`
- **Error Code**: `SETTLEMENT_IMMUTABLE`
- **Error Message**: `Settled financial records cannot be modified.`

## BR-SETTLEMENT-005
- **Status**: ASSUMPTION
- **Title**: Re-open settlement requires elevated permission and audit
- **Description**: If the business later permits reopening a settlement, it must require elevated authorization and full audit trail.
- **Applies To**: Settlement
- **Validation Point**: `SettlementService.ReopenSettlement()`
- **Error Code**: `SETTLEMENT_REOPEN_FORBIDDEN`
- **Error Message**: `Settlement reopening is not allowed.`

---

# 13) Reporting Rules

## BR-REPORT-001
- **Status**: FINAL
- **Title**: Mission reports must support mission-based search and filtering
- **Description**: The system must allow retrieval of missions for tracking and reporting by mission attributes such as requester, mission number, origin/destination, and status.
- **Applies To**: Reporting
- **Validation Point**: `ReportService.GetMissionReport()`
- **Error Code**: `REPORT_QUERY_INVALID`
- **Error Message**: `Report query parameters are invalid.`

## BR-REPORT-002
- **Status**: FINAL
- **Title**: Reports must support filtering by driver or vehicle where applicable
- **Description**: Assignment and execution reports should be queryable by selected driver or vehicle.
- **Applies To**: Reporting
- **Validation Point**: `ReportService.GetMissionAssignmentReport()`
- **Error Code**: `REPORT_FILTER_INVALID`
- **Error Message**: `Requested report filter is invalid.`

## BR-REPORT-003
- **Status**: FINAL
- **Title**: Historical records should remain available for management review
- **Description**: Mission, attendance, and financial history must remain queryable for audit and management reporting.
- **Applies To**: Reporting
- **Validation Point**: Query layer / retention policy
- **Error Code**: `REPORT_HISTORY_UNAVAILABLE`
- **Error Message**: `Historical report data is unavailable.`

## BR-REPORT-004
- **Status**: ASSUMPTION
- **Title**: Soft-deleted records must be excluded from operational reports by default
- **Description**: Operational reports should exclude soft-deleted records unless specifically requested by privileged users.
- **Applies To**: Reporting
- **Validation Point**: Query layer / report builder
- **Error Code**: `N/A`
- **Error Message**: `N/A`

---

# 14) Audit, Integrity, and Data Governance Rules

## BR-AUDIT-001
- **Status**: ASSUMPTION
- **Title**: All state-changing operations must be audited
- **Description**: Create/update/delete/approve/reject/assign/calculate/finalize actions should write audit logs with actor, timestamp, and before/after values where practical.
- **Applies To**: All aggregate roots
- **Validation Point**: Audit middleware / domain event handlers
- **Error Code**: `AUDIT_LOG_WRITE_FAILED`
- **Error Message**: `Audit log could not be written.`

## BR-AUDIT-002
- **Status**: ASSUMPTION
- **Title**: Soft delete is preferred over hard delete for business records
- **Description**: Drivers, vehicles, contracts, missions, assignments, executions, and settlements should be soft-deleted where legal/technical requirements allow.
- **Applies To**: Business entities
- **Validation Point**: Repository layer / domain services
- **Error Code**: `DELETE_HARD_FORBIDDEN`
- **Error Message**: `Hard delete is not allowed for this record.`

## BR-AUDIT-003
- **Status**: ASSUMPTION
- **Title**: Audit columns are mandatory for all business tables
- **Description**: CreatedAt, CreatedBy, UpdatedAt, UpdatedBy, IsDeleted, DeletedAt, DeletedBy should exist on business tables unless there is a justified exception.
- **Applies To**: Database schema
- **Validation Point**: `N/A` (schema rule)
- **Error Code**: `N/A`
- **Error Message**: `N/A`

## BR-AUDIT-004
- **Status**: FINAL
- **Title**: Unique business identifiers must be enforced where duplication causes operational ambiguity
- **Description**: National code, mission number, and logically unique master data must be protected by unique constraints where applicable.
- **Applies To**: Driver, MissionRequest, master data
- **Validation Point**: Service validation + database constraints
- **Error Code**: `DATA_UNIQUENESS_VIOLATION`
- **Error Message**: `Duplicate business identifier is not allowed.`

---

# 15) Configurable / TODO Rules from Incomplete RFB

## BR-TODO-001
- **Status**: TODO
- **Title**: Alternative urban calculation by kilometer is not finalized
- **Description**: The RFB mentions another possible urban model based on mission kilometers, but the specification is incomplete. Implement strategy/config placeholders without final business enforcement.
- **Applies To**: FinancePolicy
- **Validation Point**: `FinanceService.CalculateMissionCost()`
- **Error Code**: `FINANCE_URBAN_KM_POLICY_TODO`
- **Error Message**: `TODO: Urban kilometer-based calculation policy is not finalized.`

## BR-TODO-002
- **Status**: TODO
- **Title**: Additional organization-specific finance policies are incomplete
- **Description**: The RFB explicitly states other organizations may use additional models, but the examples are truncated. Policy engine must therefore be pluggable.
- **Applies To**: FinancePolicy
- **Validation Point**: `FinanceService.ResolvePolicy()`
- **Error Code**: `FINANCE_ORG_POLICY_NOT_DEFINED`
- **Error Message**: `Organization-specific finance policy is not defined.`

## BR-TODO-003
- **Status**: TODO
- **Title**: Exact list of mission status values must remain configurable
- **Description**: Core status flow is known, but whether there are additional statuses like ReturnedForCorrection, Cancelled, Settled, Closed, etc. must remain configurable.
- **Applies To**: MissionRequest
- **Validation Point**: `MissionService.ChangeStatus()`
- **Error Code**: `MISSION_STATUS_POLICY_TODO`
- **Error Message**: `TODO: Mission status model requires final confirmation.`

## BR-TODO-004
- **Status**: TODO
- **Title**: Exact cancellation policy is undefined
- **Description**: The RFB does not clearly define who can cancel a mission after approval/assignment and under what conditions.
- **Applies To**: MissionRequest, MissionAssignment, MissionExecution
- **Validation Point**: `MissionService.CancelMission()`
- **Error Code**: `MISSION_CANCELLATION_POLICY_TODO`
- **Error Message**: `TODO: Mission cancellation policy is not finalized.`

## BR-TODO-005
- **Status**: TODO
- **Title**: Driver and vehicle branch-crossing policy is undefined
- **Description**: The RFB does not clearly state whether a driver from one branch can be assigned to a mission requested by another branch.
- **Applies To**: MissionAssignment
- **Validation Point**: `DispatchService.AssignDriverAndVehicle()`
- **Error Code**: `DISPATCH_BRANCH_POLICY_TODO`
- **Error Message**: `TODO: Cross-branch assignment policy is not finalized.`

---

# 16) Suggested Enum Domains for Implementation

These are not final business rules, but recommended controlled values to support the above validations.

## MissionStatus
- `Draft`
- `PendingApproval`
- `Approved`
- `Rejected`
- `Assigned`
- `InProgress`
- `Completed`
- `CostCalculated`
- `Settled`
- `Cancelled` *(TODO/optional)*
- `ReturnedForCorrection` *(TODO/optional)*

## MissionType
- `Urban`
- `Outbound`
- `Hourly` *(TODO if distinct from Urban)*
- `Daily` *(TODO if distinct from Outbound)*

## TravelType
- `Land`
- `Air`

## AssignmentStatus
- `Pending`
- `Assigned`
- `Confirmed`
- `Reassigned`
- `Cancelled`

## SettlementStatus
- `Draft`
- `Calculated`
- `Finalized`
- `Reopened` *(ASSUMPTION / optional)*

---

# 17) Implementation Guidance for Codex

1. Enforce every **FINAL** rule in both:
   - application/service validators
   - database constraints where applicable

2. Implement **ASSUMPTION** rules behind:
   - feature flags
   - configuration values
   - policy classes
   - seeded enum/reference tables

3. Implement **TODO** rules as:
   - configuration placeholders
   - disabled validations with explicit comments
   - domain policies throwing `NotConfigured` only if the affected feature is actually used

4. For every rule above, generate:
   - one service-level validator
   - one unit test for valid case
   - one unit test for invalid case
   - one standardized API error response mapping

5. Recommended API error response:

```json
{
  "isSuccess": false,
  "message": "Mission must be approved before dispatch.",
  "errors": [
    {
      "code": "MISSION_NOT_APPROVED",
      "field": null,
      "detail": "Mission must be approved before dispatch."
    }
  ]
}
```

---

# 18) Minimum Validation Coverage Matrix

| Module | Minimum Required Rules |
|---|---|
| Master Data | BR-MASTERDATA-001..009 |
| Driver | BR-DRIVER-001..009 |
| Vehicle | BR-VEHICLE-001..007 |
| Contract | BR-CONTRACT-001..007 |
| Mission | BR-MISSION-001..013 |
| Approval | BR-APPROVAL-001..005 |
| Dispatch | BR-DISPATCH-001..008 |
| Attendance | BR-ATTENDANCE-001..007 |
| Execution | BR-EXECUTION-001..009 |
| Finance | BR-FINANCE-001..010 |
| Settlement | BR-SETTLEMENT-001..005 |
| Reporting | BR-REPORT-001..004 |
| Audit | BR-AUDIT-001..004 |
| TODO/Policy | BR-TODO-001..005 |

