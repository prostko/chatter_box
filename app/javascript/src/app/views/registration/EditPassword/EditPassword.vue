<template>
    <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <ChatBubbleLeftRightIcon class="mx-auto h-10 w-auto size-15" aria-hidden="true" />
        <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Set your new password</h2>
      </div>
  
      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
        <form class="space-y-6" @submit.prevent="handleSubmit">
          <div v-if="email">
            <label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
            <div class="mt-2">
              <input 
                type="email" 
                name="email" 
                id="email" 
                :value="email"
                disabled
                class="block w-full rounded-md bg-gray-100 px-3 py-1.5 text-base text-gray-500 outline-1 -outline-offset-1 outline-gray-300 sm:text-sm/6" />
            </div>
          </div>
  
          <div>
            <label for="password" class="block text-sm/6 font-medium text-gray-900">New Password</label>
            <div class="mt-2">
              <input 
                type="password" 
                name="password" 
                id="password" 
                autocomplete="new-password" 
                required="true"
                v-model="password"
                class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6" />
            </div>
          </div>
  
          <div>
            <label for="password_confirmation" class="block text-sm/6 font-medium text-gray-900">Confirm New Password</label>
            <div class="mt-2">
              <input 
                type="password" 
                name="password_confirmation" 
                id="password_confirmation" 
                autocomplete="new-password" 
                required="true"
                v-model="passwordConfirmation"
                class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6" />
            </div>
          </div>
  
          <div v-if="error" class="text-red-600 text-sm">
            {{ error }}
          </div>
  
          <div>
            <button 
              type="submit" 
              :disabled="loading"
              class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:opacity-50 disabled:cursor-not-allowed">
              {{ loading ? 'Updating password...' : 'Update password' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ChatBubbleLeftRightIcon } from '@heroicons/vue/24/outline';
  import { ref, onMounted } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import api from '@/src/global/services/api';
  
  const router = useRouter();
  const route = useRoute();
  const email = ref('');
  const password = ref('');
  const passwordConfirmation = ref('');
  const loading = ref(false);
  const error = ref('');
  
  onMounted(() => {
    // Get email from query parameter
    if (route.params.email) {
      email.value = route.params.email;
    }
  });
  
  const handleSubmit = async () => {
    if (!password.value || !passwordConfirmation.value) {
      error.value = 'Please fill in all fields';
      return;
    }
  
    if (password.value !== passwordConfirmation.value) {
      error.value = 'Passwords do not match';
      return;
    }
  
    loading.value = true;
    error.value = '';
  
    try {
      const response = await api.patch("/password", {
        email: email.value,
        password: password.value,
        password_confirmation: passwordConfirmation.value,
      });
      
      router.push('/sign_in');
    } catch (err) {
      console.error('Password update error:', err);
      debugger
      if (err.response?.data?.errors.length > 0) {
        error.value = err.response.data.errors.join('\n');
      } else if (err.response?.status === 422) {
        error.value = 'Invalid input. Please check your information.';
      } else {
        error.value = 'An error occurred. Please try again.';
      }
    } finally {
      loading.value = false;
    }
  };
  </script>