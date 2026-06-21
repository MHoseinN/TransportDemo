# Codex Master Prompt

You are implementing the Knowledge Base MVP for an educational organization.

Before coding, read these files in order:
1. `README_FOR_AI.md`
2. `00_start_here/AI_OPERATING_INSTRUCTIONS.md`
3. `01_product/PRD_KNOWLEDGE_BASE.md`
4. `02_analysis/BUSINESS_RULES.md`
5. `02_analysis/ROLES_AND_PERMISSIONS.md`
6. `02_analysis/DOMAIN_MODEL.md`
7. `06_api/openapi.yaml`
8. `07_database/database_schema.sql`
9. `08_backlog/BACKLOG_KANBAN.md`

Implementation principles:
- Do not invent product rules.
- If a rule is unclear, add a TODO and document the assumption.
- Keep normal edit and official versioning separate.
- Never expose unapproved content to Operator or external API.
- Never physically delete documents or versions.
- Use audit logging for key operations.
- Keep API contract aligned with OpenAPI.
- Implement small vertical slices.

Start with the first not-done task from the backlog and produce a minimal, tested implementation.
