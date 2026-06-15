using TransportMissionSystem.Domain.Common;

namespace TransportMissionSystem.Domain.Identity;

public sealed class User : SoftDeletableAuditableEntity
{
    public Guid? BranchId { get; set; }
    public Guid? OrganizationUnitId { get; set; }
    public string? PersonnelCode { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? NationalCode { get; set; }
    public string? Mobile { get; set; }
    public string? Email { get; set; }
    public string Username { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string Status { get; set; } = UserStatus.Active;
    public DateTime? LastLoginAt { get; set; }

    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();

    public bool IsActive => Status.Equals(UserStatus.Active, StringComparison.OrdinalIgnoreCase) && !IsDeleted;
}
