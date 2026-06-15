-- Transportation and Mission Management System - Phase 0.5 aligned SQL Server schema baseline.
-- This file mirrors the current Domain entities and EF Core Fluent API mappings.

CREATE TABLE Provinces (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Code NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT UX_Provinces_Code UNIQUE (Code)
);

CREATE TABLE Cities (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    ProvinceId UNIQUEIDENTIFIER NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Code NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Cities_Provinces FOREIGN KEY (ProvinceId) REFERENCES Provinces(Id),
    CONSTRAINT UX_Cities_Province_Code UNIQUE (ProvinceId, Code)
);

CREATE TABLE Branches (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    ParentId UNIQUEIDENTIFIER NULL,
    CityId UNIQUEIDENTIFIER NULL,
    Code NVARCHAR(50) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Branches_Parent FOREIGN KEY (ParentId) REFERENCES Branches(Id),
    CONSTRAINT FK_Branches_Cities FOREIGN KEY (CityId) REFERENCES Cities(Id),
    CONSTRAINT UX_Branches_Code UNIQUE (Code)
);

CREATE TABLE Vehicles (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    BranchId UNIQUEIDENTIFIER NOT NULL,
    PlateNumber NVARCHAR(50) NOT NULL,
    ChassisNumber NVARCHAR(100) NOT NULL,
    VehicleType NVARCHAR(100) NOT NULL,
    Model NVARCHAR(100) NULL,
    Color NVARCHAR(50) NULL,
    Capacity INT NULL,
    OwnershipType NVARCHAR(50) NOT NULL,
    ThirdPartyInsuranceExpiryDate DATE NOT NULL,
    BodyInsuranceExpiryDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsAvailable BIT NOT NULL DEFAULT 1,
    Description NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Vehicles_Branches FOREIGN KEY (BranchId) REFERENCES Branches(Id),
    CONSTRAINT UX_Vehicles_PlateNumber UNIQUE (PlateNumber),
    CONSTRAINT UX_Vehicles_ChassisNumber UNIQUE (ChassisNumber)
);

CREATE TABLE Drivers (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    BranchId UNIQUEIDENTIFIER NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    FatherName NVARCHAR(100) NULL,
    NationalCode NVARCHAR(20) NOT NULL,
    IdentityNumber NVARCHAR(50) NULL,
    BirthPlace NVARCHAR(100) NULL,
    BirthDate DATE NULL,
    MobileNumber NVARCHAR(30) NULL,
    DrivingLicenseNumber NVARCHAR(100) NOT NULL,
    DrivingLicenseExpiryDate DATE NULL,
    InsuranceExpiryDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Drivers_Branches FOREIGN KEY (BranchId) REFERENCES Branches(Id),
    CONSTRAINT UX_Drivers_NationalCode UNIQUE (NationalCode),
    CONSTRAINT UX_Drivers_DrivingLicenseNumber UNIQUE (DrivingLicenseNumber)
);

CREATE TABLE Contracts (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    DriverId UNIQUEIDENTIFIER NOT NULL,
    VehicleId UNIQUEIDENTIFIER NULL,
    ContractNumber NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    HourlyRate DECIMAL(18,2) NOT NULL,
    GoKmRate DECIMAL(18,2) NOT NULL,
    ReturnKmRate DECIMAL(18,2) NOT NULL,
    SleepHourRate DECIMAL(18,2) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Contracts_Drivers FOREIGN KEY (DriverId) REFERENCES Drivers(Id),
    CONSTRAINT FK_Contracts_Vehicles FOREIGN KEY (VehicleId) REFERENCES Vehicles(Id),
    CONSTRAINT UX_Contracts_ContractNumber UNIQUE (ContractNumber)
);

CREATE TABLE ContractCalculationRules (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    ContractId UNIQUEIDENTIFIER NOT NULL,
    RuleCode NVARCHAR(100) NOT NULL,
    StrategyCode NVARCHAR(100) NOT NULL,
    Priority INT NOT NULL,
    ConfigurationJson NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_ContractCalculationRules_Contracts FOREIGN KEY (ContractId) REFERENCES Contracts(Id),
    CONSTRAINT UX_ContractCalculationRules_Contract_Rule UNIQUE (ContractId, RuleCode)
);

