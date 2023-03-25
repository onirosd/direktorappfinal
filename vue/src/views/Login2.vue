<template>
  <div class="flex justify-center items-center bg-gray-100 h-screen">
    <!-- Contenedor que encierra el formulario -->
    <div class="w-full max-w-xs">
      <h1 class="text-2xl mb-4 font-bold text-center">Bienvenido a Direktor</h1>
      <h2 class="text-lg font-bold mb-4 text-center">Ingrese con sus credenciales o registrese</h2>

      <!-- Formulario para iniciar sesión -->
      <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <div class="mb-4">
          <label class="block text-gray-700 font-bold mb-2" for="username">
            Usuario
          </label>
          <input
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="username"
            type="text"
            placeholder="Ingrese su usuario"
            v-model.trim="username"
          />
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-bold mb-2" for="password">
            Contraseña
          </label>
          <input
            class="shadow appearance-none border border-red-500 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
            id="password"
            type="password"
            placeholder="******************"
            v-model.trim="password"
          />
        </div>
        <div class="flex items-center justify-between">
          <button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            type="button"
            @click.prevent="login"
          >
            Ingresar
          </button>
          <a
            class="inline-block align-baseline font-bold text-sm text-blue-500 hover:text-blue-800"
            href="/register"
          >
            Registrarse
          </a>
        </div>
      </form>
    </div>
  </div>
</template>


<script>
//  import draggable from "vuedraggable";
//  import Vue from 'vue';
//  import { LockClosedIcon } from "@vue-hero-icons/solid"
//  import VueMultiselect from 'vue-multiselect'
 import Alert from "../components/core/Alert.vue";
 import TButtonLoading from "../components/core/TButtonLoading.vue";
 import { ref } from "vue";
 import store from "../store";

 export default {
   name: "Login2",
   components: {
    // LockClosedIcon,
    Alert,
    TButtonLoading,
    // VueMultiselect,
    ref
   },
   data() {
     return {
     }
    }
  }

</script>
<style>
  /* Estilos personalizados aquí */
</style>
