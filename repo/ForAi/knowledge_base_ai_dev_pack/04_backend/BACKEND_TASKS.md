# Backend Tasks — Execution Order

## Wave 1 — Foundation
1. Create solution/project structure.
2. Configure database connection.
3. Add base entities and audit fields.
4. Add role model and permission policies.
5. Add Swagger/OpenAPI.

## Wave 2 — Categories
1. Implement Deputy/Department/Topic/SubTopic entities.
2. Implement CRUD APIs.
3. Enforce soft disable.
4. Add tests for hierarchy constraints.

## Wave 3 — Documents
1. Implement KnowledgeItem, KnowledgeVersion, Attachment, Tag, CategoryMapping.
2. Implement create document by Manager.
3. Implement create document by Supervisor with PendingApproval.
4. Implement upload/download attachments.
5. Implement get detail and list.

## Wave 4 — Approval
1. Implement ApprovalLog.
2. Implement pending approvals API.
3. Implement approve/reject flows.
4. Ensure rejected request stores reason.

## Wave 5 — Edit & Versioning
1. Implement EditRequest.
2. Implement manager direct edit.
3. Implement supervisor edit request.
4. Implement add new version.
5. Implement archive previous version on new version publish.

## Wave 6 — Search & View
1. Implement filters.
2. Implement keyword search.
3. Sort current versions first.
4. Add archived/old status filtering.

## Wave 7 — Daily Messages
1. Implement DailyMessage entity.
2. Implement create/list/detail/archive.
3. Store sent date/time.

## Wave 8 — Read Log & External API
1. Implement Mark as Read.
2. Implement external search/detail/related/latest endpoints.
3. Add external API authentication.
