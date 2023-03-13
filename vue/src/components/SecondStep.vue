<template>

  <div class="flex flex-col">
    <span @click="probar" class="text-2xl mb-8"
      >Asigna los miembros de tu primer proyecto
    </span>
    <div class="flex justify-between sm:flex-col mb-8">
      <div class="flex flex-col w-[32%] sm:w-full sm:mb-8">
        <span class="text-sm leading-6 mb-4">Ingresa el correo del miembro</span>
        <div class="autocompleteel h-[52px] w-full mb-4 border border-[#8A9CC9] rounded" v-for="(user, index) in users">

            <input type="hidden" v-model="user.id">
            <input
              type="text"

              :key="index"
              placeholder="Correo electrónico"
              v-model="user.userEmail"
              class="h-[52px] w-full mb-2 rounded px-4"
              @keyup='loadSuggestions(user.userEmail, index);'

            />
            <br>
                <div class="w-[110%] mx-[-5%] rounded bg-white border border-gray-300 px-4 py-2 space-y-1 relative z-50"
                v-if="user.suggestiondata.length > 0 "
                >
                <ul>
                    <li
                    class="px-1 pt-1 pb-2 font-bold border-b border-gray-200"
                    >
                    Mostrando {{ user.suggestiondata.length }} resultados
                    </li>
                    <li
                    v-for= 'item in user.suggestiondata'
                    v-bind:key="item.id"
                    v-bind:value = "item.email"

                    @click="user.userEmail = item.email; user.id = item.id; user.suggestiondata = [];"
                    class="cursor-pointer hover:bg-gray-100 p-1"
                    >
                      {{ item.email }}
                    </li>
                </ul>
                </div>

        </div>

      </div>

      <div class="flex flex-col w-[32%] sm:w-full sm:mb-8">
        <span class="text-sm leading-6 mb-4">Selecciona el rol</span>
        <!-- <Select
          v-for="(user, index) in users"
          :key="index"
          :indexVal="index"
          :typeVal="'text'"
          :placeHolder="'Selecciona*'"
          :selType="'role'"

          v-model="user.userRole"
          :options="rolIntegrantes"
        /> -->

        <select
        v-model="value.userRole"
        v-for="(value, index) in users"
        :key="index"
        class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        >
          <option
          v-for="item in rolIntegrantes" v-bind:key="item.value" v-bind:value = "item.value" :selected="value.userRole" >
            {{ item.name }}
          </option>

        </select>

      </div>
      <div class="flex flex-col w-[32%] sm:w-full">
        <span class="text-sm leading-6 mb-4"
          >Selecciona área al que pertenece</span
        >

        <select
        v-model="value.userArea"
        v-for="(value, index) in users"
        :key="index"
        class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        >
          <option
          v-for="item in areaIntegrantes" v-bind:key="item.value" v-bind:value = "item.value" :selected="value.userArea" >
            {{ item.name }}
          </option>

        </select>

      </div>
    </div>
    <div class="flex cursor-pointer mb-8" @click="addUser">
      <img
        src="../assets/images/icons/tooltip-person-add-active.svg"
        class="mr-2"
        alt=""
      />
      <span class="text-base leading-4 text-orange">Agregar miembro</span>
    </div>
  </div>
</template>

<script>
import Select from "./Select.vue";
export default {
  name: "second-step-component",
  components: {
    Select,
  },
  data: function () {
    return {
      areaIntegrantes : [],
      rolIntegrantes  : [],
      // userSugerencias : [],
      suggestiondata:[],
      users: [],
      search: ""
    };
  },
  methods: {
    probar : function () {
      console.log(this.users)
    },
    handleClick: function (param) {
      if (param === "coveredArea")
        this.coveredAreaStatus = !this.coveredAreaStatus;
      else if (param === "projectType")
        this.projectTypeStatus = !this.projectTypeStatus;
      else if (param === "district") this.districtStatus = !this.districtStatus;
    },
    addUser: function () {
      var temp = {
        userEmail: "",
        userRole: "",
        userArea: "",
        suggestiondata : []
      };
      console.log("as")
      this.users.push(temp);

    },
    selRole: function(payload) {
      this.users[payload.indexVal].userRole = payload.value;
      this.paraStatus = false;
    },
    selArea: function(payload) {
      this.users[payload.indexVal].userArea = payload.value;
      this.paraStatus = false;
    },
    loadSuggestions: function(buscar, index){
				var el = this;
				el.users[index].suggestiondata = [];

				if(this.searchText != ''){
          var enviamos = { buscar : buscar }
          this.$store.dispatch('get_buscar_usuarios', enviamos)
          .then((response) => {
            let data = []
            //console.log(response)
            for (let index = 0; index < response.length; index++) {
              data.push({id:response[index]["id"], email: response[index]["email"]})
            }
            // data.push({id:-999, des_Empresa: '+ Agregar Nueva Empresa'})
            //el.suggestiondata  = data
            el.users[index].suggestiondata = data
          })

				}

			},
      itemSelected: function(campo , valor){
          campo   = valor

      }
  },
  computed: {


  },
  beforeMount: function() {


  },
  beforeCreate() {


  },

};
</script>
