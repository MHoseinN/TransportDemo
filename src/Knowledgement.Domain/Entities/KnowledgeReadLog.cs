using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeReadLog : BaseEntity
{
    public Guid UserId { get; set; }
    public User? User { get; set; }
    public Guid KnowledgeItemId { get; set; }
    public KnowledgeItem? KnowledgeItem { get; set; }
    public Guid KnowledgeVersionId { get; set; }
    public KnowledgeVersion? KnowledgeVersion { get; set; }
    public DateTime ReadAt { get; set; } = DateTime.UtcNow;
    public ReadSource Source { get; set; } = ReadSource.Web;
}
