# CODEX MASTER PROMPT

You are implementing the **Transport & Mission Management System**.

## Read these files first
1. `docs/01-PRD.md`
2. `docs/02-BUSINESS_RULES.md`
3. `docs/03-DOMAIN_MODEL.md`
4. `docs/04-STATE_MACHINE.md`
5. `docs/05-BPMN.md`
6. `docs/06-ERD.md`
7. `docs/07-API_CONTRACT.md`
8. `docs/08-FINANCE_CALCULATION_RULES.md`
9. `docs/09-PERMISSION_MATRIX.md`
10. `docs/10-FRONTEND_PAGES.md`
11. `docs/11-ACCEPTANCE_CRITERIA.md`
12. `docs/12-CODEX_TASK_PLAN.md`
13. `contracts/openapi.yaml`
14. `database/schema.sql`

## Implementation goals
- Build a production-structured solution with .NET 8 backend and Vue 3 frontend
- Follow Clean Architecture and CQRS
- Keep authorization policy-based
- Do not hard-code business behavior that is explicitly marked TODO / ASSUMPTION / CONFIGURABLE
- Surface incomplete requirements as configuration hooks, comments, or extension points

## Rules for generation
- Preserve domain terminology from the docs
- Generate stable DTOs and validators from OpenAPI
- Use SQL Server compatible mappings
- Implement soft delete and audit columns where specified
- Use enums/lookup validation consistently with the schema and business rules
- Add tests for critical business rules and workflow transitions
- Prefer incremental commits/steps aligned with `docs/12-CODEX_TASK_PLAN.md`

## First execution step
Start with:
1. repository scaffolding
2. backend solution creation
3. domain entities
4. DbContext and initial migration
5. authentication foundation

Then continue phase by phase.
