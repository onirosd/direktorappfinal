<template>
  <tr>
    <td>
      <button
        class="border-2 border-orange rounded h-8 text-orange text-xs px-4"
        @click="ConstraintAnalysis(row.codProyecto)"
      >
        Ingresar
      </button>
    </td>
    <td>
      <span class="flex items-center">
        <span class="mr-2">{{ row.codEstado == 0 ? `Abierto` : `Cerrado` }}</span>
        <!-- <span class="mr-2">abierto</span> -->
        <img src="../assets/images/icons/edit.svg" alt="" class="cursor-pointer" @click="openModal({param: 'editStatus', id: row.codProyecto})" />
      </span>
    </td>
    <td>{{ row.desnombreproyecto }}</td>
    <td>
      <p class="flex flex-col">
        <span>No retrasadas: {{ row.indNoRetrasados }}</span>
        <span>Retrasadas: {{ row.indRetrasados }}</span>
      </p>
    </td>
    <td>
      <span class="flex flex-col">
        <template v-for="(equipment, index) in row.integrantesProy" :key="index">

          <span  v-if ="row.integrantes.includes(equipment.codProyIntegrante)">
           {{ equipment.desCorreo }}
          </span>

        </template>

      </span>
    </td>
    <td>
      <button
        class="bg-[#DCE4F9] w-6 h-6 rounded-md justify-center flex items-center"
        @click="$emit('selectUserFunc', {codProyecto:row.codProyecto, index:index}); openModal({param: 'selectusers'})"
        v-click-outside="hide"
      >
        <img
          src="../assets/images/icons/tooltip-person-add-active.svg"
          :class="{ 'content-pointsActive': row.isTooltip }"
          alt=""
        />
      </button>
    </td>
  </tr>
</template>

<script>
import { emit } from "process";
import ClickOutside from "vue-click-outside";
import Tooltip from "./Tooltip.vue";
import { useRouter } from "vue-router";

export default {
  name: "custome-table-row",
  components: {
    Tooltip,
},
  props: {
    index: Number,
    row: Object,
    users: Array,
  },
  data: function () {
    return {
      isOpen: false,
      modalName: '',
      // section: row.integrantes
    };
  },
  computed:{

  },
  methods: {

    handleClick: function () {
      this.isOpen = !this.isOpen;
    },
    hide: function () {
      this.isOpen = false;
    },
    openModal: function(payload) {
      this.$emit('openModal', {param: payload.param, id: payload.id, index:this.index });
    },
    ConstraintAnalysis: function(id) {

      this.$emit('openConstraintPage', {id: this.row.codProyecto, nameProy: this.row.desnombreproyecto})

    }
  },
  directives: {
    ClickOutside,
  },

};
</script>
