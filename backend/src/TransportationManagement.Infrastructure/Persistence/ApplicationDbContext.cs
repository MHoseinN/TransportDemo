using Microsoft.EntityFrameworkCore;
using TransportationManagement.Application.Abstractions.Persistence;
using TransportationManagement.Domain.Entities;

namespace TransportationManagement.Infrastructure.Persistence;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
    : DbContext(options), IApplicationDbContext
{
    public DbSet<Province> Provinces => Set<Province>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<Branch> Branches => Set<Branch>();
    public DbSet<Vehicle> Vehicles => Set<Vehicle>();
    public DbSet<Driver> Drivers => Set<Driver>();
    public DbSet<Contract> Contracts => Set<Contract>();
    public DbSet<ContractCalculationRule> ContractCalculationRules => Set<ContractCalculationRule>();
    public DbSet<MissionRequest> MissionRequests => Set<MissionRequest>();
    public DbSet<MissionCompanion> MissionCompanions => Set<MissionCompanion>();
    public DbSet<MissionAssignment> MissionAssignments => Set<MissionAssignment>();
    public DbSet<MissionExecution> MissionExecutions => Set<MissionExecution>();
    public DbSet<DriverAttendance> DriverAttendances => Set<DriverAttendance>();
    public DbSet<WorkflowDefinition> WorkflowDefinitions => Set<WorkflowDefinition>();
    public DbSet<WorkflowStep> WorkflowSteps => Set<WorkflowStep>();
    public DbSet<WorkflowInstance> WorkflowInstances => Set<WorkflowInstance>();
    public DbSet<WorkflowAction> WorkflowActions => Set<WorkflowAction>();
    public DbSet<MissionCalculationResult> MissionCalculationResults => Set<MissionCalculationResult>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
        base.OnModelCreating(modelBuilder);
    }
}
