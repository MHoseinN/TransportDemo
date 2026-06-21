using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class User : AuditableEntity
{
    public string FullName { get; set; } = string.Empty;
    public string Username { get; set; } = string.Empty;
    public UserRole Role { get; set; }
    public bool IsActive { get; set; } = true;
}
