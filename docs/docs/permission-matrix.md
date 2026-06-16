# Permission Matrix — Transport & Mission Management System

## 1. Purpose

This document defines the **default Role-Based Access Control (RBAC) matrix** for the Transport & Mission Management System.
It is intended for:

- Codex and implementation agents
- Backend authorization design
- Frontend page/menu visibility
- API authorization policies
- QA and UAT validation

This matrix is the **default V1 authorization baseline** and is designed to be **changeable/configurable** in future phases.
If business decisions change later, the implementation should prefer **policy-based authorization** over hard-coded role checks.

---

## 2. Design Principles

1. **Least Privilege**: each role should only access what it needs.
2. **Separation of Duties**: approval, dispatch, execution, and finance actions should remain separated unless explicitly allowed.
3. **Admin Override**: Admin has broad operational access by default, unless a future policy explicitly restricts some actions.
4. **Configurable Access**: role-feature mappings may change later without redesigning the core system.
5. **Scope Awareness**: some permissions apply only to “own”, “branch”, or “assigned” data.

---

## 3. Roles

| Role | Description |
|---|---|
| `Admin` | System administrator with cross-module access and supervisory privileges. |
| `Employee` | Mission requester / ordinary staff user. |
| `Manager` | Approver in the mission approval workflow. |
| `Dispatcher` | Transport operator responsible for driver/vehicle allocation and execution follow-up. |
| `Driver` | Driver who performs assigned missions and records execution-related data allowed by the system. |
| `Finance` | Financial officer responsible for cost calculation, payroll, and settlements. |
| `ITOperator` | Technical operator responsible for base/master data setup and maintenance. |

---

## 4. Permission Value Semantics

| Value | Meaning |
|---|---|
| `Yes` | Allowed by default. |
| `No` | Not allowed by default. |
| `Conditional` | Allowed only under defined business conditions. |
| `Own` | Allowed only for records created by or assigned to the current user. |
| `Branch` | Allowed only within the current user’s branch. |
| `Assigned` | Allowed only for assigned missions / execution items. |
| `Configurable` | Access is intentionally left flexible and should be finalized later based on organization policy. |

---

## 5. Authorization Model Guidance for Codex

Codex should implement authorization with:

- **Role-based policies** at API/controller level
- **Scope-based validation** inside application services
- **Optional database-backed permission overrides** for future changeability

Recommended authorization layers:

1. **Endpoint Policy Check**
2. **Resource Scope Check** (Own / Branch / Assigned)
3. **Business State Check** (e.g., only approved mission can be dispatched)

---

## 6. Default Permission Matrix (V1)

> Notes:
> - This is the **default** matrix.
> - Items marked `Conditional`, `Own`, `Branch`, or `Configurable` must be enforced by service-level validation.
> - If a future RFB update changes permissions, update this file and corresponding authorization policies.

