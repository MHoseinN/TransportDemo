# Database Schema — Transport & Mission Management System

This document converts the current ERD and RFB into an implementation-ready **SQL Server database schema specification** for Codex / ASP.NET Core / EF Core.

> Important: Some requirements in the RFB are incomplete or ambiguous. Those areas are explicitly marked as **TODO / ASSUMED** so they can be completed later without breaking the schema design.

## 1. Conventions

- **Database engine:** SQL Server 2019+
- **Primary key type:** `uniqueidentifier` with `NEWSEQUENTIALID()`
- **String type:** `nvarchar`
- **Date/time type:** `date`, `time(0)`, `datetime2(3)`
- **Money type:** `decimal(18,2)`
- **Soft delete:** used on business/master tables unless explicitly stated otherwise
- **Audit columns:** used on all business tables; minimal audit also used on infrastructure tables
- **Enum storage strategy:** store enum values as `nvarchar(...)` and validate in application layer or with `CHECK` constraints
- **Multi-tenant scope:** not included at this stage; branch-based segregation is used

## 2. Standard Audit Columns

| Column Name | Data Type | Nullable | Default Value | Description |
|---|---|---|---|---|
| CreatedAt | `datetime2(3)` | NOT NULL | `SYSUTCDATETIME()` | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL | `` | Audit |
| UpdatedAt | `datetime2(3)` | NULL | `` | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL | `` | Audit |

## 3. Standard Soft Delete Columns

| Column Name | Data Type | Nullable | Default Value | Description |
|---|---|---|---|---|
| IsDeleted | `bit` | NOT NULL | `0` | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL | `` | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL | `` | Soft delete actor |

## 4. Enum Catalog

- **UserStatus** = `Active, Inactive, Locked`
- **BranchStatus** = `Active, Inactive`
- **VehicleOwnershipType** = `Personal, Organizational`
- **VehicleStatus** = `Active, Inactive, UnderMaintenance, InsuranceExpired, Retired`
- **ContractStatus** = `Draft, Active, Expired, Terminated, Suspended`
- **MissionTravelType** = `Ground, Air`
- **MissionDurationType** = `Hourly, Daily`
- **MissionStatus** = `Draft, PendingApproval, Approved, Rejected, Assigned, ReadyToStart, InProgress, Completed, CostCalculated, PendingSettlement, Settled, Cancelled`
- **ApprovalDecision** = `Pending, Approved, Rejected, Skipped, Cancelled`
- **AssignmentStatus** = `Pending, Assigned, Confirmed, Cancelled, Reassigned, Completed`
- **AttendanceStatus** = `Recorded, Approved, Corrected, Deleted`
- **ExecutionStatus** = `Draft, Recorded, Calculated, Approved, Closed`
- **StopType** = `Stop, Penalty, ExtraPayment, Other`
- **SettlementStatus** = `Draft, Calculated, Approved, Posted, Paid, Cancelled`
- **SettlementItemType** = `Attendance, Mission, Penalty, ExtraPayment, Adjustment`
- **AuditEntityAction** = `Create, Update, Delete, Restore, Approve, Reject, Assign, Calculate, Login, Logout`
- **CalculationPolicyType** = `UrbanHourly, UrbanByDistance, OutboundByDistanceAndSleep, Custom`

## 5. Recommended Global Index / Constraint Rules

- Add filtered unique indexes on soft-deleted tables where uniqueness should apply only to active rows.
- Add nonclustered indexes on all foreign keys.
- Add composite indexes on workflow-heavy tables such as `Missions(CurrentStatus, StartDateTime)`, `MissionApprovals(MissionId, IsCurrentStep)`, `DriverAttendance(DriverId, AttendanceDate)`, and `MonthlySettlements(DriverId, Year, Month)`.
- Add application and/or database rules to prevent overlapping active mission assignments for the same driver or vehicle.

## 6. Table Specifications

### Branches

**Purpose:** Organizational branches required before driver registration and mission requests.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly mentions branch registration as a prerequisite.
  - Unique code recommended.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| Name | `nvarchar(200)` | NOT NULL |  |  |  | `` |  | Branch name |
