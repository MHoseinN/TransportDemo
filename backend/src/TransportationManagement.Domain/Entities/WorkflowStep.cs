using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class WorkflowStep : AuditableEntity
{
    public Guid WorkflowDefinitionId { get; set; }
    public WorkflowDefinition? WorkflowDefinition { get; set; }
    public int StepOrder { get; set; }
    public string Name { get; set; } = string.Empty;
    public ApproverType ApproverType { get; set; }
    public string ApproverValue { get; set; } = string.Empty;
    public Guid? OnApproveNextStepId { get; set; }
    public WorkflowStep? OnApproveNextStep { get; set; }
    public Guid? OnReturnStepId { get; set; }
    public WorkflowStep? OnReturnStep { get; set; }
    public bool IsFinalApproval { get; set; }
}
