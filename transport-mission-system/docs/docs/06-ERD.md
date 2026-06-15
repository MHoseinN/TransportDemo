# ERD — Transport & Mission Management System

## Purpose
This document provides an implementation-oriented ERD summary for Codex, complementing the detailed `database-schema.md` and `schema.sql`.

## 1. Main Entity Groups
- Identity & Organization
- Master Data / Geography
- Fleet
- Contracts & Policies
- Missions & Approvals
- Dispatch & Execution
- Finance & Settlement
- Audit & Integration

## 2. Mermaid ERD
```mermaid
erDiagram

    PROVINCE {
        uniqueidentifier Id PK
        nvarchar Name
        nvarchar Code
        bit IsActive
    }

    CITY {
        uniqueidentifier Id PK
        uniqueidentifier ProvinceId FK
        nvarchar Name
        nvarchar Code
        bit IsActive
    }

    BRANCH {
        uniqueidentifier Id PK
        nvarchar Name
        nvarchar Code
        nvarchar Status
        bit IsActive
    }

    ORGANIZATION_UNIT {
        uniqueidentifier Id PK
        uniqueidentifier ParentId FK
        nvarchar Name
        nvarchar Code
        bit IsActive
    }

    USER {
        uniqueidentifier Id PK
        uniqueidentifier BranchId FK
        uniqueidentifier OrganizationUnitId FK
        nvarchar FirstName
        nvarchar LastName
        nvarchar NationalCode
        nvarchar Mobile
        nvarchar Username
        nvarchar Status
        bit IsActive
    }

    ROLE {
        uniqueidentifier Id PK
        nvarchar Name
    }

    USER_ROLE {
        uniqueidentifier Id PK
        uniqueidentifier UserId FK
        uniqueidentifier RoleId FK
    }

    DRIVER {
        uniqueidentifier Id PK
        uniqueidentifier BranchId FK
        nvarchar FirstName
        nvarchar LastName
        nvarchar NationalCode
        nvarchar LicenseNo
        date InsuranceExpireDate
        bit IsActive
        nvarchar Status
    }

    VEHICLE {
        uniqueidentifier Id PK
        nvarchar VehicleType
        nvarchar Model
        nvarchar PlateNo
        nvarchar ChassisNo
        nvarchar OwnershipType
        date ThirdPartyInsuranceExpireDate
        date BodyInsuranceExpireDate
        nvarchar Status
        bit IsActive
    }

    CONTRACT {
        uniqueidentifier Id PK
        uniqueidentifier DriverId FK
        uniqueidentifier VehicleId FK
        date StartDate
        date EndDate
        decimal HourlyRate
        decimal KmRate
        decimal SleepRate
        nvarchar Status
    }

    CALCULATION_POLICY {
        uniqueidentifier Id PK
        nvarchar Code
        nvarchar PolicyType
        int VersionNo
        bit IsActive
    }

    MISSION {
        uniqueidentifier Id PK
        uniqueidentifier RequesterUserId FK
        uniqueidentifier OriginProvinceId FK
        uniqueidentifier OriginCityId FK
        uniqueidentifier DestinationProvinceId FK
        uniqueidentifier DestinationCityId FK
        nvarchar MissionNo
        nvarchar TravelType
        nvarchar DurationType
        datetime StartDateTime
        datetime EndDateTime
        nvarchar Status
    }

    MISSION_PASSENGER {
        uniqueidentifier Id PK
        uniqueidentifier MissionId FK
        uniqueidentifier UserId FK
    }

    MISSION_APPROVAL {
        uniqueidentifier Id PK
        uniqueidentifier MissionId FK
        uniqueidentifier ApproverUserId FK
        int ApprovalOrder
        nvarchar Decision
    }

    MISSION_STATUS_HISTORY {
        uniqueidentifier Id PK
        uniqueidentifier MissionId FK
        nvarchar FromStatus
        nvarchar ToStatus
        uniqueidentifier ChangedByUserId FK
    }

    MISSION_ASSIGNMENT {
        uniqueidentifier Id PK
        uniqueidentifier MissionId FK
        uniqueidentifier DriverId FK
        uniqueidentifier VehicleId FK
        uniqueidentifier ContractId FK
        nvarchar Status
    }

    DRIVER_ATTENDANCE {
        uniqueidentifier Id PK
        uniqueidentifier DriverId FK
        uniqueidentifier VehicleId FK
        date AttendanceDate
        time EntryTime
        time ExitTime
        decimal TotalHours
        nvarchar Status
    }

    MISSION_EXECUTION {
        uniqueidentifier Id PK
        uniqueidentifier MissionAssignmentId FK
        datetime DepartureDateTime
        datetime ReturnDateTime
        int StartKm
        int EndKm
        int TotalKm
        decimal TotalMissionHours
        decimal DrivingHours
        decimal SleepHours
        nvarchar Status
    }

    MISSION_EXECUTION_STOP {
        uniqueidentifier Id PK
        uniqueidentifier MissionExecutionId FK
        nvarchar StopType
        decimal Amount
    }

    MISSION_COST {
        uniqueidentifier Id PK
        uniqueidentifier MissionExecutionId FK
        decimal HourlyCost
        decimal KmCost
        decimal SleepCost
        decimal StopCost
        decimal PenaltyCost
        decimal ExtraPayment
        decimal TotalCost
    }

    MONTHLY_SETTLEMENT {
        uniqueidentifier Id PK
        uniqueidentifier DriverId FK
        int SettlementYear
        int SettlementMonth
        decimal TotalPayableAmount
        nvarchar Status
    }

    MONTHLY_SETTLEMENT_ITEM {
        uniqueidentifier Id PK
        uniqueidentifier SettlementId FK
        uniqueidentifier MissionExecutionId FK
        uniqueidentifier DriverAttendanceId FK
        nvarchar ItemType
        decimal Amount
    }

    AUDIT_LOG {
        uniqueidentifier Id PK
        uniqueidentifier UserId FK
        nvarchar EntityName
        nvarchar Action
        datetime OccurredAt
    }

    CHARGOON_WORKFLOW_MAPPING {
        uniqueidentifier Id PK
        uniqueidentifier MissionId FK
        nvarchar ExternalWorkflowCode
    }

    PROVINCE ||--o{ CITY : has
    BRANCH ||--o{ USER : contains
    ORGANIZATION_UNIT ||--o{ USER : includes
    ORGANIZATION_UNIT ||--o{ ORGANIZATION_UNIT : parent_of
    USER ||--o{ USER_ROLE : has
    ROLE ||--o{ USER_ROLE : assigned_to
    BRANCH ||--o{ DRIVER : contains
    DRIVER ||--o{ CONTRACT : signs
    VEHICLE ||--o{ CONTRACT : used_in
    CALCULATION_POLICY ||--o{ CONTRACT : priced_by
    USER ||--o{ MISSION : requests
    PROVINCE ||--o{ MISSION : origin_province
    CITY ||--o{ MISSION : origin_city
    PROVINCE ||--o{ MISSION : destination_province
    CITY ||--o{ MISSION : destination_city
    MISSION ||--o{ MISSION_PASSENGER : has
    USER ||--o{ MISSION_PASSENGER : accompanies
    MISSION ||--o{ MISSION_APPROVAL : has
    USER ||--o{ MISSION_APPROVAL : approves
    MISSION ||--o{ MISSION_STATUS_HISTORY : tracks
    MISSION ||--o| MISSION_ASSIGNMENT : assigned_as
    DRIVER ||--o{ MISSION_ASSIGNMENT : selected_for
    VEHICLE ||--o{ MISSION_ASSIGNMENT : assigned_to
    CONTRACT ||--o{ MISSION_ASSIGNMENT : governed_by
    DRIVER ||--o{ DRIVER_ATTENDANCE : records
    VEHICLE ||--o{ DRIVER_ATTENDANCE : used_in
    MISSION_ASSIGNMENT ||--o| MISSION_EXECUTION : executed_as
    MISSION_EXECUTION ||--o{ MISSION_EXECUTION_STOP : has
    MISSION_EXECUTION ||--o| MISSION_COST : calculated_as
    DRIVER ||--o{ MONTHLY_SETTLEMENT : has
    MONTHLY_SETTLEMENT ||--o{ MONTHLY_SETTLEMENT_ITEM : includes
    MISSION_EXECUTION ||--o{ MONTHLY_SETTLEMENT_ITEM : mission_source
    DRIVER_ATTENDANCE ||--o{ MONTHLY_SETTLEMENT_ITEM : attendance_source
    USER ||--o{ AUDIT_LOG : acts_in
    MISSION ||--o{ CHARGOON_WORKFLOW_MAPPING : mapped_to

```

## 3. Implementation Notes
- Detailed field definitions live in `docs/database-schema.md`
- Actual DDL lives in `database/schema.sql`
- Some relationship/cardinality assumptions remain configurable due to incomplete RFB areas

## 4. Open Questions / TODO
- Whether mission request and mission should be separated further
- Exact Chargoon workflow persistence requirements
- Whether representation must become its own entity