| Feature / Action | Admin | Employee | Manager | Dispatcher | Driver | Finance | ITOperator | Scope / Condition Notes |
|---|---|---:|---:|---:|---:|---:|---:|---|
| Login | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Active user account required |
| Refresh Token | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Authenticated user only |
| View Own Profile | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Own |
| Update Own Profile (basic fields) | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Own; restricted fields only |
| View User List | Yes | No | No | No | No | No | Yes | Sensitive administrative data |
| Create User | Yes | No | No | No | No | No | Yes | Default admin/IT responsibility |
| Update User | Yes | No | No | No | No | No | Yes | User lifecycle management |
| Deactivate User | Yes | No | No | No | No | No | Yes | Soft disable preferred |
| Assign Roles | Yes | No | No | No | No | No | No | High-risk admin-only action |
| View Audit Logs | Yes | No | No | No | No | Conditional | Yes | Finance may see finance-related logs only if required later |
| View System Configuration | Yes | No | No | No | No | No | Yes | Technical access |
| Update System Configuration | Yes | No | No | No | No | No | Yes | Technical access |
| View Branches | Yes | Conditional | Conditional | Conditional | No | Conditional | Yes | May be broadened later |
| Create Branch | Yes | No | No | No | No | No | Yes | Base/master data |
| Update Branch | Yes | No | No | No | No | No | Yes | Base/master data |
| View Organization Units | Yes | Conditional | Conditional | Conditional | No | Conditional | Yes | Read-only visibility may expand later |
| Create Organization Unit | Yes | No | No | No | No | No | Yes | Base/master data |
| Update Organization Unit | Yes | No | No | No | No | No | Yes | Base/master data |
| View Provinces | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Needed by many forms |
| Create Province | Yes | No | No | No | No | No | Yes | Base/master data |
| Update Province | Yes | No | No | No | No | No | Yes | Base/master data |
| View Cities | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Needed by many forms |
| Create City | Yes | No | No | No | No | No | Yes | Base/master data |
| Update City | Yes | No | No | No | No | No | Yes | Base/master data |
| View Drivers | Yes | No | No | Yes | Own | Conditional | Yes | Driver may only view own profile; Finance may view for payroll context |
| Create Driver | Yes | No | No | Yes | No | No | Yes | Dispatcher or IT based on operating model |
| Update Driver | Yes | No | No | Yes | Conditional | No | Yes | Driver may update own limited profile fields only if enabled later |
| Deactivate Driver | Yes | No | No | Yes | No | No | Yes | Configurable; operational impact |
| View Driver Insurance Status | Yes | No | No | Yes | Own | Conditional | Yes | Finance optional for control reporting |
| View Driver Availability | Yes | No | No | Yes | Own | No | Yes | Availability data for dispatch |
| View Vehicles | Yes | No | No | Yes | Conditional | Conditional | Yes | Driver may view assigned vehicle only |
| Create Vehicle | Yes | No | No | Yes | No | No | Yes | Dispatcher or IT |
| Update Vehicle | Yes | No | No | Yes | No | No | Yes | Dispatcher or IT |
| Deactivate Vehicle | Yes | No | No | Yes | No | No | Yes | Configurable |
| View Vehicle Insurance Status | Yes | No | No | Yes | Conditional | Conditional | Yes | Driver may see assigned vehicle only |
| View Vehicle Availability | Yes | No | No | Yes | No | No | Yes | Dispatch operation |
| View Contracts | Yes | No | No | Yes | No | Yes | Conditional | Dispatcher + Finance need active contract visibility |
| Create Contract | Yes | No | No | No | No | Yes | Conditional | Finance owner by default |
| Update Contract | Yes | No | No | No | No | Yes | No | Finance owner by default |
| Deactivate/Expire Contract | Yes | No | No | No | No | Yes | No | Financial control |
| View Contract Rates | Yes | No | No | Conditional | No | Yes | No | Dispatcher may need read-only visibility during assignment |
| Create Mission Request | Yes | Yes | No | No | No | No | No | Employee creates mission |
| Edit Mission Draft | Yes | Own | No | No | No | No | No | Only own draft/pending-before-lock if allowed |
| Submit Mission Request | Yes | Own | No | No | No | No | No | Own mission only |
| Cancel Own Mission Request | Yes | Own | No | No | No | No | No | Before approval / according to state rules |
| View Own Missions | Yes | Own | Conditional | Conditional | Assigned | Conditional | No | Role-scoped visibility |
| View All Missions | Yes | No | Conditional | Yes | No | Conditional | No | Manager may view approval-relevant missions only |
| Search Missions | Yes | Own | Branch | Yes | Assigned | Conditional | No | Scope-aware search |
| Approve Mission | Yes | No | Yes | No | No | No | No | Only users in approval chain |
| Reject Mission | Yes | No | Yes | No | No | No | No | Only users in approval chain |
| View Approval Queue | Yes | No | Yes | No | No | No | No | Approval inbox |
| View Approval History | Yes | Own | Branch | Yes | Assigned | Conditional | No | Scope-aware |
| Assign Driver to Mission | Yes | No | No | Yes | No | No | No | Mission must be approved |
| Assign Vehicle to Mission | Yes | No | No | Yes | No | No | No | Mission must be approved |
| Reassign Driver/Vehicle | Yes | No | No | Yes | No | No | No | Subject to mission state |
| Remove Assignment | Yes | No | No | Yes | No | No | No | Before execution or by policy |
| View Dispatch Pool | Yes | No | No | Yes | No | No | No | Available drivers/vehicles |
| View Assigned Missions | Yes | No | Branch | Yes | Assigned | Conditional | No | Finance optional later |
| Record Driver Attendance Entry | Yes | No | No | Yes | Conditional | No | No | Driver self-entry may be enabled later |
| Record Driver Attendance Exit | Yes | No | No | Yes | Conditional | No | No | Driver self-exit may be enabled later |
| Edit Attendance Record | Yes | No | No | Yes | No | No | No | Strictly controlled |
| Delete Attendance Record | Yes | No | No | Conditional | No | No | No | Prefer soft-delete or reversal workflow |
| Start Mission Execution | Yes | No | No | Yes | Conditional | No | No | Driver may confirm start if mobile/self-service exists later |
| Record Mission Departure Time | Yes | No | No | Yes | Conditional | No | No | Driver self-record may be enabled later |
| Record Mission Return Time | Yes | No | No | Yes | Conditional | No | No | Driver self-record may be enabled later |
| Record Mission Start KM | Yes | No | No | Yes | Conditional | No | No | Driver self-record may be enabled later |
| Record Mission End KM | Yes | No | No | Yes | Conditional | No | No | Driver self-record may be enabled later |
| Record Stop Cost | Yes | No | No | Yes | No | Yes | No | Operational entry + financial review possible |
| Record Penalty | Yes | No | No | Conditional | No | Yes | No | Policy-sensitive |
| Record Extra Payment | Yes | No | No | Conditional | No | Yes | No | Policy-sensitive |
| Complete Mission Execution | Yes | No | No | Yes | Conditional | No | No | Service/state validation required |
| View Mission Execution Details | Yes | Own | Branch | Yes | Assigned | Yes | No | Scope-based |
| Reopen Mission Execution | Conditional | No | No | Conditional | No | Conditional | No | High-risk; should be tightly controlled and audited |
| Calculate Mission Cost | Yes | No | No | No | No | Yes | No | Finance-owned process |
| Recalculate Mission Cost | Conditional | No | No | No | No | Yes | No | Only before settlement, or with reversal workflow |
| View Mission Cost Breakdown | Yes | No | No | Conditional | No | Yes | No | Dispatcher may need read-only visibility if policy allows |
| Generate Monthly Settlement | Yes | No | No | No | No | Yes | No | Finance-owned process |
| View Settlement List | Yes | No | No | No | No | Yes | No | Finance domain |
| View Own Settlement | Yes | No | No | No | Conditional | No | No | Driver self-service configurable |
| Approve/Finalize Settlement | Yes | No | No | No | No | Yes | No | Optional approval chain if introduced later |
| Export Payroll Report | Yes | No | No | No | No | Yes | No | Sensitive financial data |
| Mission Reports | Yes | No | Branch | Yes | No | Conditional | No | Scope-based reporting |
| Driver Performance Report | Yes | No | Branch | Yes | Own | Conditional | No | Driver may view own KPI if enabled |
| Vehicle Usage Report | Yes | No | Branch | Yes | No | Conditional | No | Scope-based reporting |
| Cost Analysis Report | Yes | No | No | No | No | Yes | No | Finance-only by default |
| Monthly Payroll Report | Yes | No | No | No | No | Yes | No | Finance-only by default |
| Export Operational Reports | Yes | No | Conditional | Yes | No | Conditional | No | Configurable |
| Access Chargoon Integration Settings | Yes | No | No | No | No | No | Yes | Placeholder until integration clarified |
| Trigger Chargoon Sync | Yes | No | No | No | No | No | Yes | Integration admin action |

