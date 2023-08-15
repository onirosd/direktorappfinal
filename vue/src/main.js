import { createApp } from 'vue'
import store from './store'
import router from './router'
import './index.css'
import 'v-calendar/dist/style.css';
import App from './App.vue'
import VCalendar from "v-calendar";
import mitt from 'mitt';

import { library } from "@fortawesome/fontawesome-svg-core";
import { faCircle } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

library.add(faCircle);
const emitter = mitt();

const app = createApp(App);
app.component("font-awesome-icon", FontAwesomeIcon)
app.use(store);
app.use(VCalendar, {});
app.use(router);
app.provide('emitter', emitter);
app.mount('#app');  
