# CODEX Task Plan — Transport & Mission Management System

## Purpose
This file breaks implementation into Codex-friendly phases so the system is built incrementally with low rework risk.

## Phase 0 — Repository Bootstrap
### Task 00.1
Create repository structure:
- `/docs`
- `/contracts`
- `/database`
- `/backend`
- `/frontend`

### Task 00.2
Create solution scaffold:
- ASP.NET Core Web API
- Application layer
- Domain layer
- Infrastructure layer
- Web/API host
- Vue 3 frontend scaffold

## Phase 1 — Core Technical Foundation
### Task 01.1
Implement shared building blocks:
- Result/Error model
- Audit interfaces
- Soft-delete interfaces
- Domain event base classes
- Base entity classes

### Task 01.2
Implement auth foundation:
- JWT auth
- refresh token flow
- role claims
- policy registration hooks

## Phase 2 — Database & Persistence
### Task 02.1
Generate EF Core models and mappings from `database/schema.sql`
### Task 02.2
Create initial migration
### Task 02.3
Implement seed data script usage
### Task 02.4
Implement repositories or DbContext usage pattern per architecture choice

## Phase 3 — Master Data
### Task 03.1
Users / Roles / Branches / Org Units APIs
### Task 03.2
Provinces / Cities APIs
### Task 03.3
Permission policy wiring for master data pages

## Phase 4 — Fleet
### Task 04.1
Drivers module
### Task 04.2
Vehicles module
### Task 04.3
Availability read models
### Task 04.4
Insurance validation helpers

## Phase 5 — Contracts & Policies
### Task 05.1
Contracts module
### Task 05.2
Calculation policy module
### Task 05.3
Active contract resolution service

## Phase 6 — Mission Core
### Task 06.1
Mission creation
### Task 06.2
Mission edit / view / search
### Task 06.3
Approval workflow
### Task 06.4
Mission status history
### Task 06.5
Mission passenger management

## Phase 7 — Dispatch
### Task 07.1
Driver/vehicle availability queries
### Task 07.2
Assignment endpoint
### Task 07.3
Reassignment / cancellation rules
### Task 07.4
Conflict detection for overlaps

## Phase 8 — Execution
### Task 08.1
Driver attendance
### Task 08.2
Mission execution start / complete
### Task 08.3
Mileage recording
### Task 08.4
Stop / penalty / extra payment entries

## Phase 9 — Finance
### Task 09.1
Finance calculation engine
### Task 09.2
Urban calculation policy
### Task 09.3
Outbound calculation policy
### Task 09.4
Mission cost persistence

## Phase 10 — Settlement
### Task 10.1
Monthly settlement generation
### Task 10.2
Payroll preview/report
### Task 10.3
Settlement approval / posting / payment states

## Phase 11 — Reporting
### Task 11.1
Mission reports
### Task 11.2
Driver performance reports
### Task 11.3
Vehicle utilization reports
### Task 11.4
Financial reports

## Phase 12 — Frontend
### Task 12.1
Shell layout + auth screens
### Task 12.2
Master data pages
### Task 12.3
Fleet pages
### Task 12.4
Mission request / approval pages
### Task 12.5
Dispatch page
### Task 12.6
Execution page
### Task 12.7
Finance / settlement pages
### Task 12.8
Reports page

## Phase 13 — Quality
### Task 13.1
Unit tests for business rules
### Task 13.2
Integration tests for API flows
### Task 13.3
Seed/demo data validation
### Task 13.4
Permission matrix verification tests

## Phase 14 — Hardening
### Task 14.1
Audit log coverage
### Task 14.2
Concurrency / overlap protection
### Task 14.3
Observability / logging
### Task 14.4
Performance review

## Recommended Codex Working Mode
- Implement one phase at a time
- Run tests after each phase
- Do not invent missing business policy values; preserve TODOs as config or explicit comments
- Prefer configuration over hard-coded organization-specific behavior
