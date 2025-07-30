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
              @click="router.push(`/users/${userStore.user.id}/posts/new?showToast=true`)"
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
              <RatingStars :post-id="post.id" />
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

        <div class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
            <div class="flex flex-1 justify-between sm:hidden">
              <a href="#" class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                Previous
              </a>
              <a href="#" class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                Next
              </a>
            </div>
            <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
              <div>
                <p class="text-sm text-gray-700">
                  Showing
                  {{ ' ' }}
                  <span class="font-medium">{{ page }}</span>
                  {{ ' ' }}
                  to
                  {{ ' ' }}
                  <span class="font-medium">{{ perPage }}</span>
                  {{ ' ' }}
                  of
                  {{ ' ' }}
                  <span class="font-medium">{{ totalPostCount }}</span>
                  {{ ' ' }}
                  results
                </p>
              </div>
              <div>
                <nav class="isolate inline-flex -space-x-px rounded-md shadow-xs" aria-label="Pagination">
                  <button
                    @click="previousPage"
                    class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-gray-300 ring-inset hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                    <span class="sr-only">Previous</span>
                    <ChevronLeftIcon class="size-5" aria-hidden="true" />
                  </button>
                  <template v-for="pageNum in pageNumberWindow" :key="pageNum">
                    <button
                      v-if="pageNum !== '...'"
                      @click="goToPage(pageNum)"
                      :class="[
                        'relative inline-flex items-center px-4 py-2 text-sm font-semibold ring-1 ring-gray-300 ring-inset hover:bg-gray-50 focus:z-20 focus:outline-offset-0',
                        pageNum === page 
                          ? 'z-10 bg-indigo-600 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600'
                          : 'text-gray-900'
                      ]"
                    >
                      {{ pageNum }}
                    </button>
                    <span
                      v-else
                      class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 ring-1 ring-gray-300 ring-inset focus:outline-offset-0"
                    >
                      ...
                    </span>
                  </template>
                  <button
                    @click="nextPage"
                    class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-gray-300 ring-inset hover:bg-gray-50 focus:z-20 focus:outline-offset-0"
                   >
                    <span class="sr-only">Next</span>
                    <ChevronRightIcon class="size-5" aria-hidden="true" />
                  </button>
                </nav>
              </div>
            </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup> 
  import { onMounted, ref, computed } from 'vue';
  import { useRouter } from 'vue-router';
  import api from '@/src/global/services/api';
  import { useUserStore } from '@/src/global/stores/UserStore';
  import Nav from '@/src/app/components/Nav/Nav.vue';
  import RatingStars from '@/src/app/components/RatingStars/RatingStars.vue';
  import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/20/solid'

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
    if (response.headers['x-total-count']) {
      totalPostCount.value = parseInt(response.headers['x-total-count'])
    }

    posts.value = response.data.posts || []
  }

  const goToPage = (pageNum) => {
    page.value = pageNum
    loadPosts()
  }

  const nextPage = () => {
    page.value += 1
    loadPosts()
  }

  const previousPage = () => {
    page.value -= 1
    loadPosts()
  }

  const pageNumberWindow = computed(() => {
    const windowSize = 5
    const currentPage = page.value
    
    const totalPages = Math.ceil(totalPostCount.value / perPage.value)
    if (totalPages <= windowSize) {
      return Array.from({length: totalPages}, (_,i) => i + 1)
    }

    // Calculate the start and end of the window
    let start = Math.max(1, currentPage - Math.floor(windowSize / 2))
    let end = Math.min(totalPages, start + windowSize - 1)
    
    // Adjust start if we're near the end
    if (end === totalPages) {
      start = Math.max(1, end - windowSize + 1)
    }
    
    const pages = []
    
    // Always include page 1
    if (start > 1) {
      pages.push(1)
      if (start > 2) {
        pages.push('...')
      }
    }
    
    // Add the window pages
    for (let i = start; i <= end; i++) {
      pages.push(i)
    }
    
    // Always include the last page
    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.push('...')
      }
      pages.push(totalPages)
    }
    
    return pages
  })


  </script>