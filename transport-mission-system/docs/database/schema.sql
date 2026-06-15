-- Transport & Mission Management System
-- Generated from docs/database-schema.md
-- SQL Server 2019+
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[Branches] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Branches_Id] DEFAULT (NEWSEQUENTIALID()),
    [Name] nvarchar(200) NOT NULL,
    [Code] nvarchar(50) NOT NULL,
    [Address] nvarchar(500) NULL,
    [PhoneNumber] nvarchar(30) NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Branches_Status] DEFAULT (N'Active'),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Branches_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Branches_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Branches] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[OrganizationUnits] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_OrganizationUnits_Id] DEFAULT (NEWSEQUENTIALID()),
    [BranchId] uniqueidentifier NULL,
    [ParentOrganizationUnitId] uniqueidentifier NULL,
    [Name] nvarchar(200) NOT NULL,
    [Code] nvarchar(50) NULL,
    [ManagerUserId] uniqueidentifier NULL,
    [LevelNo] int NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_OrganizationUnits_Status] DEFAULT (N'Active'),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_OrganizationUnits_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_OrganizationUnits_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_OrganizationUnits] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Users] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Users_Id] DEFAULT (NEWSEQUENTIALID()),
    [BranchId] uniqueidentifier NULL,
    [OrganizationUnitId] uniqueidentifier NULL,
    [PersonnelCode] nvarchar(50) NULL,
    [FirstName] nvarchar(100) NOT NULL,
    [LastName] nvarchar(100) NOT NULL,
    [NationalCode] nvarchar(10) NULL,
    [Mobile] nvarchar(20) NULL,
    [Email] nvarchar(256) NULL,
    [Username] nvarchar(100) NOT NULL,
    [PasswordHash] nvarchar(512) NOT NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Users_Status] DEFAULT (N'Active'),
    [LastLoginAt] datetime2(3) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Users_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Roles] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Roles_Id] DEFAULT (NEWSEQUENTIALID()),
    [Name] nvarchar(100) NOT NULL,
    [DisplayName] nvarchar(150) NULL,
    [Description] nvarchar(500) NULL,
    [IsSystemRole] bit NOT NULL CONSTRAINT [DF_Roles_IsSystemRole] DEFAULT (1),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Roles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[UserRoles] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_UserRoles_Id] DEFAULT (NEWSEQUENTIALID()),
    [UserId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    [StartDate] date NULL,
    [EndDate] date NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_UserRoles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[RefreshTokens] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_RefreshTokens_Id] DEFAULT (NEWSEQUENTIALID()),
    [UserId] uniqueidentifier NOT NULL,
    [Token] nvarchar(512) NOT NULL,
    [ExpiresAt] datetime2(3) NOT NULL,
    [RevokedAt] datetime2(3) NULL,
    [ReasonRevoked] nvarchar(250) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_RefreshTokens_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_RefreshTokens_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_RefreshTokens] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Provinces] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Provinces_Id] DEFAULT (NEWSEQUENTIALID()),
    [Name] nvarchar(150) NOT NULL,
    [Code] nvarchar(20) NULL,
    [DisplayOrder] int NOT NULL CONSTRAINT [DF_Provinces_DisplayOrder] DEFAULT (0),
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Provinces_Status] DEFAULT (N'Active'),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Provinces_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Provinces_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Cities] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Cities_Id] DEFAULT (NEWSEQUENTIALID()),
    [ProvinceId] uniqueidentifier NOT NULL,
    [Name] nvarchar(150) NOT NULL,
    [Code] nvarchar(20) NULL,
    [DisplayOrder] int NOT NULL CONSTRAINT [DF_Cities_DisplayOrder] DEFAULT (0),
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Cities_Status] DEFAULT (N'Active'),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Cities_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Cities_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Drivers] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Drivers_Id] DEFAULT (NEWSEQUENTIALID()),
    [BranchId] uniqueidentifier NOT NULL,
    [RepresentationName] nvarchar(200) NULL,
    [FirstName] nvarchar(100) NOT NULL,
    [LastName] nvarchar(100) NOT NULL,
    [FatherName] nvarchar(100) NULL,
    [NationalCode] nvarchar(10) NOT NULL,
    [BirthCertificateNo] nvarchar(20) NOT NULL,
    [BirthPlace] nvarchar(100) NULL,
    [BirthDate] date NULL,
    [Mobile] nvarchar(20) NULL,
    [LicenseNo] nvarchar(50) NOT NULL,
    [InsuranceExpireDate] date NULL,
    [InsuranceWarningEnabled] bit NOT NULL CONSTRAINT [DF_Drivers_InsuranceWarningEnabled] DEFAULT (0),
    [IsActive] bit NOT NULL CONSTRAINT [DF_Drivers_IsActive] DEFAULT (1),
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Drivers_Status] DEFAULT (N'Active'),
    [Notes] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Drivers_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Drivers_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Drivers] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Vehicles] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Vehicles_Id] DEFAULT (NEWSEQUENTIALID()),
    [OwningBranchId] uniqueidentifier NULL,
    [VehicleType] nvarchar(100) NOT NULL,
    [Model] nvarchar(100) NOT NULL,
    [ModelYear] smallint NULL,
    [Color] nvarchar(50) NOT NULL,
    [ChassisNo] nvarchar(100) NOT NULL,
    [PlateNo] nvarchar(30) NOT NULL,
    [OwnershipType] nvarchar(20) NOT NULL CONSTRAINT [DF_Vehicles_OwnershipType] DEFAULT (N'Organizational'),
    [ThirdPartyInsuranceExpireDate] date NULL,
    [BodyInsuranceExpireDate] date NULL,
    [Status] nvarchar(30) NOT NULL CONSTRAINT [DF_Vehicles_Status] DEFAULT (N'Active'),
    [IsActive] bit NOT NULL CONSTRAINT [DF_Vehicles_IsActive] DEFAULT (1),
    [Notes] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Vehicles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Vehicles_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Contracts] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Contracts_Id] DEFAULT (NEWSEQUENTIALID()),
    [DriverId] uniqueidentifier NOT NULL,
    [VehicleId] uniqueidentifier NOT NULL,
    [ContractNo] nvarchar(50) NULL,
    [StartDate] date NOT NULL,
    [EndDate] date NOT NULL,
    [HourlyAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_Contracts_HourlyAmount] DEFAULT (0),
    [GoingAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_Contracts_GoingAmount] DEFAULT (0),
    [ReturningAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_Contracts_ReturningAmount] DEFAULT (0),
    [SleepHourlyAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_Contracts_SleepHourlyAmount] DEFAULT (0),
    [KilometerAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_Contracts_KilometerAmount] DEFAULT (0),
    [InsuranceStatus] nvarchar(50) NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_Contracts_Status] DEFAULT (N'Draft'),
    [Notes] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Contracts_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Contracts_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[CalculationPolicies] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_CalculationPolicies_Id] DEFAULT (NEWSEQUENTIALID()),
    [BranchId] uniqueidentifier NULL,
    [Name] nvarchar(150) NOT NULL,
    [PolicyType] nvarchar(50) NOT NULL CONSTRAINT [DF_CalculationPolicies_PolicyType] DEFAULT (N'UrbanHourly'),
    [IsDefault] bit NOT NULL CONSTRAINT [DF_CalculationPolicies_IsDefault] DEFAULT (0),
    [ConfigurationJson] nvarchar(max) NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_CalculationPolicies_Status] DEFAULT (N'Active'),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_CalculationPolicies_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_CalculationPolicies_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_CalculationPolicies] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Missions] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_Missions_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionNo] nvarchar(50) NOT NULL,
    [RequesterUserId] uniqueidentifier NOT NULL,
    [BranchId] uniqueidentifier NULL,
    [OriginProvinceId] uniqueidentifier NOT NULL,
    [OriginCityId] uniqueidentifier NOT NULL,
    [OriginAddress] nvarchar(500) NOT NULL,
    [DestinationProvinceId] uniqueidentifier NOT NULL,
    [DestinationCityId] uniqueidentifier NOT NULL,
    [DestinationAddress] nvarchar(500) NOT NULL,
    [TravelType] nvarchar(20) NOT NULL CONSTRAINT [DF_Missions_TravelType] DEFAULT (N'Ground'),
    [DurationType] nvarchar(20) NOT NULL CONSTRAINT [DF_Missions_DurationType] DEFAULT (N'Daily'),
    [StartDateTime] datetime2(3) NOT NULL,
    [EndDateTime] datetime2(3) NOT NULL,
    [Reason] nvarchar(1000) NOT NULL,
    [Description] nvarchar(2000) NULL,
    [RequestedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Missions_RequestedAt] DEFAULT (SYSUTCDATETIME()),
    [CurrentStatus] nvarchar(30) NOT NULL CONSTRAINT [DF_Missions_CurrentStatus] DEFAULT (N'Draft'),
    [FinalApprovalAt] datetime2(3) NULL,
    [FinalApprovedByUserId] uniqueidentifier NULL,
    [CalculationPolicyId] uniqueidentifier NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_Missions_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_Missions_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_Missions] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionPassengers] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionPassengers_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NOT NULL,
    [PassengerUserId] uniqueidentifier NOT NULL,
    [IsPrimaryPassenger] bit NOT NULL CONSTRAINT [DF_MissionPassengers_IsPrimaryPassenger] DEFAULT (0),
    [Notes] nvarchar(500) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionPassengers_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionPassengers_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionPassengers] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionApprovals] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionApprovals_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NOT NULL,
    [ApprovalOrder] int NOT NULL,
    [ApproverUserId] uniqueidentifier NULL,
    [ApproverRoleName] nvarchar(100) NULL,
    [Decision] nvarchar(20) NOT NULL CONSTRAINT [DF_MissionApprovals_Decision] DEFAULT (N'Pending'),
    [DecisionComment] nvarchar(1000) NULL,
    [DecidedAt] datetime2(3) NULL,
    [ExternalWorkflowItemId] nvarchar(100) NULL,
    [IsCurrentStep] bit NOT NULL CONSTRAINT [DF_MissionApprovals_IsCurrentStep] DEFAULT (0),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionApprovals_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionApprovals_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionApprovals] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionStatusHistory] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionStatusHistory_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NOT NULL,
    [FromStatus] nvarchar(30) NULL,
    [ToStatus] nvarchar(30) NOT NULL,
    [ChangedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionStatusHistory_ChangedAt] DEFAULT (SYSUTCDATETIME()),
    [ChangedByUserId] uniqueidentifier NULL,
    [Reason] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionStatusHistory_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionStatusHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionAssignments] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionAssignments_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NOT NULL,
    [DriverId] uniqueidentifier NOT NULL,
    [VehicleId] uniqueidentifier NOT NULL,
    [ContractId] uniqueidentifier NOT NULL,
    [AssignedByUserId] uniqueidentifier NOT NULL,
    [ConfirmedByUserId] uniqueidentifier NULL,
    [AssignedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionAssignments_AssignedAt] DEFAULT (SYSUTCDATETIME()),
    [ConfirmedAt] datetime2(3) NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_MissionAssignments_Status] DEFAULT (N'Assigned'),
    [Notes] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionAssignments_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionAssignments_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionAssignments] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[DriverAttendance] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_DriverAttendance_Id] DEFAULT (NEWSEQUENTIALID()),
    [DriverId] uniqueidentifier NOT NULL,
    [VehicleId] uniqueidentifier NULL,
    [AttendanceDate] date NOT NULL,
    [EntryTime] time(0) NOT NULL,
    [ExitTime] time(0) NOT NULL,
    [TotalHours] decimal(9,2) NULL,
    [Status] nvarchar(20) NOT NULL CONSTRAINT [DF_DriverAttendance_Status] DEFAULT (N'Recorded'),
    [Source] nvarchar(50) NOT NULL CONSTRAINT [DF_DriverAttendance_Source] DEFAULT (N'Manual'),
    [Notes] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_DriverAttendance_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_DriverAttendance_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_DriverAttendance] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionExecutions] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionExecutions_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NOT NULL,
    [MissionAssignmentId] uniqueidentifier NOT NULL,
    [DepartureDateTime] datetime2(3) NOT NULL,
    [ReturnDateTime] datetime2(3) NOT NULL,
    [StartOdometerKm] int NOT NULL,
    [EndOdometerKm] int NOT NULL,
    [TotalDistanceKm] int NULL,
    [TotalMissionHours] decimal(9,2) NULL,
    [DrivingHours] decimal(9,2) NULL,
    [SleepHours] decimal(9,2) NULL,
    [WithoutPayment] bit NOT NULL CONSTRAINT [DF_MissionExecutions_WithoutPayment] DEFAULT (0),
    [ExecutionStatus] nvarchar(20) NOT NULL CONSTRAINT [DF_MissionExecutions_ExecutionStatus] DEFAULT (N'Recorded'),
    [Notes] nvarchar(2000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionExecutions_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionExecutions_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionExecutions] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionExecutionStops] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionExecutionStops_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionExecutionId] uniqueidentifier NOT NULL,
    [StopType] nvarchar(30) NOT NULL CONSTRAINT [DF_MissionExecutionStops_StopType] DEFAULT (N'Stop'),
    [Description] nvarchar(500) NULL,
    [Quantity] decimal(9,2) NOT NULL CONSTRAINT [DF_MissionExecutionStops_Quantity] DEFAULT (1),
    [UnitAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionExecutionStops_UnitAmount] DEFAULT (0),
    [TotalAmount] decimal(18,2) NULL,
    [OccurredAt] datetime2(3) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionExecutionStops_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionExecutionStops_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionExecutionStops] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MissionCosts] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MissionCosts_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionExecutionId] uniqueidentifier NOT NULL,
    [ContractId] uniqueidentifier NOT NULL,
    [CalculationPolicyId] uniqueidentifier NULL,
    [HourlyAmountApplied] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_HourlyAmountApplied] DEFAULT (0),
    [KilometerAmountApplied] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_KilometerAmountApplied] DEFAULT (0),
    [SleepHourlyAmountApplied] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_SleepHourlyAmountApplied] DEFAULT (0),
    [GoingAmountApplied] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_GoingAmountApplied] DEFAULT (0),
    [ReturningAmountApplied] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_ReturningAmountApplied] DEFAULT (0),
    [AttendanceAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_AttendanceAmount] DEFAULT (0),
    [KilometerCost] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_KilometerCost] DEFAULT (0),
    [SleepCost] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_SleepCost] DEFAULT (0),
    [StopCost] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_StopCost] DEFAULT (0),
    [PenaltyCost] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_PenaltyCost] DEFAULT (0),
    [ExtraPaymentAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_ExtraPaymentAmount] DEFAULT (0),
    [TotalPayableAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MissionCosts_TotalPayableAmount] DEFAULT (0),
    [CalculationVersion] int NOT NULL CONSTRAINT [DF_MissionCosts_CalculationVersion] DEFAULT (1),
    [IsFinal] bit NOT NULL CONSTRAINT [DF_MissionCosts_IsFinal] DEFAULT (0),
    [CalculationNotes] nvarchar(2000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MissionCosts_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MissionCosts_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MissionCosts] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MonthlySettlements] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MonthlySettlements_Id] DEFAULT (NEWSEQUENTIALID()),
    [DriverId] uniqueidentifier NOT NULL,
    [BranchId] uniqueidentifier NULL,
    [Year] smallint NOT NULL,
    [Month] tinyint NOT NULL,
    [SettlementStatus] nvarchar(20) NOT NULL CONSTRAINT [DF_MonthlySettlements_SettlementStatus] DEFAULT (N'Draft'),
    [AttendanceAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_AttendanceAmount] DEFAULT (0),
    [MissionAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_MissionAmount] DEFAULT (0),
    [PenaltyAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_PenaltyAmount] DEFAULT (0),
    [ExtraPaymentAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_ExtraPaymentAmount] DEFAULT (0),
    [AdjustmentAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_AdjustmentAmount] DEFAULT (0),
    [TotalPayableAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlements_TotalPayableAmount] DEFAULT (0),
    [GeneratedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MonthlySettlements_GeneratedAt] DEFAULT (SYSUTCDATETIME()),
    [ApprovedAt] datetime2(3) NULL,
    [ApprovedByUserId] uniqueidentifier NULL,
    [PaidAt] datetime2(3) NULL,
    [PaymentReferenceNo] nvarchar(100) NULL,
    [Notes] nvarchar(2000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MonthlySettlements_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MonthlySettlements_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MonthlySettlements] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[MonthlySettlementItems] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_MonthlySettlementItems_Id] DEFAULT (NEWSEQUENTIALID()),
    [MonthlySettlementId] uniqueidentifier NOT NULL,
    [ItemType] nvarchar(30) NOT NULL CONSTRAINT [DF_MonthlySettlementItems_ItemType] DEFAULT (N'Mission'),
    [ReferenceAttendanceId] uniqueidentifier NULL,
    [ReferenceMissionCostId] uniqueidentifier NULL,
    [Description] nvarchar(500) NULL,
    [Quantity] decimal(9,2) NOT NULL CONSTRAINT [DF_MonthlySettlementItems_Quantity] DEFAULT (1),
    [UnitAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlementItems_UnitAmount] DEFAULT (0),
    [TotalAmount] decimal(18,2) NOT NULL CONSTRAINT [DF_MonthlySettlementItems_TotalAmount] DEFAULT (0),
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_MonthlySettlementItems_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_MonthlySettlementItems_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_MonthlySettlementItems] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[AuditLogs] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_AuditLogs_Id] DEFAULT (NEWSEQUENTIALID()),
    [EntityName] nvarchar(150) NOT NULL,
    [EntityId] uniqueidentifier NULL,
    [Action] nvarchar(30) NOT NULL,
    [PerformedByUserId] uniqueidentifier NULL,
    [PerformedAt] datetime2(3) NOT NULL CONSTRAINT [DF_AuditLogs_PerformedAt] DEFAULT (SYSUTCDATETIME()),
    [ClientIp] nvarchar(64) NULL,
    [CorrelationId] nvarchar(100) NULL,
    [OldValuesJson] nvarchar(max) NULL,
    [NewValuesJson] nvarchar(max) NULL,
    [Remarks] nvarchar(1000) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_AuditLogs_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_AuditLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[ChargoonWorkflowMappings] (
    [Id] uniqueidentifier NOT NULL CONSTRAINT [DF_ChargoonWorkflowMappings_Id] DEFAULT (NEWSEQUENTIALID()),
    [MissionId] uniqueidentifier NULL,
    [MissionApprovalId] uniqueidentifier NULL,
    [ExternalSystemName] nvarchar(100) NOT NULL CONSTRAINT [DF_ChargoonWorkflowMappings_ExternalSystemName] DEFAULT (N'Chargoon'),
    [ExternalWorkflowId] nvarchar(100) NULL,
    [ExternalTaskId] nvarchar(100) NULL,
    [SyncStatus] nvarchar(50) NOT NULL CONSTRAINT [DF_ChargoonWorkflowMappings_SyncStatus] DEFAULT (N'Pending'),
    [LastSyncedAt] datetime2(3) NULL,
    [PayloadJson] nvarchar(max) NULL,
    [CreatedAt] datetime2(3) NOT NULL CONSTRAINT [DF_ChargoonWorkflowMappings_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId] uniqueidentifier NULL,
    [UpdatedAt] datetime2(3) NULL,
    [UpdatedByUserId] uniqueidentifier NULL,
    [IsDeleted] bit NOT NULL CONSTRAINT [DF_ChargoonWorkflowMappings_IsDeleted] DEFAULT (0),
    [DeletedAt] datetime2(3) NULL,
    [DeletedByUserId] uniqueidentifier NULL,
    CONSTRAINT [PK_ChargoonWorkflowMappings] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

ALTER TABLE [dbo].[Branches]  WITH CHECK ADD CONSTRAINT [FK_Branches_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Branches]  WITH CHECK ADD CONSTRAINT [FK_Branches_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Branches]  WITH CHECK ADD CONSTRAINT [FK_Branches_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Branches] ADD CONSTRAINT [CK_Branches_Status_BranchStatus] CHECK ([Status] IN (N'Active', N'Inactive'));
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_ParentOrganizationUnitId_OrganizationUnits] FOREIGN KEY([ParentOrganizationUnitId]) REFERENCES [dbo].[OrganizationUnits] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_ManagerUserId_Users] FOREIGN KEY([ManagerUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD CONSTRAINT [FK_OrganizationUnits_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[OrganizationUnits] ADD CONSTRAINT [CK_OrganizationUnits_Status_BranchStatus] CHECK ([Status] IN (N'Active', N'Inactive'));
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD CONSTRAINT [FK_Users_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD CONSTRAINT [FK_Users_OrganizationUnitId_OrganizationUnits] FOREIGN KEY([OrganizationUnitId]) REFERENCES [dbo].[OrganizationUnits] ([Id]);
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD CONSTRAINT [FK_Users_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD CONSTRAINT [FK_Users_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD CONSTRAINT [FK_Users_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Users] ADD CONSTRAINT [CK_Users_Status_UserStatus] CHECK ([Status] IN (N'Active', N'Inactive', N'Locked'));
GO

ALTER TABLE [dbo].[Roles]  WITH CHECK ADD CONSTRAINT [FK_Roles_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Roles]  WITH CHECK ADD CONSTRAINT [FK_Roles_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD CONSTRAINT [FK_UserRoles_UserId_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD CONSTRAINT [FK_UserRoles_RoleId_Roles] FOREIGN KEY([RoleId]) REFERENCES [dbo].[Roles] ([Id]);
GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD CONSTRAINT [FK_UserRoles_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD CONSTRAINT [FK_UserRoles_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD CONSTRAINT [FK_RefreshTokens_UserId_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD CONSTRAINT [FK_RefreshTokens_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD CONSTRAINT [FK_RefreshTokens_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD CONSTRAINT [FK_RefreshTokens_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Provinces]  WITH CHECK ADD CONSTRAINT [FK_Provinces_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Provinces]  WITH CHECK ADD CONSTRAINT [FK_Provinces_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Provinces]  WITH CHECK ADD CONSTRAINT [FK_Provinces_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Provinces] ADD CONSTRAINT [CK_Provinces_Status_BranchStatus] CHECK ([Status] IN (N'Active', N'Inactive'));
GO

ALTER TABLE [dbo].[Cities]  WITH CHECK ADD CONSTRAINT [FK_Cities_ProvinceId_Provinces] FOREIGN KEY([ProvinceId]) REFERENCES [dbo].[Provinces] ([Id]);
GO

ALTER TABLE [dbo].[Cities]  WITH CHECK ADD CONSTRAINT [FK_Cities_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Cities]  WITH CHECK ADD CONSTRAINT [FK_Cities_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Cities]  WITH CHECK ADD CONSTRAINT [FK_Cities_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Cities] ADD CONSTRAINT [CK_Cities_Status_BranchStatus] CHECK ([Status] IN (N'Active', N'Inactive'));
GO

ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD CONSTRAINT [FK_Drivers_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD CONSTRAINT [FK_Drivers_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD CONSTRAINT [FK_Drivers_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD CONSTRAINT [FK_Drivers_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Drivers] ADD CONSTRAINT [CK_Drivers_Status_UserStatus] CHECK ([Status] IN (N'Active', N'Inactive', N'Locked'));
GO

ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD CONSTRAINT [FK_Vehicles_OwningBranchId_Branches] FOREIGN KEY([OwningBranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD CONSTRAINT [FK_Vehicles_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD CONSTRAINT [FK_Vehicles_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD CONSTRAINT [FK_Vehicles_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Vehicles] ADD CONSTRAINT [CK_Vehicles_OwnershipType_VehicleOwnershipType] CHECK ([OwnershipType] IN (N'Personal', N'Organizational'));
GO

ALTER TABLE [dbo].[Vehicles] ADD CONSTRAINT [CK_Vehicles_Status_VehicleStatus] CHECK ([Status] IN (N'Active', N'Inactive', N'UnderMaintenance', N'InsuranceExpired', N'Retired'));
GO

ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD CONSTRAINT [FK_Contracts_DriverId_Drivers] FOREIGN KEY([DriverId]) REFERENCES [dbo].[Drivers] ([Id]);
GO

ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD CONSTRAINT [FK_Contracts_VehicleId_Vehicles] FOREIGN KEY([VehicleId]) REFERENCES [dbo].[Vehicles] ([Id]);
GO

ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD CONSTRAINT [FK_Contracts_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD CONSTRAINT [FK_Contracts_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD CONSTRAINT [FK_Contracts_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Contracts] ADD CONSTRAINT [CK_Contracts_Status_ContractStatus] CHECK ([Status] IN (N'Draft', N'Active', N'Expired', N'Terminated', N'Suspended'));
GO

ALTER TABLE [dbo].[CalculationPolicies]  WITH CHECK ADD CONSTRAINT [FK_CalculationPolicies_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[CalculationPolicies]  WITH CHECK ADD CONSTRAINT [FK_CalculationPolicies_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[CalculationPolicies]  WITH CHECK ADD CONSTRAINT [FK_CalculationPolicies_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[CalculationPolicies]  WITH CHECK ADD CONSTRAINT [FK_CalculationPolicies_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[CalculationPolicies] ADD CONSTRAINT [CK_CalculationPolicies_PolicyType_CalculationPolicyType] CHECK ([PolicyType] IN (N'UrbanHourly', N'UrbanByDistance', N'OutboundByDistanceAndSleep', N'Custom'));
GO

ALTER TABLE [dbo].[CalculationPolicies] ADD CONSTRAINT [CK_CalculationPolicies_Status_BranchStatus] CHECK ([Status] IN (N'Active', N'Inactive'));
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_RequesterUserId_Users] FOREIGN KEY([RequesterUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_OriginProvinceId_Provinces] FOREIGN KEY([OriginProvinceId]) REFERENCES [dbo].[Provinces] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_OriginCityId_Cities] FOREIGN KEY([OriginCityId]) REFERENCES [dbo].[Cities] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_DestinationProvinceId_Provinces] FOREIGN KEY([DestinationProvinceId]) REFERENCES [dbo].[Provinces] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_DestinationCityId_Cities] FOREIGN KEY([DestinationCityId]) REFERENCES [dbo].[Cities] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_FinalApprovedByUserId_Users] FOREIGN KEY([FinalApprovedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_CalculationPolicyId_CalculationPolicies] FOREIGN KEY([CalculationPolicyId]) REFERENCES [dbo].[CalculationPolicies] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Missions]  WITH CHECK ADD CONSTRAINT [FK_Missions_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[Missions] ADD CONSTRAINT [CK_Missions_TravelType_MissionTravelType] CHECK ([TravelType] IN (N'Ground', N'Air'));
GO

ALTER TABLE [dbo].[Missions] ADD CONSTRAINT [CK_Missions_DurationType_MissionDurationType] CHECK ([DurationType] IN (N'Hourly', N'Daily'));
GO

ALTER TABLE [dbo].[Missions] ADD CONSTRAINT [CK_Missions_CurrentStatus_MissionStatus] CHECK ([CurrentStatus] IN (N'Draft', N'PendingApproval', N'Approved', N'Rejected', N'Assigned', N'ReadyToStart', N'InProgress', N'Completed', N'CostCalculated', N'PendingSettlement', N'Settled', N'Cancelled'));
GO

ALTER TABLE [dbo].[MissionPassengers]  WITH CHECK ADD CONSTRAINT [FK_MissionPassengers_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[MissionPassengers]  WITH CHECK ADD CONSTRAINT [FK_MissionPassengers_PassengerUserId_Users] FOREIGN KEY([PassengerUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionPassengers]  WITH CHECK ADD CONSTRAINT [FK_MissionPassengers_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionPassengers]  WITH CHECK ADD CONSTRAINT [FK_MissionPassengers_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionPassengers]  WITH CHECK ADD CONSTRAINT [FK_MissionPassengers_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals]  WITH CHECK ADD CONSTRAINT [FK_MissionApprovals_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals]  WITH CHECK ADD CONSTRAINT [FK_MissionApprovals_ApproverUserId_Users] FOREIGN KEY([ApproverUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals]  WITH CHECK ADD CONSTRAINT [FK_MissionApprovals_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals]  WITH CHECK ADD CONSTRAINT [FK_MissionApprovals_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals]  WITH CHECK ADD CONSTRAINT [FK_MissionApprovals_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionApprovals] ADD CONSTRAINT [CK_MissionApprovals_Decision_ApprovalDecision] CHECK ([Decision] IN (N'Pending', N'Approved', N'Rejected', N'Skipped', N'Cancelled'));
GO

ALTER TABLE [dbo].[MissionStatusHistory]  WITH CHECK ADD CONSTRAINT [FK_MissionStatusHistory_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[MissionStatusHistory]  WITH CHECK ADD CONSTRAINT [FK_MissionStatusHistory_ChangedByUserId_Users] FOREIGN KEY([ChangedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionStatusHistory]  WITH CHECK ADD CONSTRAINT [FK_MissionStatusHistory_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionStatusHistory]  WITH CHECK ADD CONSTRAINT [FK_MissionStatusHistory_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionStatusHistory] ADD CONSTRAINT [CK_MissionStatusHistory_FromStatus_MissionStatus] CHECK ([FromStatus] IN (N'Draft', N'PendingApproval', N'Approved', N'Rejected', N'Assigned', N'ReadyToStart', N'InProgress', N'Completed', N'CostCalculated', N'PendingSettlement', N'Settled', N'Cancelled'));
GO

ALTER TABLE [dbo].[MissionStatusHistory] ADD CONSTRAINT [CK_MissionStatusHistory_ToStatus_MissionStatus] CHECK ([ToStatus] IN (N'Draft', N'PendingApproval', N'Approved', N'Rejected', N'Assigned', N'ReadyToStart', N'InProgress', N'Completed', N'CostCalculated', N'PendingSettlement', N'Settled', N'Cancelled'));
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_DriverId_Drivers] FOREIGN KEY([DriverId]) REFERENCES [dbo].[Drivers] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_VehicleId_Vehicles] FOREIGN KEY([VehicleId]) REFERENCES [dbo].[Vehicles] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_ContractId_Contracts] FOREIGN KEY([ContractId]) REFERENCES [dbo].[Contracts] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_AssignedByUserId_Users] FOREIGN KEY([AssignedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_ConfirmedByUserId_Users] FOREIGN KEY([ConfirmedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments]  WITH CHECK ADD CONSTRAINT [FK_MissionAssignments_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionAssignments] ADD CONSTRAINT [CK_MissionAssignments_Status_AssignmentStatus] CHECK ([Status] IN (N'Pending', N'Assigned', N'Confirmed', N'Cancelled', N'Reassigned', N'Completed'));
GO

ALTER TABLE [dbo].[DriverAttendance]  WITH CHECK ADD CONSTRAINT [FK_DriverAttendance_DriverId_Drivers] FOREIGN KEY([DriverId]) REFERENCES [dbo].[Drivers] ([Id]);
GO

ALTER TABLE [dbo].[DriverAttendance]  WITH CHECK ADD CONSTRAINT [FK_DriverAttendance_VehicleId_Vehicles] FOREIGN KEY([VehicleId]) REFERENCES [dbo].[Vehicles] ([Id]);
GO

ALTER TABLE [dbo].[DriverAttendance]  WITH CHECK ADD CONSTRAINT [FK_DriverAttendance_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[DriverAttendance]  WITH CHECK ADD CONSTRAINT [FK_DriverAttendance_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[DriverAttendance]  WITH CHECK ADD CONSTRAINT [FK_DriverAttendance_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[DriverAttendance] ADD CONSTRAINT [CK_DriverAttendance_Status_AttendanceStatus] CHECK ([Status] IN (N'Recorded', N'Approved', N'Corrected', N'Deleted'));
GO

ALTER TABLE [dbo].[MissionExecutions]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutions_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutions]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutions_MissionAssignmentId_MissionAssignments] FOREIGN KEY([MissionAssignmentId]) REFERENCES [dbo].[MissionAssignments] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutions]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutions_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutions]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutions_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutions]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutions_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutions] ADD CONSTRAINT [CK_MissionExecutions_ExecutionStatus_ExecutionStatus] CHECK ([ExecutionStatus] IN (N'Draft', N'Recorded', N'Calculated', N'Approved', N'Closed'));
GO

ALTER TABLE [dbo].[MissionExecutionStops]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutionStops_MissionExecutionId_MissionExecutions] FOREIGN KEY([MissionExecutionId]) REFERENCES [dbo].[MissionExecutions] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutionStops]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutionStops_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutionStops]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutionStops_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutionStops]  WITH CHECK ADD CONSTRAINT [FK_MissionExecutionStops_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionExecutionStops] ADD CONSTRAINT [CK_MissionExecutionStops_StopType_StopType] CHECK ([StopType] IN (N'Stop', N'Penalty', N'ExtraPayment', N'Other'));
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_MissionExecutionId_MissionExecutions] FOREIGN KEY([MissionExecutionId]) REFERENCES [dbo].[MissionExecutions] ([Id]);
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_ContractId_Contracts] FOREIGN KEY([ContractId]) REFERENCES [dbo].[Contracts] ([Id]);
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_CalculationPolicyId_CalculationPolicies] FOREIGN KEY([CalculationPolicyId]) REFERENCES [dbo].[CalculationPolicies] ([Id]);
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MissionCosts]  WITH CHECK ADD CONSTRAINT [FK_MissionCosts_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_DriverId_Drivers] FOREIGN KEY([DriverId]) REFERENCES [dbo].[Drivers] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_BranchId_Branches] FOREIGN KEY([BranchId]) REFERENCES [dbo].[Branches] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_ApprovedByUserId_Users] FOREIGN KEY([ApprovedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlements_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlements] ADD CONSTRAINT [CK_MonthlySettlements_SettlementStatus_SettlementStatus] CHECK ([SettlementStatus] IN (N'Draft', N'Calculated', N'Approved', N'Posted', N'Paid', N'Cancelled'));
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_MonthlySettlementId_MonthlySettlements] FOREIGN KEY([MonthlySettlementId]) REFERENCES [dbo].[MonthlySettlements] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_ReferenceAttendanceId_DriverAttendance] FOREIGN KEY([ReferenceAttendanceId]) REFERENCES [dbo].[DriverAttendance] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_ReferenceMissionCostId_MissionCosts] FOREIGN KEY([ReferenceMissionCostId]) REFERENCES [dbo].[MissionCosts] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems]  WITH CHECK ADD CONSTRAINT [FK_MonthlySettlementItems_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[MonthlySettlementItems] ADD CONSTRAINT [CK_MonthlySettlementItems_ItemType_SettlementItemType] CHECK ([ItemType] IN (N'Attendance', N'Mission', N'Penalty', N'ExtraPayment', N'Adjustment'));
GO

ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD CONSTRAINT [FK_AuditLogs_PerformedByUserId_Users] FOREIGN KEY([PerformedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD CONSTRAINT [FK_AuditLogs_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD CONSTRAINT [FK_AuditLogs_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[AuditLogs] ADD CONSTRAINT [CK_AuditLogs_Action_AuditEntityAction] CHECK ([Action] IN (N'Create', N'Update', N'Delete', N'Restore', N'Approve', N'Reject', N'Assign', N'Calculate', N'Login', N'Logout'));
GO

ALTER TABLE [dbo].[ChargoonWorkflowMappings]  WITH CHECK ADD CONSTRAINT [FK_ChargoonWorkflowMappings_MissionId_Missions] FOREIGN KEY([MissionId]) REFERENCES [dbo].[Missions] ([Id]);
GO

ALTER TABLE [dbo].[ChargoonWorkflowMappings]  WITH CHECK ADD CONSTRAINT [FK_ChargoonWorkflowMappings_MissionApprovalId_MissionApprovals] FOREIGN KEY([MissionApprovalId]) REFERENCES [dbo].[MissionApprovals] ([Id]);
GO

ALTER TABLE [dbo].[ChargoonWorkflowMappings]  WITH CHECK ADD CONSTRAINT [FK_ChargoonWorkflowMappings_CreatedByUserId_Users] FOREIGN KEY([CreatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[ChargoonWorkflowMappings]  WITH CHECK ADD CONSTRAINT [FK_ChargoonWorkflowMappings_UpdatedByUserId_Users] FOREIGN KEY([UpdatedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

ALTER TABLE [dbo].[ChargoonWorkflowMappings]  WITH CHECK ADD CONSTRAINT [FK_ChargoonWorkflowMappings_DeletedByUserId_Users] FOREIGN KEY([DeletedByUserId]) REFERENCES [dbo].[Users] ([Id]);
GO

CREATE UNIQUE INDEX [UQ_Branches_Code] ON [dbo].[Branches] ([Code]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_OrganizationUnits_Code] ON [dbo].[OrganizationUnits] ([Code]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Users_PersonnelCode] ON [dbo].[Users] ([PersonnelCode]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Users_NationalCode] ON [dbo].[Users] ([NationalCode]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Users_Email] ON [dbo].[Users] ([Email]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Users_Username] ON [dbo].[Users] ([Username]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Roles_Name] ON [dbo].[Roles] ([Name]);
GO

CREATE UNIQUE INDEX [UQ_RefreshTokens_Token] ON [dbo].[RefreshTokens] ([Token]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Provinces_Name] ON [dbo].[Provinces] ([Name]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Provinces_Code] ON [dbo].[Provinces] ([Code]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Drivers_NationalCode] ON [dbo].[Drivers] ([NationalCode]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Drivers_LicenseNo] ON [dbo].[Drivers] ([LicenseNo]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Vehicles_ChassisNo] ON [dbo].[Vehicles] ([ChassisNo]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Vehicles_PlateNo] ON [dbo].[Vehicles] ([PlateNo]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Contracts_ContractNo] ON [dbo].[Contracts] ([ContractNo]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_CalculationPolicies_Name] ON [dbo].[CalculationPolicies] ([Name]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_Missions_MissionNo] ON [dbo].[Missions] ([MissionNo]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_MissionAssignments_MissionId] ON [dbo].[MissionAssignments] ([MissionId]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_MissionExecutions_MissionId] ON [dbo].[MissionExecutions] ([MissionId]) WHERE [IsDeleted] = 0;
GO

CREATE UNIQUE INDEX [UQ_MissionCosts_MissionExecutionId] ON [dbo].[MissionCosts] ([MissionExecutionId]) WHERE [IsDeleted] = 0;
GO

CREATE INDEX [IX_Branches_CreatedByUserId] ON [dbo].[Branches] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Branches_UpdatedByUserId] ON [dbo].[Branches] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Branches_DeletedByUserId] ON [dbo].[Branches] ([DeletedByUserId]);
GO

CREATE INDEX [IX_OrganizationUnits_BranchId] ON [dbo].[OrganizationUnits] ([BranchId]);
GO

CREATE INDEX [IX_OrganizationUnits_ParentOrganizationUnitId] ON [dbo].[OrganizationUnits] ([ParentOrganizationUnitId]);
GO

CREATE INDEX [IX_OrganizationUnits_ManagerUserId] ON [dbo].[OrganizationUnits] ([ManagerUserId]);
GO

CREATE INDEX [IX_OrganizationUnits_CreatedByUserId] ON [dbo].[OrganizationUnits] ([CreatedByUserId]);
GO

CREATE INDEX [IX_OrganizationUnits_UpdatedByUserId] ON [dbo].[OrganizationUnits] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_OrganizationUnits_DeletedByUserId] ON [dbo].[OrganizationUnits] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Users_BranchId] ON [dbo].[Users] ([BranchId]);
GO

CREATE INDEX [IX_Users_OrganizationUnitId] ON [dbo].[Users] ([OrganizationUnitId]);
GO

CREATE INDEX [IX_Users_CreatedByUserId] ON [dbo].[Users] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Users_UpdatedByUserId] ON [dbo].[Users] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Users_DeletedByUserId] ON [dbo].[Users] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Roles_CreatedByUserId] ON [dbo].[Roles] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Roles_UpdatedByUserId] ON [dbo].[Roles] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_UserRoles_UserId] ON [dbo].[UserRoles] ([UserId]);
GO

CREATE INDEX [IX_UserRoles_RoleId] ON [dbo].[UserRoles] ([RoleId]);
GO

CREATE INDEX [IX_UserRoles_CreatedByUserId] ON [dbo].[UserRoles] ([CreatedByUserId]);
GO

CREATE INDEX [IX_UserRoles_UpdatedByUserId] ON [dbo].[UserRoles] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_RefreshTokens_UserId] ON [dbo].[RefreshTokens] ([UserId]);
GO

CREATE INDEX [IX_RefreshTokens_CreatedByUserId] ON [dbo].[RefreshTokens] ([CreatedByUserId]);
GO

CREATE INDEX [IX_RefreshTokens_UpdatedByUserId] ON [dbo].[RefreshTokens] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_RefreshTokens_DeletedByUserId] ON [dbo].[RefreshTokens] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Provinces_CreatedByUserId] ON [dbo].[Provinces] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Provinces_UpdatedByUserId] ON [dbo].[Provinces] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Provinces_DeletedByUserId] ON [dbo].[Provinces] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Cities_ProvinceId] ON [dbo].[Cities] ([ProvinceId]);
GO

CREATE INDEX [IX_Cities_CreatedByUserId] ON [dbo].[Cities] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Cities_UpdatedByUserId] ON [dbo].[Cities] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Cities_DeletedByUserId] ON [dbo].[Cities] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Drivers_BranchId] ON [dbo].[Drivers] ([BranchId]);
GO

CREATE INDEX [IX_Drivers_CreatedByUserId] ON [dbo].[Drivers] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Drivers_UpdatedByUserId] ON [dbo].[Drivers] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Drivers_DeletedByUserId] ON [dbo].[Drivers] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Vehicles_OwningBranchId] ON [dbo].[Vehicles] ([OwningBranchId]);
GO

