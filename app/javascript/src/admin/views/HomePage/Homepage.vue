<template>
    <div>
      <h3 class="text-base font-semibold text-gray-900">Global Stats</h3>
      <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
        <div v-for="item in statRollup" :key="item.name" class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow-sm sm:p-6">
          <dt class="truncate text-sm font-medium text-gray-500">{{ item.name }}</dt>
          <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">{{ item.stat }}</dd>
        </div>
      </dl>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue'
  import api from '@/src/global/services/api'

  const stats = ref({
    total_users: {
        name: 'Total Users',
        stat: 0,
    },
  })

  const statRollup = computed(() => {
    return Object.keys(stats.value).reduce((acc, key) => {
        acc.push(stats.value[key])
        return acc
    }, [])
  })

  onMounted(async () => {
    await api.get('/admin_api/v1/users')
      .then(response => {
        console.log(response.data.length)
        stats.value.total_users.stat = response.data.length    
      })
      .catch(error => {
        console.error(error)
      })
  })
  </script>