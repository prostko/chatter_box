<template>
    <Nav />

    <div class="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
        
        <PostForm 
            ref="postForm"
            @submit="handleSubmit" 
            :post="post"
            form-title="Edit Post"
            subTitle="Make changes to your post"
        />
    </div>
    
  </template>
  
  <script setup>
  import Nav from '@/src/app/components/Nav/Nav.vue';
  import { ref, onMounted } from 'vue'
  import { useUserStore } from '@/src/global/stores/UserStore'
  import api from '@/src/global/services/api'
  import { useRoute } from 'vue-router'
  import PostForm from '@/src/app/components/forms/PostForm.vue'

  const userStore = useUserStore()
  const route = useRoute()
  
  const postID = route.params.id

  const post = ref({title: '', body: ''})

  onMounted(async () => {
    if (!userStore.user) {
      await userStore.fetchCurrentUser()
    }

    const response = await api.get(`/api/v1/users/${userStore.user.id}/posts/${postID}`)
    post.value = response.data.post

    const toast = route.query.toast
    if (toast) {
      showToast('success', 'Post updated successfully')
    }
  })

  const postForm = ref(null)        

  const handleSubmit = async (post) => {
    const response = await api.put(`/api/v1/users/${userStore.user.id}/posts/${postID}`, post)
    post.value = response.data.post

    if (response.status === 200) {
      showToast()
    }
  }

  const showToast = () => {
    postForm.value.triggerToast('success', 'Post updated successfully')
  }
  </script>