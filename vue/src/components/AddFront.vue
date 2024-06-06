<template>
  <Modal
    :header="'Agregar Frente'"
    :modalType="'addFront'"
    :paragraphs="paragraphs"
  >
      <div class="flex w-full flex-col mb-4 relative">
        <div class="relative">
          <input
            type="text"
            v-model="frontName"
            class="h-[52px] w-full px-4 rounded border border-[#8A9CC9] font-normal text-base text-activeText"
            placeholder="Ingresa el nombre de un nuevo frente"
            @click="cleanMessage()"
          />
          <p v-show="message.error === true" class="alert alert-danger">{{ message.info }}</p>
          <p v-show="message.error === false" class="alert alert-success">{{ message.info }}</p>
        </div>
      </div>

    <button class="h-14 sm:w-full rounded px-8 text-base leading-4 mt-10 bg-orange text-white"
      :class="frontName === '' ? 'opacity-80' : ''" @click="addFront({ frontId: frontId, frontName: frontName })"
      :disabled="frontName === ''">
      Guardar cambios
    </button>
  </Modal>
</template>

<script>
import Modal from "./Modal.vue";

export default {
  name: "add-front-component",
  components: {
    Modal,
  },
  props: {
    rows: Array,
    codAreaUsuario: "",
  },
  data: function () {
    return {
      frontId: '',
      frontName: '',
      isOpen: false,
      paragraphs: [],
      message: {
        error: null,
        info: "",
      }
    };
  },
  methods: {
    cleanMessage: function() {
      if (this.message.info) {
        this.message.info = ""
        this.message.error = null
      }
    },
    addFront: function (payload) {
      payload['codAreaUsuario'] = this.areaUsuario
      let point = this;
      this.$store.dispatch("add_front", payload).then((response) => {
        payload["codFrenteReal"] = response.data.codFrente;
        if (response.data.error) {
          this.message.error = true
          this.message.info = response.data.mensaje
          this.frontName = ""
          return;
        };
        this.message.error = false
        this.message.info = response.data.mensaje
        this.frontName = ""
        point.$store.commit({
            type: "addFront",
            ...payload,
          });
      });
    },
  },
};
</script>
