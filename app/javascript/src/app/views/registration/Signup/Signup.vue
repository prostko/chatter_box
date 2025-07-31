<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <ChatBubbleLeftRightIcon class="mx-auto h-10 w-auto size-15" aria-hidden="true" />
      <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-gray-900">Create your account</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form class="space-y-6" @submit.prevent="handleSubmit">
        <div>
          <label for="username" class="block text-sm/6 font-medium text-gray-900">Username</label>
          <div class="mt-2">
            <input 
              type="text" 
              name="username" 
              id="username" 
              autocomplete="username" 
              required="true" 
              v-model="username"
              class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6" />
          </div>
        </div>

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
          <label for="password" class="block text-sm/6 font-medium text-gray-900">Password</label>
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
          <label for="password_confirmation" class="block text-sm/6 font-medium text-gray-900">Confirm Password</label>
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
            {{ loading ? 'Creating account...' : 'Create account' }}
          </button>
        </div>
      </form>

      <p class="mt-10 text-center text-sm/6 text-gray-500">
        Already have an account?
        {{ ' ' }}
        <router-link to="/sign_in" class="font-semibold text-indigo-600 hover:text-indigo-500">Sign in</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ChatBubbleLeftRightIcon } from '@heroicons/vue/24/outline';
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/src/global/services/api';

const router = useRouter();
const email = ref('');
const username = ref('');
const password = ref('');
const passwordConfirmation = ref('');
const loading = ref(false);
const error = ref('');

const handleSubmit = async () => {
  if (!username.value || !email.value || !password.value || !passwordConfirmation.value) {
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
    const response = await api.post('/sign_up', {
      username: username.value,
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirmation.value
    });

    router.push('/home');
  } catch (err) {
    console.error('Sign up error:', err);
    
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