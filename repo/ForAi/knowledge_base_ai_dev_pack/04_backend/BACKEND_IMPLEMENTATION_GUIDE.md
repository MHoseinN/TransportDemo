# Backend Implementation Guide

## Suggested Architecture
اگر از ASP.NET Core استفاده می‌شود، ساختار پیشنهادی:

```text
src/
  KnowledgeBase.Api/
  KnowledgeBase.Application/
  KnowledgeBase.Domain/
  KnowledgeBase.Infrastructure/
  KnowledgeBase.Contracts/
tests/
  KnowledgeBase.UnitTests/
  KnowledgeBase.IntegrationTests/
```

## Domain Modules
1. Identity / Access Control
2. Category Management
3. Knowledge Documents
4. Approval Workflow
5. Versioning
6. Daily Messages
7. Search
8. Read Logs
9. External API
10. Audit Logs

## Key Services
- `CategoryService`
- `KnowledgeDocumentService`
- `ApprovalService`
- `VersioningService`
- `DailyMessageService`
- `SearchService`
- `ReadLogService`
- `ExternalKnowledgeApiService`
- `AuditLogService`

## Backend Rules to Enforce
- Never physically delete documents or versions.
- Supervisor-created official documents must be pending approval.
- Manager-created official documents can be published directly.
- Edit by Supervisor must create EditRequest and not affect published content until approval.
- Normal edit must not create a new KnowledgeVersion.
- Add New Version must create KnowledgeVersion.
- Publishing a new version must mark the previous current version as Archived/Old and `IsCurrent=false`.
- Unapproved content must not be returned in public UI/API queries.
- All key operations must be audited.

## Error Handling
Use consistent error responses:
- 400: Validation error
- 401: Unauthorized
- 403: Forbidden
- 404: Not found
- 409: Business rule conflict
- 500: Unexpected error

## API Versioning
Suggested prefix:
`/api/v1/...`

External app endpoints:
`/api/v1/external/knowledge/...`
