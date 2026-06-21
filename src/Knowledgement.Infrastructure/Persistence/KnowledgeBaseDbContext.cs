using Knowledgement.Application.Common.Interfaces;
using Knowledgement.Domain.Entities;
using Knowledgement.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace Knowledgement.Infrastructure.Persistence;

public sealed class KnowledgeBaseDbContext(DbContextOptions<KnowledgeBaseDbContext> options)
    : DbContext(options), IApplicationDbContext
{
    public DbSet<User> UsersSet => Set<User>();
    public DbSet<Deputy> DeputiesSet => Set<Deputy>();
    public DbSet<Department> DepartmentsSet => Set<Department>();
    public DbSet<Topic> TopicsSet => Set<Topic>();
    public DbSet<SubTopic> SubTopicsSet => Set<SubTopic>();
    public DbSet<KnowledgeItem> KnowledgeItemsSet => Set<KnowledgeItem>();
    public DbSet<KnowledgeVersion> KnowledgeVersionsSet => Set<KnowledgeVersion>();
    public DbSet<KnowledgeAttachment> KnowledgeAttachmentsSet => Set<KnowledgeAttachment>();
    public DbSet<KnowledgeCategoryMapping> KnowledgeCategoryMappingsSet => Set<KnowledgeCategoryMapping>();
    public DbSet<KnowledgeTag> KnowledgeTagsSet => Set<KnowledgeTag>();
    public DbSet<EditRequest> EditRequestsSet => Set<EditRequest>();
    public DbSet<ApprovalLog> ApprovalLogsSet => Set<ApprovalLog>();
    public DbSet<KnowledgeReadLog> KnowledgeReadLogsSet => Set<KnowledgeReadLog>();
    public DbSet<DailyMessage> DailyMessagesSet => Set<DailyMessage>();
    public DbSet<DailyMessageAttachment> DailyMessageAttachmentsSet => Set<DailyMessageAttachment>();
    public DbSet<AuditLog> AuditLogsSet => Set<AuditLog>();

    IQueryable<User> IApplicationDbContext.Users => UsersSet;
    IQueryable<Deputy> IApplicationDbContext.Deputies => DeputiesSet;
    IQueryable<Department> IApplicationDbContext.Departments => DepartmentsSet;
    IQueryable<Topic> IApplicationDbContext.Topics => TopicsSet;
    IQueryable<SubTopic> IApplicationDbContext.SubTopics => SubTopicsSet;
    IQueryable<KnowledgeItem> IApplicationDbContext.KnowledgeItems => KnowledgeItemsSet;
    IQueryable<KnowledgeVersion> IApplicationDbContext.KnowledgeVersions => KnowledgeVersionsSet;
    IQueryable<KnowledgeAttachment> IApplicationDbContext.KnowledgeAttachments => KnowledgeAttachmentsSet;
    IQueryable<KnowledgeCategoryMapping> IApplicationDbContext.KnowledgeCategoryMappings => KnowledgeCategoryMappingsSet;
    IQueryable<KnowledgeTag> IApplicationDbContext.KnowledgeTags => KnowledgeTagsSet;
    IQueryable<EditRequest> IApplicationDbContext.EditRequests => EditRequestsSet;
    IQueryable<ApprovalLog> IApplicationDbContext.ApprovalLogs => ApprovalLogsSet;
    IQueryable<KnowledgeReadLog> IApplicationDbContext.KnowledgeReadLogs => KnowledgeReadLogsSet;
    IQueryable<DailyMessage> IApplicationDbContext.DailyMessages => DailyMessagesSet;
    IQueryable<DailyMessageAttachment> IApplicationDbContext.DailyMessageAttachments => DailyMessageAttachmentsSet;
    IQueryable<AuditLog> IApplicationDbContext.AuditLogs => AuditLogsSet;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(KnowledgeBaseDbContext).Assembly);

        modelBuilder.Entity<KnowledgeItem>()
            .HasOne(x => x.CurrentVersion)
            .WithMany()
            .HasForeignKey(x => x.CurrentVersionId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<KnowledgeItem>()
            .HasOne(x => x.CreatedByUser)
            .WithMany()
            .HasForeignKey(x => x.CreatedByUserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<KnowledgeVersion>()
            .HasOne(x => x.KnowledgeItem)
            .WithMany(x => x.Versions)
            .HasForeignKey(x => x.KnowledgeItemId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<KnowledgeVersion>()
            .HasOne(x => x.CreatedByUser)
            .WithMany()
            .HasForeignKey(x => x.CreatedByUserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<KnowledgeVersion>()
            .HasOne(x => x.ApprovedByUser)
            .WithMany()
            .HasForeignKey(x => x.ApprovedByUserId)
            .OnDelete(DeleteBehavior.Restrict);

        ConfigureEnums(modelBuilder);
        ConfigureIndexes(modelBuilder);
        ConfigureLengths(modelBuilder);
    }

    private static void ConfigureEnums(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().Property(x => x.Role).HasConversion<string>();
        modelBuilder.Entity<KnowledgeItem>().Property(x => x.DocumentType).HasConversion<string>();
        modelBuilder.Entity<KnowledgeVersion>().Property(x => x.Status).HasConversion<string>();
        modelBuilder.Entity<EditRequest>().Property(x => x.Status).HasConversion<string>();
        modelBuilder.Entity<ApprovalLog>().Property(x => x.EntityType).HasConversion<string>();
        modelBuilder.Entity<ApprovalLog>().Property(x => x.Action).HasConversion<string>();
        modelBuilder.Entity<KnowledgeReadLog>().Property(x => x.Source).HasConversion<string>();
        modelBuilder.Entity<DailyMessage>().Property(x => x.Status).HasConversion<string>();
    }

    private static void ConfigureIndexes(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().HasIndex(x => x.Username).IsUnique();
        modelBuilder.Entity<KnowledgeVersion>().HasIndex(x => x.Status);
        modelBuilder.Entity<KnowledgeVersion>().HasIndex(x => x.IsCurrent);
        modelBuilder.Entity<KnowledgeTag>().HasIndex(x => x.TagText);
        modelBuilder.Entity<KnowledgeCategoryMapping>().HasIndex(x => new { x.TopicId, x.SubTopicId });
    }

    private static void ConfigureLengths(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().Property(x => x.FullName).HasMaxLength(200);
        modelBuilder.Entity<User>().Property(x => x.Username).HasMaxLength(100);
        modelBuilder.Entity<Deputy>().Property(x => x.Title).HasMaxLength(200);
        modelBuilder.Entity<Department>().Property(x => x.Title).HasMaxLength(200);
        modelBuilder.Entity<Topic>().Property(x => x.Title).HasMaxLength(200);
        modelBuilder.Entity<SubTopic>().Property(x => x.Title).HasMaxLength(200);
        modelBuilder.Entity<KnowledgeItem>().Property(x => x.Title).HasMaxLength(300);
        modelBuilder.Entity<KnowledgeVersion>().Property(x => x.Title).HasMaxLength(300);
        modelBuilder.Entity<KnowledgeAttachment>().Property(x => x.FileName).HasMaxLength(300);
        modelBuilder.Entity<KnowledgeAttachment>().Property(x => x.FilePath).HasMaxLength(1000);
        modelBuilder.Entity<KnowledgeAttachment>().Property(x => x.ContentType).HasMaxLength(100);
        modelBuilder.Entity<KnowledgeTag>().Property(x => x.TagText).HasMaxLength(100);
        modelBuilder.Entity<DailyMessage>().Property(x => x.Title).HasMaxLength(300);
        modelBuilder.Entity<DailyMessageAttachment>().Property(x => x.FileName).HasMaxLength(300);
        modelBuilder.Entity<DailyMessageAttachment>().Property(x => x.FilePath).HasMaxLength(1000);
        modelBuilder.Entity<DailyMessageAttachment>().Property(x => x.ContentType).HasMaxLength(100);
        modelBuilder.Entity<AuditLog>().Property(x => x.Action).HasMaxLength(100);
        modelBuilder.Entity<AuditLog>().Property(x => x.EntityType).HasMaxLength(100);
        modelBuilder.Entity<AuditLog>().Property(x => x.CorrelationId).HasMaxLength(100);
    }
}
