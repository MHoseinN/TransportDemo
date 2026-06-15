using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class WorkflowInstance : AuditableEntity
{
    public Guid WorkflowDefinitionId { get; set; }
    public WorkflowDefinition? WorkflowDefinition { get; set; }
    public string EntityType { get; set; } = string.Empty;
    public Guid EntityId { get; set; }
    public Guid? CurrentStepId { get; set; }
    public WorkflowStep? CurrentStep { get; set; }
    public WorkflowStatus Status { get; set; }
    public DateTime StartedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
}
