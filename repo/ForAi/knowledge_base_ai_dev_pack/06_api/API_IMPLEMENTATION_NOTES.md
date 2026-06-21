# API Implementation Notes

## Visibility Rules
- Internal UI endpoints may return pending content only to authorized Manager/Supervisor views.
- Operator-facing endpoints must return only Published/Archived content that is allowed to be seen.
- External API should return only published content. Pending or rejected content must not be exposed.

## Search Rules
- Search should support title, summary, keywords, bodyHtml text.
- MVP does not require searching inside uploaded PDF/Word files.
- Current versions should appear before old/archived versions.

## Attachments
- Upload should validate file size and content type.
- Store file metadata in DB.
- Store file physically in storage/file system/object storage depending on infrastructure.

## Security
- Use role-based authorization for internal API.
- Use API key or service token for external app.
- Log external API access if possible.
