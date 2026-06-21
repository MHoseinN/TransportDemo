using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class Topic : AuditableEntity
{
    public Guid DepartmentId { get; set; }
    public Department? Department { get; set; }
    public string Title { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<SubTopic> SubTopics { get; set; } = [];
}
