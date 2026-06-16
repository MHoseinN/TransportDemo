# Codex instructions for BPMN files

This repository contains BPMN 2.0 XML files for the transport and mission-order system.

## How to work with these files
- Treat `*.bpmn` as the source of truth for process models.
- Preserve existing `id` values unless a deliberate refactor requires coordinated updates.
- Keep lane names in Persian unless explicitly asked to translate.
- Prefer editing the semantic BPMN elements first (`process`, `laneSet`, tasks, gateways, events, `sequenceFlow`).
- Keep `bpmndi:BPMNDiagram` and `BPMNShape` / `BPMNEdge` blocks consistent with semantic nodes when changing layout-sensitive items.
- Do not convert BPMN XML into Mermaid unless explicitly requested.
- If a process rule is ambiguous, annotate it in comments or a companion markdown note rather than inventing business logic.

## File map
- `transport-main-process.bpmn` — end-to-end main process
- `city-province-registration.bpmn`
- `vehicle-registration.bpmn`
- `driver-registration.bpmn`
- `contract-registration.bpmn`
- `mission-request.bpmn`
- `driver-entry-exit.bpmn`
- `mission-driver-vehicle-assignment.bpmn`
- `mission-info-and-kilometer.bpmn`
- `other-organizations-calculation.bpmn`
