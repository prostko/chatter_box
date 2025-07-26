import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
        path: '/',
        component: () => import('@/src/admin/views/HomePage/Homepage.vue'),
        default: true,
      },
  ],
});

export default router;