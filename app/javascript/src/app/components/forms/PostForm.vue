<template>    
    <div class="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
    
      <form @submit.prevent="handleSubmit">
        <div class="space-y-12">
          <div class="grid grid-cols-1 gap-x-8 gap-y-10 border-b border-gray-900/10 pb-12 md:grid-cols-3">
            <div>
              <h2 class="text-base/7 font-semibold text-gray-900">{{ formTitle }}</h2>
              <p class="mt-1 text-sm/6 text-gray-600">{{ subTitle }}</p>
            </div>
          
            <div class="grid max-w-2xl grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6 md:col-span-2">
              <div class="sm:col-span-4">
                <label for="title" class="block text-sm/6 font-medium text-gray-900">Title</label>
                <div class="mt-2">
                  <div class="flex items-center rounded-md bg-white pl-3 outline-1 -outline-offset-1 outline-gray-300 focus-within:outline-2 focus-within:-outline-offset-2 focus-within:outline-indigo-600">
                    <input @input="validateTitle()" v-model="title" type="text" name="title" id="title" class="block min-w-0 grow py-1.5 pr-3 pl-1 text-base text-gray-900 placeholder:text-gray-400 focus:outline-none sm:text-sm/6" />
                  </div>
                  <p v-if="errors.title" class="text-red-500 text-sm">{{ errors.title }}</p>
                </div>
              </div>
            
              <div class="col-span-full">
                <label for="body" class="block text-sm/6 font-medium text-gray-900">Post Body</label>

                <div class="mt-2">
                  <textarea @input="validateBody()" v-model="body" name="body" id="body" rows="3" class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6" />
                  <p v-if="errors.body" class="text-red-500 text-sm">{{ errors.body }}</p>
                </div>
              </div>
            </div>
          </div>

        </div>
      
        <div class="mt-6 flex items-center justify-end gap-x-6">
          <button type="submit" class="rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Save</button>
        </div>
      </form>
    </div>

    <Teleport to="body">    
        <Toast v-if="showToast" message="Post saved successfully" @hide="showToast = false"/>
    </Teleport>
  </template>
  
  <script setup>
  import { ref, onMounted, watch } from 'vue'
  import { useUserStore } from '@/src/global/stores/UserStore'
  import Toast from '@/src/app/components/Toast/Toast.vue'

  const userStore = useUserStore()

  const title = ref('')
  const body = ref('')
  const errors = ref({})
  const showToast = ref(false)

  const emits = defineEmits(['submit'])

  const props = defineProps({
    post: {
      type: Object,
      required: false,
      default: () => ({
        title: '',
        body: ''
      })
    }, 
    formTitle: {
      type: String,
      required: false,
      default: 'New Post'
    },
    subTitle: { 
      type: String,
      required: false,
      default: 'Create a new post'
    }
  })

  onMounted(async () => {
    if (!userStore.user) {
      await userStore.fetchCurrentUser()
    }
  })

  watch(() => props.post, (newVal) => {
    title.value = newVal.title
    body.value = newVal.body
  }, { immediate: true, deep: true })

  const validateTitle = () => {
    const message = 'Title must be less than 100 characters'
    if (title.value.length > 100) {
      errors.value.title = message
    } else {
      delete errors.value.title
    }
  }

  const validateBody = () => {
    const message = 'Body must be less than 1000 characters'
    if (body.value.length > 1000) { 
      errors.value.body = message
    } else {
      delete errors.value.body
    }
  }

  const handleSubmit = async () => {
    validateTitle()
    validateBody()  
    if (Object.keys(errors.value).length > 0) {
      return
    }

    emits('submit', {
      title: title.value,
      body: body.value
    })
  }

  const triggerToast = (type, message) => {
    showToast.value = true
    setTimeout(() => {
      showToast.value = false
    }, 3000)
  }

  // Expose the triggerToast function to parent components
  defineExpose({
    triggerToast
  })
  </script>