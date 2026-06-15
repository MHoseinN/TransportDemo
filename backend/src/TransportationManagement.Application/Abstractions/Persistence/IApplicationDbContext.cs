using Microsoft.EntityFrameworkCore;
using TransportationManagement.Domain.Entities;

namespace TransportationManagement.Application.Abstractions.Persistence;

public interface IApplicationDbContext
{
    DbSet<Province> Provinces { get; }
    DbSet<City> Cities { get; }
    DbSet<Branch> Branches { get; }
    DbSet<Vehicle> Vehicles { get; }
    DbSet<Driver> Drivers { get; }
    DbSet<Contract> Contracts { get; }
    DbSet<ContractCalculationRule> ContractCalculationRules { get; }
    DbSet<MissionRequest> MissionRequests { get; }
    DbSet<MissionCompanion> MissionCompanions { get; }
    DbSet<MissionAssignment> MissionAssignments { get; }
    DbSet<MissionExecution> MissionExecutions { get; }
    DbSet<DriverAttendance> DriverAttendances { get; }
    DbSet<WorkflowDefinition> WorkflowDefinitions { get; }
    DbSet<WorkflowStep> WorkflowSteps { get; }
    DbSet<WorkflowInstance> WorkflowInstances { get; }
    DbSet<WorkflowAction> WorkflowActions { get; }
    DbSet<MissionCalculationResult> MissionCalculationResults { get; }
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
