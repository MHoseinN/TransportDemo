# Transport Mission System Backend

Phase 1 implements the core technical foundation from `transport-mission-system/docs/docs/12-CODEX_TASK_PLAN.md`:

- shared result/error abstractions
- audit and soft-delete base types
- domain event base support
- JWT authentication
- refresh-token flow
- role-based policy registration hooks
- `/api/v1/auth/login`
- `/api/v1/auth/refresh`
- `/api/v1/me`

## Local run notes

- Target runtime follows the package specification: `.NET 8`
- Default database connection expects SQL Server LocalDB
- Development bootstrap seeding creates an `admin` user with password `ChangeMe123!`
- Replace the JWT signing key before non-local use

## Scope intentionally left for later phases

- Full schema generation and migrations
- Master data, fleet, mission, dispatch, execution, finance, and reporting modules
- Database-backed configurable permission overrides
- Chargoon integration hooks beyond placeholder policy-friendly boundaries
