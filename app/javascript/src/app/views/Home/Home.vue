<template>
  <div>
    <Nav />
    
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div 
        class="lg:col-span-2 lg:col-start-1 lg:row-start-1 lg:mx-auto lg:grid lg:w-full lg:max-w-7xl lg:grid-cols-2 lg:gap-x-8 lg:px-0">
        <div class="lg:pr-4">
          <div class="lg:max-w-lg">
            <p class="text-base/7 font-semibold text-indigo-600">Discover</p>
            <h1 class="mt-2 text-4xl font-semibold tracking-tight text-pretty text-gray-900 sm:text-5xl">ChatterBox</h1>
          </div>
        </div>
      </div>
        <AllPosts />
    </div>
  </div>
</template>

<script setup>
import Nav from '@/src/app/components/Nav/Nav.vue';
import AllPosts from '@/src/app/views/AllPosts/AllPosts.vue';
</script>
