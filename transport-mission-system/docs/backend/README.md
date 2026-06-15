# Backend

## Target Stack
- .NET 8
- ASP.NET Core Web API
- Clean Architecture
- EF Core + SQL Server
- CQRS + MediatR
- FluentValidation
- Swagger / OpenAPI

## Expected Solution Layout
- Domain
- Application
- Infrastructure
- WebApi

## Notes
- Use `contracts/openapi.yaml` as API source of truth
- Use `database/schema.sql` and `docs/database-schema.md` for persistence design
- Respect TODO / CONFIGURABLE markers instead of hard-coding unknown policies
