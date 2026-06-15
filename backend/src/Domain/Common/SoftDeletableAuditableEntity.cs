namespace TransportMissionSystem.Domain.Common;

public abstract class SoftDeletableAuditableEntity : AuditableEntity, ISoftDeletable
{
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public Guid? DeletedByUserId { get; set; }
}
