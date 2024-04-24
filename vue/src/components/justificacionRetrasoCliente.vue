<template>

  <transition name="fade" v-if="get_rolProyecto != 8">
          <div id="flotante" v-show="com_mostrarFlotante" class="fixed h-[32em] right-10 bg-gray-50 shadow-2xl p-6 rounded-lg w-[22em] z-20 border border-[#d13f5a] flex flex-col">
            <h2 class="text-xl font-semibold mb-2 text-red-400 ">{{form_data.form_titulo}}</h2>
            <img
              src="../assets/modal-close.svg"
              alt=""
              class="absolute top-4 right-4 cursor-pointer w-6"
              @click="cerrarFlotante()"
            />

            <!-- Contenedor de Instrucciones -->
            <div class="text-xs text-red-400 mb-4">
              <p>* Elija el motivo del retraso y añada un comentario de manera obligatoria.</p>
            </div>

            <!-- Select -->
            <nav class="text-xs text-red-400 ">Elegir Motivos de retraso</nav>
            <select v-model="form_data.form_seleccion" class="text-xs mb-2 p-2 rounded-md w-full bg-white border border-red-400 focus:border-red-500 focus:ring focus:ring-red-400 focus:ring-opacity-50">
              <option disabled value="">Elegir una opción</option>
              <option v-for="opcion in motivosRetraso" :key="opcion.codRetrasoMotivo" :value="opcion.codRetrasoMotivo">{{ opcion.desRetrasoMotivo }}</option>
            </select>

            <!-- Área de Comentarios -->
            <textarea v-model="form_data.form_comentario" class="mb-4 p-3 text-xs rounded-md bg-white border border-red-400  focus:border-red-500 focus:ring focus:ring-red-400 focus:ring-opacity-50 h-[15em]" placeholder="Comentarios adicionales"></textarea>
            <!-- Mensaje de error -->
            <div v-if="form_data.mostrarError" class="text-red-500 text-xs mb-2">
              {{ form_data.mensajeError }}
            </div>

            <!-- Botón de Guardar -->
            <div class="mt-auto">
              <button @click="guardarFormulario" class="w-full bg-red-400 hover:bg-red-600 text-white p-3 rounded-md transition duration-300">Guardar Comentarios</button>
            </div>
          </div>
  </transition>

  <transition name="fade" v-if="get_rolProyecto == 8">
          <div id="flotante" v-show="com_mostrarFlotante" class="fixed h-[32em] right-10 bg-gray-50 shadow-2xl p-6 rounded-lg w-[22em] z-20 border flex flex-col">
            <div class="text-xl font-semibold mb-2   ">Justificar Cambio - Cliente</div>
            <div class="text-sm  mb-2 ">Actividad  :  {{form_data.form_titulo}}</div>
            <img
              src="../assets/modal-close.svg"
              alt=""
              class="absolute top-4 right-4 cursor-pointer w-6"
              @click="cerrarFlotante()"
            />

            <!-- Contenedor de Instrucciones -->
            <div class="text-xs ">
              entrmoaaaaaaas
              <p>* Sustente el motivo de cambio de estado correctamente</p>
              <p>* Luego de esto se validara el sustento y se aprobara el cambio.</p>

            </div>

            <!-- Select -->
            <nav class="text-xs text-red-400 ">Elegir Motivos de retraso</nav>
            <select v-model="form_data.form_seleccion" class="text-xs mb-2 p-2 rounded-md w-full bg-white border border-red-400 focus:border-red-500 focus:ring focus:ring-red-400 focus:ring-opacity-50">
              <option disabled value="">Elegir una opción</option>
              <option v-for="opcion in motivosRetraso" :key="opcion.codRetrasoMotivo" :value="opcion.codRetrasoMotivo">{{ opcion.desRetrasoMotivo }}</option>
            </select>

            <!-- Área de Comentarios -->
            <textarea v-model="form_data.form_comentario" class="mb-4 p-3 text-xs rounded-md bg-white border border-red-400  focus:border-red-500 focus:ring focus:ring-red-400 focus:ring-opacity-50 h-[15em]" placeholder="Comentarios adicionales"></textarea>
            <!-- Mensaje de error -->
            <div v-if="form_data.mostrarError" class="text-red-500 text-xs mb-2">
              {{ form_data.mensajeError }}
            </div>

            <!-- Botón de Guardar -->
            <div class="mt-auto">
              <button @click="guardarFormulario" class="w-full bg-gray-400 hover:bg-red-600 text-white p-3 rounded-md transition duration-300">Enviar Justificación</button>
            </div>
          </div>
  </transition>

</template>

<script>
export default {
  name: 'JustificacionCambioCliente',
  props: {


    get_rolProyecto : Number,

    mostrarFlotante: {
      type: Boolean,
      default: false,
    },

    form_data     : Array,
    motivosRetraso: Array,

  },
  data() {
    return {

    //   mostrarError: false,
    //   mensajeError: '',
    };
  },
  methods: {
    cerrarFlotante(){

       this.$emit('actualizarFlotante', { valor: false });


    },
    guardarFormulario() {
      // Implementación de la lógica para guardar el formulario
      this.$emit('guardarFormulario', { data: this.form_data });
    },
  },
  computed: {

    com_mostrarFlotante : function (){

        return this.mostrarFlotante;
    },


  },

};
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
}
</style>
