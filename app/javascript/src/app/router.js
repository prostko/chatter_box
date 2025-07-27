import { createRouter, createWebHistory } from 'vue-router';
const Signup = () => import('@/src/app/views/registration/Signup/Signup.vue');
const Signin = () => import('@/src/app/views/registration/Signin/Signin.vue');
const Root = () => import('@/src/app/root.vue');
const Home = () => import('@/src/app/views/Home/Home.vue');
const PasswordReset = () => import('@/src/app/views/registration/PasswordReset/PasswordReset.vue');
const EditPassword = () => import('@/src/app/views/registration/EditPassword/EditPassword.vue');

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
      path: '/',
      name: 'root',
      components: {
        default: Home,
      },
    },
  ],
});

export default router;