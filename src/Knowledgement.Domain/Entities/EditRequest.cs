using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class EditRequest : AuditableEntity
{
    public Guid KnowledgeVersionId { get; set; }
    public KnowledgeVersion? KnowledgeVersion { get; set; }
    public Guid RequestedByUserId { get; set; }
    public User? RequestedByUser { get; set; }
    public string? ProposedTitle { get; set; }
    public string? ProposedSummary { get; set; }
    public string? ProposedBodyHtml { get; set; }
    public DateOnly? ProposedIssueDate { get; set; }
    public DateOnly? ProposedValidUntil { get; set; }
    public EditRequestStatus Status { get; set; }
    public string? RejectionReason { get; set; }
    public Guid? ReviewedByUserId { get; set; }
    public User? ReviewedByUser { get; set; }
    public DateTime? ReviewedAt { get; set; }
}
