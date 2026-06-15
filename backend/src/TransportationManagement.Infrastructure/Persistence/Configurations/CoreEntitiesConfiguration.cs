using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Entities;

namespace TransportationManagement.Infrastructure.Persistence.Configurations;

public class ProvinceConfiguration : BaseEntityConfiguration<Province>
{
    public override void Configure(EntityTypeBuilder<Province> builder)
    {
        base.Configure(builder);
        builder.ToTable("Provinces");
        builder.Property(x => x.Name).HasMaxLength(200).IsRequired();
        builder.Property(x => x.Code).HasMaxLength(50).IsRequired();
        builder.HasIndex(x => x.Code).IsUnique();
        builder.HasMany(x => x.Cities).WithOne(x => x.Province).HasForeignKey(x => x.ProvinceId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class CityConfiguration : BaseEntityConfiguration<City>
{
    public override void Configure(EntityTypeBuilder<City> builder)
    {
        base.Configure(builder);
        builder.ToTable("Cities");
        builder.Property(x => x.Name).HasMaxLength(200).IsRequired();
        builder.Property(x => x.Code).HasMaxLength(50).IsRequired();
        builder.HasIndex(x => new { x.ProvinceId, x.Code }).IsUnique();
    }
}

public class BranchConfiguration : BaseEntityConfiguration<Branch>
{
    public override void Configure(EntityTypeBuilder<Branch> builder)
    {
        base.Configure(builder);
        builder.ToTable("Branches");
        builder.Property(x => x.Name).HasMaxLength(200).IsRequired();
        builder.Property(x => x.Code).HasMaxLength(50).IsRequired();
        builder.HasIndex(x => x.Code).IsUnique();
        builder.HasOne(x => x.Parent).WithMany(x => x.Children).HasForeignKey(x => x.ParentId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.City).WithMany().HasForeignKey(x => x.CityId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class VehicleConfiguration : BaseEntityConfiguration<Vehicle>
{
    public override void Configure(EntityTypeBuilder<Vehicle> builder)
    {
        base.Configure(builder);
        builder.ToTable("Vehicles");
        builder.Property(x => x.PlateNumber).HasMaxLength(50).IsRequired();
        builder.Property(x => x.ChassisNumber).HasMaxLength(100).IsRequired();
        builder.Property(x => x.VehicleType).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Color).HasMaxLength(50);
        builder.Property(x => x.OwnershipType).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.Description).HasMaxLength(1000);
        builder.HasIndex(x => x.PlateNumber).IsUnique();
        builder.HasIndex(x => x.ChassisNumber).IsUnique();
        builder.HasOne(x => x.Branch).WithMany().HasForeignKey(x => x.BranchId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class DriverConfiguration : BaseEntityConfiguration<Driver>
{
    public override void Configure(EntityTypeBuilder<Driver> builder)
    {
        base.Configure(builder);
        builder.ToTable("Drivers");
        builder.Property(x => x.FirstName).HasMaxLength(100).IsRequired();
        builder.Property(x => x.LastName).HasMaxLength(100).IsRequired();
        builder.Property(x => x.FatherName).HasMaxLength(100);
        builder.Property(x => x.NationalCode).HasMaxLength(20).IsRequired();
        builder.Property(x => x.IdentityNumber).HasMaxLength(50);
        builder.Property(x => x.BirthPlace).HasMaxLength(100);
        builder.Property(x => x.MobileNumber).HasMaxLength(30);
        builder.Property(x => x.DrivingLicenseNumber).HasMaxLength(100).IsRequired();
        builder.HasIndex(x => x.NationalCode).IsUnique();
        builder.HasIndex(x => x.DrivingLicenseNumber).IsUnique();
        builder.HasOne(x => x.Branch).WithMany().HasForeignKey(x => x.BranchId).OnDelete(DeleteBehavior.Restrict);
        builder.HasMany(x => x.Attendances).WithOne(x => x.Driver).HasForeignKey(x => x.DriverId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class ContractConfiguration : BaseEntityConfiguration<Contract>
{
    public override void Configure(EntityTypeBuilder<Contract> builder)
    {
        base.Configure(builder);
        builder.ToTable("Contracts");
        builder.Property(x => x.ContractNumber).HasMaxLength(100).IsRequired();
        builder.Property(x => x.HourlyRate).HasPrecision(18, 2);
        builder.Property(x => x.GoKmRate).HasPrecision(18, 2);
        builder.Property(x => x.ReturnKmRate).HasPrecision(18, 2);
        builder.Property(x => x.SleepHourRate).HasPrecision(18, 2);
        builder.HasIndex(x => x.ContractNumber).IsUnique();
        builder.HasOne(x => x.Driver).WithMany().HasForeignKey(x => x.DriverId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.Vehicle).WithMany().HasForeignKey(x => x.VehicleId).OnDelete(DeleteBehavior.Restrict);
        builder.HasMany(x => x.CalculationRules).WithOne(x => x.Contract).HasForeignKey(x => x.ContractId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class ContractCalculationRuleConfiguration : BaseEntityConfiguration<ContractCalculationRule>
{
    public override void Configure(EntityTypeBuilder<ContractCalculationRule> builder)
    {
        base.Configure(builder);
        builder.ToTable("ContractCalculationRules");
        builder.Property(x => x.RuleCode).HasMaxLength(100).IsRequired();
        builder.Property(x => x.StrategyCode).HasMaxLength(100).IsRequired();
        builder.HasIndex(x => new { x.ContractId, x.RuleCode }).IsUnique();
    }
}

public class MissionRequestConfiguration : BaseEntityConfiguration<MissionRequest>
{
    public override void Configure(EntityTypeBuilder<MissionRequest> builder)
    {
        base.Configure(builder);
        builder.ToTable("MissionRequests");
        builder.Property(x => x.RequestNumber).HasMaxLength(100).IsRequired();
        builder.Property(x => x.RequesterUserId).HasMaxLength(100).IsRequired();
        builder.Property(x => x.RequesterDisplayName).HasMaxLength(200).IsRequired();
        builder.Property(x => x.MissionType).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.TransportType).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.MissionArea).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.OriginAddress).HasMaxLength(1000);
        builder.Property(x => x.DestinationAddress).HasMaxLength(1000);
        builder.Property(x => x.Reason).HasMaxLength(1000).IsRequired();
        builder.Property(x => x.Description).HasMaxLength(1000);
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(50);
        builder.HasIndex(x => x.RequestNumber).IsUnique();
        builder.HasOne(x => x.RequesterBranch).WithMany().HasForeignKey(x => x.RequesterBranchId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.OriginProvince).WithMany().HasForeignKey(x => x.OriginProvinceId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.OriginCity).WithMany().HasForeignKey(x => x.OriginCityId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.DestinationProvince).WithMany().HasForeignKey(x => x.DestinationProvinceId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.DestinationCity).WithMany().HasForeignKey(x => x.DestinationCityId).OnDelete(DeleteBehavior.Restrict);
        builder.HasMany(x => x.Companions).WithOne(x => x.MissionRequest).HasForeignKey(x => x.MissionRequestId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class MissionCompanionConfiguration : BaseEntityConfiguration<MissionCompanion>
{
    public override void Configure(EntityTypeBuilder<MissionCompanion> builder)
    {
        base.Configure(builder);
        builder.ToTable("MissionCompanions");
        builder.Property(x => x.PersonName).HasMaxLength(200).IsRequired();
        builder.Property(x => x.NationalCode).HasMaxLength(20);
        builder.Property(x => x.EmployeeUserId).HasMaxLength(100);
    }
}

public class MissionAssignmentConfiguration : BaseEntityConfiguration<MissionAssignment>
{
    public override void Configure(EntityTypeBuilder<MissionAssignment> builder)
    {
        base.Configure(builder);
        builder.ToTable("MissionAssignments");
        builder.Property(x => x.AssignedBy).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.OverrideReason).HasMaxLength(1000);
        builder.HasIndex(x => x.MissionRequestId).IsUnique();
        builder.HasOne(x => x.MissionRequest).WithMany().HasForeignKey(x => x.MissionRequestId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.Driver).WithMany().HasForeignKey(x => x.DriverId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.Vehicle).WithMany().HasForeignKey(x => x.VehicleId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class MissionExecutionConfiguration : BaseEntityConfiguration<MissionExecution>
{
    public override void Configure(EntityTypeBuilder<MissionExecution> builder)
    {
        base.Configure(builder);
        builder.ToTable("MissionExecutions");
        builder.Property(x => x.DrivingHours).HasPrecision(10, 2);
        builder.Property(x => x.SleepHours).HasPrecision(10, 2);
        builder.Property(x => x.StopCost).HasPrecision(18, 2);
        builder.Property(x => x.PenaltyAmount).HasPrecision(18, 2);
        builder.Property(x => x.ExtraPayment).HasPrecision(18, 2);
        builder.Property(x => x.Description).HasMaxLength(1000);
        builder.HasIndex(x => x.MissionRequestId).IsUnique();
        builder.HasOne(x => x.MissionRequest).WithMany().HasForeignKey(x => x.MissionRequestId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class DriverAttendanceConfiguration : BaseEntityConfiguration<DriverAttendance>
{
    public override void Configure(EntityTypeBuilder<DriverAttendance> builder)
    {
        base.Configure(builder);
        builder.ToTable("DriverAttendances");
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.Notes).HasMaxLength(1000);
    }
}

public class WorkflowDefinitionConfiguration : BaseEntityConfiguration<WorkflowDefinition>
{
    public override void Configure(EntityTypeBuilder<WorkflowDefinition> builder)
    {
        base.Configure(builder);
        builder.ToTable("WorkflowDefinitions");
        builder.Property(x => x.Code).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Name).HasMaxLength(200).IsRequired();
        builder.Property(x => x.EntityType).HasMaxLength(100).IsRequired();
        builder.HasIndex(x => x.Code).IsUnique();
        builder.HasMany(x => x.Steps).WithOne(x => x.WorkflowDefinition).HasForeignKey(x => x.WorkflowDefinitionId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class WorkflowStepConfiguration : BaseEntityConfiguration<WorkflowStep>
{
    public override void Configure(EntityTypeBuilder<WorkflowStep> builder)
    {
        base.Configure(builder);
        builder.ToTable("WorkflowSteps");
        builder.Property(x => x.Name).HasMaxLength(200).IsRequired();
        builder.Property(x => x.ApproverType).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.ApproverValue).HasMaxLength(200).IsRequired();
        builder.HasIndex(x => new { x.WorkflowDefinitionId, x.StepOrder }).IsUnique();
        builder.HasOne(x => x.OnApproveNextStep).WithMany().HasForeignKey(x => x.OnApproveNextStepId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.OnReturnStep).WithMany().HasForeignKey(x => x.OnReturnStepId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class WorkflowInstanceConfiguration : BaseEntityConfiguration<WorkflowInstance>
{
    public override void Configure(EntityTypeBuilder<WorkflowInstance> builder)
    {
        base.Configure(builder);
        builder.ToTable("WorkflowInstances");
        builder.Property(x => x.EntityType).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(50);
        builder.HasIndex(x => new { x.EntityType, x.EntityId });
        builder.HasOne(x => x.WorkflowDefinition).WithMany().HasForeignKey(x => x.WorkflowDefinitionId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.CurrentStep).WithMany().HasForeignKey(x => x.CurrentStepId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class WorkflowActionConfiguration : BaseEntityConfiguration<WorkflowAction>
{
    public override void Configure(EntityTypeBuilder<WorkflowAction> builder)
    {
        base.Configure(builder);
        builder.ToTable("WorkflowActions");
        builder.Property(x => x.ActionType).HasConversion<string>().HasMaxLength(50);
        builder.Property(x => x.ActorUserId).HasMaxLength(100).IsRequired();
        builder.Property(x => x.ActorRole).HasMaxLength(100);
        builder.Property(x => x.Comment).HasMaxLength(1000);
        builder.HasOne(x => x.WorkflowInstance).WithMany().HasForeignKey(x => x.WorkflowInstanceId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(x => x.WorkflowStep).WithMany().HasForeignKey(x => x.WorkflowStepId).OnDelete(DeleteBehavior.Restrict);
    }
}

public class MissionCalculationResultConfiguration : BaseEntityConfiguration<MissionCalculationResult>
{
    public override void Configure(EntityTypeBuilder<MissionCalculationResult> builder)
    {
        base.Configure(builder);
        builder.ToTable("MissionCalculationResults");
        builder.Property(x => x.BaseAmount).HasPrecision(18, 2);
        builder.Property(x => x.KmAmount).HasPrecision(18, 2);
        builder.Property(x => x.HourAmount).HasPrecision(18, 2);
        builder.Property(x => x.SleepAmount).HasPrecision(18, 2);
        builder.Property(x => x.StopCostAmount).HasPrecision(18, 2);
        builder.Property(x => x.PenaltyAmount).HasPrecision(18, 2);
        builder.Property(x => x.ExtraAmount).HasPrecision(18, 2);
        builder.Property(x => x.TotalAmount).HasPrecision(18, 2);
        builder.Property(x => x.StrategyCode).HasMaxLength(100).IsRequired();
        builder.HasOne(x => x.MissionExecution).WithMany().HasForeignKey(x => x.MissionExecutionId).OnDelete(DeleteBehavior.Restrict);
    }
}

public abstract class BaseEntityConfiguration<TEntity> : IEntityTypeConfiguration<TEntity>
    where TEntity : AuditableEntity
{
    public virtual void Configure(EntityTypeBuilder<TEntity> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.RowVersion).IsRowVersion();
    }
}
