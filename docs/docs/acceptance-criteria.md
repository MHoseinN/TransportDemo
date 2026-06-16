# Acceptance Criteria — Transport & Mission Management System

Version: 1.0-draft  
Status: Codex-ready, change-friendly, partially open for unresolved RFB items  
Purpose: This document defines testable acceptance criteria for major product features so Codex can generate implementation aligned with expected behavior and QA can convert them into test cases.

---

## 1. How to use this document

- Each feature has a unique `Feature ID`.
- Each acceptance criterion has a unique `AC ID`.
- Criteria are written to be testable.
- When the RFB is incomplete or ambiguous, criteria are marked as `TODO` or `CONFIGURABLE`.
- If business policy changes later, update the criteria instead of hard-coding assumptions in source code.

### Status markers
- **FINAL**: clear enough to implement now.
- **CONFIGURABLE**: implement via settings, policy tables, or feature flags.
- **TODO**: intentionally left open for later completion.

### General implementation expectation for Codex
- Backend validation must enforce mandatory criteria.
- Frontend validation should mirror backend validation where possible.
- All business-relevant failures must return meaningful error codes/messages.
- All create/update/delete operations must be auditable.

---

## 2. Global acceptance criteria

### Feature ID: FEA-GLOBAL-001 — Auditability
**Status:** FINAL

- **AC-GLOBAL-001**: System must record create/update/delete/approve/reject/assign/calculate/settle actions with actor, timestamp, entity type, entity id, old value summary, and new value summary where applicable.
- **AC-GLOBAL-002**: Audit logs must be queryable by entity type, entity id, actor, and date range.
- **AC-GLOBAL-003**: Financially settled records must remain traceable even if later administrative corrections are introduced.

### Feature ID: FEA-GLOBAL-002 — Validation and errors
**Status:** FINAL

- **AC-GLOBAL-004**: System must reject invalid input with appropriate HTTP status codes and structured error payload.
- **AC-GLOBAL-005**: Validation messages must identify the failing field or business rule whenever possible.
- **AC-GLOBAL-006**: Frontend must display field-level validation errors for form inputs.

### Feature ID: FEA-GLOBAL-003 — Authorization
**Status:** FINAL

- **AC-GLOBAL-007**: Users may access only features allowed by the current permission matrix.
- **AC-GLOBAL-008**: Unauthorized requests must be rejected by backend authorization even if frontend hides UI.
- **AC-GLOBAL-009**: Role or scope changes must take effect on subsequent authorized requests.

### Feature ID: FEA-GLOBAL-004 — Soft delete and history
**Status:** CONFIGURABLE

- **AC-GLOBAL-010**: Deletable master data should use soft delete unless legal/operational policy requires hard delete.
- **AC-GLOBAL-011**: Records referenced by mission, finance, or settlement modules must not be physically deleted if historical traceability would be broken.
- **AC-GLOBAL-012**: Inactive records must be excluded from default selection lists unless explicitly requested.

---

## 3. Authentication and session

### Feature ID: FEA-AUTH-001 — Login
**Status:** FINAL

- **AC-AUTH-001**: User can log in with valid credentials.
- **AC-AUTH-002**: System rejects invalid credentials.
- **AC-AUTH-003**: System returns access token and refresh token on successful login.
- **AC-AUTH-004**: After login, user is redirected to dashboard or default landing page based on role.
- **AC-AUTH-005**: Locked or inactive users cannot log in.

### Feature ID: FEA-AUTH-002 — Logout / token refresh
**Status:** FINAL

- **AC-AUTH-006**: System can refresh a valid refresh token and issue a new access token.
- **AC-AUTH-007**: System rejects expired or invalid refresh tokens.
- **AC-AUTH-008**: Logout invalidates the current session according to the chosen auth design.

---

## 4. Base master data

### Feature ID: FEA-GEO-001 — Province management
**Status:** FINAL

- **AC-GEO-001**: Authorized user can create a province with required fields.
- **AC-GEO-002**: Province name must be unique within the system according to configured normalization rules.
- **AC-GEO-003**: Inactive provinces must not appear in standard mission selection lists.
- **AC-GEO-004**: Province changes must be auditable.

### Feature ID: FEA-GEO-002 — City management
**Status:** FINAL

- **AC-GEO-005**: Authorized user can create a city under an existing province.
- **AC-GEO-006**: City must be linked to exactly one province.
- **AC-GEO-007**: Duplicate city names within the same province must be prevented according to configured normalization rules.
- **AC-GEO-008**: Inactive cities must not appear in standard mission selection lists.

### Feature ID: FEA-ORG-001 — Branch management
**Status:** FINAL