CREATE INDEX [IX_Vehicles_CreatedByUserId] ON [dbo].[Vehicles] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Vehicles_UpdatedByUserId] ON [dbo].[Vehicles] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Vehicles_DeletedByUserId] ON [dbo].[Vehicles] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Contracts_DriverId] ON [dbo].[Contracts] ([DriverId]);
GO

CREATE INDEX [IX_Contracts_VehicleId] ON [dbo].[Contracts] ([VehicleId]);
GO

CREATE INDEX [IX_Contracts_CreatedByUserId] ON [dbo].[Contracts] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Contracts_UpdatedByUserId] ON [dbo].[Contracts] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Contracts_DeletedByUserId] ON [dbo].[Contracts] ([DeletedByUserId]);
GO

CREATE INDEX [IX_CalculationPolicies_BranchId] ON [dbo].[CalculationPolicies] ([BranchId]);
GO

CREATE INDEX [IX_CalculationPolicies_CreatedByUserId] ON [dbo].[CalculationPolicies] ([CreatedByUserId]);
GO

CREATE INDEX [IX_CalculationPolicies_UpdatedByUserId] ON [dbo].[CalculationPolicies] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_CalculationPolicies_DeletedByUserId] ON [dbo].[CalculationPolicies] ([DeletedByUserId]);
GO

