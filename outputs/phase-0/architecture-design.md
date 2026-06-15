# Transportation and Mission Management System - Phase 0 Architecture

## Architecture Goals

The system is designed as a long-term enterprise platform, not a single-purpose CRUD application. Business rules, workflow steps, approval authorities, and mission cost formulas must evolve through configuration and isolated extension points.

Primary goals:

- Keep domain models independent from ASP.NET, EF Core, SQL Server, and Vue.
- Keep controllers thin and limited to HTTP mapping.
- Treat Swagger/OpenAPI as the API contract consumed by the frontend.
- Model workflow as a generic engine that can approve any business object.
- Model cost calculation as pluggable strategies selected by contract configuration.
- Keep auditability, reporting, and future integrations as first-class concerns.

## Backend Solution Structure

```text
src/
  TransportationManagement.Domain/
  TransportationManagement.Application/
  TransportationManagement.Infrastructure/
  TransportationManagement.Api/
tests/
  TransportationManagement.UnitTests/
  TransportationManagement.IntegrationTests/
```

## Layer Responsibilities

### Domain Layer

Contains enterprise concepts and pure domain rules only.

Includes:

- Entities: `Province`, `City`, `Vehicle`, `Driver`, `Contract`, `MissionRequest`, `MissionAssignment`, `MissionExecution`, `DriverAttendance`, workflow entities, calculation result entities.
- Enums: mission status, assignment status, attendance status, workflow action type, approver type, calculation model.
- Value objects where useful: `Money`, `DateRange`, `KilometerRange`, `NationalCode`.
- Minimal pure validation methods such as vehicle insurance expiry checks.

Does not include:

- EF Core attributes or DbContext logic.
- HTTP concepts.
- Authorization framework code.
- SQL-specific behavior.

### Application Layer

Contains use cases and business orchestration.

Includes:

- Commands and queries per feature.
- DTOs and request/response contracts.
- Interfaces for persistence and infrastructure dependencies.
- Workflow services:
  - `IWorkflowDefinitionService`
  - `IWorkflowEngine`
  - `IApproverResolver`
- Calculation services:
  - `ICalculationStrategy`
  - `ICalculationStrategyResolver`
  - `IMissionCostCalculator`
- Availability services:
  - `IDriverAvailabilityService`
  - `IVehicleAvailabilityService`
- Validation abstractions for rules that may become configurable.

### Infrastructure Layer

Contains technical implementations.

Includes:

- EF Core DbContext and mappings.
- SQL Server persistence.
- Repository implementations.
- Unit of Work implementation.
- Workflow definition persistence.
- Strategy registration and configuration loading.
- External integration placeholders.
- EF migrations.

### API Layer

Contains ASP.NET Core HTTP boundary only.

Includes:

- Controllers.
- Authentication and authorization wiring.
- Swagger/OpenAPI configuration.
- Exception handling middleware.
- Request validation pipeline.
- API versioning.

Controllers must call application use cases only. They must not contain workflow, calculation, assignment, or validation logic.

## Backend Feature Modules

Application and API folders should be feature-aligned:

```text
Features/
  Geography/
  Vehicles/
  Drivers/
  Contracts/
  Missions/
  Workflows/
  Attendance/
  Assignments/
  Execution/
  Calculations/
  Reports/
```

Each feature contains its commands, queries, DTOs, validators, and handlers.

## Generic Workflow Design

Workflow is not mission-specific.

Core model:

- `WorkflowDefinition`: reusable workflow template for a business entity type.
- `WorkflowStep`: ordered step within a definition.
- `WorkflowInstance`: active workflow for one business object.
- `WorkflowAction`: user action history for approve, reject, or return.

Important fields:

- `EntityType`: for example `MissionRequest`, future `Contract`, `VehicleRequest`.
- `EntityId`: ID of the target record.
- `ApproverType`: `Role`, `User`, or future resolver type.
- `ApproverValue`: role name or user ID.
- `OnApproveNextStepId`, `OnRejectStatus`, `OnReturnStepId` for configurable routing.

Workflow behavior:

1. A use case submits an entity.
2. The application layer asks `IWorkflowEngine.StartAsync(entityType, entityId, workflowCode)`.
3. The workflow engine loads active definition and first step.
4. The engine creates an instance and moves the entity to `InReview`.
5. Approvers call `Approve`, `Reject`, or `Return`.
6. The engine validates actor permission through `IApproverResolver`.
7. The engine records a `WorkflowAction`.
8. The engine advances, returns, rejects, or completes the instance.
9. The owning use case updates the entity lifecycle status through a domain-safe transition.

No workflow step, role, or sequence is hardcoded in mission code.

## Calculation Strategy Design

Cost calculation is selected through contract pricing configuration.

Interfaces:

```csharp
public interface ICalculationStrategy
{
    string Code { get; }
    Task<MissionCalculationResultDto> CalculateAsync(MissionCalculationContext context, CancellationToken cancellationToken);
}
```

Initial strategies:

- `InCityHourlyStrategy`
- `OutCityKmStrategy`

Strategy selection:

- `ContractCalculationRule.StrategyCode` determines the strategy.
- `ICalculationStrategyResolver` maps code to implementation.
- `IMissionCostCalculator` builds the calculation context and delegates to the resolved strategy.

Adding a future strategy should require:

1. Creating a new strategy class.
2. Registering it in DI.
3. Adding database configuration that points a contract rule to its `StrategyCode`.

Existing orchestration logic should not change.

## Frontend Architecture

Vue 3 should be feature-based and API-contract driven.

```text
frontend/
  src/
    app/
      main.js
      router/
      stores/
      plugins/
    shared/
      api/
      components/
      composables/
      layouts/
      utils/
    features/
      geography/
      vehicles/
      drivers/
      contracts/
      missions/
      workflows/
      attendance/
      assignments/
      execution/
      reports/
```

Frontend rules:

- API calls go through `shared/api/httpClient.js`.
- Feature services wrap endpoint calls.
- Pinia stores manage state per feature.
- Pages compose feature components.
- No business rules duplicated from backend except basic UI validation and display formatting.
- Generated API clients may be introduced later from OpenAPI.

## Cross-Cutting Concerns

Required from the beginning:

- API versioning: `/api/v1`.
- Correlation ID middleware.
- Standard API response envelope for errors.
- Global exception handling.
- EF Core optimistic concurrency with `RowVersion`.
- Soft delete for master data where appropriate.
- Audit columns: `CreatedAt`, `CreatedBy`, `UpdatedAt`, `UpdatedBy`.
- Future audit log table for behavioral events.
- Role/user abstractions kept behind interfaces for future identity provider integration.

## Phase Roadmap

Phase 1 implements master data CRUD: provinces, cities, vehicles, drivers, contracts.

Phase 2 implements mission request submission and generic workflow engine.

Phase 3 implements attendance and mission assignment with conflict checks.

Phase 4 implements execution tracking and strategy-based calculation.

Phase 5 implements reporting, audit logs, and operational dashboards.
