# Backend Prompt

Implement backend for the Knowledge Base MVP using the chosen stack.

Focus areas:
1. Domain entities and migrations
2. Role-based authorization
3. Category CRUD
4. Knowledge document create/list/detail
5. Approval workflow
6. EditRequest flow
7. Add new version flow
8. Daily messages
9. Read logs
10. External API

Must enforce:
- Manager direct publish.
- Supervisor requires approval for official document, edit, and new version.
- Edit does not create new version.
- Add New Version creates KnowledgeVersion.
- Previous version is archived when new version publishes.
- Unapproved content not visible to Operator/external API.
- No physical delete.
