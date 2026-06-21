using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeAttachment : BaseEntity
{
    public Guid KnowledgeVersionId { get; set; }
    public KnowledgeVersion? KnowledgeVersion { get; set; }
    public string FileName { get; set; } = string.Empty;
    public string FilePath { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public Guid UploadedByUserId { get; set; }
    public User? UploadedByUser { get; set; }
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
}
