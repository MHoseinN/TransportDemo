using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class WorkflowAction : AuditableEntity
{
    public Guid WorkflowInstanceId { get; set; }
    public WorkflowInstance? WorkflowInstance { get; set; }
    public Guid WorkflowStepId { get; set; }
    public WorkflowStep? WorkflowStep { get; set; }
    public WorkflowActionType ActionType { get; set; }
    public string ActorUserId { get; set; } = string.Empty;
    public string? ActorRole { get; set; }
    public string? Comment { get; set; }
    public DateTime ActionAt { get; set; }
}
