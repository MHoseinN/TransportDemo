using TransportMissionSystem.Domain.Common;

namespace TransportMissionSystem.Domain.Identity;

public sealed class UserRole : AuditableEntity
{
    public Guid UserId { get; set; }
    public Guid RoleId { get; set; }
    public DateOnly? StartDate { get; set; }
    public DateOnly? EndDate { get; set; }

    public User User { get; set; } = null!;
    public Role Role { get; set; } = null!;
}
