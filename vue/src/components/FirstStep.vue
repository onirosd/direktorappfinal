<template>

  <div class="flex flex-col" >
    <span class="text-2xl mb-8">Crea tu primer proyecto</span>
    <div class="flex justify-between sm:flex-col">
      <div class="flex flex-col w-[48%] sm:w-full">

       <!-- <div> placeholder ::: {{placeholder}}</div> -->
       <!-- <div> ubigeo ::: {{ubigeo}}</div> -->
        <!-- <Alert
          v-if="Object.keys(errors).length"
          class="flex-col items-stretch text-sm"


          @click="sinFocoEmpresa(); sinFocoUbicacion();"
        >
          <div v-for="(field, i) of Object.keys(errors)" :key="i">
            <div v-for="(error, ind) of errors[field] || []" :key="ind">
              * {{ error }}
            </div>
          </div>
        </Alert> -->
        <input
          type="text"
          placeholder="Nombre del proyecto*"
          v-model="projectName"
          :errors="errors"
          class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        />

        <div
        class="autocompleteel h-[52px] w-full mb-4 border border-[#8A9CC9] rounded "

        >
	  		<div class="w-full"
        >
          <input type="hidden" v-model="business">
		  		<input type='text' @keyup='loadSuggestions' placeholder='Empresa'
            class="pl-4 foco_empresa"
		  			v-model='searchText'
            @focus="this.focoEmpresa = true"


      			>	<br>
		  		<div class="w-[100%]  rounded bg-white border border-gray-300 px-4 py-2 space-y-1 relative z-50 foco_empresa"
          v-if="suggestiondata.length"

          >
		  		<ul>
              <li
              class="px-1 pt-1 pb-2 font-bold border-b border-gray-200 foco_empresa"
              >
              <!-- Mostrando {{ suggestiondata.length }} resultados -->

              <div class="flex justify-between sm:flex-col foco_empresa">
              <div class="flex flex-col w-[80%] foco_empresa">
                Mostrando {{ suggestiondata.length }} resultados.

              </div>
              <div class="flex flex-col w-[10%] foco_empresa">

                <img
                  src="../assets/images/icons/close.svg"
                  alt=""
                  class="w-[50%] cursor-pointer foco_empresa"
                  @click='itemSelected(-100)'

              />

              </div>
              </div>
              </li>
              <div class="overflow-x-auto h-40 foco_empresa">
                  <li
                  v-for= 'item in suggestiondata'
                  v-bind:key="item.cod_Empresa"
                  v-bind:value = "item.cod_Empresa"
                  @click='itemSelected(item.cod_Empresa);'
                  class="cursor-pointer hover:bg-gray-100 p-1 foco_empresa"
                  >
                    {{ item.des_Empresa }}
                  </li>
              </div>
		  		</ul>
		  		</div>
	  		</div>
	  	</div>


        <input
          type="text"
          placeholder="Plazo"
          v-model="term"
          @keypress="onlyNumber"
          class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        />
        <div class="flex  mb-4">
          <input
            type="text"
            placeholder="Área techada"
            v-model="coveredArea"
            @keypress="onlyNumber"
            class="h-[52px] w-[82%] border border-[#8A9CC9] rounded-l pl-4 pr-[116px]"
          />

          <div class="w-[18%] border border-[#8A9CC9] rounded-r px-4">
            <p class="font-normal text-[#8A9CC9] mt-[30%] ml-[10%]">m2</p>

          </div>
        </div>

        <div class="flex mb-4 w-full">

          <select
          v-model="projectType"
          :errors="errors"
          class="h-[52px] w-full border border-[#8A9CC9] rounded pl-4 selectPer2"

          >
          <option disabled value="">Tipo de Proyecto</option>
          <option
          v-for="item in listaTiposproyectos" v-bind:key="item.codTipoProyecto" v-bind:value = "item.codTipoProyecto">
            {{ item.desTipoProyecto }}
          </option>

          </select>

        </div>


          <!-- <autocomplete
        v-model="ubigeo"

        :items="listaUbigeos"
        permitArbitraryValues
        :returned="'codUbigeo'"
        displayed="desUbigeo"
        :placeholder="placeholder"
        modelValue = ""
        class="h-[52px] w-full border border-[#8A9CC9] rounded pl-4 pr-[116px] mb-4 relative flex"
     /> -->

     <div class="autocompleteel h-[52px] w-full mb-4 border border-[#8A9CC9] rounded ">
	  		<div >
          <input type="hidden" v-model="ubigeo">
		  		<input
                 type='text'
                 placeholder='Ubicación'
		  			     v-model='searchTextUbigeo'
                 @keypress=" searchTextUbigeoFlg = 0"
                 class="border border-[#8A9CC9] rounded px-4 foco_ubigeo"
                 @blur="focoUbigeo = true"

      			>
          <br>
		  		<div

          v-if="loadSuggestionsUbigeo.length && searchTextUbigeoFlg == 0"
          class="w-[100%] rounded bg-white border border-gray-300 py-2 relative foco_ubigeo"
          >
		  		<ul class="z-2">
              <li
              class="px-1 pt-1 pb-2 font-bold border-b border-gray-200 foco_ubigeo"
              >
              <div class="flex justify-between sm:flex-col foco_ubigeo">
              <div class="flex flex-col w-[80%] foco_ubigeo">
                Mostrando {{ loadSuggestionsUbigeo.length }} de {{ listaUbigeos.length }} resultados.

              </div>
              <div class="flex flex-col w-[10%] foco_ubigeo">

                <img
                  src="../assets/images/icons/close.svg"
                  alt=""
                  class="w-[50%] cursor-pointer foco_ubigeo"
                  @click='itemSelectedUbigeo(-100)'

              />

              </div>
            </div>


              </li>
              <div class="overflow-x-auto h-40 foco_ubigeo">
                  <li
                  v-for= 'item in loadSuggestionsUbigeo'
                  v-bind:key="item.codUbigeo"
                  v-bind:value = "item.codUbigeo"
                  @click='itemSelectedUbigeo(item.codUbigeo)'
                  class="cursor-pointer hover:bg-gray-100 p-1 foco_ubigeo"
                  >
                    {{ item.desUbigeo }}
                  </li>
              </div>
		  		</ul>
		  		</div>
	  		</div>
	  	</div>

      </div>


      <div class="flex flex-col w-[48%] sm:w-full">
        <v-date-picker v-model="startDate" mode="date" class="mb-4" >
          <template v-slot="{ inputValue, inputEvents }" >
            <input
              class="h-[52px] w-full  border border-[#8A9CC9] rounded px-4"
              placeholder="Fecha de inicio*"
              :value="inputValue"
              v-on="inputEvents"
            />
          </template>
        </v-date-picker>

        <div class="flex mb-4 h-[52px] rounded">
        <input
          type="number"
          placeholder="Monto referencial"
          v-model="referenceAmount"
          @keypress="onlyNumber"
          class="h-[52px] w-[82%] mb-4 border border-[#8A9CC9] rounded-l px-4"
        />

          <div class="w-[18%] border border-[#8A9CC9] rounded-r ">

          <select
          v-model="codMoneda"
          :errors="errors"
          class="flex  right-0 h-full justify-between border-[#8A9CC9] w-full selectPer1"

          >

          <option
          v-for="item in listaMonedas" v-bind:key="item.codMoneda" v-bind:value = "item.codMoneda">
            {{ item.desSimbolo }}
          </option>

          </select>


          <!-- <img
            src="../assets/images/icons/ic_arrow-down.svg"
            alt=""
            class=" mt-[-45%] ml-[50%]"
          /> -->
        </div>



        </div>
    <div class="flex  mb-4  h-[52px]">
     <input
          type="text"
          placeholder="Área construída"
          v-model="builtArea"
          @keypress="onlyNumber"
          class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded-l px-4 w-[82%]"
        />
    <div
      class="w-[18%] border border-[#8A9CC9] rounded-r px-4"
    >
      <p class="font-normal text-[#8A9CC9] mt-[30%] ml-[10%]">m2</p>
      <!-- <img
        src="../assets/images/icons/ic_arrow-down.svg"
        @click="handleClick('coveredArea')"

        class=" mt-[-20%] ml-[50%]"
      /> -->
    </div>
  </div>
        <input
          type="text"
          placeholder="País*"
          v-model="country"
          :errors="errors"
          readonly="readonly"

          class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        />
        <input
          type="text"
          placeholder="Dirección"
          v-model="address"
          class="h-[52px] w-full mb-4 border border-[#8A9CC9] rounded px-4"
        />



    </div>



    <!-- <span class="cursor-pointer" @click="openModal({param: 'newproject', id: 1})">Ver</span> -->


    <NewCompany
          v-if="modalName === 'newproject'"
          @closeModal   ="closeModal"
          @crearEmpresa = "datosProyecto"
          v-model="datapasar"

        />

    </div>
  </div>

