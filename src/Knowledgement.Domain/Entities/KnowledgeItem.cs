using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeItem : AuditableEntity
{
    public string Title { get; set; } = string.Empty;
    public DocumentType DocumentType { get; set; }
    public Guid? CurrentVersionId { get; set; }
    public KnowledgeVersion? CurrentVersion { get; set; }
    public Guid CreatedByUserId { get; set; }
    public User? CreatedByUser { get; set; }
    public bool IsArchived { get; set; }
    public ICollection<KnowledgeVersion> Versions { get; set; } = [];
}
