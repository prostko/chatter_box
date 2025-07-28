<template>
    <Nav />
    
    <div class="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
      <PostForm @submit="handleSubmit" />
    </div>
  </template>
  
  <script setup>
  import Nav from '@/src/app/components/Nav/Nav.vue';
  import { ref, onMounted } from 'vue'
  import { useUserStore } from '@/src/global/stores/UserStore'
  import { useRouter } from 'vue-router'
  import api from '@/src/global/services/api'
  import PostForm from '@/src/app/components/forms/PostForm.vue'
  
  const userStore = useUserStore()
  const router = useRouter()

  const title = ref('')
  const body = ref('')
  const errors = ref({})

  onMounted(async () => {
    if (!userStore.user) {
      await userStore.fetchCurrentUser()
    }
  })

  const validateTitle = () => {
    const message = 'Title must be less than 100 characters'
    if (title.value.length > 100) {
      errors.value.title = message
    } else {
      delete errors.value.title
    }
  }

  const validateBody = () => {
    const message = 'Body must be less than 1000 char   acters'
    if (body.value.length > 1000) { 
      errors.value.body = message
    } else {
      delete errors.value.body
    }
  }

  const handleSubmit = async (post) => {
    const response = await api.post(`/api/v1/users/${userStore.user.id}/posts`, post)
    console.log(response)
    router.push(`/posts/${response.data.post.id}`)
  }
  </script>