---

## 7. Scope Rules

### 7.1 Own Scope
A permission marked `Own` means the user can only access records:

- created by themselves, or
- explicitly belonging to their user identity.

Examples:

- Employee can edit only own mission drafts.
- Driver can view only own profile / assigned missions if self-service is enabled.

### 7.2 Branch Scope
A permission marked `Branch` means the user can only access records within the branch assigned to their account.

Examples:

- Manager may search branch missions.
- Manager may view driver performance within branch.

### 7.3 Assigned Scope
A permission marked `Assigned` means the user can only access records assigned to them.

Examples:

- Driver can view assigned missions.
- Driver may record execution data only for assigned missions.

### 7.4 Conditional Scope
A permission marked `Conditional` must be finalized by business policy and enforced by service logic.

Examples:

- Whether driver self-service is enabled
- Whether Finance can view operational mission details
- Whether Dispatcher can view contract rates

---

## 8. Recommended Authorization Policies for Codex

Recommended policy naming pattern:

- `Policies.Users.ViewAll`
- `Policies.Users.Manage`
- `Policies.MasterData.ManageLocations`
- `Policies.Drivers.Manage`
- `Policies.Vehicles.Manage`
- `Policies.Contracts.Manage`
- `Policies.Missions.Create`
- `Policies.Missions.EditOwnDraft`
- `Policies.Missions.Approve`
- `Policies.Dispatch.Assign`
- `Policies.Execution.Record`
- `Policies.Finance.Calculate`
- `Policies.Finance.Settlement`
- `Policies.Reports.Finance`
- `Policies.Audit.View`

