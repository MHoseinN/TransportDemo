using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeCategoryMapping : BaseEntity
{
    public Guid KnowledgeVersionId { get; set; }
    public KnowledgeVersion? KnowledgeVersion { get; set; }
    public Guid DeputyId { get; set; }
    public Deputy? Deputy { get; set; }
    public Guid DepartmentId { get; set; }
    public Department? Department { get; set; }
    public Guid TopicId { get; set; }
    public Topic? Topic { get; set; }
    public Guid? SubTopicId { get; set; }
    public SubTopic? SubTopic { get; set; }
}
