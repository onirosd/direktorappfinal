<template>
  <Modal
    :header="'Ocultar / mostrar columnas'"
    :modalType="'toggleColumn'"
    :paragraphs="paragraphs"
  >
      <span class="text-sm leading-6 mb-4">
        Desmarca las columnas que deseas ocultar:
      </span>
      <div class="flex flex-row w-full ">

      <div class="flex w-full flex-col mb-4 basis-1/2">

        <div class="flex mb-4">
          <input
            type="checkbox"
            name="exercise"
            id="exercise"
            value="exercise"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="exercise">
            <span class="font-medium text-sm leading-6">
              Descrip. actividad
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="restrictionType"
            id="restrictionType"
            value="restrictionType"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="restrictionType">
            <span class="font-medium text-sm leading-6">
              Tipo de restricción
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="date_conciliad"
            id="date_conciliad"
            value="date_conciliad"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="date_conciliad">
            <span class="font-medium text-sm leading-6">
              Fecha Conciliada
            </span>
          </label>
        </div>

        <div class="flex mb-4">
          <input
            type="checkbox"
            name="date_identity"
            id="date_identity"
            value="date_identity"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="date_identity">
            <span class="font-medium text-sm leading-6">
              Fecha Identificación
            </span>
          </label>
        </div>

        <div class="flex mb-4">
          <input
            type="checkbox"
            name="responsible_area"
            id="responsible_area"
            value="responsible_area"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="responsible_area">
            <span class="font-medium text-sm leading-6">
              Área responsable
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="applicant"
            id="applicant"
            value="applicant"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="applicant">
            <span class="font-medium text-sm leading-6">
              Solicitante
            </span>
          </label>
        </div>

      </div>
      <div class="flex w-full flex-col mb-4 basis-1/2">
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="restriction"
            id="restriction"
            value="restriction"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="restriction">
            <span class="font-medium text-sm leading-6">
              Descrip. restricción
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="date_required"
            id="date_required"
            value="date_required"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="date_required">
            <span class="font-medium text-sm leading-6">
              Fecha requerida
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="responsible"
            id="responsible"
            value="responsible"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="responsible">
            <span class="font-medium text-sm leading-6">
              Responsable
            </span>
          </label>
        </div>
        <div class="flex mb-4">
          <input
            type="checkbox"
            name="condition"
            id="condition"
            value="condition"
            v-model="checkedCols"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
          />
          <label for="condition">
            <span class="font-medium text-sm leading-6">
              Estado
            </span>
          </label>
        </div>


      </div>
    </div>

      <button
        class="h-14 sm:w-full rounded px-8 text-base leading-4 mt-10 bg-orange text-white"
        @click="$emit('setColumnsStatus', {'hideCols': checkedCols})"
      >
        Guardar cambios
      </button>
  </Modal>
</template>

<script>
import Modal from "../components/Modal.vue";

export default {
  name: "toggle-column-component",
  components: {
    Modal,
  },
  data: function () {
    return {
      checkedCols: this.hideCols,
      paragraphs: [],
    };
  },
  props: {
    hideCols: Array,
  },
};
</script>
