using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeTag : BaseEntity
{
    public Guid KnowledgeVersionId { get; set; }
    public KnowledgeVersion? KnowledgeVersion { get; set; }
    public string TagText { get; set; } = string.Empty;
}
