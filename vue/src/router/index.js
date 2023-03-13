import { createRouter, createWebHistory } from "vue-router";

import Home from "../views/Home.vue";
import Login from "../views/Login.vue";
import Register from "../views/Register.vue";
// import Prueba2 from "../views/Prueba2.vue";
import Project from "../views/start/Project.vue";
// import Welcome from "../views/start/Welcome.vue";
import NotFound from "../views/NotFound.vue";
import AuthLayout from "../components/core/AuthLayout.vue";
import DefaultLayout from "../components/core/DefaultLayout.vue";
// import PageLayout from "../components/Ant_PageComponent.vue";
import Restrictions from "../views/execution/Restrictions.vue";
import WhiteProject from "../views/execution/WhiteProject.vue";
import AddRestrictions from "../views/execution/AddRestrictions.vue";
import Graphic from "../views/execution/Graphic.vue";
import Person from "../views/person/Person.vue";
import Person_edit from "../views/person/Person_edit.vue";
import store from "../store";
var routes = [

  {
    path: "/auth",
    redirect: "/login",
    name: "Auth",
    component: AuthLayout,
    meta: {isGuest: true},
    children: [
      {
        path: "/login",
        name: "Login",
        component: Login,
        meta: { layout: 'login', sidebarOpen: false },
      },
      {
        path: "/register",
        name: "Register",
        component: Register,
        meta: { layout: 'register', sidebarOpen: false },
      },
    ],
  },
  {
    path: "/",
    redirect: "/Home",
    component: DefaultLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: "/Home",
        name: "Home",
        component: Home,
        meta: { layout: 'home', sidebarOpen: true },
      },
      {
        path: "/create_project",
        name: "Create_Project",
        component: Project,
        meta: { layout: 'home' , sidebarOpen: true},
      },
      {
        path: "/restrictions_analysis",
        name: "restrictions_analysis",
        component: Restrictions,
        meta: { layout: 'home' , sidebarOpen: true},
      },
      {
        path: "/white_project",
        name: "white_project",
        component: WhiteProject,
        meta: { layout: 'home' , sidebarOpen: true},
      },

      {
        path: "/addRestrictions",
        name: "add_restrictions",
        component: AddRestrictions,
        meta: { layout: 'home' , sidebarOpen: false},
      },

      {
        path: "/graphic_advance",
        name: "graphic_advance",
        component: Graphic,
        meta: { layout: 'home' , sidebarOpen: true},
      },
      {
        path: "/person",
        name: "person",
        component: Person,
        meta: { layout: 'home' , sidebarOpen: true},
      },
      {
        path: "/person_edit",
        name: "person_edit",
        component: Person_edit,
        meta: { layout: 'home' , sidebarOpen: true},
      },
      // {
      //   path: "/prueba2",
      //   name: "prueba2",
      //   component: Prueba2,
      //   meta: { layout: 'prueba2' , sidebarOpen: true},
      // },
    ],
  },
  {
    path: '/404',
    name: 'NotFound',
    component: NotFound
  }

]



const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !store.state.user.token) {
    next({ name: "Login" });
  } else if (store.state.user.token && to.meta.isGuest) {
    next({ name: "Home" });
  } else {
    next();
  }
});

export default router;
