using Knowledgement.Domain.Common;

namespace Knowledgement.Domain.Entities;

public sealed class DailyMessageAttachment : BaseEntity
{
    public Guid DailyMessageId { get; set; }
    public DailyMessage? DailyMessage { get; set; }
    public string FileName { get; set; } = string.Empty;
    public string FilePath { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
}