</template>

<script>
// import autocomplete from 'vue-autocomplete-input-tag'
// import vClickOutside from 'v-click-outside'
import NewCompany from './NewCompany.vue'
import Loading from 'vue-loading-overlay';
export default {
  name: "first-step-component",
  components: {
    // autocomplete,
    Loading,
    NewCompany

  },
  // directives: {
  //     clickOutside: vClickOutside.directive
  //   },
  data: function () {
    return {
      searchTextUbigeo : "",
      searchTextUbigeoFlg:0,

      focoUbigeo:false,
      focoEmpresa:false,

      status_modal_np : false,
      rowId:0,
      modalName:"",
      datapasar: {},
      userid1: 0,
      searchText:'',
      searchSaved:'',
      suggestiondata:[],
      coveredAreaStatus: false,
      projectTypeStatus: false,
      districtStatus: false,
      projectName: "",
      // codEmpresa:"",
      business: "",
      term: "",
      coveredArea: "",
      projectType: "",
      ubigeo: "0",
      startDate: "",
      referenceAmount: "",
      area: "",
      builtArea: "",
      country: "Perú",
      address: "",
      codMoneda:"",
      placeholder:"",
      listaTiposproyectos: [],
      listaUbigeos:[],
      listaMonedas:[],
      attributes: [
        {
          key: 'today',
          // highlight: '##002B6B',
          highlight: true,
          dates: new Date(),
        },
      ],
      errors: {},
      test: {},
      items: [
      ],
    };
  },
  methods: {

    // dataVerificamos: function (param) {
    //   console.log(param)

    // },

    sinFocoEmpresa: function (param) {

            if (this.business == ''){

              this.searchText = ""
              this.suggestiondata = [];

            }else{
                  // let buscar = [this.business]
                  // let name   = buscar.map((id) => (this.suggestiondata.find(x => x.cod_Empresa == id).des_Empresa));

                  this.searchText     = this.searchSaved
                  this.suggestiondata = [];

            }
            this.focoEmpresa = false;

    },
    sinFocoUbicacion: function (param) {

      // if(this.focoUbigeo == true){

        // console.log(">>>>>> entramos por que cambio el blur del ubigeo")
        // console.log(this.ubigeo)

          if (this.ubigeo == '0' || this.ubigeo == '' ){

              this.searchTextUbigeo = ""
              this.suggestiondata   = [];

              }else{

              let buscar               = [this.ubigeo]
              this.searchTextUbigeoFlg = 1
              let name                 = buscar.map((id) => (this.listaUbigeos.find(x => x.codUbigeo == id).desUbigeo));
              this.searchTextUbigeo    = name[0]


          }

          this.focoUbigeo = false;

      // }

    },


    openModal: function (param) {
      if (typeof param !== "string") {
        this.rowId = param.id;
        param = param.param;
      }
      this.modalName = param;
    },
    closeModal: function () {
      this.searchText = ""
      this.business   = ""
      if (this.modalName === "") this.$store.commit("increaseHint");
      else this.modalName = "";
    },
    datosProyecto: function (datos) {

      this.$store.dispatch('save_newempresa', datos)
          .then((response) => {

            this.modalName      = "";
            this.suggestiondata = [];

            if (response["flag"] == 1){

              this.business   = response["registro"]["cod_Empresa"];
              this.searchText = response["registro"]["des_Empresa"];

            }

      });

    },

    loadSuggestions: function(e){
				var el = this;
				this.suggestiondata = [];

				if(this.searchText != ''){
          var enviamos = { buscar : this.searchText }
          this.$store.dispatch('get_buscar', enviamos)
          .then((response) => {
            let data = []
            //console.log(response)
            for (let index = 0; index < response.length; index++) {
              data.push({cod_Empresa:response[index]["cod_Empresa"], des_Empresa: response[index]["des_Empresa"]})
            }
            data.push({cod_Empresa:-999, des_Empresa: '+ Agregar Nueva Empresa'})
            el.suggestiondata  = data
          })

				}

			},

      itemSelectedUbigeo: function (cod){
      // console.log(cod)

        if (cod != -100){

          let buscar               = [cod]
          let name                 = buscar.map((id) => (this.listaUbigeos.find(x => x.codUbigeo == id).desUbigeo));
          // console.log(name[0])
          this.searchTextUbigeo    = name[0]
          this.ubigeo              = cod
          this.searchTextUbigeoFlg = 1

        }else{

          let buscar               = [this.ubigeo]
          this.searchTextUbigeoFlg = 1
          let name                 = buscar.map((id) => (this.listaUbigeos.find(x => x.codUbigeo == id).desUbigeo));
          this.searchTextUbigeo    = name[0]

        }

    },
    // itemSelectedUbigeo: function(id){
    //     let buscar            = [id]
    //     let name              = buscar.map((id) => (this.listaUbigeos.find(x => x.codUbigeo == id).desUbigeo));
    //     this.searchTextUbigeo = name
    //     this.ubigeo           = id
    // },
		itemSelected: function(id){

          if (id == -100){

            let buscar = [this.business]
            let name   = buscar.map((id) => (this.suggestiondata.find(x => x.cod_Empresa == id).des_Empresa));

            this.searchText     = name[0];
            this.suggestiondata = [];
            // this.business       = id



          }else if (id == -999){

            this.modalName      = 'newproject';

          }else{


            let buscar = [id]
            let name   = buscar.map((id) => (this.suggestiondata.find(x => x.cod_Empresa == id).des_Empresa));

            this.searchText     = name;
            this.searchSaved    = name;
            this.suggestiondata = [];
            this.business       = id


          }



		},
    handleClick: function(param) {
      if (param === 'coveredArea') this.coveredAreaStatus = !this.coveredAreaStatus;
      else if (param === 'projectType') this.projectTypeStatus = !this.projectTypeStatus;
      else if (param === 'district') this.districtStatus = !this.districtStatus;
    },
    onlyNumber: function ($event) {
      //console.log($event.keyCode); //keyCodes value
      let keyCode = ($event.keyCode ? $event.keyCode : $event.which);
      if ((keyCode < 48 || keyCode > 57) && keyCode !== 46) { // 46 is dot
          $event.preventDefault();
      }
    },



  },
  computed: {


    loadSuggestionsUbigeo(e){
     let matches              = 0
    //  this.searchTextUbigeoFlg = 0
    //  console.log("entrando al final :"+this.searchTextUbigeoFlg.toString())

     if (this.searchTextUbigeo == '') {
             return []
     }
     return this.listaUbigeos.filter(ubigeo => {
      if (
             ubigeo.desUbigeo.toLowerCase().includes(this.searchTextUbigeo.toLowerCase())
             &&
             matches < 10
         ){
             matches++
             return ubigeo
          }

     });

    },

  },

  mounted() {

  this.$el.addEventListener('click',(e) =>
    {
       let elementClass = e.target.className;

        if (elementClass !== '') {

          if(this.focoEmpresa == true){

            if(elementClass.search('foco_empresa') < 0){
              this.sinFocoEmpresa()
            }

          }

          if(this.focoUbigeo == true){

            if(elementClass.search('foco_ubigeo') < 0){
              this.sinFocoUbicacion()
            }

          }


        }

    // // If element has no classes
    // else {
    //   console.log('An element without a class was clicked');
    // }
  });


  },



};

// document.addEventListener('click',(e) =>
//   {
//     // Get element class(es)
//     let elementClass = e.target.className;
//     // If element has class(es)
//     if (elementClass !== '') {
//       console.log(elementClass);
//     }
//     // If element has no classes
//     else {
//       console.log('An element without a class was clicked');
//     }
//   }
// );

</script>

<style>

.selectPer1 {
  text-indent: 1px;
  text-overflow: '';
  /* width: px; */
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;

  background: transparent url("../assets/images/icons/ic_arrow-down.svg") no-repeat 70%;


}
.selectPer2 {
  text-indent: 1px;
  text-overflow: '';
  /* width: px; */
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;

  background: transparent url("../assets/images/icons/ic_arrow-down.svg") no-repeat 92%;


}

 .ocultar{
      display: none;
 }

 .without_icon {

      background-image: none !important
 }

  .autocompleteel,.autocompleteel{
      width: 100%;


  }

  .autocompleteel input[type=text]{
      width: 100%;
      border: none;
      height: 3em;
      /* margin-left: -1em; */

  }


</style>
