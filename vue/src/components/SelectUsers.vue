<template>
    <Modal :header="'Selecciona Integrantes'" :modalType="'selectusers'" :status="status" class="flex  ">
    <!-- Campo de búsqueda -->
    <div class="flex  w-full  mb-4">
        <input
            type="text"
            v-model="searchQuery"
            class="w-full h-10 border border-[#8A9CC9] rounded p-2"
            placeholder="Buscar usuario..."
        />
    </div>

    <!-- Seleccionar todo -->
    <div id="seleccionartodo" class="flex justify-start mb-4 ">
        <input
            type="checkbox"
            name="selall"
            id="selall"
            value="selall"
            class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
            @change="selectAll"
        />
        <label for="selall">
            <span class="font-bold text-sm leading-6">
            Todos los usuarios
            </span>
        </label>
    </div>


    <!-- Listar usuarios con scroll -->
    <div id="listarusuarios" class="flex mb-6 flex-col w-full overflow-auto max-h-[300px]">
        <div v-for="(user, index) in filteredUsers" :key="index" class="flex mb-4">
            <input
                type="checkbox"
                :name="'user_'+index"
                :id="'user_'+index"
                :value="user.codProyIntegrante"
                class="w-6 h-6 border border-[#8A9CC9] rounded mr-4 accent-orange"
                v-model="this.$store.state.restriction_rows_real[rowIndex].integrantes"
                @change="capturamosCambios"
            />
            <label :for="'user_'+index">
                <span class="font-medium text-sm leading-6">
                {{ user.desCorreo }}
                </span>
            </label>
        </div>
    </div>
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
        modelValue: {
            type: Array,
            default: []
        },
        rowId: Number,
        rowIndex: Number
    },
    data: function () {
        return {
            searchQuery: '',
            status: false,
            // selUsers: this.$store.state.restriction,
            selAllState: false
        };
    },
    methods: {
        capturamosCambios: function(payload) {



          let data_update = this.$store.state.restriction_rows_real[this.rowIndex].integrantes
          this.$emit('capturamosCambios', {lista: data_update, codProyecto: this.$store.state.restriction_rows_real[this.rowIndex].codProyecto});

        },
        updSelectAll: function(){

          this.selAllState = this.$store.state.restriction_rows_real[this.rowIndex].integrantes.length != this.$store.state.restriction_rows_real[this.rowIndex].integrantesProy.length ? false : true

        },
        selectAll: function() {
            this.selAllState = !this.selAllState
            if(this.selAllState === false) {

                this.$store.state.restriction_rows_real[this.rowIndex].integrantes = []
            }
            else {

              let pintegrantes = this.$store.state.restriction_rows_real[this.rowIndex].integrantesProy
              let integrantes  = []
              pintegrantes.forEach (inte => {

                integrantes.push(inte.codProyIntegrante);

              });

              this.$store.state.restriction_rows_real[this.rowIndex].integrantes = integrantes;

            }

            this.capturamosCambios()
        }
    },
    mounted: function() {

      // this.updSelectAll()

    },
    computed: {
        filteredUsers() {
            if (!this.searchQuery) {
                return this.modelValue;
            }
            return this.modelValue.filter(user =>
                user.desCorreo.toLowerCase().includes(this.searchQuery.toLowerCase())
            );
        },
    },
  };
  </script>
