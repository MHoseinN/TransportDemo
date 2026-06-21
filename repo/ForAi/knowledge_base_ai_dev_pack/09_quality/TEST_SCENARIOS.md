# Test Scenarios

## TS-01 Manager creates official document
Given Manager is logged in, when they create a Regulation with required fields, then it is Published and visible to all roles.

## TS-02 Supervisor creates official document
Given Supervisor is logged in, when they create a Procedure, then it becomes PendingApproval and is not visible to Operator.

## TS-03 Manager rejects document
Given a pending document exists, when Manager rejects it with reason, then it becomes Rejected and Supervisor can see rejection reason.

## TS-04 Supervisor edit request
Given a published document exists, when Supervisor edits it, then current content remains visible until Manager approves.

## TS-05 Manager edit
Given a published document exists, when Manager edits it, then changes are applied directly and audit log is created.

## TS-06 Add new version
Given a published document version 1 exists, when Manager adds version 2, then version 2 becomes current and version 1 becomes old/archived.

## TS-07 Old version warning
Given user opens old version, then warning is visible and link to latest version is displayed.

## TS-08 Search by topic
Given documents are mapped to topics, when user filters by topic, then related documents are shown.

## TS-09 Mark as read
Given user opens document, when they click Mark as Read, then KnowledgeReadLog is created.

## TS-10 External API search
Given external app calls search API, then only published/allowed documents are returned.