Where needed, policies must be combined with resource checks such as:

- `CanAccessOwnMission(userId, mission)`
- `CanAccessBranchMission(branchId, mission)`
- `CanAccessAssignedMission(userId, missionAssignment)`

---

## 9. Changeability / Future-Proofing Requirements

The authorization system must be implemented so that future changes do **not** require rewriting all services.

### 9.1 Mandatory Future-Proofing Decisions

1. Role checks should be encapsulated in policies, not scattered in business code.
2. Scope checks should be centralized in application/domain services.
3. Sensitive actions should be audit logged.
4. Optional future support for database-driven permission overrides should be considered.
5. Menu visibility in frontend must derive from permissions, not only hardcoded role names.

### 9.2 Candidate Future Enhancements

- Branch-specific permission overrides
- Temporary delegated approval
- Fine-grained feature flags
- Driver self-service mobile permissions
- Settlement approval chain
- Read-only finance dashboards for management

---

## 10. High-Risk Actions Requiring Extra Controls

The following actions should require additional safeguards:

| Action | Recommended Control |
|---|---|
| Assign Roles | Admin only + audit log |
| Reopen Mission Execution | Multi-step confirmation + audit log |
| Recalculate Cost | Allowed only before settlement or through reversal workflow |
| Finalize Settlement | Finance only + audit log |
| Delete Attendance Record | Prefer reversal or soft delete + audit log |
| Update Contract Rates | Finance only + version history |
| Trigger Chargoon Sync | IT only + audit log |

---

## 11. Open Questions / TODO from RFB

These items remain intentionally flexible because RFB is incomplete or ambiguous in some areas:

1. Whether Drivers will use a self-service panel or only Dispatcher enters execution data.
2. Whether Finance can view full mission operational details or only cost outputs.
3. Whether Managers can see only approval-related missions or all branch missions.
4. Whether ITOperator can manage contracts as a backup role.
5. Whether settlements need a separate approval chain after generation.
6. Whether branch-level admin roles will exist in future.
7. Whether penalty and extra-payment registration belongs to Dispatcher, Finance, or both.

These must be finalized later and then reflected in:

- API authorization attributes
- frontend menu visibility
- business rule validation
- audit logging rules

---

## 12. Implementation Notes for Codex

Codex should implement:

1. **Role constants / enums** for all roles.
2. **Authorization policy registration** in the backend.
3. **Scope-aware access validators** in application services.
4. **Frontend permission guards** based on policies, not raw role strings only.
5. **Audit logging** for all high-risk actions.
6. A permission structure that allows future conversion to DB-backed RBAC if needed.

---

## 13. Suggested Permission Seed Keys

Suggested permission keys if the system later moves to DB-backed RBAC:

- `users.view`
- `users.create`
- `users.update`
- `users.roles.assign`
- `branches.manage`
- `orgunits.manage`
- `locations.manage`
- `drivers.view`
- `drivers.manage`
- `vehicles.view`
- `vehicles.manage`
- `contracts.view`
- `contracts.manage`
- `missions.create`
- `missions.edit.own`
- `missions.view.own`
- `missions.view.branch`
- `missions.approve`
- `dispatch.assign`
- `attendance.record`
- `execution.record`
- `finance.calculate`
- `finance.settlement.generate`
- `finance.payroll.view`
- `reports.operations.view`
- `reports.finance.view`
- `audit.view`
- `integration.chargoon.manage`

---

## 14. Version

- Document: `permission-matrix.md`
- Version: `v1-default`
- Status: `Draft for Codex Implementation`
- Changeability: `High` (expected to evolve with RFB clarification)
