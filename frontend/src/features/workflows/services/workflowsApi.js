import { httpClient } from '../../../shared/api/httpClient'

export const workflowsApi = {
  definitions: '/workflow-definitions',
  instances: '/workflow-instances',
  inbox: '/workflow/inbox',
  history: '/workflow/history',
  client: httpClient
}