CREATE INDEX [IX_Missions_RequesterUserId] ON [dbo].[Missions] ([RequesterUserId]);
GO

CREATE INDEX [IX_Missions_BranchId] ON [dbo].[Missions] ([BranchId]);
GO

CREATE INDEX [IX_Missions_OriginProvinceId] ON [dbo].[Missions] ([OriginProvinceId]);
GO

CREATE INDEX [IX_Missions_OriginCityId] ON [dbo].[Missions] ([OriginCityId]);
GO

CREATE INDEX [IX_Missions_DestinationProvinceId] ON [dbo].[Missions] ([DestinationProvinceId]);
GO

CREATE INDEX [IX_Missions_DestinationCityId] ON [dbo].[Missions] ([DestinationCityId]);
GO

CREATE INDEX [IX_Missions_FinalApprovedByUserId] ON [dbo].[Missions] ([FinalApprovedByUserId]);
GO

CREATE INDEX [IX_Missions_CalculationPolicyId] ON [dbo].[Missions] ([CalculationPolicyId]);
GO

CREATE INDEX [IX_Missions_CreatedByUserId] ON [dbo].[Missions] ([CreatedByUserId]);
GO

CREATE INDEX [IX_Missions_UpdatedByUserId] ON [dbo].[Missions] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_Missions_DeletedByUserId] ON [dbo].[Missions] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionPassengers_MissionId] ON [dbo].[MissionPassengers] ([MissionId]);
GO

