<template>
  <Modal :header="header" :confirmHeader="confirmHeader" :modalType="'confirm'" :paragraphs="paragraphs">
    <div class=" w-full mt-10 ">

      <div class=" w-[90%] ml-[5%]  " v-if="!(rolProyecto == '3' || rolProyecto == '0')">

        <label for="message"  class=" block mb-2 text-sm font-medium text-gray-900 dark:text-white">Comentarios Finales : </label>
        <div class="block  rounded pb-5 text-sm font-medium text-gray-900 dark:text-white bg-red-300 text-center">

              {{comentarioFinal}}

        </div>
      </div>

      <div class=" w-[90%] " v-if="(rolProyecto == '3' || rolProyecto == '0')">


        <label for="message"  class=" block mb-2 text-sm font-medium text-gray-900 dark:text-white">Añadir Comentarios : </label>
        <textarea v-model="comentariosFinales" id="message" rows="4" class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Escribe algun comentario."></textarea>


      </div>
      <br>
      <div class=" w-[90%] ml-[5%]  flex justify-between sm:flex-col sm:flex-col-reverse">
      <button
        v-if="(rolProyecto == '3' || rolProyecto == '0')"
        :disabled="bloq"
        class="h-14 w-[48%] sm:w-full rounded border-2 text-base leading-4 "
        :class="{
          'border-2 border-orange text-orange': !bloq,
          'border-2 border-gray text-gray': bloq,
          'w-48': buttons[0].length > 11,
          'px-8': buttons[0].length < 12
        }"
        @click="$emit('confirmStatus',{param: '1', bloq:true, idAprobacion:idAprobacion, comentario:comentariosFinales})"
      >
        {{ buttons[0] }}
      </button>
      <button
        v-if="(rolProyecto == '3' || rolProyecto == '0')"
        :disabled="bloq"
        class="h-14 w-[48%] sm:w-full rounded bg-orange text-base leading-4 text-white mb-4"
        :class="{ 'w-48': buttons[1].length > 11, 'px-8': buttons[1].length < 12 }"
        @click="$emit('confirmStatus', {param: '2', bloq:true, idAprobacion:idAprobacion , comentario:comentariosFinales})"
      >
        {{ buttons[1] }}
      </button>
      <button
        v-if="!(rolProyecto == '3' || rolProyecto == '0')"

        class="h-14 w-[100%] sm:w-full rounded bg-gray-400   text-base leading-4 text-white mb-4"
        :class="{ 'w-48': buttons[2].length > 11, 'px-8': buttons[2].length < 12 }"
        @click="$emit('closeModal', {param: false})"
      >
        {{ buttons[2] }}

      </button>
      </div>
    </div>
  </Modal>
</template>

<script>
import Modal from "./Modal.vue";

export default {
  name: "success-component",
  props: {
    rolProyecto:String,
    bloq:Boolean,
    header: String,
    confirmHeader: String,
    paragraphs: Array,
    buttons: Array,
    val: String,
    idAprobacion: String,
    comentarioFinal:String,
  },
  data() {
  return {
    comentariosFinales: '' // Variable que se enlazará con el textarea
  };
  },
  components: {
    Modal,
  },

};
</script>
