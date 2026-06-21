using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class Deputy : AuditableEntity
{
    public string Title { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<Department> Departments { get; set; } = [];
}
