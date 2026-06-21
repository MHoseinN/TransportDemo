using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class SubTopic : AuditableEntity
{
    public Guid TopicId { get; set; }
    public Topic? Topic { get; set; }
    public string Title { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
}
