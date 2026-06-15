# Transportation & Mission Management System

Enterprise-grade greenfield scaffold for a transportation and mission management platform.

## Phase Status

Current phase: **Phase 0.5 - Architecture Alignment and Requirement Gap Fix**

This phase contains:

- Clean Architecture backend scaffold.
- Vue 3 frontend scaffold.
- Aligned domain model, EF Core mappings, SQL schema baseline, and OpenAPI contract.
- Placeholder API endpoints only.

This phase intentionally contains **no CRUD implementation, no business logic, no workflow engine, no calculation engine, no authentication implementation, and no external integrations**.

## Solution Structure

```text
backend/
  src/
    TransportationManagement.Api/
    TransportationManagement.Application/
    TransportationManagement.Domain/
    TransportationManagement.Infrastructure/
frontend/
  src/
    app/
    shared/
    features/
outputs/
  phase-0/
    contracts/openapi.yaml
    database/schema.sql
```

## Run Backend

```powershell
dotnet restore TransportationManagement.sln
dotnet run --project backend/src/TransportationManagement.Api/TransportationManagement.Api.csproj
```

Swagger URL:

```text
https://localhost:5001/swagger
```

The actual HTTPS port may differ depending on local launch settings.

## Run Frontend

```powershell
cd frontend
npm install
npm run dev
```

Default Vite URL:

```text
http://localhost:5173
```

## Migrations Later

Migrations are intentionally not created in Phase 0.5. When Phase 1 starts and the SQL Server connection is confirmed, use:

```powershell
dotnet ef migrations add InitialCreate `
  --project backend/src/TransportationManagement.Infrastructure `
  --startup-project backend/src/TransportationManagement.Api `
  --output-dir Persistence/Migrations

dotnet ef database update `
  --project backend/src/TransportationManagement.Infrastructure `
  --startup-project backend/src/TransportationManagement.Api
```

## API Contract

The Phase 0.5 OpenAPI contract is stored at:

```text
outputs/phase-0/contracts/openapi.yaml
```

Controllers currently expose placeholder routes returning `501 Not Implemented`.
