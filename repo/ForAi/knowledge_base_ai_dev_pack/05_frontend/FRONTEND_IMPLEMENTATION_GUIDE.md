# Frontend Implementation Guide

## Suggested Stack
- Vue 3
- TypeScript
- Vuetify
- Vue Router
- Pinia
- Axios or Fetch wrapper
- Rich Text Editor: TipTap / Quill / CKEditor with RTL support

## UI Direction
- Main UI language: Persian
- Direction: RTL by default
- Rich text editor must support both RTL and LTR blocks.

## Main Pages
1. Login / Auth callback, if needed
2. Dashboard
3. Category Management
4. Document List / Search
5. Document Create
6. Document Detail
7. Document Edit
8. Add New Version
9. Approval Inbox
10. Approval Review
11. Daily Message List
12. Daily Message Create
13. Read Log / Reports, optional for MVP

## Shared Components
- `RoleGuard`
- `AppLayout`
- `SearchFilterPanel`
- `CategorySelector`
- `DocumentStatusBadge`
- `OldDocumentWarning`
- `RichTextEditor`
- `AttachmentUploader`
- `AttachmentList`
- `ApprovalActions`
- `MarkAsReadButton`
- `EmptyState`
- `ErrorState`
- `LoadingState`

## UX Rules
- Old/archived documents must be visually distinct.
- Current version must be clearly identified.
- For old documents, show button: «مشاهده آخرین نسخه معتبر».
- Unapproved content must not appear to operator.
- Supervisor should see pending status for own requests.
- Manager should see approval count/badge.

## Required States on Each Page
- Loading
- Empty
- Error
- Permission denied
- Success message
