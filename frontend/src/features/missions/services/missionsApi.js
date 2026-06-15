import { httpClient } from '../../../shared/api/httpClient'

export const missionsApi = {
  missionRequests: '/mission-requests',
  assignments: '/mission-assignments',
  executions: '/mission-executions',
  client: httpClient
}
