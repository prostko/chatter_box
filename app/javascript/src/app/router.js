import { createRouter, createWebHistory } from 'vue-router';
const Signup = () => import('@/src/app/views/registration/Signup/Signup.vue');
const Signin = () => import('@/src/app/views/registration/Signin/Signin.vue');
const Root = () => import('@/src/app/root.vue');
const Home = () => import('@/src/app/views/Home/Home.vue');

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/home',
      name: 'home',
      components: {
        default: Home,
      }
    },
    {
      path: '/signup',
      name: 'signup',
      components: {
        default: Signup,
      }
    },
    {
      path: '/signin',
      name: 'signin',
      components: {
        default: Signin,
      }
    },
    {
      path: '/',
      name: 'root',
      components: {
        default: Home,
      },
    },
  ],
});

export default router;