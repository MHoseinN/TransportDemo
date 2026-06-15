using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class WorkflowDefinition : AuditableEntity
{
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string EntityType { get; set; } = string.Empty;
    public int Version { get; set; }
    public bool IsActive { get; set; } = true;
    public ICollection<WorkflowStep> Steps { get; set; } = [];
}
