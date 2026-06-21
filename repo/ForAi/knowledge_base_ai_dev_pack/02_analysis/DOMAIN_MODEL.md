# Domain Model

## Core Entities

### User
- Id
- FullName
- Username
- Role
- IsActive

### Deputy
- Id
- Title
- IsActive
- CreatedAt
- UpdatedAt

### Department
- Id
- DeputyId
- Title
- IsActive
- CreatedAt
- UpdatedAt

### Topic
- Id
- DepartmentId
- Title
- IsActive
- CreatedAt
- UpdatedAt

### SubTopic
- Id
- TopicId
- Title
- IsActive
- CreatedAt
- UpdatedAt

### KnowledgeItem
سند مادر.
- Id
- Title
- DocumentType: Regulation, Circular, Procedure
- CurrentVersionId
- CreatedByUserId
- CreatedAt
- UpdatedAt
- IsArchived

### KnowledgeVersion
نسخه رسمی سند.
- Id
- KnowledgeItemId
- VersionNumber
- Title
- Summary
- BodyHtml
- ChangeSummary
- IssueDate
- PublishDate
- ValidUntil
- Status: Draft, PendingApproval, Published, Rejected, Archived
- IsCurrent
- CreatedByUserId
- ApprovedByUserId
- CreatedAt
- UpdatedAt
- ApprovedAt

### KnowledgeAttachment
- Id
- KnowledgeVersionId
- FileName
- FilePath
- ContentType
- FileSize
- UploadedByUserId
- UploadedAt

### KnowledgeCategoryMapping
اتصال سند/نسخه به ساختار موضوعی.
- Id
- KnowledgeVersionId
- DeputyId
- DepartmentId
- TopicId
- SubTopicId nullable

### KnowledgeTag
- Id
- KnowledgeVersionId
- TagText

### EditRequest
ویرایش عادی که نسخه جدید محسوب نمی‌شود.
- Id
- KnowledgeVersionId
- RequestedByUserId
- ProposedTitle
- ProposedSummary
- ProposedBodyHtml
- ProposedIssueDate
- ProposedValidUntil
- Status: PendingApproval, Approved, Rejected
- RejectionReason
- CreatedAt
- ReviewedByUserId
- ReviewedAt

### ApprovalLog
- Id
- EntityType: KnowledgeVersion, EditRequest
- EntityId
- Action: Submitted, Approved, Rejected
- ActorUserId
- Reason
- CreatedAt

### KnowledgeReadLog
- Id
- UserId
- KnowledgeItemId
- KnowledgeVersionId
- ReadAt
- Source: Web, ExternalApi

### DailyMessage
- Id
- Title
- BodyHtml
- CreatedByUserId
- SentAt
- Status: Published, Archived
- CreatedAt
- UpdatedAt

### DailyMessageAttachment
- Id
- DailyMessageId
- FileName
- FilePath
- ContentType
- FileSize
- UploadedAt

### AuditLog
- Id
- ActorUserId
- Action
- EntityType
- EntityId
- BeforeJson
- AfterJson
- CreatedAt
- CorrelationId

## Important Design Decision
- `KnowledgeItem` هویت سند را نگه می‌دارد.
- `KnowledgeVersion` نسخه رسمی سند را نگه می‌دارد.
- ویرایش عادی در `EditRequest` ذخیره می‌شود و بعد از تأیید روی همان نسخه اعمال می‌شود.
- فقط عملیات `Add New Version` باعث ایجاد `KnowledgeVersion` جدید می‌شود.