| Code | `nvarchar(50)` | NOT NULL |  |  | UQ_Branches_Code | `` |  | Business code |
| Address | `nvarchar(500)` | NULL |  |  |  | `` |  |  |
| PhoneNumber | `nvarchar(30)` | NULL |  |  |  | `` |  |  |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | BranchStatus |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### OrganizationUnits

**Purpose:** Hierarchical organizational units used for approval routing and reporting.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB references organizational chart (Chargoon) approval hierarchy.
  - Parent-child hierarchy supports manager chain.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| BranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  | NULL allowed because some units may be enterprise-level |
| ParentOrganizationUnitId | `uniqueidentifier` | NULL |  | FK -> OrganizationUnits.Id |  | `` |  | Self-reference |
| Name | `nvarchar(200)` | NOT NULL |  |  |  | `` |  |  |
| Code | `nvarchar(50)` | NULL |  |  | UQ_OrganizationUnits_Code | `` |  | Optional but recommended |
| ManagerUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Primary manager / approver |
| LevelNo | `int` | NULL |  |  |  | `` |  | Optional cached hierarchy depth |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | BranchStatus |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Users

**Purpose:** System users including employees, approvers, dispatchers, finance staff, and administrators.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - User identity/HR source is partly outside RFB; fields below are implementation-ready assumptions.
  - Can be synced later from HR/SSO.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| BranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  |  |
| OrganizationUnitId | `uniqueidentifier` | NULL |  | FK -> OrganizationUnits.Id |  | `` |  |  |
| PersonnelCode | `nvarchar(50)` | NULL |  |  | UQ_Users_PersonnelCode | `` |  | TODO if organization requires mandatory personnel code |
| FirstName | `nvarchar(100)` | NOT NULL |  |  |  | `` |  |  |
| LastName | `nvarchar(100)` | NOT NULL |  |  |  | `` |  |  |
| NationalCode | `nvarchar(10)` | NULL |  |  | UQ_Users_NationalCode | `` |  | Unique when provided |
| Mobile | `nvarchar(20)` | NULL |  |  |  | `` |  |  |
| Email | `nvarchar(256)` | NULL |  |  | UQ_Users_Email | `` |  | Unique when provided |
| Username | `nvarchar(100)` | NOT NULL |  |  | UQ_Users_Username | `` |  |  |
| PasswordHash | `nvarchar(512)` | NOT NULL |  |  |  | `` |  |  |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | UserStatus |  |
| LastLoginAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Roles

**Purpose:** Application roles for RBAC.

- **Soft Delete:** No
- **Audit Columns:** Yes
- **Notes:**
  - Seed with Admin, Employee, Manager, Dispatcher, Driver, Finance, ITOperator.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| Name | `nvarchar(100)` | NOT NULL |  |  | UQ_Roles_Name | `` |  |  |
| DisplayName | `nvarchar(150)` | NULL |  |  |  | `` |  |  |
| Description | `nvarchar(500)` | NULL |  |  |  | `` |  |  |
| IsSystemRole | `bit` | NOT NULL |  |  |  | `1` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |

### UserRoles

**Purpose:** Many-to-many mapping between users and roles.

- **Soft Delete:** No
- **Audit Columns:** Yes
- **Notes:**
  - Composite unique on UserId + RoleId.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| UserId | `uniqueidentifier` | NOT NULL |  | FK -> Users.Id |  | `` |  |  |
| RoleId | `uniqueidentifier` | NOT NULL |  | FK -> Roles.Id |  | `` |  |  |
| StartDate | `date` | NULL |  |  |  | `` |  | Optional effective date |
| EndDate | `date` | NULL |  |  |  | `` |  | Optional expiry date |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |

### RefreshTokens

