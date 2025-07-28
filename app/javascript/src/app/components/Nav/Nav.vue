<template>
    <header class="bg-white">
      <nav class="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8" aria-label="Global">
        <div class="flex lg:flex-1">
          <router-link to="/" class="-m-1.5 p-1.5">
            <span class="sr-only">Your Company</span>
            <ChatBubbleLeftRightIcon class="size-6" aria-hidden="true" />
          </router-link>
        </div>
        <div class="flex lg:hidden">
          <button type="button" class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700" @click="mobileMenuOpen = true">
            <span class="sr-only">Open main menu</span>
            <Bars3Icon class="size-6" aria-hidden="true" />
          </button>
        </div>
        <PopoverGroup class="hidden lg:flex lg:gap-x-12">
          <Popover class="relative">
            <PopoverButton class="flex items-center gap-x-1 text-sm/6 font-semibold text-gray-900">
              Menu
              <ChevronDownIcon class="size-5 flex-none text-gray-400" aria-hidden="true" />
            </PopoverButton>
  
            <transition enter-active-class="transition ease-out duration-200" enter-from-class="opacity-0 translate-y-1" enter-to-class="opacity-100 translate-y-0" leave-active-class="transition ease-in duration-150" leave-from-class="opacity-100 translate-y-0" leave-to-class="opacity-0 translate-y-1">
              <PopoverPanel class="absolute left-1/2 z-10 mt-3 w-screen max-w-md -translate-x-1/2 overflow-hidden rounded-3xl bg-white shadow-lg ring-1 ring-gray-900/5">
                <div class="p-4">
                  <div v-for="item in actions" :key="item.name" class="group relative flex items-center gap-x-6 rounded-lg p-4 text-sm/6 hover:bg-gray-50">
                    <div class="flex size-11 flex-none items-center justify-center rounded-lg bg-gray-50 group-hover:bg-white">
                      <component :is="item.icon" class="size-6 text-gray-600 group-hover:text-indigo-600" aria-hidden="true" />
                    </div>
                    <div class="flex-auto">
                      <a :href="item.href" class="block font-semibold text-gray-900">
                        {{ item.name }}
                        <span class="absolute inset-0" />
                      </a>
                      <p class="mt-1 text-gray-600">{{ item.description }}</p>
                    </div>
                  </div>
                </div>
              </PopoverPanel>
            </transition>
          </Popover>
  
          <a href="/admin" v-if="userStore.isAdmin" class="text-sm/6 font-semibold text-gray-900">
            Admin Panel
          </a>
          <a href="#" v-if="!userStore.isAdmin" class="text-sm/6 font-semibold text-gray-300">
            Admin Panel
          </a>
        </PopoverGroup>
        <div class="hidden lg:flex lg:flex-1 lg:justify-end">
          <!-- Logged out state -->
          <div v-if="!userStore.isLoggedIn" class="flex items-center gap-4">
            <router-link to="/sign_in" class="text-sm/6 font-semibold text-gray-900 hover:text-gray-700">
              Log in
            </router-link>
            <router-link to="/sign_up" class="text-sm/6 font-semibold text-white bg-indigo-600 px-4 py-2 rounded-md hover:bg-indigo-700">
              Register
            </router-link>
          </div>
          
          <!-- Logged in state -->
          <div v-else class="flex items-center gap-4">
            <span class="text-sm/6 text-gray-900">
              Welcome, {{ userStore.currentUser?.name || 'User' }}
            </span>
            <button 
              @click="handleLogout" 
              class="text-sm/6 font-semibold text-gray-900 hover:text-gray-700"
              :disabled="userStore.loading"
            >
              {{ userStore.loading ? 'Logging out...' : 'Log out' }}
            </button>
          </div>
        </div>
      </nav>
      <Dialog class="lg:hidden" @close="mobileMenuOpen = false" :open="mobileMenuOpen">
        <div class="fixed inset-0 z-50" />
        <DialogPanel class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-white p-6 sm:max-w-sm sm:ring-1 sm:ring-gray-900/10">
          <div class="flex items-center justify-between">
            <a href="#" class="-m-1.5 p-1.5">
              <span class="sr-only">Chatter Box</span>
              <ChatBubbleLeftRightIcon class="size-6" aria-hidden="true" />
            </a>
            <button type="button" class="-m-2.5 rounded-md p-2.5 text-gray-700" @click="mobileMenuOpen = false">
              <span class="sr-only">Close menu</span>
              <XMarkIcon class="size-6" aria-hidden="true" />
            </button>
          </div>
          <div class="mt-6 flow-root">
            <div class="-my-6 divide-y divide-gray-500/10">
              <div class="space-y-2 py-6">
                <Disclosure as="div" class="-mx-3" v-slot="{ open }">
                  <DisclosureButton class="flex w-full items-center justify-between rounded-lg py-2 pr-3.5 pl-3 text-base/7 font-semibold text-gray-900 hover:bg-gray-50">
                    Menu
                    <ChevronDownIcon :class="[open ? 'rotate-180' : '', 'size-5 flex-none']" aria-hidden="true" />
                  </DisclosureButton>
                  <DisclosurePanel class="mt-2 space-y-2">
                    <DisclosureButton v-for="item in actions" :key="item.name" as="a" :href="item.href" class="block rounded-lg py-2 pr-3 pl-6 text-sm/7 font-semibold text-gray-900 hover:bg-gray-50">{{ item.name }}</DisclosureButton>
                  </DisclosurePanel>
                  <a href="/admin" v-if="userStore.isAdmin" class="block rounded-lg py-2 pr-3 pl-3 text-sm/7 font-semibold text-gray-900 hover:bg-gray-50">
                    Admin Panel
                  </a>
                  <a href="#" v-if="!userStore.isAdmin" class="block rounded-lg py-2 pr-3 pl-3 text-sm/7 font-semibold text-gray-300 hover:bg-gray-50">
                    Admin Panel
                  </a>
                </Disclosure>
              </div>
              <div class="py-6">
                <!-- Logged out state -->
                <div v-if="!userStore.isLoggedIn" class="space-y-2">
                  <router-link to="/sign_in" class="-mx-3 block rounded-lg px-3 py-2.5 text-base/7 font-semibold text-gray-900 hover:bg-gray-50">
                    Log in
                  </router-link>
                  <router-link to="/sign_up" class="-mx-3 block rounded-lg px-3 py-2.5 text-base/7 font-semibold text-white bg-indigo-600 hover:bg-indigo-700">
                    Register
                  </router-link>
                </div>
                
                <!-- Logged in state -->
                <div v-else class="space-y-2">
                  <div class="-mx-3 block rounded-lg px-3 py-2.5 text-base/7 text-gray-900">
                    Welcome, {{ userStore.currentUser?.username || 'User' }}
                  </div>
                  <button 
                    @click="handleLogout" 
                    class="-mx-3 block w-full text-left rounded-lg px-3 py-2.5 text-base/7 font-semibold text-gray-900 hover:bg-gray-50"
                  >
                    Log out
                  </button>
                </div>
              </div>
            </div>
          </div>
        </DialogPanel>
      </Dialog>
    </header>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { useUserStore } from '@/src/global/stores/UserStore'

  import {
    Dialog,
    DialogPanel,
    Disclosure,
    DisclosureButton,
    DisclosurePanel,
    Popover,
    PopoverButton,
    PopoverGroup,
    PopoverPanel,
  } from '@headlessui/vue'
  import {
    Bars3Icon,
    XMarkIcon,
    ChatBubbleLeftRightIcon,
    BookOpenIcon,
    PencilIcon,
  } from '@heroicons/vue/24/outline'
  import { ChevronDownIcon } from '@heroicons/vue/20/solid'
  
  const userStore = useUserStore()
  
  const actions = [
    { name: 'My Posts', description: 'View your posts', href: '/posts', icon: BookOpenIcon },
    { name: 'Create Post', description: 'Create a new post', href: '/posts/new', icon: PencilIcon },
  ]
  
  const mobileMenuOpen = ref(false)
  
  const handleLogout = async () => {
    await userStore.logout()
    mobileMenuOpen.value = false

    await userStore.fetchCurrentUser()
  }
  </script>