- **AC-ORG-001**: Authorized user can create, edit, activate, and deactivate branches.
- **AC-ORG-002**: Branch code must be unique if branch code is enabled as a required field.
- **AC-ORG-003**: Branches referenced by users, drivers, or missions cannot be deleted in a way that breaks referential integrity.

### Feature ID: FEA-ORG-002 — Organization unit management
**Status:** CONFIGURABLE

- **AC-ORG-004**: Authorized user can manage organization units in hierarchical form.
- **AC-ORG-005**: Parent-child cycles must be prevented.
- **AC-ORG-006**: Approval routing must be able to reference organization units when the organization chooses hierarchy-based approval.

### Feature ID: FEA-USER-001 — User and role management
**Status:** FINAL

- **AC-USER-001**: Authorized admin can create users with required identity and access fields.
- **AC-USER-002**: Username or login identifier must be unique.
- **AC-USER-003**: Authorized admin can assign one or more roles to a user, subject to security policy.
- **AC-USER-004**: Inactive users cannot perform authenticated business actions.

---

## 5. Driver management

### Feature ID: FEA-DRIVER-001 — Driver creation
**Status:** FINAL

- **AC-DRIVER-001**: Authorized user can create a driver with required personal and operational fields.
- **AC-DRIVER-002**: National code must be unique if national code is enabled as required by organization policy.
- **AC-DRIVER-003**: Driving license number must be required.
- **AC-DRIVER-004**: Driver cannot be activated if critical required fields are missing.
- **AC-DRIVER-005**: Driver must be linked to a valid branch when branch assignment is required.

### Feature ID: FEA-DRIVER-002 — Driver update and status
**Status:** FINAL

- **AC-DRIVER-006**: Authorized user can edit mutable driver fields.
- **AC-DRIVER-007**: Deactivated drivers must not appear in standard dispatch selection lists.
- **AC-DRIVER-008**: Expired or missing driver insurance data must be handled according to current policy: warning, blocking, or conditional assignment.
- **AC-DRIVER-009**: Driver status changes must be auditable.

### Feature ID: FEA-DRIVER-003 — Driver availability
**Status:** FINAL

- **AC-DRIVER-010**: Driver availability must consider current active mission assignments.
- **AC-DRIVER-011**: Driver must not be assignable to overlapping mission windows.
- **AC-DRIVER-012**: Availability checks must be available to dispatch screens and APIs.

---

## 6. Vehicle management

### Feature ID: FEA-VEHICLE-001 — Vehicle creation
**Status:** FINAL

- **AC-VEHICLE-001**: Authorized user can create a vehicle with required identity and insurance fields.
- **AC-VEHICLE-002**: Plate number must be unique according to configured normalization rules.
- **AC-VEHICLE-003**: Chassis number must be unique if captured by policy.
- **AC-VEHICLE-004**: Vehicle ownership type must be stored when the organization distinguishes personal vs organizational vehicles.

### Feature ID: FEA-VEHICLE-002 — Vehicle update and status
**Status:** FINAL

- **AC-VEHICLE-005**: Authorized user can edit mutable vehicle fields.
- **AC-VEHICLE-006**: Inactive vehicles must not appear in standard dispatch selection lists.
- **AC-VEHICLE-007**: Vehicles with expired mandatory insurance must be blocked or warned according to configured policy.
- **AC-VEHICLE-008**: Vehicle changes must be auditable.

### Feature ID: FEA-VEHICLE-003 — Vehicle availability
**Status:** FINAL

- **AC-VEHICLE-009**: Vehicle must not be assignable to overlapping active mission windows.
- **AC-VEHICLE-010**: Vehicle availability must be queryable from dispatch APIs and screens.

---

## 7. Contract management

### Feature ID: FEA-CONTRACT-001 — Contract creation
**Status:** FINAL

- **AC-CONTRACT-001**: Authorized user can create a contract linked to a valid driver and vehicle.
- **AC-CONTRACT-002**: Contract start date and end date must be valid and start date must not be after end date.
- **AC-CONTRACT-003**: Required pricing fields must be stored according to current calculation policy.
- **AC-CONTRACT-004**: Contract cannot be activated if required pricing inputs are missing.

### Feature ID: FEA-CONTRACT-002 — Contract validity and overlap
**Status:** CONFIGURABLE

- **AC-CONTRACT-005**: System must prevent prohibited overlap of active contracts for the same driver-vehicle pair.
- **AC-CONTRACT-006**: Dispatch and finance modules must use the valid applicable contract according to mission date and policy.
- **AC-CONTRACT-007**: Expired contracts must not be selected for new assignments unless explicit override policy exists.