**Purpose:** JWT refresh tokens for authentication.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - Infrastructure table; not from RFB, but required for secure API implementation.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| UserId | `uniqueidentifier` | NOT NULL |  | FK -> Users.Id |  | `` |  |  |
| Token | `nvarchar(512)` | NOT NULL |  |  | UQ_RefreshTokens_Token | `` |  |  |
| ExpiresAt | `datetime2(3)` | NOT NULL |  |  |  | `` |  |  |
| RevokedAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| ReasonRevoked | `nvarchar(250)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Provinces

**Purpose:** Master list of provinces used in missions.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB requires province and city lists before mission registration.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| Name | `nvarchar(150)` | NOT NULL |  |  | UQ_Provinces_Name | `` |  |  |
| Code | `nvarchar(20)` | NULL |  |  | UQ_Provinces_Code | `` |  | Optional national code |
| DisplayOrder | `int` | NOT NULL |  |  |  | `0` |  |  |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | BranchStatus |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Cities

**Purpose:** Master list of cities linked to provinces.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - City names are unique within a province, not globally.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| ProvinceId | `uniqueidentifier` | NOT NULL |  | FK -> Provinces.Id |  | `` |  |  |
| Name | `nvarchar(150)` | NOT NULL |  |  |  | `` |  |  |
| Code | `nvarchar(20)` | NULL |  |  |  | `` |  | Optional national code |
| DisplayOrder | `int` | NOT NULL |  |  |  | `0` |  |  |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | BranchStatus |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Drivers

**Purpose:** Registered drivers used for mission assignment and payroll calculation.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires branch/representation selection, identity fields, license number, and insurance date.
  - Representation details are ambiguous; a free-text field is provided as placeholder.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| BranchId | `uniqueidentifier` | NOT NULL |  | FK -> Branches.Id |  | `` |  |  |
| RepresentationName | `nvarchar(200)` | NULL |  |  |  | `` |  | TODO: replace with FK if representation becomes a master table |
| FirstName | `nvarchar(100)` | NOT NULL |  |  |  | `` |  |  |
| LastName | `nvarchar(100)` | NOT NULL |  |  |  | `` |  |  |
| FatherName | `nvarchar(100)` | NULL |  |  |  | `` |  | RFB requires this field |
| NationalCode | `nvarchar(10)` | NOT NULL |  |  | UQ_Drivers_NationalCode | `` |  |  |
| BirthCertificateNo | `nvarchar(20)` | NOT NULL |  |  |  | `` |  |  |
| BirthPlace | `nvarchar(100)` | NULL |  |  |  | `` |  |  |
| BirthDate | `date` | NULL |  |  |  | `` |  |  |
| Mobile | `nvarchar(20)` | NULL |  |  |  | `` |  |  |
| LicenseNo | `nvarchar(50)` | NOT NULL |  |  | UQ_Drivers_LicenseNo | `` |  |  |
| InsuranceExpireDate | `date` | NULL |  |  |  | `` |  | RFB mentions driver insurance; exact insurance type is TODO |
| InsuranceWarningEnabled | `bit` | NOT NULL |  |  |  | `0` |  |  |
| IsActive | `bit` | NOT NULL |  |  |  | `1` |  | Operational active flag |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | UserStatus |  |
| Notes | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Vehicles

**Purpose:** Registered personal or organizational vehicles used in assignments.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires vehicle type, model, color, chassis number, plate number, third-party/body insurance, and ownership type.
  - Owning branch is an implementation assumption and can be made mandatory later.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| OwningBranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  | ASSUMED |
| VehicleType | `nvarchar(100)` | NOT NULL |  |  |  | `` |  | Example: L90, Samand |
| Model | `nvarchar(100)` | NOT NULL |  |  |  | `` |  |  |
| ModelYear | `smallint` | NULL |  |  |  | `` |  | TODO: if needed |
| Color | `nvarchar(50)` | NOT NULL |  |  |  | `` |  |  |
| ChassisNo | `nvarchar(100)` | NOT NULL |  |  | UQ_Vehicles_ChassisNo | `` |  |  |
| PlateNo | `nvarchar(30)` | NOT NULL |  |  | UQ_Vehicles_PlateNo | `` |  |  |
| OwnershipType | `nvarchar(20)` | NOT NULL |  |  |  | `'Organizational'` | VehicleOwnershipType |  |
| ThirdPartyInsuranceExpireDate | `date` | NULL |  |  |  | `` |  |  |
| BodyInsuranceExpireDate | `date` | NULL |  |  |  | `` |  |  |
| Status | `nvarchar(30)` | NOT NULL |  |  |  | `'Active'` | VehicleStatus |  |
| IsActive | `bit` | NOT NULL |  |  |  | `1` |  |  |
| Notes | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Contracts

**Purpose:** Commercial/operational contracts binding a driver and optionally a vehicle with pricing rules.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires driver, vehicle, start/end dates, hourly amount, going amount, returning amount, sleep amount, and insurance status.
  - Kilometer amount is inferred from later mission calculation text and should be kept.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| DriverId | `uniqueidentifier` | NOT NULL |  | FK -> Drivers.Id |  | `` |  |  |
| VehicleId | `uniqueidentifier` | NOT NULL |  | FK -> Vehicles.Id |  | `` |  |  |
| ContractNo | `nvarchar(50)` | NULL |  |  | UQ_Contracts_ContractNo | `` |  | Recommended |
| StartDate | `date` | NOT NULL |  |  |  | `` |  |  |
| EndDate | `date` | NOT NULL |  |  |  | `` |  |  |
| HourlyAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | For urban hourly calculation |
| GoingAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | RFB explicit |
| ReturningAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | RFB explicit |
| SleepHourlyAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| KilometerAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Inferred from outbound formula |
| InsuranceStatus | `nvarchar(50)` | NULL |  |  |  | `` |  | RFB says status of contract insurance; business use is unclear |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Draft'` | ContractStatus |  |
| Notes | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### CalculationPolicies

