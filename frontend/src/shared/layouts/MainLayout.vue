<template>
  <div class="app-shell">
    <aside class="sidebar">
      <strong>Transportation</strong>
      <RouterLink to="/">Dashboard</RouterLink>
      <RouterLink to="/provinces">Provinces</RouterLink>
      <RouterLink to="/cities">Cities</RouterLink>
      <RouterLink to="/branches">Branches</RouterLink>
      <RouterLink to="/vehicles">Vehicles</RouterLink>
      <RouterLink to="/drivers">Drivers</RouterLink>
      <RouterLink to="/contracts">Contracts</RouterLink>
      <RouterLink to="/mission-requests">Mission Requests</RouterLink>
    </aside>
    <main class="content">
      <RouterView />
    </main>
  </div>
</template>

<style scoped>
.app-shell {
  display: grid;
  grid-template-columns: 240px 1fr;
  min-height: 100vh;
  font-family: Arial, sans-serif;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 24px;
  border-right: 1px solid #e5e7eb;
}

.content {
  padding: 24px;
}
</style>