### Feature ID: FEA-CONTRACT-003 — Contract updates
**Status:** CONFIGURABLE

- **AC-CONTRACT-008**: Authorized user can update contract details before financial settlement impact is locked.
- **AC-CONTRACT-009**: If a contract affects already calculated missions, recalculation behavior must follow configured policy: block, allow with audit, or create adjustment.

---

## 8. Mission request

### Feature ID: FEA-MISSION-001 — Mission request creation
**Status:** FINAL

- **AC-MISSION-001**: User can create a mission request with valid data.
- **AC-MISSION-002**: System rejects request if origin city or destination city is empty.
- **AC-MISSION-003**: Created mission status must be `Draft` or `PendingApproval` based on configured submission policy.
- **AC-MISSION-004**: Mission number must be unique.
- **AC-MISSION-005**: Request must be visible in the manager approval list when it enters approval flow.
- **AC-MISSION-006**: Start date/time must be before end date/time.
- **AC-MISSION-007**: Mission type must be one of the configured allowed values.
- **AC-MISSION-008**: Travel type must be one of the configured allowed values when travel type is required.
- **AC-MISSION-009**: Origin and destination address text fields must be stored when provided.
- **AC-MISSION-010**: Passenger list must store selected companion personnel when the feature is used.

### Feature ID: FEA-MISSION-002 — Mission request editing
**Status:** CONFIGURABLE

- **AC-MISSION-011**: User can edit own mission request while it is in editable state according to policy.
- **AC-MISSION-012**: Editing must be blocked after approval, assignment, or a configured lock state.
- **AC-MISSION-013**: Edits to approval-pending requests may require approval reset according to configured policy.

### Feature ID: FEA-MISSION-003 — Mission search and view
**Status:** FINAL

- **AC-MISSION-014**: Authorized users can search missions by mission number, requester, date range, status, and selected operational filters.
- **AC-MISSION-015**: Mission details page must show request data, current status, approval history, assignment details, execution details, and finance summary according to role access.

---

## 9. Mission approval workflow

### Feature ID: FEA-APPROVAL-001 — Approval inbox
**Status:** FINAL

- **AC-APPROVAL-001**: Manager must see pending mission requests requiring their action.
- **AC-APPROVAL-002**: Approval list must support filtering by date, requester, status, and organizational scope.
- **AC-APPROVAL-003**: Manager can open request details before approving or rejecting.

### Feature ID: FEA-APPROVAL-002 — Approve / reject mission
**Status:** FINAL

- **AC-APPROVAL-004**: Authorized approver can approve a mission request in pending approval state.
- **AC-APPROVAL-005**: Authorized approver can reject a mission request in pending approval state.
- **AC-APPROVAL-006**: Rejected missions must not proceed to dispatch.
- **AC-APPROVAL-007**: Approval or rejection action must be auditable.
- **AC-APPROVAL-008**: Approval comments and rejection reason must be stored when required by policy.

### Feature ID: FEA-APPROVAL-003 — Multi-level approval
**Status:** TODO

- **AC-APPROVAL-009**: System must support hierarchical approval routing if organization policy requires multiple approvers.
- **AC-APPROVAL-010**: Request must advance to next approver only after current approval succeeds.
- **AC-APPROVAL-011**: Any configured rejection in the chain must terminate the approval workflow and mark request rejected.
- **AC-APPROVAL-012**: Exact routing logic must remain configurable until Chargoon/organizational hierarchy details are finalized.

---

## 10. Dispatch and assignment

### Feature ID: FEA-DISPATCH-001 — Resource selection
**Status:** FINAL

- **AC-DISPATCH-001**: Dispatcher can view available drivers and vehicles for an approved mission.
- **AC-DISPATCH-002**: Availability calculation must consider overlapping missions.
- **AC-DISPATCH-003**: Resource list must reflect insurance status according to current dispatch policy.
- **AC-DISPATCH-004**: Resource list must support filtering by branch and operational criteria when applicable.

### Feature ID: FEA-DISPATCH-002 — Driver and vehicle assignment
**Status:** FINAL

- **AC-DISPATCH-005**: Mission cannot be assigned unless it is in an assignable approved state.
- **AC-DISPATCH-006**: Dispatcher can assign exactly one driver and one vehicle per mission under current RFB assumptions.
- **AC-DISPATCH-007**: System must create an assignment record after successful allocation.
- **AC-DISPATCH-008**: Assigned mission must transition to assignment-related status according to state machine.
- **AC-DISPATCH-009**: Assignment operation must be auditable.

