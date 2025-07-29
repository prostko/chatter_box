<template>
    <div class="flex items-center">
        <div v-if="ratingCount === 0">
            <span class="text-xs text-gray-500">No ratings yet</span>
        </div>
        <div v-else>
            <span :class="['stars-container', starClass(rating)]">★★★★★</span>
            <span class="text-gray-500">{{ rating }} out of {{ ratingCount }}</span>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    rating: {
        type: Number,
        required: true,
        default: 0,
        validator: (value) => value >= 0 && value <= 5
    },
    ratingCount: {
        type: Number,
        required: true,
        default: 0,
    },
})

const starClass = (rating) => {
    const ratingOutOf100 = rating * 20.0
    const modulo = ratingOutOf100 % 10 
    const starClass = `stars-${ratingOutOf100 - modulo}`
    return starClass
}
</script>

<style scoped lang="scss">
.asdf { font-size: 18px; }

.stars-container {
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