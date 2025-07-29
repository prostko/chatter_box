<template>
<Nav />

    <div class="bg-white py-24 sm:py-32">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="sm:flex sm:items-center">
            <div class="sm:flex-auto">
              <h2 class="text-4xl font-semibold tracking-tight text-pretty text-gray-900 sm:text-5xl">From your Library</h2>
              <p class="mt-2 text-lg/8 text-gray-600">Your posts</p>
            </div>
            <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
              <button type="button" class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600" 
              @click="router.push('/posts/new')"
              v-if="userStore.user">
                Create a Post
            </button>
            </div>
        </div>

        <div class="mx-auto mt-10 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 border-t border-gray-200 pt-10 sm:mt-16 sm:pt-16 lg:mx-0 lg:max-w-none lg:grid-cols-3">
          <article v-for="post in posts" :key="post.id" class="flex max-w-xl flex-col items-start justify-between">
            <div class="flex items-center gap-x-4 text-xs">
              <time :datetime="post.created_at" class="text-gray-500">{{ post.published_date }}</time>
            </div>
            <div class="flex items-center gap-x-2">
              <RatingStars :rating="post.rating" :rating-count="post.rating_count" />
            </div>
            <div class="group relative grow">
              <h3 class="mt-3 text-lg/6 font-semibold text-gray-900 group-hover:text-gray-600">
                <a :href="post.href">
                  <span class="absolute inset-0" />
                  {{ post.title }}
                </a>
              </h3>
              <p class="mt-5 line-clamp-3 text-sm/6 text-gray-600">{{ post.body }}</p>
            </div>
          </article>
        </div>

        <div v-if="posts.length < totalPostCount" class="mt-10">
          <button class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600" 
          @click="loadMorePosts">
            Load More
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup> 
  import { onMounted, ref } from 'vue';
  import { useRouter } from 'vue-router';
  import api from '@/src/global/services/api';
  import { useUserStore } from '@/src/global/stores/UserStore';
  import Nav from '@/src/app/components/Nav/Nav.vue';
  import RatingStars from '@/src/app/components/RatingStars/RatingStars.vue';

  const userStore = useUserStore()
  const router = useRouter()

  const posts = ref([])
  const totalPostCount = ref(0)
  const page = ref(1)
  const perPage = ref(10)

  onMounted(async () => {
    if (!userStore.user) {
      await userStore.fetchCurrentUser()
    }

    loadPosts()
  })

  const loadPosts = async () => {
    const response = await api.get(`/api/v1/users/${userStore.user.id}/posts`, {
      params: {
        page: page.value,
        per_page: perPage.value
      }
    })
    totalPostCount.value += response.headers['x-total-count'] || 0

    posts.value ||= []
    response.data.posts.forEach(post => {
      posts.value.push(post)
    })
  }

  const loadMorePosts = async () => {
    page.value += 1
    loadPosts()
  }
  </script>