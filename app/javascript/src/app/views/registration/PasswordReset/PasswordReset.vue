<template>
    <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <ChatBubbleLeftRightIcon class="mx-auto h-10 w-auto size-15" aria-hidden="true" />
        <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Reset your password</h2>
      </div>
  
      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
        <form class="space-y-6" @submit.prevent="handleSubmit">
          <div>
            <label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
            <div class="mt-2">
              <input 
                type="email" 
                name="email" 
                id="email" 
                autocomplete="email" 
                required="true" 
                v-model="email"
                class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6" />
            </div>
          </div>
  
          <div v-if="error" class="text-red-600 text-sm">
            {{ error }}
          </div>
  
          <div>
            <button type="submit" class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Sign in</button>
          </div>
        </form>
  
      </div>
    </div>
  </template>
  
  <script setup>
  import { ChatBubbleLeftRightIcon } from '@heroicons/vue/24/outline';
  import { ref } from 'vue';
  import { useRouter } from 'vue-router';
  
  const router = useRouter();
  const email = ref('');
  const error = ref('');

  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleSubmit = async () => {
    // Clear previous errors
    error.value = '';
    
    // Check if email is present
    if (!email.value) {
      error.value = 'Please enter your email address';
      return;
    }
    
    // Validate email format
    if (!validateEmail(email.value)) {
      error.value = 'Please enter a valid email address';
      return;
    }
    
    // Redirect to password edit page with email as query parameter
    router.push({
      name: 'password_edit',
      params: { email: email.value }
    });
  };
  </script>