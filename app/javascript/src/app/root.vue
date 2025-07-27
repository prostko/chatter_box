<template>
  <div>
    <router-view />
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useUserStore } from '@/src/global/stores/UserStore'

const userStore = useUserStore()

onMounted(async () => {
  // Initialize user session on app mount
  await userStore.fetchCurrentUser()
})
</script>
 
<style lang="scss">
</style>