CREATE INDEX [IX_MissionPassengers_PassengerUserId] ON [dbo].[MissionPassengers] ([PassengerUserId]);
GO

CREATE INDEX [IX_MissionPassengers_CreatedByUserId] ON [dbo].[MissionPassengers] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionPassengers_UpdatedByUserId] ON [dbo].[MissionPassengers] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionPassengers_DeletedByUserId] ON [dbo].[MissionPassengers] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionApprovals_MissionId] ON [dbo].[MissionApprovals] ([MissionId]);
GO

CREATE INDEX [IX_MissionApprovals_ApproverUserId] ON [dbo].[MissionApprovals] ([ApproverUserId]);
GO

CREATE INDEX [IX_MissionApprovals_CreatedByUserId] ON [dbo].[MissionApprovals] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionApprovals_UpdatedByUserId] ON [dbo].[MissionApprovals] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionApprovals_DeletedByUserId] ON [dbo].[MissionApprovals] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionStatusHistory_MissionId] ON [dbo].[MissionStatusHistory] ([MissionId]);
GO

CREATE INDEX [IX_MissionStatusHistory_ChangedByUserId] ON [dbo].[MissionStatusHistory] ([ChangedByUserId]);
GO

CREATE INDEX [IX_MissionStatusHistory_CreatedByUserId] ON [dbo].[MissionStatusHistory] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionStatusHistory_UpdatedByUserId] ON [dbo].[MissionStatusHistory] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionAssignments_MissionId] ON [dbo].[MissionAssignments] ([MissionId]);
GO

