<template>
    <div 
        :id="`rating-stars-container-${postId}`"
        :class="[
            'bg-white shadow-lg sm:rounded-lg absolute border-1 border-gray-300 left-0 min-w-96 min-h-25',
            { 'border-2 border-green-500': success }
        ]">
        <div class="px-4 py-5 sm:p-6">
          <h3 class="text-base font-semibold text-gray-900">Rate this post</h3>
          <div class="mt-2 max-w-xl text-sm text-gray-500">
                <span 
                    v-for="star in 5" 
                    :key="star"
                    :class="['star-container', hoverStarClass(star)]" 
                    @mouseover="hoverStar(star)" 
                    @mouseleave="hoverStar(0)"
                    @click="setRating(star)"
                >
                    <span>★</span>
                </span>
          </div>
        </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref, computed } from 'vue'
import api from '@/src/global/services/api'
import { useUserStore } from '@/src/global/stores/UserStore'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()

const props = defineProps({
    postId: {
        type: Number,
        required: true,
        default: 0,
    },
})

const hoverStarRating = ref(0)
const ratingId = ref(null)
const usersRating = ref(null)
const success = ref(false)

const hoverStarClass = (index) => {
    const starToUse = hoverStarRating.value > 0 ? hoverStarRating.value : usersRating.value
    if (index <= starToUse) { 
        return 'star-filled'
    }
    return ''
}

const hoverStar = (star) => {
    hoverStarRating.value = star
}   

const emits = defineEmits(['close', 'update:rating'])

const close = () => {
    emits('close')
}

const clickOutside = (event) => {
    const clickOnEdit = event.target.closest(`#rating-stars-${props.postId}`)
    const clickOnPopover = event.target.closest(`#rating-stars-container-${props.postId}`)
    if (clickOnEdit || clickOnPopover) {
        return
    }
    close()
}
onMounted(async () => {
    document.addEventListener('click', clickOutside)
    if (userStore.user?.id) {
        const response = await api.get(`/api/v1/users/${userStore.user.id}/posts/${props.postId}/rating`)
        if (response.status === 200) {
            const { rating: { id, rating } } = response.data
            ratingId.value = id
            usersRating.value = rating
        }
    }
})

onUnmounted(() => {
    document.removeEventListener('click', clickOutside)
})

const setRating = async (star) => {
    if (!userStore.user?.id) {
        router.push('/sign_in')
        return
    }

    let response
    if(ratingId.value) { 
        response = await updateRating(star)
    } else {
        response = await createRating(star)
    }

    if ([200, 201].includes(response.status)) {
        const {rating: { id, rating }} = response.data

        if (rating) {
            ratingId.value = id
            usersRating.value = rating
        }

        emits('update:rating', rating)

        success.value = true
        setTimeout(() => {
            success.value = false
            close()
        }, 100)
    }
}

const updateRating = (star) => {
    return api.put(`/api/v1/users/${userStore.currentUser.id}/posts/${props.postId}/rating`, {
        rating: star
    })
}

const createRating = (star) => {
    return api.post(`/api/v1/users/${userStore.currentUser.id}/posts/${props.postId}/rating`, {
        rating: star
    })
}
</script>

<style scoped lang="scss">
.star-container {
  position: relative;
  display: inline-block;
  color: transparent;
}

.star-container:before {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  content: '★';
  color: lightgray;
}

.star-container:after {
  position: absolute;
  top: 0;
  left: 0;
  width: 0;
  content: '★';
  color: gold;
  overflow: hidden;
}

.star-filled:after { width: 100%; }
</style>