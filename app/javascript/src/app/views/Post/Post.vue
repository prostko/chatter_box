<template>
  <Nav />

  <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
    <div class="divide-y divide-gray-200 overflow-hidden rounded-lg bg-white shadow-sm mt-5">
    <div class="px-4 py-5 sm:px-6">
      <p class="text-base/7 font-semibold text-indigo-600">{{ authorsList }}</p> 
      <h1 class="mt-2 text-4xl font-semibold tracking-tight text-pretty text-gray-900 sm:text-5xl">{{ post.title }}</h1>
    </div>
    <div class="px-4 py-5 sm:p-6">
      <div class="grid max-w-xl grid-cols-1 gap-8 text-base/7 text-gray-700 lg:max-w-none lg:grid-cols-2">
          <div>
            <p>{{ post.body }}</p>
          </div>
          <div>
          </div>
        </div>
    </div>
    <div class="px-4 py-4 sm:px-6">        
        <div class="flex flex-row items-center gap-x-2">
          <span class="text-xs text-gray-500">{{ post.view_count || 0 }} views</span>
          <svg viewBox="0 0 2 2" class="size-0.5 fill-current">
              <circle cx="1" cy="1" r="1" />
            </svg>
          <RatingStars :post-id="route.params.postId" />
        </div>
    </div>
  </div>
</div>
  

</template>

<script setup>
import Nav from '@/src/app/components/Nav/Nav.vue';
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import api from '@/src/global/services/api';
import RatingStars from '@/src/app/components/RatingStars/RatingStars.vue';

const route = useRoute();
const post = ref({});

const authorsList = computed(() => {
  return post.value?.authors?.map(author => author.username).join(', ') || '';
});

onMounted(() => {
  const postId = route.params.postId;
  if (postId) {
    api.get(`/api/v1/posts/${postId}`)
      .then(response => {
        post.value = response.data.post;
      });

    recordView().then(() => {
      post.value.view_count = post.value.view_count + 1;
    });
  }
});

const recordView = () => {
  return api.post(`/api/v1/posts/${route.params.postId}/views`)
}
</script>
