# UI Pages Specification

## 1. Dashboard
### Users
Manager, Supervisor, Operator
### Sections
- Latest published documents
- Latest daily messages
- Pending approvals, manager only
- Quick search
- Recent updates

## 2. Document Search/List
### Filters
- Text search
- Document type
- Deputy
- Department
- Topic
- SubTopic
- Status: Current, Old, Archived
- Issue date
- Publish date
### List Columns
- Title
- Type
- Category path
- Version number
- Status badge
- Issue date
- Publish date
- Actions

## 3. Document Detail
### Sections
- Title
- Document metadata
- Status and current/old badge
- Old document warning, if applicable
- Summary
- BodyHtml
- Attachments
- Version history
- Mark as read button

## 4. Create/Edit Document
### Fields
- Title
- Type
- Category selector, supports multiple mappings
- Summary
- Body rich text
- Keywords/tags
- Issue date
- Valid until, optional
- Attachments
### Actions
- Manager: Publish
- Supervisor: Submit for approval

## 5. Add New Version
### Fields
- Full new body text
- Change summary
- Issue date
- Attachments
- Category mappings
### Actions
- Manager: Publish new version
- Supervisor: Submit for approval

## 6. Approval Inbox
### Users
Manager only
### Content
- Pending new documents
- Pending edit requests
- Pending new versions
### Actions
- Approve
- Reject with reason

## 7. Daily Messages
### List
- Title
- Sent date/time
- Created by
- Status
### Create
- Title
- Body
- Attachment optional
- Publish directly
