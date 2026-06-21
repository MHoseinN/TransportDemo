using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class ApprovalLog : BaseEntity
{
    public ApprovalEntityType EntityType { get; set; }
    public Guid EntityId { get; set; }
    public ApprovalAction Action { get; set; }
    public Guid ActorUserId { get; set; }
    public User? ActorUser { get; set; }
    public string? Reason { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
