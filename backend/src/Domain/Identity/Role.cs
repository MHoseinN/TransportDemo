using TransportMissionSystem.Domain.Common;

namespace TransportMissionSystem.Domain.Identity;

public sealed class Role : AuditableEntity
{
    public string Name { get; set; } = string.Empty;
    public string? DisplayName { get; set; }
    public string? Description { get; set; }
    public bool IsSystemRole { get; set; } = true;

    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