CREATE INDEX [IX_MissionAssignments_DriverId] ON [dbo].[MissionAssignments] ([DriverId]);
GO

CREATE INDEX [IX_MissionAssignments_VehicleId] ON [dbo].[MissionAssignments] ([VehicleId]);
GO

CREATE INDEX [IX_MissionAssignments_ContractId] ON [dbo].[MissionAssignments] ([ContractId]);
GO

CREATE INDEX [IX_MissionAssignments_AssignedByUserId] ON [dbo].[MissionAssignments] ([AssignedByUserId]);
GO

CREATE INDEX [IX_MissionAssignments_ConfirmedByUserId] ON [dbo].[MissionAssignments] ([ConfirmedByUserId]);
GO

CREATE INDEX [IX_MissionAssignments_CreatedByUserId] ON [dbo].[MissionAssignments] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionAssignments_UpdatedByUserId] ON [dbo].[MissionAssignments] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionAssignments_DeletedByUserId] ON [dbo].[MissionAssignments] ([DeletedByUserId]);
GO

CREATE INDEX [IX_DriverAttendance_DriverId] ON [dbo].[DriverAttendance] ([DriverId]);
GO

CREATE INDEX [IX_DriverAttendance_VehicleId] ON [dbo].[DriverAttendance] ([VehicleId]);
GO

