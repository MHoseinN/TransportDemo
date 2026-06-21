using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Knowledgement.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialFoundation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AuditLogsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ActorUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    Action = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    EntityType = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    EntityId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    BeforeJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    AfterJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CorrelationId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditLogsSet", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DeputiesSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DeputiesSet", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "UsersSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FullName = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Role = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UsersSet", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DepartmentsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeputyId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DepartmentsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DepartmentsSet_DeputiesSet_DeputyId",
                        column: x => x.DeputyId,
                        principalTable: "DeputiesSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ApprovalLogsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    EntityType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EntityId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Action = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ActorUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ApprovalLogsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ApprovalLogsSet_UsersSet_ActorUserId",
                        column: x => x.ActorUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DailyMessagesSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    BodyHtml = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SentAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DailyMessagesSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DailyMessagesSet_UsersSet_CreatedByUserId",
                        column: x => x.CreatedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "TopicsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DepartmentId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TopicsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TopicsSet_DepartmentsSet_DepartmentId",
                        column: x => x.DepartmentId,
                        principalTable: "DepartmentsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DailyMessageAttachmentsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DailyMessageId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FileName = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    FilePath = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    ContentType = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FileSize = table.Column<long>(type: "bigint", nullable: false),
                    UploadedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DailyMessageAttachmentsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DailyMessageAttachmentsSet_DailyMessagesSet_DailyMessageId",
                        column: x => x.DailyMessageId,
                        principalTable: "DailyMessagesSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "SubTopicsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TopicId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubTopicsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SubTopicsSet_TopicsSet_TopicId",
                        column: x => x.TopicId,
                        principalTable: "TopicsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "EditRequestsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RequestedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ProposedTitle = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ProposedSummary = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ProposedBodyHtml = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ProposedIssueDate = table.Column<DateOnly>(type: "date", nullable: true),
                    ProposedValidUntil = table.Column<DateOnly>(type: "date", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RejectionReason = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ReviewedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ReviewedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EditRequestsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_EditRequestsSet_UsersSet_RequestedByUserId",
                        column: x => x.RequestedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_EditRequestsSet_UsersSet_ReviewedByUserId",
                        column: x => x.ReviewedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeAttachmentsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FileName = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    FilePath = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    ContentType = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FileSize = table.Column<long>(type: "bigint", nullable: false),
                    UploadedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UploadedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeAttachmentsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeAttachmentsSet_UsersSet_UploadedByUserId",
                        column: x => x.UploadedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeCategoryMappingsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeputyId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DepartmentId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TopicId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SubTopicId = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeCategoryMappingsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeCategoryMappingsSet_DepartmentsSet_DepartmentId",
                        column: x => x.DepartmentId,
                        principalTable: "DepartmentsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KnowledgeCategoryMappingsSet_DeputiesSet_DeputyId",
                        column: x => x.DeputyId,
                        principalTable: "DeputiesSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KnowledgeCategoryMappingsSet_SubTopicsSet_SubTopicId",
                        column: x => x.SubTopicId,
                        principalTable: "SubTopicsSet",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_KnowledgeCategoryMappingsSet_TopicsSet_TopicId",
                        column: x => x.TopicId,
                        principalTable: "TopicsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeItemsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    DocumentType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CurrentVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    CreatedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IsArchived = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeItemsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeItemsSet_UsersSet_CreatedByUserId",
                        column: x => x.CreatedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeVersionsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeItemId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    VersionNumber = table.Column<int>(type: "int", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    Summary = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BodyHtml = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ChangeSummary = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IssueDate = table.Column<DateOnly>(type: "date", nullable: false),
                    PublishDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ValidUntil = table.Column<DateOnly>(type: "date", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    IsCurrent = table.Column<bool>(type: "bit", nullable: false),
                    CreatedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ApprovedByUserId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    ApprovedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeVersionsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeVersionsSet_KnowledgeItemsSet_KnowledgeItemId",
                        column: x => x.KnowledgeItemId,
                        principalTable: "KnowledgeItemsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_KnowledgeVersionsSet_UsersSet_ApprovedByUserId",
                        column: x => x.ApprovedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_KnowledgeVersionsSet_UsersSet_CreatedByUserId",
                        column: x => x.CreatedByUserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeReadLogsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeItemId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ReadAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Source = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeReadLogsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeReadLogsSet_KnowledgeItemsSet_KnowledgeItemId",
                        column: x => x.KnowledgeItemId,
                        principalTable: "KnowledgeItemsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KnowledgeReadLogsSet_KnowledgeVersionsSet_KnowledgeVersionId",
                        column: x => x.KnowledgeVersionId,
                        principalTable: "KnowledgeVersionsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KnowledgeReadLogsSet_UsersSet_UserId",
                        column: x => x.UserId,
                        principalTable: "UsersSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KnowledgeTagsSet",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KnowledgeVersionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TagText = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KnowledgeTagsSet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KnowledgeTagsSet_KnowledgeVersionsSet_KnowledgeVersionId",
                        column: x => x.KnowledgeVersionId,
                        principalTable: "KnowledgeVersionsSet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ApprovalLogsSet_ActorUserId",
                table: "ApprovalLogsSet",
                column: "ActorUserId");

            migrationBuilder.CreateIndex(
                name: "IX_DailyMessageAttachmentsSet_DailyMessageId",
                table: "DailyMessageAttachmentsSet",
                column: "DailyMessageId");

            migrationBuilder.CreateIndex(
                name: "IX_DailyMessagesSet_CreatedByUserId",
                table: "DailyMessagesSet",
                column: "CreatedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_DepartmentsSet_DeputyId",
                table: "DepartmentsSet",
                column: "DeputyId");

            migrationBuilder.CreateIndex(
                name: "IX_EditRequestsSet_KnowledgeVersionId",
                table: "EditRequestsSet",
                column: "KnowledgeVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_EditRequestsSet_RequestedByUserId",
                table: "EditRequestsSet",
                column: "RequestedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_EditRequestsSet_ReviewedByUserId",
                table: "EditRequestsSet",
                column: "ReviewedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeAttachmentsSet_KnowledgeVersionId",
                table: "KnowledgeAttachmentsSet",
                column: "KnowledgeVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeAttachmentsSet_UploadedByUserId",
                table: "KnowledgeAttachmentsSet",
                column: "UploadedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeCategoryMappingsSet_DepartmentId",
                table: "KnowledgeCategoryMappingsSet",
                column: "DepartmentId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeCategoryMappingsSet_DeputyId",
                table: "KnowledgeCategoryMappingsSet",
                column: "DeputyId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeCategoryMappingsSet_KnowledgeVersionId",
                table: "KnowledgeCategoryMappingsSet",
                column: "KnowledgeVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeCategoryMappingsSet_SubTopicId",
                table: "KnowledgeCategoryMappingsSet",
                column: "SubTopicId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeCategoryMappingsSet_TopicId_SubTopicId",
                table: "KnowledgeCategoryMappingsSet",
                columns: new[] { "TopicId", "SubTopicId" });

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeItemsSet_CreatedByUserId",
                table: "KnowledgeItemsSet",
                column: "CreatedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeItemsSet_CurrentVersionId",
                table: "KnowledgeItemsSet",
                column: "CurrentVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeReadLogsSet_KnowledgeItemId",
                table: "KnowledgeReadLogsSet",
                column: "KnowledgeItemId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeReadLogsSet_KnowledgeVersionId",
                table: "KnowledgeReadLogsSet",
                column: "KnowledgeVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeReadLogsSet_UserId",
                table: "KnowledgeReadLogsSet",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeTagsSet_KnowledgeVersionId",
                table: "KnowledgeTagsSet",
                column: "KnowledgeVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeTagsSet_TagText",
                table: "KnowledgeTagsSet",
                column: "TagText");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeVersionsSet_ApprovedByUserId",
                table: "KnowledgeVersionsSet",
                column: "ApprovedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeVersionsSet_CreatedByUserId",
                table: "KnowledgeVersionsSet",
                column: "CreatedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeVersionsSet_IsCurrent",
                table: "KnowledgeVersionsSet",
                column: "IsCurrent");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeVersionsSet_KnowledgeItemId",
                table: "KnowledgeVersionsSet",
                column: "KnowledgeItemId");

            migrationBuilder.CreateIndex(
                name: "IX_KnowledgeVersionsSet_Status",
                table: "KnowledgeVersionsSet",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_SubTopicsSet_TopicId",
                table: "SubTopicsSet",
                column: "TopicId");

            migrationBuilder.CreateIndex(
                name: "IX_TopicsSet_DepartmentId",
                table: "TopicsSet",
                column: "DepartmentId");

            migrationBuilder.CreateIndex(
                name: "IX_UsersSet_Username",
                table: "UsersSet",
                column: "Username",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_EditRequestsSet_KnowledgeVersionsSet_KnowledgeVersionId",
                table: "EditRequestsSet",
                column: "KnowledgeVersionId",
                principalTable: "KnowledgeVersionsSet",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_KnowledgeAttachmentsSet_KnowledgeVersionsSet_KnowledgeVersionId",
                table: "KnowledgeAttachmentsSet",
                column: "KnowledgeVersionId",
                principalTable: "KnowledgeVersionsSet",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_KnowledgeCategoryMappingsSet_KnowledgeVersionsSet_KnowledgeVersionId",
                table: "KnowledgeCategoryMappingsSet",
                column: "KnowledgeVersionId",
                principalTable: "KnowledgeVersionsSet",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_KnowledgeItemsSet_KnowledgeVersionsSet_CurrentVersionId",
                table: "KnowledgeItemsSet",
                column: "CurrentVersionId",
                principalTable: "KnowledgeVersionsSet",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_KnowledgeItemsSet_UsersSet_CreatedByUserId",
                table: "KnowledgeItemsSet");

            migrationBuilder.DropForeignKey(
                name: "FK_KnowledgeVersionsSet_UsersSet_ApprovedByUserId",
                table: "KnowledgeVersionsSet");

            migrationBuilder.DropForeignKey(
                name: "FK_KnowledgeVersionsSet_UsersSet_CreatedByUserId",
                table: "KnowledgeVersionsSet");

            migrationBuilder.DropForeignKey(
                name: "FK_KnowledgeItemsSet_KnowledgeVersionsSet_CurrentVersionId",
                table: "KnowledgeItemsSet");

            migrationBuilder.DropTable(
                name: "ApprovalLogsSet");

            migrationBuilder.DropTable(
                name: "AuditLogsSet");

            migrationBuilder.DropTable(
                name: "DailyMessageAttachmentsSet");

            migrationBuilder.DropTable(
                name: "EditRequestsSet");

            migrationBuilder.DropTable(
                name: "KnowledgeAttachmentsSet");

            migrationBuilder.DropTable(
                name: "KnowledgeCategoryMappingsSet");

            migrationBuilder.DropTable(
                name: "KnowledgeReadLogsSet");

            migrationBuilder.DropTable(
                name: "KnowledgeTagsSet");

            migrationBuilder.DropTable(
                name: "DailyMessagesSet");

            migrationBuilder.DropTable(
                name: "SubTopicsSet");

            migrationBuilder.DropTable(
                name: "TopicsSet");

            migrationBuilder.DropTable(
                name: "DepartmentsSet");

            migrationBuilder.DropTable(
                name: "DeputiesSet");

            migrationBuilder.DropTable(
                name: "UsersSet");

            migrationBuilder.DropTable(
                name: "KnowledgeVersionsSet");

            migrationBuilder.DropTable(
                name: "KnowledgeItemsSet");
        }
    }
}