**Purpose:** Configurable calculation policy per organization/branch to support future RFB variants for other organizations.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB states other organizations may calculate urban missions hourly, by distance, and potentially additional models, but details are incomplete.
  - Use this table to avoid code changes later.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| BranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  | NULL means global default |
| Name | `nvarchar(150)` | NOT NULL |  |  | UQ_CalculationPolicies_Name | `` |  |  |
| PolicyType | `nvarchar(50)` | NOT NULL |  |  |  | `'UrbanHourly'` | CalculationPolicyType |  |
| IsDefault | `bit` | NOT NULL |  |  |  | `0` |  |  |
| ConfigurationJson | `nvarchar(max)` | NULL |  |  |  | `` |  | TODO: store formula parameters when RFB is completed |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Active'` | BranchStatus |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### Missions

**Purpose:** Mission request header and lifecycle record.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires origin/destination province/city/address, travel type (ground/air), duration type (hourly/daily), start/end times, reason, description, requester, and status workflow.
  - Air mission financial/dispatch handling remains TODO.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionNo | `nvarchar(50)` | NOT NULL |  |  | UQ_Missions_MissionNo | `` |  | Unique business identifier |
| RequesterUserId | `uniqueidentifier` | NOT NULL |  | FK -> Users.Id |  | `` |  |  |
| BranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  | Can be derived from requester |
| OriginProvinceId | `uniqueidentifier` | NOT NULL |  | FK -> Provinces.Id |  | `` |  |  |
| OriginCityId | `uniqueidentifier` | NOT NULL |  | FK -> Cities.Id |  | `` |  |  |
| OriginAddress | `nvarchar(500)` | NOT NULL |  |  |  | `` |  |  |
| DestinationProvinceId | `uniqueidentifier` | NOT NULL |  | FK -> Provinces.Id |  | `` |  |  |
| DestinationCityId | `uniqueidentifier` | NOT NULL |  | FK -> Cities.Id |  | `` |  |  |
| DestinationAddress | `nvarchar(500)` | NOT NULL |  |  |  | `` |  |  |
| TravelType | `nvarchar(20)` | NOT NULL |  |  |  | `'Ground'` | MissionTravelType |  |
| DurationType | `nvarchar(20)` | NOT NULL |  |  |  | `'Daily'` | MissionDurationType |  |
| StartDateTime | `datetime2(3)` | NOT NULL |  |  |  | `` |  |  |
| EndDateTime | `datetime2(3)` | NOT NULL |  |  |  | `` |  |  |
| Reason | `nvarchar(1000)` | NOT NULL |  |  |  | `` |  |  |
| Description | `nvarchar(2000)` | NULL |  |  |  | `` |  |  |
| RequestedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  |  |
| CurrentStatus | `nvarchar(30)` | NOT NULL |  |  |  | `'Draft'` | MissionStatus |  |
| FinalApprovalAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| FinalApprovedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  |  |
| CalculationPolicyId | `uniqueidentifier` | NULL |  | FK -> CalculationPolicies.Id |  | `` |  | TODO: finalize when org-specific models are clarified |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionPassengers

