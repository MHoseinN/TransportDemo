# Acceptance Criteria — MVP

## Document Creation
- Manager can create and publish official document directly.
- Supervisor can create official document and it becomes PendingApproval.
- Operator cannot create official document.
- Required fields are validated.
- At least one category mapping is required.

## Approval
- Manager can view pending requests.
- Manager can approve or reject.
- Rejection requires reason.
- Approved content becomes visible to all roles.
- Rejected content remains invisible to operator.

## Edit
- Manager edit applies directly.
- Supervisor edit creates EditRequest.
- Pending edit does not affect visible published content.
- Edit does not create new version.

## Versioning
- Add New Version creates a new KnowledgeVersion.
- After publishing new version, previous current version becomes old/archived.
- Old version remains visible to all roles.
- Old version must show warning.

## Search
- Search works by title, summary, keyword, and main body text.
- Filters work by type, deputy, department, topic, subtopic, status.
- Current versions appear before old versions.

## Daily Messages
- Manager and Supervisor can create daily messages.
- Daily messages publish directly.
- Sent date/time is shown.
- All roles can view daily messages.

## Mark as Read
- All roles can mark current and old versions as read.
- Read log stores user, knowledge item, version, date/time.

## External API
- External app can search and get details.
- External API does not expose pending/rejected content.
