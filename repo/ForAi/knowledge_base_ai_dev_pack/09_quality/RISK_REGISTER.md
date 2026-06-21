# Risk Register

| Risk | Impact | Mitigation |
|---|---|---|
| Mixing edit with versioning | High | Keep EditRequest and KnowledgeVersion separate. |
| Showing unapproved content | High | Enforce visibility in backend queries. |
| Old documents causing wrong answers | High | Strong UI warning and current version priority. |
| Rich text editor complexity | Medium | Keep MVP editor simple. |
| Full-text search in files delaying MVP | Medium | Move PDF/Word content search to phase 2. |
| External API security weakness | High | Use API key/service token and logging. |
| Category hierarchy becoming messy | Medium | Soft disable, no physical delete, audit changes. |
