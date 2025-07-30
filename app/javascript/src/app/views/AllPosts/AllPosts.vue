<template>
    <ul role="list" class="divide-y divide-gray-100">
      <li v-for="post in posts" :key="post.id" class="flex items-center justify-between gap-x-6 py-5">
        <div class="min-w-0">
          <div class="flex items-start gap-x-3">
            <p class="text-sm/6 font-semibold text-gray-900">{{ post.title }}</p>
            <RatingStars class="mt-0.5 rounded-md px-1.5 py-0.5 text-xs whitespace-nowrap" :post-id="post.id" />
        </div>
          <div class="mt-1 flex items-center gap-x-2 text-xs/5 text-gray-500">
            <p class="whitespace-nowrap">
              <time :datetime="post.published_at">{{ post.published_date }}</time>
            </p>
            <svg viewBox="0 0 2 2" class="size-0.5 fill-current">
              <circle cx="1" cy="1" r="1" />
            </svg>
            <p class="truncate">by {{ post.authors.map(author => author.username).join(', ') }}</p>
          </div>
        </div>
        <div class="flex flex-none items-center gap-x-4" v-if="post.can_edit">
          <Menu as="div" class="relative flex-none">
            <MenuButton class="relative block text-gray-500 hover:text-gray-900">
              <span class="absolute -inset-2.5" />
              <span class="sr-only">Open options</span>
              <EllipsisVerticalIcon class="size-5" aria-hidden="true" />
            </MenuButton>
            <transition enter-active-class="transition ease-out duration-100" enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100" leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100" leave-to-class="transform opacity-0 scale-95">
              <MenuItems class="absolute right-0 z-10 mt-2 w-32 origin-top-right rounded-md bg-white py-2 shadow-lg ring-1 ring-gray-900/5 focus:outline-hidden">
                <MenuItem v-slot="{ active }">
                  <a href="#" :class="[active ? 'bg-gray-50 outline-hidden' : '', 'block px-3 py-1 text-sm/6 text-gray-900']"
                    >Edit<span class="sr-only">, {{ post.title }}</span></a>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <a href="#" :class="[active ? 'bg-gray-50 outline-hidden' : '', 'block px-3 py-1 text-sm/6 text-gray-900']"
                    >Delete<span class="sr-only">, {{ post.title }}</span></a
                  >
                </MenuItem>
              </MenuItems>
            </transition>
          </Menu>
        </div>
      </li>
    </ul>
    <div class="flex justify-center">
      <button
        class="bg-blue-500 text-white px-4 py-2 rounded-md"
        @click="loadMore"
        v-if="posts.length < totalPosts">
        Load more
      </button>
    </div>
</template>
  
<script setup>
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { EllipsisVerticalIcon } from '@heroicons/vue/20/solid'
import RatingStars from '@/src/app/components/RatingStars/RatingStars.vue';
import api from '@/src/global/services/api';
import { ref, onMounted } from 'vue';
import { useUserStore } from '@/src/global/stores/UserStore'

const userStore = useUserStore()

const posts = ref([]);

const page = ref(1);
const perPage = ref(10);
const totalPosts = ref(0);

const getPosts = async () => {
    const response = await api.get('/api/v1/posts', {
        params: {
            page: page.value,
            per_page: perPage.value
        },
    });

    response.data.posts.forEach(post => {
        posts.value.push(post);
    });
    if (response.headers['x-total-count']) {
        totalPosts.value = response.headers['x-total-count'];
    }
};

const loadMore = () => {
    page.value++;
    getPosts();
};

onMounted(() => {
    getPosts();
});
  
const statuses = {
  Complete: 'text-green-700 bg-green-50 ring-green-600/20',
  'In progress': 'text-gray-600 bg-gray-50 ring-gray-500/10',
  Archived: 'text-yellow-800 bg-yellow-50 ring-yellow-600/20',
}

</script>

<style scoped>
</style>