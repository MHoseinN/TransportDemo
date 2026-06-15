import { createRouter, createWebHistory } from 'vue-router'
import DashboardPage from '../../features/dashboard/pages/DashboardPage.vue'
import ProvincePage from '../../features/geography/pages/ProvincePage.vue'
import CityPage from '../../features/geography/pages/CityPage.vue'
import BranchPage from '../../features/branches/pages/BranchPage.vue'
import VehiclePage from '../../features/vehicles/pages/VehiclePage.vue'
import DriverPage from '../../features/drivers/pages/DriverPage.vue'
import ContractPage from '../../features/contracts/pages/ContractPage.vue'
import MissionRequestPage from '../../features/missions/pages/MissionRequestPage.vue'

const routes = [
  { path: '/', name: 'dashboard', component: DashboardPage },
  { path: '/provinces', name: 'provinces', component: ProvincePage },
  { path: '/cities', name: 'cities', component: CityPage },
  { path: '/branches', name: 'branches', component: BranchPage },
  { path: '/vehicles', name: 'vehicles', component: VehiclePage },
  { path: '/drivers', name: 'drivers', component: DriverPage },
  { path: '/contracts', name: 'contracts', component: ContractPage },
  { path: '/mission-requests', name: 'mission-requests', component: MissionRequestPage }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