CREATE TABLE MissionRequests (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    RequestNumber NVARCHAR(100) NOT NULL,
    RequesterUserId NVARCHAR(100) NOT NULL,
    RequesterDisplayName NVARCHAR(200) NOT NULL,
    RequesterBranchId UNIQUEIDENTIFIER NOT NULL,
    MissionType NVARCHAR(50) NOT NULL,
    TransportType NVARCHAR(50) NOT NULL,
    MissionArea NVARCHAR(50) NOT NULL,
    StartDateTime DATETIME2 NOT NULL,
    EndDateTime DATETIME2 NOT NULL,
    OriginProvinceId UNIQUEIDENTIFIER NOT NULL,
    OriginCityId UNIQUEIDENTIFIER NOT NULL,
    OriginAddress NVARCHAR(1000) NULL,
    DestinationProvinceId UNIQUEIDENTIFIER NOT NULL,
    DestinationCityId UNIQUEIDENTIFIER NOT NULL,
    DestinationAddress NVARCHAR(1000) NULL,
    Reason NVARCHAR(1000) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Status NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_MissionRequests_RequesterBranch FOREIGN KEY (RequesterBranchId) REFERENCES Branches(Id),
    CONSTRAINT FK_MissionRequests_OriginProvince FOREIGN KEY (OriginProvinceId) REFERENCES Provinces(Id),
    CONSTRAINT FK_MissionRequests_OriginCity FOREIGN KEY (OriginCityId) REFERENCES Cities(Id),
    CONSTRAINT FK_MissionRequests_DestinationProvince FOREIGN KEY (DestinationProvinceId) REFERENCES Provinces(Id),
    CONSTRAINT FK_MissionRequests_DestinationCity FOREIGN KEY (DestinationCityId) REFERENCES Cities(Id),
    CONSTRAINT UX_MissionRequests_RequestNumber UNIQUE (RequestNumber)
);

CREATE TABLE MissionCompanions (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    MissionRequestId UNIQUEIDENTIFIER NOT NULL,
    PersonName NVARCHAR(200) NOT NULL,
    NationalCode NVARCHAR(20) NULL,
    EmployeeUserId NVARCHAR(100) NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_MissionCompanions_MissionRequests FOREIGN KEY (MissionRequestId) REFERENCES MissionRequests(Id)
);

CREATE TABLE WorkflowDefinitions (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Code NVARCHAR(100) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    EntityType NVARCHAR(100) NOT NULL,
    Version INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT UX_WorkflowDefinitions_Code UNIQUE (Code)
);

CREATE TABLE WorkflowSteps (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    WorkflowDefinitionId UNIQUEIDENTIFIER NOT NULL,
    StepOrder INT NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    ApproverType NVARCHAR(50) NOT NULL,
    ApproverValue NVARCHAR(200) NOT NULL,
    OnApproveNextStepId UNIQUEIDENTIFIER NULL,
    OnReturnStepId UNIQUEIDENTIFIER NULL,
    IsFinalApproval BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_WorkflowSteps_Definitions FOREIGN KEY (WorkflowDefinitionId) REFERENCES WorkflowDefinitions(Id),
    CONSTRAINT FK_WorkflowSteps_OnApproveNext FOREIGN KEY (OnApproveNextStepId) REFERENCES WorkflowSteps(Id),
    CONSTRAINT FK_WorkflowSteps_OnReturn FOREIGN KEY (OnReturnStepId) REFERENCES WorkflowSteps(Id),
    CONSTRAINT UX_WorkflowSteps_Definition_Order UNIQUE (WorkflowDefinitionId, StepOrder)
);

CREATE TABLE WorkflowInstances (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    WorkflowDefinitionId UNIQUEIDENTIFIER NOT NULL,
    EntityType NVARCHAR(100) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    CurrentStepId UNIQUEIDENTIFIER NULL,
    Status NVARCHAR(50) NOT NULL,
    StartedAt DATETIME2 NOT NULL,
    CompletedAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_WorkflowInstances_Definitions FOREIGN KEY (WorkflowDefinitionId) REFERENCES WorkflowDefinitions(Id),
    CONSTRAINT FK_WorkflowInstances_CurrentStep FOREIGN KEY (CurrentStepId) REFERENCES WorkflowSteps(Id)
);

