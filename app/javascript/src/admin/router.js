import { createRouter, createWebHistory } from 'vue-router';
const HomePage = () => import('@/src/admin/views/HomePage/Homepage.vue');
const Users = () => import('@/src/admin/views/Users/Users.vue');
const router = createRouter({
  history: createWebHistory('/admin'),
  routes: [
    {
      path: '/',
      component: HomePage,
      name: 'home',
      default: true,
    },
    {
      path: '/users',
      component: Users,
      name: 'users',
    },
  ],
});

export default router;