using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class Department : AuditableEntity
{
    public Guid DeputyId { get; set; }
    public Deputy? Deputy { get; set; }
    public string Title { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<Topic> Topics { get; set; } = [];
}
