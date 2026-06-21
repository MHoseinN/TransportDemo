using Knowledgement.Domain.Common;
using Knowledgement.Domain.Enums;

namespace Knowledgement.Domain.Entities;

public sealed class DailyMessage : AuditableEntity
{
    public string Title { get; set; } = string.Empty;
    public string BodyHtml { get; set; } = string.Empty;
    public Guid CreatedByUserId { get; set; }
    public User? CreatedByUser { get; set; }
    public DateTime SentAt { get; set; } = DateTime.UtcNow;
    public DailyMessageStatus Status { get; set; } = DailyMessageStatus.Published;
    public ICollection<DailyMessageAttachment> Attachments { get; set; } = [];
}