### Feature ID: FEA-DISPATCH-003 — Reassignment and removal
**Status:** CONFIGURABLE

- **AC-DISPATCH-010**: Authorized users can reassign driver or vehicle before execution lock state.
- **AC-DISPATCH-011**: Reassignment must re-run eligibility and overlap checks.
- **AC-DISPATCH-012**: Reassignment history must be preserved.
- **AC-DISPATCH-013**: Whether assignment can be removed entirely after creation must remain configurable.

---

## 11. Driver attendance

### Feature ID: FEA-ATTENDANCE-001 — Entry/exit registration
**Status:** FINAL

- **AC-ATTENDANCE-001**: Authorized user can register driver entry and exit times for a given attendance date.
- **AC-ATTENDANCE-002**: System must allow multiple attendance records per driver per day if policy requires multiple traffic windows.
- **AC-ATTENDANCE-003**: Exit time must not be before entry time for a single attendance record.
- **AC-ATTENDANCE-004**: Attendance records must be auditable.

### Feature ID: FEA-ATTENDANCE-002 — Attendance validation
**Status:** CONFIGURABLE

- **AC-ATTENDANCE-005**: Duplicate attendance detection rules must be configurable.
- **AC-ATTENDANCE-006**: Attendance linked to locked finance periods must not be editable without elevated override.

---

## 12. Mission execution

### Feature ID: FEA-EXECUTION-001 — Start and complete execution
**Status:** FINAL

- **AC-EXECUTION-001**: Assigned mission can be moved to in-progress state by authorized workflow.
- **AC-EXECUTION-002**: Mission execution cannot be completed unless mandatory operational fields are present.
- **AC-EXECUTION-003**: Completed execution must become available for finance calculation.

### Feature ID: FEA-EXECUTION-002 — Kilometer and time registration
**Status:** FINAL

- **AC-EXECUTION-004**: Authorized user can store departure and return date/time for a mission.
- **AC-EXECUTION-005**: Authorized user can record departure kilometer and return kilometer.
- **AC-EXECUTION-006**: Return kilometer must be greater than or equal to departure kilometer.
- **AC-EXECUTION-007**: System must compute total kilometers or validate provided total according to implementation policy.
- **AC-EXECUTION-008**: Execution data changes must be auditable.

### Feature ID: FEA-EXECUTION-003 — Optional execution cost inputs
**Status:** CONFIGURABLE

- **AC-EXECUTION-009**: System must support stop cost, penalty, and extra payment inputs where enabled by policy.
- **AC-EXECUTION-010**: Disabled cost components must not be required by validation.
- **AC-EXECUTION-011**: Reason/comment fields should be stored for manual penalties and manual extra payments.

---

## 13. Finance calculation

### Feature ID: FEA-FINANCE-001 — Mission cost calculation
**Status:** FINAL

- **AC-FINANCE-001**: Authorized finance user can calculate mission cost for eligible execution records.
- **AC-FINANCE-002**: Calculation must use the applicable contract and current calculation policy version.
- **AC-FINANCE-003**: Calculation result must store a breakdown of components used in the total.
- **AC-FINANCE-004**: System must reject cost calculation when required contract or mandatory execution data is missing.

### Feature ID: FEA-FINANCE-002 — Urban mission formula
**Status:** CONFIGURABLE

- **AC-FINANCE-005**: For urban mission policies, total cost must be calculable from attendance hours and hourly contract rate.
- **AC-FINANCE-006**: Attendance-hour derivation rules must remain configurable if organization changes the urban policy.

### Feature ID: FEA-FINANCE-003 — Outbound mission formula
**Status:** CONFIGURABLE

- **AC-FINANCE-007**: For outbound mission policies, system must support calculation using kilometers, sleep hours, stop cost, penalty, and extra payment according to active policy.
- **AC-FINANCE-008**: Driving hour conversion rule such as `100 KM = 1 hour` must be policy-driven, not hard-coded without override support.
- **AC-FINANCE-009**: Negative computed sleep hours must be blocked or normalized according to configured policy.

### Feature ID: FEA-FINANCE-004 — Recalculation
**Status:** CONFIGURABLE

- **AC-FINANCE-010**: Recalculation must be allowed only before settlement lock unless override permission exists.
- **AC-FINANCE-011**: Recalculation must preserve prior calculation history or audit trail.
- **AC-FINANCE-012**: Recalculated totals must be visible in mission finance details.

---

## 14. Monthly settlement and payroll

### Feature ID: FEA-SETTLEMENT-001 — Settlement generation
**Status:** FINAL