**Purpose:** Additional employees accompanying the primary requester on a mission.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly mentions other employees can be selected and added to the mission.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NOT NULL |  | FK -> Missions.Id |  | `` |  |  |
| PassengerUserId | `uniqueidentifier` | NOT NULL |  | FK -> Users.Id |  | `` |  |  |
| IsPrimaryPassenger | `bit` | NOT NULL |  |  |  | `0` |  | Usually false; requester is primary outside this table |
| Notes | `nvarchar(500)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionApprovals

**Purpose:** Approval steps and decisions for each mission following the hierarchical organizational chart.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires hierarchical circulation from expert to managers through transport unit and mentions Chargoon workflow integration.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NOT NULL |  | FK -> Missions.Id |  | `` |  |  |
| ApprovalOrder | `int` | NOT NULL |  |  |  | `` |  | Sequence number |
| ApproverUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | NULL if step is resolved externally/integration |
| ApproverRoleName | `nvarchar(100)` | NULL |  |  |  | `` |  | Snapshot of approver role |
| Decision | `nvarchar(20)` | NOT NULL |  |  |  | `'Pending'` | ApprovalDecision |  |
| DecisionComment | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| DecidedAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| ExternalWorkflowItemId | `nvarchar(100)` | NULL |  |  |  | `` |  | TODO: Chargoon/task identifier if integrated |
| IsCurrentStep | `bit` | NOT NULL |  |  |  | `0` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionStatusHistory

**Purpose:** Status transition log for missions.

- **Soft Delete:** No
- **Audit Columns:** Yes
- **Notes:**
  - Required to make workflow auditable and state-machine-safe.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NOT NULL |  | FK -> Missions.Id |  | `` |  |  |
| FromStatus | `nvarchar(30)` | NULL |  |  |  | `` | MissionStatus |  |
| ToStatus | `nvarchar(30)` | NOT NULL |  |  |  | `` | MissionStatus |  |
| ChangedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  |  |
| ChangedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  |  |
| Reason | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |

### MissionAssignments

**Purpose:** Driver and vehicle assignment for an approved mission.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB says each mission can have only one driver and one vehicle.
  - Confirmation prompt in old system suggests explicit confirmation tracking.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NOT NULL |  | FK -> Missions.Id | UQ_MissionAssignments_MissionId | `` |  | One active assignment per mission |
| DriverId | `uniqueidentifier` | NOT NULL |  | FK -> Drivers.Id |  | `` |  |  |
| VehicleId | `uniqueidentifier` | NOT NULL |  | FK -> Vehicles.Id |  | `` |  |  |
| ContractId | `uniqueidentifier` | NOT NULL |  | FK -> Contracts.Id |  | `` |  |  |
| AssignedByUserId | `uniqueidentifier` | NOT NULL |  | FK -> Users.Id |  | `` |  |  |
| ConfirmedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | User who confirmed assignment |
| AssignedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  |  |
| ConfirmedAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Assigned'` | AssignmentStatus |  |
| Notes | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### DriverAttendance

