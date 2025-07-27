<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <ChatBubbleLeftRightIcon class="mx-auto h-10 w-auto size-15" aria-hidden="true" />
      <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Sign in to your account</h2>
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

        <div>
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm/6 font-medium text-gray-900">Password</label>
            <div class="text-sm">
              <a href="/password_reset" class="font-semibold text-indigo-600 hover:text-indigo-500">Forgot password?</a>
            </div>
          </div>
          <div class="mt-2">
            <input 
              type="password" 
              name="password" 
              id="password" 
              autocomplete="current-password" 
              required="true"
              v-model="password"
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

      <p class="mt-10 text-center text-sm/6 text-gray-500">
        Not a member?
        {{ ' ' }}
        <router-link to="/sign_up" class="font-semibold text-indigo-600 hover:text-indigo-500">Sign up</router-link>
      </p>
    </div>
  </div>
</template>


<script setup>
import { ChatBubbleLeftRightIcon } from '@heroicons/vue/24/outline';
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/src/global/services/api';
import { useUserStore } from '@/src/global/stores/UserStore';

const userStore = useUserStore();
const router = useRouter();
const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');

const handleSubmit = async () => {
  if (!email.value || !password.value) {
    error.value = 'Please fill in all fields';
    return;
  }

  loading.value = true;
  error.value = '';

  try {
    const response = await api.post('/sign_in', {
      email: email.value,
      password: password.value
    });

    // Handle successful sign in
    console.log('Sign in successful:', response.data);
    
    // Redirect to home page or dashboard
    router.push('/home');
  } catch (err) {
    console.error('Sign in error:', err);
    
    if (err.response?.data?.error) {
      error.value = err.response.data.error;
    } else if (err.response?.status === 422) {
      error.value = 'Invalid email or password';
    } else {
      error.value = 'An error occurred. Please try again.';
    }
  } finally {
    loading.value = false;
    userStore.fetchCurrentUser()
  }
};
</script>