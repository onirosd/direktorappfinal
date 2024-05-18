<template>
  <Modal :header="'Agregar Nueva Empresa'" :modalType="'viewproject'" :paragraphs="paragraphs" :status="status">
      <div class="flex mb-4 flex-col w-full">
          <span class="text-sm leading-6 mb-2">Empresa:</span>
          <input
              type="text"
              class="h-[52px] w-full px-4 rounded border border-[#8A9CC9] font-normal text-base text-activeText mb-4"
              :class="{'border-red-500 border-2': inputError && !newcompany.company}"
              placeholder="Ingresa Empresa"
              v-model="newcompany.company"
              @input="limpiarMensaje"
          />
          
      </div>
      <div class="flex mb-4 flex-col w-full">
          <span class="text-sm leading-6 mb-2">RUC:</span>
          <input
              type="text"
              @keypress="onlyNumber"
              class="h-[52px] w-full px-4 rounded border border-[#8A9CC9] font-normal text-base text-activeText mb-4"
              :class="{'border-red-500 border-2': inputError && !newcompany.ruc}"
              placeholder="Ingresar Ruc"
              v-model="newcompany.ruc"
          />
          <span class="text-sm leading-6 mb-2">* Campo Obligatorio</span>
          <span v-if="mensaje !== ''" class="text-sm leading-6 mb-2 text-red-400">{{ mensaje }}</span>
      </div>
      <footer class="modal-footer">
        <button v-bind:style="{ backgroundColor: colorDisabled}" class="h-14 px-8 rounded bg-orange text-white text-base leading-4 sm:mb-4" @click="crearempresa" :disabled="isDisabled">Crear Empresa</button>
      </footer>
  </Modal>
</template>

<script>
import Modal from "./Modal.vue";

export default {
  name: "add-person-component",
  components: {
    Modal,
  },
  props: {
      // isDisabled : false,
      modelValue: {
          type: Object,
          default: () => ({}),
      },
      mensaje: {
        type: String,
        default: "",
      }
  },
  data: function () {
    return {
      newcompany:{company:"", ruc:""},
      status: false,
      isDisabled : false,
      colorDisabled : 'rgb(235 93 0 / var(--tw-bg-opacity))',
      paragraphs: [
        "Si no encuentra el nombre de su empresa, agreguela.",
      ],
      inputError: false,
      //errorMessage: this.mensaje,
    };
  },
  methods: {
    crearempresa: function() {
      if(this.newcompany.company === "" || this.newcompany.ruc === ""){
        return this.inputError = true;
      }
      else{
        //this.isDisabled    = true;
        //this.colorDisabled = '#e7e7e7';
        // this.$emit("isDisabled", true) ;
        console.log("entrando aqui .---->")
        console.log('Nombre empresa:', this.newcompany.company)
        this.$emit('crearEmpresa', this.newcompany);
      }
      
    },
    onlyNumber: function ($event) {
      //console.log($event.keyCode); //keyCodes value
      let keyCode = ($event.keyCode ? $event.keyCode : $event.which);
      if ((keyCode < 48 || keyCode > 57) && keyCode !== 46) { // 46 is dot
          $event.preventDefault();
      }
    },
    limpiarMensaje() {
      this.$emit('limpiarMensaje');
      this.newcompany.company = this.newcompany.company.replace(/[¡!%&/¿?;"']/g, '');
    },

    // changeDisabled() {
    //   this.$emit("changeDisabled", this.isDisabled);
    // },

  },
};
</script>



