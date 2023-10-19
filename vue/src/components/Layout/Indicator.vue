<template>
  <div class="w-12/12 flex justify-between sm:flex-col mb-9 sm:mb-6 m-auto">
    <div class="flex flex-col tracking-tight">
      <span class="text-base text-activeText mb-2">{{ header }}</span>
      <span class="text-xs leading-6 text-activeText font-medium sm:mb-4">
        {{ paragraph }}
      </span>
    </div>
    <div class="flex items-end">
      <!-- <button
        title=" Crea un nuevo proyecto , asigne personal y asigne reportes."
        class="new-button h-8 sm:w-10/12 bg-orange text-white text-[0.8rem] leading-4 px-4 rounded"
        @click="$emit(desAccion)"
      >

        {{ buttonText }}
      </button> -->


      <button
        v-if="grafico == 'indicador'"
        title=" Crea un nuevo proyecto , asigne personal y asigne reportes."
        class=" new-button  h-8 sm:w-10/12 bg-orange text-white text-[0.8rem] leading-4 px-4 rounded"
        @click="$emit(desAccion)"
      >
      <i class="mr-2" :class="iconGrafico"></i>
      <span class="new-indicator">Nuevo</span>
      <!-- <i class="fa-regular fa-chart-line text-[1.2rem]"></i> -->
      <!-- <i :class="iconGrafico"></i>
       -->


        {{ buttonText }}
      </button>

      <button
        v-else
        title=" Crea un nuevo proyecto , asigne personal y asigne reportes."
        class="h-8 sm:w-10/12 bg-orange text-white text-[0.8rem] leading-4 px-4 rounded"
        @click="$emit(desAccion)"
      >
      <i class="mr-2"  :class="iconGrafico"></i>

        {{ buttonText }}
      </button>

    </div>
  </div>
</template>

<script>
export default {
  name: "indicator-component",
  props: {
    desAccion: String,
    header: String,
    paragraph: String,
    buttonText: String,
    grafico: String
  },
  computed: {
    iconGrafico: function() {
      if (this.grafico === 'indicador') {
        return ['fa-solid', 'fa-chart-line'];
      } else {
        return ['fa-solid', 'fa-square-plus'];
      }
    }
  }
};
</script>

<style scoped>
.new-button {
  position: relative;
  /* padding: 10px 20px; */
  /* background-color: #c35c07; */
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
  overflow: hidden; /* Esto es para que el indicador NEW no se salga del botón */
}

/* .new-button:hover {
  background-color: #2980b9;
} */

.new-indicator {
  position: absolute; /* Posicionamos el indicador de manera absoluta */
  top: -5px; /* Ajusta según prefieras */
  right: -5px; /* Ajusta según prefieras */
  background-color: #ffffff;
  color: #eb5d00;
  padding: 2px 6px;
  border-radius: 50%; /* Esto hará que el indicador sea circular */
  font-size: 0.6em;
  font-weight: bold;
  transform: rotate(1deg); /* Añade un ligero ángulo al indicador */
}
</style>

