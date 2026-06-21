using Knowledgement.Domain.Entities;

namespace Knowledgement.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    IQueryable<User> Users { get; }
    IQueryable<Deputy> Deputies { get; }
    IQueryable<Department> Departments { get; }
    IQueryable<Topic> Topics { get; }
    IQueryable<SubTopic> SubTopics { get; }
    IQueryable<KnowledgeItem> KnowledgeItems { get; }
    IQueryable<KnowledgeVersion> KnowledgeVersions { get; }
    IQueryable<KnowledgeAttachment> KnowledgeAttachments { get; }
    IQueryable<KnowledgeCategoryMapping> KnowledgeCategoryMappings { get; }
    IQueryable<KnowledgeTag> KnowledgeTags { get; }
    IQueryable<EditRequest> EditRequests { get; }
    IQueryable<ApprovalLog> ApprovalLogs { get; }
    IQueryable<KnowledgeReadLog> KnowledgeReadLogs { get; }
    IQueryable<DailyMessage> DailyMessages { get; }
    IQueryable<DailyMessageAttachment> DailyMessageAttachments { get; }
    IQueryable<AuditLog> AuditLogs { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
