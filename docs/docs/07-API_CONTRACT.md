# API Contract — Transport & Mission Management System

## Purpose
This document is the human-readable companion to `contracts/openapi.yaml`. Codex must treat the YAML file as the source of truth for endpoint generation, DTOs, response schemas, Swagger, and controller contracts.

## 1. Source of Truth
- Primary contract: `contracts/openapi.yaml`
- Supporting rules: `docs/02-BUSINESS_RULES.md`
- Supporting validation: `docs/11-ACCEPTANCE_CRITERIA.md`
- Data alignment: `docs/database-schema.md`

## 2. Global API Conventions
- Base URL: `/api/v1`
- Auth: Bearer JWT
- Response envelope:
```json
{
  "isSuccess": true,
  "message": "string",
  "data": {},
  "errors": []
}
```
- All business-critical endpoints must validate permissions and business rules before state transitions
- Sections marked TODO / ASSUMED remain configurable and must not be hard-coded beyond the declared contract

## 3. Module Coverage
- Auth
- Users
- Roles
- Branches
- OrganizationUnits
- Geography
- Drivers
- Vehicles
- Contracts
- Missions
- Approvals
- Dispatch
- Attendance
- Execution
- Finance
- Reports
- Audit
- Integrations
- Lookups
- search
- branchId
- organizationUnitId
- search
- parentId
- provinceId
- branchId
- isActive
- search
- startDateTime
- endDateTime
- branchId
- status
- ownershipType
- startDateTime
- endDateTime
- driverId
- vehicleId
- status
- status
- requesterUserId
- driverId
- fromDate
- toDate
- missionId
- driverId
- vehicleId
- dateFrom
- dateTo
- year
- month
- driverId
- fromDate
- toDate
- status
- driverId
- fromDate
- toDate
- vehicleId
- fromDate
- toDate
- fromDate
- toDate
- driverId
- entityName
- entityId
- actorUserId

## 4. Expected Endpoint Families
- Auth
- Users / Roles
- Branches / Org Units
- Geography
- Drivers / Vehicles
- Contracts
- Missions / Approvals
- Dispatch
- Attendance
- Execution
- Finance / Settlements
- Reports
- Audit
- Integrations

## 5. Codex Implementation Guidance
- Generate request/response DTOs directly from OpenAPI schemas
- Use FluentValidation or equivalent for validation rules
- Enforce role and policy checks using the permission matrix
- Keep handlers thin and defer business logic to application/domain services
- Preserve TODO markers in code comments where stakeholder clarification is still pending

## 6. Error Handling Guidance
- Use stable business error codes
- Distinguish validation errors (400), auth errors (401/403), not found (404), conflict/business state (409), and server errors (500)
- For rule violations, prefer domain-specific error codes documented in OpenAPI extensions

## 7. Open Questions / TODO
- Final login/identity provider strategy
- Exact Chargoon integration transport
- Final report export formats
