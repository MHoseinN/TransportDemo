-- Seed Data — Transport & Mission Management System
-- Minimal bootstrap data. Safe to customize per environment.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Roles
IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Admin')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Admin', N'System administrator', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Employee')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Employee', N'Mission requester', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Manager')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Manager', N'Mission approver', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Dispatcher')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Dispatcher', N'Transport dispatcher', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Driver')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Driver', N'Driver role', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'Finance')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'Finance', N'Finance operator', 1, SYSUTCDATETIME(), 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Name = N'ITOperator')
BEGIN
    INSERT INTO dbo.Roles (Id, Name, Description, IsSystemRole, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'ITOperator', N'IT operator', 1, SYSUTCDATETIME(), 0);
END
GO

-- Default branch placeholder
IF NOT EXISTS (SELECT 1 FROM dbo.Branches WHERE Code = N'HO')
BEGIN
    INSERT INTO dbo.Branches (
        Id, Name, Code, Status, IsActive, CreatedAt, IsDeleted
    )
    VALUES (
        NEWSEQUENTIALID(), N'Head Office', N'HO', N'Active', 1, SYSUTCDATETIME(), 0
    );
END
GO

-- Default organization unit placeholder
IF NOT EXISTS (SELECT 1 FROM dbo.OrganizationUnits WHERE Code = N'ROOT')
BEGIN
    INSERT INTO dbo.OrganizationUnits (
        Id, ParentId, Name, Code, LevelNo, Status, IsActive, CreatedAt, IsDeleted
    )
    VALUES (
        NEWSEQUENTIALID(), NULL, N'Root Unit', N'ROOT', 1, N'Active', 1, SYSUTCDATETIME(), 0
    );
END
GO

-- Calculation policies
IF NOT EXISTS (SELECT 1 FROM dbo.CalculationPolicies WHERE Code = N'URBAN-HOURLY-V1')
BEGIN
    INSERT INTO dbo.CalculationPolicies (
        Id, Code, Name, PolicyType, VersionNo, IsDefault, ParametersJson, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, IsDeleted
    )
    VALUES (
        NEWSEQUENTIALID(),
        N'URBAN-HOURLY-V1',
        N'Urban Hourly Default Policy',
        N'UrbanHourly',
        1,
        1,
        N'{"formula":"Total = AttendanceHours * Contract.HourlyRate"}',
        CAST(GETDATE() AS date),
        NULL,
        1,
        SYSUTCDATETIME(),
        0
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CalculationPolicies WHERE Code = N'OUTBOUND-DISTANCE-SLEEP-V1')
BEGIN
    INSERT INTO dbo.CalculationPolicies (
        Id, Code, Name, PolicyType, VersionNo, IsDefault, ParametersJson, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, IsDeleted
    )
    VALUES (
        NEWSEQUENTIALID(),
        N'OUTBOUND-DISTANCE-SLEEP-V1',
        N'Outbound Distance and Sleep Default Policy',
        N'OutboundByDistanceAndSleep',
        1,
        1,
        N'{"formula":"DrivingHours = TotalKm / 100; SleepHours = TotalMissionHours - DrivingHours; KmCost = TotalKm * Contract.KmRate; SleepCost = SleepHours * Contract.SleepRate; Total = KmCost + SleepCost + StopCost + ExtraPayment - Penalty"}',
        CAST(GETDATE() AS date),
        NULL,
        1,
        SYSUTCDATETIME(),
        0
    );
END
GO

-- Sample geography placeholders only. Replace with real master data later.
IF NOT EXISTS (SELECT 1 FROM dbo.Provinces WHERE Code = N'TODO-P1')
BEGIN
    INSERT INTO dbo.Provinces (Id, Name, Code, SortOrder, IsActive, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), N'TODO Province 1', N'TODO-P1', 1, 1, SYSUTCDATETIME(), 0);
END
GO

DECLARE @ProvinceId uniqueidentifier = (SELECT TOP 1 Id FROM dbo.Provinces WHERE Code = N'TODO-P1');
IF @ProvinceId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Cities WHERE Code = N'TODO-C1')
BEGIN
    INSERT INTO dbo.Cities (Id, ProvinceId, Name, Code, SortOrder, IsActive, CreatedAt, IsDeleted)
    VALUES (NEWSEQUENTIALID(), @ProvinceId, N'TODO City 1', N'TODO-C1', 1, 1, SYSUTCDATETIME(), 0);
END
GO
