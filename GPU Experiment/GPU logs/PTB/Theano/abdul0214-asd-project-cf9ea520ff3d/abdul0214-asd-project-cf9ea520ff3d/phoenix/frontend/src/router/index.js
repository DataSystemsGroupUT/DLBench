import Vue from 'vue';
import VueRouter from 'vue-router';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import Map from '../views/Map.vue';
import Profile from "../views/Profile";

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'login',
    component: Login,
  },
  {
    path: '/signup',
    name: 'register',
    component: Register,
  },
  {
    path: '/home',
    name: 'map',
    component: Map,
  },
  {
    path: '/profile',
    name: 'profile',
    component: Profile,
  },
];

const router = new VueRouter({
  routes,
});

export default router;
