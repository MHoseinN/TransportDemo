using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class AuditLog : BaseEntity
{
    public Guid? ActorUserId { get; set; }
    public string Action { get; set; } = string.Empty;
    public string EntityType { get; set; } = string.Empty;
    public Guid? EntityId { get; set; }
    public string? BeforeJson { get; set; }
    public string? AfterJson { get; set; }
    public string? CorrelationId { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
