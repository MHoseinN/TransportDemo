<template>
  <header class="page-header">
    <h1>{{ title }}</h1>
  </header>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  }
})
</script>

<style scoped>
.page-header {
  margin-bottom: 24px;
}

h1 {
  margin: 0;
  font-size: 24px;
}
</style>
