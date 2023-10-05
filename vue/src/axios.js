/**
 * Created by Zura on 12/25/2021.
 */
import axios from "axios";
import store from "./store";
import router from "./router";

const axiosClient = axios.create({
  // baseURL: `${import.meta.env.VITE_API_BASE_URL}/api`
  baseURL: `${import.meta.env.VITE_API_BASE_URL}/api`
})

axiosClient.interceptors.request.use(config => {
  config.headers.Authorization = `Bearer ${store.state.user.token}`
  return config;
})

axiosClient.interceptors.response.use(response => {
  return response;
}, error => {
  if (error.response) {
    switch (error.response.status) {
      case 401:
        sessionStorage.removeItem('TOKEN');
        router.push({name: 'Login'});
        break;
      case 404:
        router.push({name: 'NotFound'});
        break;
      default:
        // Aquí puedes manejar otros códigos de estado o mostrar un mensaje genérico
        console.error("Error del servidor:", error.response.data.message || 'Error desconocido');
        console.log(error.response)
        break;
    }
  } else {
    // Si no hay respuesta del servidor
    console.error("Error de red o del servidor:", error.message);
  }
  return Promise.reject(error); // Esto es importante para que puedas manejar el error en tus llamadas axios
});


export default axiosClient;
