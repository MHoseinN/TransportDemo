# BPMN — Mission Lifecycle

## Purpose
This document provides BPMN-like executable flow definitions in Mermaid for implementation planning.

## 1. Level 1 — High-Level Mission Lifecycle
```mermaid
flowchart TD
    A([Start]) --> B[Create Mission Request]
    B --> C[Approval Process]
    C --> D[Dispatch Assignment]
    D --> E[Mission Execution]
    E --> F[Cost Calculation]
    F --> G[Monthly Settlement]
    G --> H([End])
```

## 2. Level 2 — Executable Mission Lifecycle
```mermaid
flowchart TD
    A([Start: Mission Lifecycle])
    B[Employee creates mission request]
    C[Validate mission data]
    A --> B --> C
    C --> D{Data valid?}
    D -- No --> D1[Return to Employee for correction] --> B
    D -- Yes --> E[Save Mission Request]
    E --> F[Set Status: Pending Approval]
    F --> G[Manager reviews request]
    G --> H{Approved?}
    H -- No --> H1[Set Status: Rejected] --> Z([End])
    H -- Yes --> I[Set Status: Approved]
    I --> J[Dispatcher checks driver availability]
    J --> K[Dispatcher checks vehicle availability]
    K --> L[Check insurance validity]
    L --> M{Resources valid?}
    M -- No --> M1[Return to Dispatch Pool] --> J
    M -- Yes --> N[Assign Driver]
    N --> O[Assign Vehicle]
    O --> P[Create Mission Assignment]
    P --> Q[Notify Driver]
    Q --> R[Driver starts mission]
    R --> S[Record Entry Time]
    S --> T[Record Exit Time]
    T --> U[Record Mileage]
    U --> V{Mission Type?}
    V -- Urban --> W[Hourly Calculation Engine]
    V -- Outbound --> X[KM + Sleep Calculation Engine]
    W --> Y[Generate Mission Execution Record]
    X --> Y
    Y --> Z1[Calculate Mission Cost]
    Z1 --> Z2[Apply Contract Rules]
    Z2 --> Z3[Store Cost Record]
    Z3 --> Z4{End of Month?}
    Z4 -- No --> Z([End])
    Z4 -- Yes --> Z5[Aggregate Driver Data]
    Z5 --> Z6[Calculate Payroll]
    Z6 --> Z7[Generate Settlement Report]
    Z7 --> Z([End])
```

## 3. Service-Level BPMN — Mission Core
```mermaid
flowchart TD
    A([Start]) --> B[Create Mission Request]
    B --> C[Validate Request Data]
    C --> D{Data Valid?}
    D -- No --> D1[Return to User for Fix] --> B
    D -- Yes --> E[Save MissionRequest]
    E --> F[Set Status: Draft]
    F --> G[Set Status: Pending Approval]
    G --> H[Send to Manager]
    H --> I{Manager Decision}
    I -- Reject --> J[Set Status: Rejected] --> Z([End])
    I -- Approve --> K[Set Status: Approved]
    K --> L[Update Mission Status: Ready for Dispatch]
    L --> Z([End])
```

## 4. Service-Level BPMN — Dispatch
```mermaid
flowchart TD
    A([Start]) --> B[Receive Approved Mission]
    B --> C[Load Available Drivers]
    C --> D[Load Available Vehicles]
    D --> E{Driver available?}
    E -- No --> E1[Wait / Re-check Pool] --> C
    E -- Yes --> F{Vehicle available?}
    F -- No --> F1[Re-check Vehicles] --> D
    F -- Yes --> G[Check Driver Insurance]
    G --> H{Valid Insurance?}
    H -- No --> H1[Reject Driver] --> C
    H -- Yes --> I[Assign Driver]
    I --> J[Assign Vehicle]
    J --> K[Create Mission Assignment]
    K --> L([End])
```

## 5. Service-Level BPMN — Execution
```mermaid
flowchart TD
    A([Start Mission Execution]) --> B[Driver Starts Mission]
    B --> C[Record Entry Time]
    C --> D[Travel in Progress]
    D --> E[Record Exit Time]
    E --> F[Record Mileage Start]
    F --> G[Record Mileage End]
    G --> H[Calculate Total KM]
    H --> I[Calculate Duration]
    I --> J{Mission Type?}
    J -- Urban --> K[Hourly Calculation Logic]
    J -- Outbound --> L[KM + Sleep Calculation Logic]
    K --> M[Create Execution Record]
    L --> M
    M --> N[Send to Finance Service]
    N --> O([End])
```

## 6. Service-Level BPMN — Finance
```mermaid
flowchart TD
    A([Start Finance Process]) --> B[Receive Execution Record]
    B --> C[Load Contract Rules]
    C --> D[Calculate KM Cost]
    D --> E[Calculate Hourly Cost]
    E --> F[Calculate Sleep Cost]
    F --> G[Apply Penalties / Extra Fees]
    D --> H[Aggregate Total Cost]
    E --> H
    F --> H
    G --> H
    H --> I[Store Mission Cost Record]
    I --> J{End of Month?}
    J -- No --> Z([End])
    J -- Yes --> K[Aggregate Driver Missions]
    K --> L[Calculate Payroll]
    L --> M[Generate Settlement Sheet]
    M --> Z([End])
```

## 7. Open Questions / TODO
- Air travel specifics
- Multi-step approval across organizational hierarchy
- Special organization-specific finance flows