CREATE INDEX [IX_DriverAttendance_CreatedByUserId] ON [dbo].[DriverAttendance] ([CreatedByUserId]);
GO

CREATE INDEX [IX_DriverAttendance_UpdatedByUserId] ON [dbo].[DriverAttendance] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_DriverAttendance_DeletedByUserId] ON [dbo].[DriverAttendance] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionExecutions_MissionId] ON [dbo].[MissionExecutions] ([MissionId]);
GO

CREATE INDEX [IX_MissionExecutions_MissionAssignmentId] ON [dbo].[MissionExecutions] ([MissionAssignmentId]);
GO

CREATE INDEX [IX_MissionExecutions_CreatedByUserId] ON [dbo].[MissionExecutions] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionExecutions_UpdatedByUserId] ON [dbo].[MissionExecutions] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionExecutions_DeletedByUserId] ON [dbo].[MissionExecutions] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionExecutionStops_MissionExecutionId] ON [dbo].[MissionExecutionStops] ([MissionExecutionId]);
GO

CREATE INDEX [IX_MissionExecutionStops_CreatedByUserId] ON [dbo].[MissionExecutionStops] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionExecutionStops_UpdatedByUserId] ON [dbo].[MissionExecutionStops] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionExecutionStops_DeletedByUserId] ON [dbo].[MissionExecutionStops] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MissionCosts_MissionExecutionId] ON [dbo].[MissionCosts] ([MissionExecutionId]);
GO

