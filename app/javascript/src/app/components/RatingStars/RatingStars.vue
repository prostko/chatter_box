<template>
    <div 
        :id="`rating-stars-${postId}`"
        class="flex items-center relative z-10" 
        @click.prevent="showRatingModal = true">
        <div v-if="ratingCount === 0">
            <span class="text-xs text-gray-500 z-10">No ratings yet</span>
        </div>
        <div v-else>
            <span :class="['stars-container', starClass(rating)]">★★★★★</span>
            <span class="ml-2 text-xs text-gray-500">{{ rating }} stars from {{ ratingCount }} reviews</span>
        </div>

        <transition enter-active-class="transition ease-out duration-100" enter-from-class="opacity-0 translate-y-1" enter-to-class="opacity-100 translate-y-0" leave-active-class="transition ease-in duration-150" leave-from-class="opacity-100 translate-y-0" leave-to-class="opacity-0 translate-y-1">
            <EditRatingStars 
            class="z-50 absolute" 
            v-if="showRatingModal" 
            :post-id="postId" 
            @update:rating="updateRating"
            @close="showRatingModal = false"
            />
        </transition>
        
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '@/src/global/services/api'
import EditRatingStars from '@/src/app/components/RatingStars/EditRatingStars.vue'

const props = defineProps({
    postId: {
        type: Number,
        required: true,
        default: 0,
    },
})

const rating = ref(0)
const ratingCount = ref(0)

const starClass = (rating) => {
    const ratingOutOf100 = rating * 20.0
    const modulo = ratingOutOf100 % 10 
    const starClass = `stars-${ratingOutOf100 - modulo}`
    return starClass
}

const showRatingModal = ref(false)

onMounted(() => {
    getRatingsForPost()
})

const getRatingsForPost = async () => {
    const response = await api.get(`/api/v1/posts/${props.postId}/ratings`)
    if (response.status === 200) {
        const { average_rating, rating_count } = response.data
        rating.value = average_rating
        ratingCount.value = rating_count
    }
}

const updateRating = () => {
    getRatingsForPost()
}
</script>

<style scoped lang="scss">
.stars-container {
  font-size: 18px;
  position: relative;
  display: inline-block;
  color: transparent;
}

.stars-container:before {
  position: absolute;
  top: 0;
  left: 0;
  content: '★★★★★';
  color: lightgray;
}

.stars-container:after {
  position: absolute;
  top: 0;
  left: 0;
  content: '★★★★★';
  color: gold;
  overflow: hidden;
}

.stars-0:after { width: 0%; }
.stars-10:after { width: 10%; }
.stars-20:after { width: 20%; }
.stars-30:after { width: 30%; }
.stars-40:after { width: 40%; }
.stars-50:after { width: 50%; }
.stars-60:after { width: 60%; }
.stars-70:after { width: 70%; }
.stars-80:after { width: 80%; }
.stars-90:after { width: 90%; }
.stars-100:after { width: 100; }
</style>