**Purpose:** Driver entry/exit records used mainly for urban/hourly calculations.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly allows multiple attendance records per driver because of leave/split attendance.
  - Vehicle selection in old system is mentioned but kilometrage there is marked as not used.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| DriverId | `uniqueidentifier` | NOT NULL |  | FK -> Drivers.Id |  | `` |  |  |
| VehicleId | `uniqueidentifier` | NULL |  | FK -> Vehicles.Id |  | `` |  | RFB old system showed vehicle, but business use is unclear |
| AttendanceDate | `date` | NOT NULL |  |  |  | `` |  |  |
| EntryTime | `time(0)` | NOT NULL |  |  |  | `` |  |  |
| ExitTime | `time(0)` | NOT NULL |  |  |  | `` |  |  |
| TotalHours | `decimal(9,2)` | NULL |  |  |  | `` |  | Computed or persisted |
| Status | `nvarchar(20)` | NOT NULL |  |  |  | `'Recorded'` | AttendanceStatus |  |
| Source | `nvarchar(50)` | NOT NULL |  |  |  | `'Manual'` |  | Manual / Import / Device |
| Notes | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionExecutions

**Purpose:** Executed mission details after mission completion.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires departure/return date-time, start/end kilometer, total kilometer, cost-related inputs, without-pay option, and recalculation capability.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NOT NULL |  | FK -> Missions.Id | UQ_MissionExecutions_MissionId | `` |  | One execution record per mission |
| MissionAssignmentId | `uniqueidentifier` | NOT NULL |  | FK -> MissionAssignments.Id |  | `` |  |  |
| DepartureDateTime | `datetime2(3)` | NOT NULL |  |  |  | `` |  |  |
| ReturnDateTime | `datetime2(3)` | NOT NULL |  |  |  | `` |  |  |
| StartOdometerKm | `int` | NOT NULL |  |  |  | `` |  |  |
| EndOdometerKm | `int` | NOT NULL |  |  |  | `` |  |  |
| TotalDistanceKm | `int` | NULL |  |  |  | `` |  | Computed |
| TotalMissionHours | `decimal(9,2)` | NULL |  |  |  | `` |  | Computed |
| DrivingHours | `decimal(9,2)` | NULL |  |  |  | `` |  | Computed based on policy |
| SleepHours | `decimal(9,2)` | NULL |  |  |  | `` |  | Computed or adjusted |
| WithoutPayment | `bit` | NOT NULL |  |  |  | `0` |  | RFB explicit option |
| ExecutionStatus | `nvarchar(20)` | NOT NULL |  |  |  | `'Recorded'` | ExecutionStatus |  |
| Notes | `nvarchar(2000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionExecutionStops

**Purpose:** Optional stop/penalty/extra-payment detail lines for an execution.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB allows multiple stops and separate stop, penalty, and extra payment costs. This table normalizes those variable details.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionExecutionId | `uniqueidentifier` | NOT NULL |  | FK -> MissionExecutions.Id |  | `` |  |  |
| StopType | `nvarchar(30)` | NOT NULL |  |  |  | `'Stop'` | StopType |  |
| Description | `nvarchar(500)` | NULL |  |  |  | `` |  |  |
| Quantity | `decimal(9,2)` | NOT NULL |  |  |  | `1` |  | Hours or count |
| UnitAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| TotalAmount | `decimal(18,2)` | NULL |  |  |  | `` |  | Computed |
| OccurredAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MissionCosts

**Purpose:** Calculated financial result of a mission execution.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly mentions kilometer cost, sleep cost, stop cost, penalty cost, extra payment, and possibility of recalculation.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionExecutionId | `uniqueidentifier` | NOT NULL |  | FK -> MissionExecutions.Id | UQ_MissionCosts_MissionExecutionId | `` |  | One cost record per latest active calculation |
| ContractId | `uniqueidentifier` | NOT NULL |  | FK -> Contracts.Id |  | `` |  |  |
| CalculationPolicyId | `uniqueidentifier` | NULL |  | FK -> CalculationPolicies.Id |  | `` |  |  |
| HourlyAmountApplied | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Rate snapshot |
| KilometerAmountApplied | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Rate snapshot |
| SleepHourlyAmountApplied | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Rate snapshot |
| GoingAmountApplied | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Rate snapshot |
| ReturningAmountApplied | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Rate snapshot |
| AttendanceAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Urban hourly result |
| KilometerCost | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| SleepCost | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| StopCost | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| PenaltyCost | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| ExtraPaymentAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| TotalPayableAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Final result |
| CalculationVersion | `int` | NOT NULL |  |  |  | `1` |  | Increment on recalculation |
| IsFinal | `bit` | NOT NULL |  |  |  | `0` |  | Becomes true after settlement |
| CalculationNotes | `nvarchar(2000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MonthlySettlements

**Purpose:** Monthly payroll/settlement header per driver and accounting period.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly requires end-of-month calculation of driver payments.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| DriverId | `uniqueidentifier` | NOT NULL |  | FK -> Drivers.Id |  | `` |  |  |
| BranchId | `uniqueidentifier` | NULL |  | FK -> Branches.Id |  | `` |  |  |
| Year | `smallint` | NOT NULL |  |  |  | `` |  |  |
| Month | `tinyint` | NOT NULL |  |  |  | `` |  | 1-12 |
| SettlementStatus | `nvarchar(20)` | NOT NULL |  |  |  | `'Draft'` | SettlementStatus |  |
| AttendanceAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| MissionAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| PenaltyAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| ExtraPaymentAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| AdjustmentAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  | Manual adjustment |
| TotalPayableAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| GeneratedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  |  |
| ApprovedAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| ApprovedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  |  |
| PaidAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| PaymentReferenceNo | `nvarchar(100)` | NULL |  |  |  | `` |  |  |
| Notes | `nvarchar(2000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### MonthlySettlementItems

**Purpose:** Settlement detail lines from attendance, mission, penalties, and adjustments.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - Allows transparent payroll breakdown and reporting.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MonthlySettlementId | `uniqueidentifier` | NOT NULL |  | FK -> MonthlySettlements.Id |  | `` |  |  |
| ItemType | `nvarchar(30)` | NOT NULL |  |  |  | `'Mission'` | SettlementItemType |  |
| ReferenceAttendanceId | `uniqueidentifier` | NULL |  | FK -> DriverAttendance.Id |  | `` |  |  |
| ReferenceMissionCostId | `uniqueidentifier` | NULL |  | FK -> MissionCosts.Id |  | `` |  |  |
| Description | `nvarchar(500)` | NULL |  |  |  | `` |  |  |
| Quantity | `decimal(9,2)` | NOT NULL |  |  |  | `1` |  |  |
| UnitAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| TotalAmount | `decimal(18,2)` | NOT NULL |  |  |  | `0` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

### AuditLogs

**Purpose:** Central audit trail for business-sensitive operations.

- **Soft Delete:** No
- **Audit Columns:** Yes
- **Notes:**
  - Non-functional requirement: audit all important actions.
  - Can store before/after JSON snapshots.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| EntityName | `nvarchar(150)` | NOT NULL |  |  |  | `` |  |  |
| EntityId | `uniqueidentifier` | NULL |  |  |  | `` |  | Nullable for auth/system events |
| Action | `nvarchar(30)` | NOT NULL |  |  |  | `` | AuditEntityAction |  |
| PerformedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  |  |
| PerformedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  |  |
| ClientIp | `nvarchar(64)` | NULL |  |  |  | `` |  |  |
| CorrelationId | `nvarchar(100)` | NULL |  |  |  | `` |  |  |
| OldValuesJson | `nvarchar(max)` | NULL |  |  |  | `` |  |  |
| NewValuesJson | `nvarchar(max)` | NULL |  |  |  | `` |  |  |
| Remarks | `nvarchar(1000)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |

### ChargoonWorkflowMappings

**Purpose:** Placeholder integration table for Chargoon organizational workflow / task mapping.

- **Soft Delete:** Yes
- **Audit Columns:** Yes
- **Notes:**
  - RFB explicitly names Chargoon/organizational chart as a prerequisite for approval routing, but interface details are missing.
  - Keep as placeholder until integration is defined.

| Column Name | Data Type | Nullable | Primary Key | Foreign Key | Unique Index | Default Value | Enum Values | Description |
|---|---|---|---|---|---|---|---|---|
| Id | `uniqueidentifier` | NOT NULL | PK |  |  | `NEWSEQUENTIALID()` |  |  |
| MissionId | `uniqueidentifier` | NULL |  | FK -> Missions.Id |  | `` |  |  |
| MissionApprovalId | `uniqueidentifier` | NULL |  | FK -> MissionApprovals.Id |  | `` |  |  |
| ExternalSystemName | `nvarchar(100)` | NOT NULL |  |  |  | `'Chargoon'` |  |  |
| ExternalWorkflowId | `nvarchar(100)` | NULL |  |  |  | `` |  |  |
| ExternalTaskId | `nvarchar(100)` | NULL |  |  |  | `` |  |  |
| SyncStatus | `nvarchar(50)` | NOT NULL |  |  |  | `'Pending'` |  | TODO enum |
| LastSyncedAt | `datetime2(3)` | NULL |  |  |  | `` |  |  |
| PayloadJson | `nvarchar(max)` | NULL |  |  |  | `` |  |  |
| CreatedAt | `datetime2(3)` | NOT NULL |  |  |  | `SYSUTCDATETIME()` |  | Audit |
| CreatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| UpdatedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Audit |
| UpdatedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Audit |
| IsDeleted | `bit` | NOT NULL |  |  |  | `0` |  | Soft delete flag |
| DeletedAt | `datetime2(3)` | NULL |  |  |  | `` |  | Soft delete timestamp |
| DeletedByUserId | `uniqueidentifier` | NULL |  | FK -> Users.Id |  | `` |  | Soft delete actor |

## 7. Relationship Summary

- Branches 1 --- * Users
- Branches 1 --- * Drivers
- Branches 1 --- * OrganizationUnits
- Provinces 1 --- * Cities
- Drivers 1 --- * Contracts
- Vehicles 1 --- * Contracts
- Users 1 --- * Missions (RequesterUserId)
- Missions 1 --- * MissionPassengers
- Missions 1 --- * MissionApprovals
- Missions 1 --- 1 MissionAssignments (active/current design)
- Missions 1 --- 1 MissionExecutions (active/current design)
- MissionExecutions 1 --- * MissionExecutionStops
- MissionExecutions 1 --- 1 MissionCosts
- Drivers 1 --- * DriverAttendance
- Drivers 1 --- * MonthlySettlements
- MonthlySettlements 1 --- * MonthlySettlementItems

## 8. Open Questions / TODO from RFB

- Clarify whether **Representation / Agency** should be a separate master table or remain a free-text field under driver registration.
- Clarify the exact meaning of **driver insurance** in the driver form (type, issuer, mandatory/optional).
- Clarify whether **vehicles are branch-scoped** or globally shared.
- Clarify whether **air missions** use driver/vehicle assignment or bypass transport allocation.
- Clarify the full set of **calculation models for other organizations** beyond the partial RFB text.
- Clarify whether **contract insurance status** is a meaningful business field or can be removed.
- Clarify whether a mission may ever need **multiple assignments** over time (reassignment history) while still keeping one active assignment.
- Clarify whether **attachments/documents** (insurance file, contract file, mission docs) are required.
- Clarify whether approval routing stays internal or must be synchronized with **Chargoon** in phase 1.

## 9. Implementation Notes for Codex

- Generate EF Core entities and configurations from this schema, not from the raw RFB text.
- Implement enums in the domain layer and map them to `nvarchar` columns with validation.
- Add concurrency handling to workflow tables, preferably with `rowversion` where needed.
- Use separate migration files for master data, workflow tables, finance tables, and integration placeholders.
- Add seed data for Roles, default Branch status values, and optionally base calculation policies.