CREATE INDEX [IX_MissionCosts_ContractId] ON [dbo].[MissionCosts] ([ContractId]);
GO

CREATE INDEX [IX_MissionCosts_CalculationPolicyId] ON [dbo].[MissionCosts] ([CalculationPolicyId]);
GO

CREATE INDEX [IX_MissionCosts_CreatedByUserId] ON [dbo].[MissionCosts] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MissionCosts_UpdatedByUserId] ON [dbo].[MissionCosts] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MissionCosts_DeletedByUserId] ON [dbo].[MissionCosts] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlements_DriverId] ON [dbo].[MonthlySettlements] ([DriverId]);
GO

CREATE INDEX [IX_MonthlySettlements_BranchId] ON [dbo].[MonthlySettlements] ([BranchId]);
GO

CREATE INDEX [IX_MonthlySettlements_ApprovedByUserId] ON [dbo].[MonthlySettlements] ([ApprovedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlements_CreatedByUserId] ON [dbo].[MonthlySettlements] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlements_UpdatedByUserId] ON [dbo].[MonthlySettlements] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlements_DeletedByUserId] ON [dbo].[MonthlySettlements] ([DeletedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_MonthlySettlementId] ON [dbo].[MonthlySettlementItems] ([MonthlySettlementId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_ReferenceAttendanceId] ON [dbo].[MonthlySettlementItems] ([ReferenceAttendanceId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_ReferenceMissionCostId] ON [dbo].[MonthlySettlementItems] ([ReferenceMissionCostId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_CreatedByUserId] ON [dbo].[MonthlySettlementItems] ([CreatedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_UpdatedByUserId] ON [dbo].[MonthlySettlementItems] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_MonthlySettlementItems_DeletedByUserId] ON [dbo].[MonthlySettlementItems] ([DeletedByUserId]);
GO

CREATE INDEX [IX_AuditLogs_PerformedByUserId] ON [dbo].[AuditLogs] ([PerformedByUserId]);
GO

CREATE INDEX [IX_AuditLogs_CreatedByUserId] ON [dbo].[AuditLogs] ([CreatedByUserId]);
GO

CREATE INDEX [IX_AuditLogs_UpdatedByUserId] ON [dbo].[AuditLogs] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_ChargoonWorkflowMappings_MissionId] ON [dbo].[ChargoonWorkflowMappings] ([MissionId]);
GO

CREATE INDEX [IX_ChargoonWorkflowMappings_MissionApprovalId] ON [dbo].[ChargoonWorkflowMappings] ([MissionApprovalId]);
GO

CREATE INDEX [IX_ChargoonWorkflowMappings_CreatedByUserId] ON [dbo].[ChargoonWorkflowMappings] ([CreatedByUserId]);
GO

CREATE INDEX [IX_ChargoonWorkflowMappings_UpdatedByUserId] ON [dbo].[ChargoonWorkflowMappings] ([UpdatedByUserId]);
GO

CREATE INDEX [IX_ChargoonWorkflowMappings_DeletedByUserId] ON [dbo].[ChargoonWorkflowMappings] ([DeletedByUserId]);
GO