CREATE TABLE WorkflowActions (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    WorkflowInstanceId UNIQUEIDENTIFIER NOT NULL,
    WorkflowStepId UNIQUEIDENTIFIER NOT NULL,
    ActionType NVARCHAR(50) NOT NULL,
    ActorUserId NVARCHAR(100) NOT NULL,
    ActorRole NVARCHAR(100) NULL,
    Comment NVARCHAR(1000) NULL,
    ActionAt DATETIME2 NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_WorkflowActions_Instances FOREIGN KEY (WorkflowInstanceId) REFERENCES WorkflowInstances(Id),
    CONSTRAINT FK_WorkflowActions_Steps FOREIGN KEY (WorkflowStepId) REFERENCES WorkflowSteps(Id)
);

CREATE TABLE DriverAttendances (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    DriverId UNIQUEIDENTIFIER NOT NULL,
    AttendanceDate DATE NOT NULL,
    CheckInAt DATETIME2 NOT NULL,
    CheckOutAt DATETIME2 NULL,
    Status NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_DriverAttendances_Drivers FOREIGN KEY (DriverId) REFERENCES Drivers(Id)
);

CREATE TABLE MissionAssignments (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    MissionRequestId UNIQUEIDENTIFIER NOT NULL,
    DriverId UNIQUEIDENTIFIER NOT NULL,
    VehicleId UNIQUEIDENTIFIER NOT NULL,
    AssignedAt DATETIME2 NOT NULL,
    AssignedBy NVARCHAR(100) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    OverrideInsuranceExpiry BIT NOT NULL DEFAULT 0,
    OverrideReason NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_MissionAssignments_Missions FOREIGN KEY (MissionRequestId) REFERENCES MissionRequests(Id),
    CONSTRAINT FK_MissionAssignments_Drivers FOREIGN KEY (DriverId) REFERENCES Drivers(Id),
    CONSTRAINT FK_MissionAssignments_Vehicles FOREIGN KEY (VehicleId) REFERENCES Vehicles(Id),
    CONSTRAINT UX_MissionAssignments_MissionRequest UNIQUE (MissionRequestId)
);

CREATE TABLE MissionExecutions (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    MissionRequestId UNIQUEIDENTIFIER NOT NULL,
    ActualStartTime DATETIME2 NOT NULL,
    ActualEndTime DATETIME2 NULL,
    StartKm INT NOT NULL,
    EndKm INT NULL,
    TotalKm INT NULL,
    DrivingHours DECIMAL(10,2) NULL,
    SleepHours DECIMAL(10,2) NOT NULL,
    StopCost DECIMAL(18,2) NOT NULL,
    PenaltyAmount DECIMAL(18,2) NOT NULL,
    ExtraPayment DECIMAL(18,2) NOT NULL,
    NoSalary BIT NOT NULL DEFAULT 0,
    Description NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_MissionExecutions_Missions FOREIGN KEY (MissionRequestId) REFERENCES MissionRequests(Id),
    CONSTRAINT UX_MissionExecutions_MissionRequest UNIQUE (MissionRequestId)
);

CREATE TABLE MissionCalculationResults (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    MissionExecutionId UNIQUEIDENTIFIER NOT NULL,
    BaseAmount DECIMAL(18,2) NOT NULL,
    KmAmount DECIMAL(18,2) NOT NULL,
    HourAmount DECIMAL(18,2) NOT NULL,
    SleepAmount DECIMAL(18,2) NOT NULL,
    StopCostAmount DECIMAL(18,2) NOT NULL,
    PenaltyAmount DECIMAL(18,2) NOT NULL,
    ExtraAmount DECIMAL(18,2) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    CalculationJson NVARCHAR(MAX) NULL,
    StrategyCode NVARCHAR(100) NOT NULL,
    CalculatedAt DATETIME2 NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(100) NULL,
    UpdatedAt DATETIME2 NULL,
    UpdatedBy NVARCHAR(100) NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_MissionCalculationResults_Executions FOREIGN KEY (MissionExecutionId) REFERENCES MissionExecutions(Id)
);

CREATE INDEX IX_WorkflowInstances_Entity ON WorkflowInstances(EntityType, EntityId);
CREATE INDEX IX_DriverAttendances_Driver_Date ON DriverAttendances(DriverId, AttendanceDate);
