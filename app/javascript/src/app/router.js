import { createRouter, createWebHistory } from 'vue-router';
const Signup = () => import('@/src/app/views/registration/Signup/Signup.vue');
const Signin = () => import('@/src/app/views/registration/Signin/Signin.vue');
const Home = () => import('@/src/app/views/Home/Home.vue');
const PasswordReset = () => import('@/src/app/views/registration/PasswordReset/PasswordReset.vue');
const EditPassword = () => import('@/src/app/views/registration/EditPassword/EditPassword.vue');
const ListUserPosts = () => import('@/src/app/views/ListUserPosts/ListUserPosts.vue');
const NewUserPost = () => import('@/src/app/views/NewUserPost/NewUserPost.vue');
const EditUserPost = () => import('@/src/app/views/EditUserPost/EditUserPost.vue');
const AllPosts = () => import('@/src/app/views/AllPosts/AllPosts.vue');

import { useUserStore } from '@/src/global/stores/UserStore.js';
import { createPinia } from 'pinia';

// Global State
const pinia = createPinia()

const beforeEnter = async (to, from, next) => {
 const userStore = useUserStore(pinia)
  await userStore.fetchCurrentUser()
  if (userStore.isLoggedIn) {
    next()
  } else {
    next('/sign_in')
  }
}

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
      path: '/sign_up',
      name: 'signup',
      components: {
        default: Signup,
      }
    },
    {
      path: '/sign_in',
      name: 'signin',
      components: {
        default: Signin,
      }
    },
    {
      path: '/password_reset',
      name: 'password_reset',
      components: {
        default: PasswordReset,
      }
    },
    {
      path: '/password/edit/:email',
      name: 'password_edit',
      components: {
        default: EditPassword,
      }
    },
    {
      path: '/users/:userId/posts',
      name: 'posts',
      components: {
        default: ListUserPosts,
      },
      beforeEnter
    },
    {
      path: '/users/:userId/posts/new',
      name: 'newUserPost',
      components: {
        default: NewUserPost,
      },
      beforeEnter
    },
    {
      path: '/users/:userId/posts/:id/edit',
      name: 'postEdit',
      components: {
        default: EditUserPost,
      },
    },
    {
      path: '/discover',
      name: 'discover',
      components: {
        default: AllPosts,
      },
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

// Add router to Pinia stores
pinia.use(({ store }) => {
	store.router = markRaw(router)
})

export default router;