- **AC-SETTLEMENT-001**: Authorized finance user can generate monthly settlement for a target period.
- **AC-SETTLEMENT-002**: Settlement generation must aggregate eligible attendance and mission execution/cost records according to active policy.
- **AC-SETTLEMENT-003**: System must prevent duplicate final settlement generation for the same driver and period unless replacement/reopen policy exists.
- **AC-SETTLEMENT-004**: Settlement records must store totals and relevant itemized references.

### Feature ID: FEA-SETTLEMENT-002 — Payroll visibility
**Status:** FINAL

- **AC-SETTLEMENT-005**: Finance users can view payroll totals by driver and period.
- **AC-SETTLEMENT-006**: Settlement details must show source items contributing to the total.
- **AC-SETTLEMENT-007**: Finalized settlement must become immutable unless privileged reopen/adjustment policy exists.

### Feature ID: FEA-SETTLEMENT-003 — Reopen or adjustment
**Status:** TODO

- **AC-SETTLEMENT-008**: Whether a finalized settlement can be reopened, reversed, or adjusted must remain configurable.
- **AC-SETTLEMENT-009**: If reopening is enabled, all changes must be fully auditable with reason and actor.

---

## 15. Reports

### Feature ID: FEA-REPORT-001 — Mission reports
**Status:** FINAL

- **AC-REPORT-001**: Authorized users can view mission reports filtered by date range, status, requester, driver, vehicle, and branch where applicable.
- **AC-REPORT-002**: Mission report must include mission number, requester, route, dates, status, and key operational details.

### Feature ID: FEA-REPORT-002 — Driver reports
**Status:** FINAL

- **AC-REPORT-003**: Authorized users can view driver performance/utilization reports.
- **AC-REPORT-004**: Driver report must support filtering by driver, branch, date range, and operational status.

### Feature ID: FEA-REPORT-003 — Vehicle reports
**Status:** FINAL

- **AC-REPORT-005**: Authorized users can view vehicle usage reports.
- **AC-REPORT-006**: Vehicle report must support filtering by vehicle, branch, date range, and insurance status where relevant.

### Feature ID: FEA-REPORT-004 — Finance reports
**Status:** FINAL

- **AC-REPORT-007**: Authorized finance users can view mission cost reports and payroll reports.
- **AC-REPORT-008**: Financial reports must match stored settlement and cost records exactly for finalized periods.

### Feature ID: FEA-REPORT-005 — Export
**Status:** TODO

- **AC-REPORT-009**: Export formats and fields remain configurable until reporting/export requirements are fully finalized.
- **AC-REPORT-010**: If export is enabled, access must respect report role permissions.

---

## 16. Integration and organizational workflow placeholders

### Feature ID: FEA-INTEGRATION-001 — Chargoon / organizational chart integration
**Status:** TODO

- **AC-INTEGRATION-001**: System must be able to support organization-chart-based approval routing when integration details are finalized.
- **AC-INTEGRATION-002**: Integration failure behavior must be explicitly defined before production rollout.
- **AC-INTEGRATION-003**: Until finalized, integration points should be implemented behind abstraction interfaces.

---

## 17. UX and frontend behavior

### Feature ID: FEA-UX-001 — Form behavior
**Status:** FINAL

- **AC-UX-001**: Required fields must be visibly marked on forms.
- **AC-UX-002**: Disabled actions must show clear reason where practical.
- **AC-UX-003**: Selection controls for city, driver, vehicle, and contracts must reflect current active/eligible data.

### Feature ID: FEA-UX-002 — Lists and tables
**Status:** FINAL

- **AC-UX-004**: Lists must support pagination or equivalent scalable loading behavior for operational datasets.
- **AC-UX-005**: Tables must support sorting and filtering for key operational fields.
- **AC-UX-006**: Empty states and loading states must be handled explicitly.

---

## 18. Open items intentionally left for later completion

These items should remain visible to Codex and the implementation team as unresolved placeholders rather than hidden assumptions:

- Exact approval hierarchy derived from organizational chart / Chargoon.
- Exact enum set for mission types, travel types, and some statuses if organization changes terminology.
- Whether some insurance checks are blocking or warning-only.
- Whether settlement reopening is allowed.
- Exact export requirements and file formats.
- Whether one mission can ever require multiple drivers or multiple vehicles in future scope.
- Whether some fields are mandatory for all organizations or only specific branches.

---

## 19. Minimum Definition of Done per feature

For any feature to be considered done, the generated implementation should satisfy all applicable items below:

- Backend validation implemented.
- Authorization enforced.
- Audit logging applied.
- API contract aligned.
- Frontend validation mirrored where relevant.
- Happy path and rejection path handled.
- Acceptance criteria test cases can be derived without guessing.

