namespace TransportMissionSystem.Domain.Common;

public interface IAuditableEntity
{
    DateTime CreatedAt { get; set; }
    Guid? CreatedByUserId { get; set; }
    DateTime? UpdatedAt { get; set; }
    Guid? UpdatedByUserId { get; set; }
}
