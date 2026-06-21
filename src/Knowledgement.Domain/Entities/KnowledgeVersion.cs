using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class KnowledgeVersion : AuditableEntity
{
    public Guid KnowledgeItemId { get; set; }
    public KnowledgeItem? KnowledgeItem { get; set; }
    public int VersionNumber { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Summary { get; set; }
    public string BodyHtml { get; set; } = string.Empty;
    public string? ChangeSummary { get; set; }
    public DateOnly IssueDate { get; set; }
    public DateTime? PublishDate { get; set; }
    public DateOnly? ValidUntil { get; set; }
    public KnowledgeStatus Status { get; set; }
    public bool IsCurrent { get; set; }
    public Guid CreatedByUserId { get; set; }
    public User? CreatedByUser { get; set; }
    public Guid? ApprovedByUserId { get; set; }
    public User? ApprovedByUser { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public ICollection<KnowledgeAttachment> Attachments { get; set; } = [];
    public ICollection<KnowledgeCategoryMapping> CategoryMappings { get; set; } = [];
    public ICollection<KnowledgeTag> Tags { get; set; } = [];
}
