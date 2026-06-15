namespace TransportMissionSystem.Domain.Common;

public abstract class AuditableEntity : Entity, IAuditableEntity
{
    public DateTime CreatedAt { get; set; }
    public Guid? CreatedByUserId { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public Guid? UpdatedByUserId { get; set; }
}
