using TransportMissionSystem.Domain.Common;

namespace TransportMissionSystem.Domain.Identity;

public sealed class RefreshToken : SoftDeletableAuditableEntity
{
    public Guid UserId { get; set; }
    public string Token { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
    public DateTime? RevokedAt { get; set; }
    public string? ReasonRevoked { get; set; }

    public User User { get; set; } = null!;

    public bool IsActive => RevokedAt is null && ExpiresAt > DateTime.UtcNow && !IsDeleted;
}
