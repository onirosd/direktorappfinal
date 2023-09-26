<template>
  <div
    v-if="isLoading == true"
    class="h-full flex justify-center sm:items-start"

  >
  <loading

        v-model:active=isLoadingTrue
        :can-cancel="false"
        :is-full-page=true
        loader="dots"
    />


  </div>
  <div v-if="!isLoading">
  <!-- <div> -->
    <Breadcrumb
      :paths="['Inicio', 'Análisis de restricciones', 'Indicadores']"
      :urls ="['home','restricciones']"
      :settingFlag="true"
    />
    <!-- <Indicator
      :header="'Análisis de restricciones'"
      :paragraph="'Acá podrás visualizar las restricciones de tus proyectos y entrar al detalle de cada uno'"
      :buttonText="'Ver indicadores'"
    /> -->
    <div class="flex xl:flex-row border border-[#D0D9F1] rounded-md  sm:hidden">


      <div class="flex xl:flex-row  xl:w-2/12 md:w-3/12 sm:w-full  h-full " >

        <div class="xl:w-3/12 md:w-3/12 sm:w-full md:w-full h-full" >
          <!-- h-8 px-2 py-2 w-[50px] -->
          <img
            src="../../assets/logo-black.png"
            class=" ml-1 mt-1"
            title="Volver a la pagina de Inicio."
        />

        </div>

        <div class="xl:w-9/12 md:w-9/12 sm:w-full  h-full" >

           <div class="text-sm font-bold"> Direktor Monitor <br>
            <nav class="text-[0.7em] text-gray-600">Empresa inarco</nav>
            <nav class="text-[0.7em] text-gray-600">Ultima Actualización {{getDate}}</nav>

           </div>
        </div>

      </div>


      <div class="flex xl:flex-row xl:w-4/12 md:w-4/12 sm:w-full h-full gap-1" >

           <div class="ml-10 border border-[#D0D9F1] rounded-[18px] w-[90px] h-[30px] text-center mt-3 bg-slate-700 text-white font-medium text-sm pt-1">
            Principal
           </div>

           <div class=" border border-[#D0D9F1] rounded-[18px] w-[90px] h-[30px] text-center mt-3 bg-gray-400 text-white font-medium text-sm pt-1">
            Operaciones
           </div>

      </div>

      <div class="flex  xl:flex-row  xl:w-6/12  md:w-5/12 sm:w-full h-full " >

        <div class="xl:w-3/12 md:w-3/12  mt-1" >


           <nav class="text-[11px]">Proyecto</nav>
          <select v-model="selectedProyecto" @change="loadFrentes" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
            <option value="" > Selecciona </option>
            <option v-for="proyecto in rawDataProyecto" :key="proyecto.codProyecto" :value="proyecto.codProyecto">
              {{ proyecto.desNombreProyecto }}
            </option>
          </select>


        </div>

        <div class="xl:w-2/12 md:w-3/12  mt-1" >


          <nav class="text-[11px]">Frente</nav>
          <select :disabled="!selectedProyecto" v-model="selectedFrente" @change="loadFase" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
          <option value="" >Todos</option>
          <option v-for="frente in frentes" :key="frente.codAnaResFrente" :value="frente.codAnaResFrente">
              {{ frente.desAnaResFrente }}
          </option>
          </select>


        </div>


        <div class="xl:w-2/12 md:w-3/12  mt-1" >


          <nav class="text-[11px]">Fase</nav>
          <select :disabled="!selectedProyecto || !selectedFrente" v-model="selectedFase" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
          <option value="" >Todos</option>
          <option v-for="fase in fases" :key="fase.codAnaResFase" :value="fase.codAnaResFase">
            {{ fase.desAnaResFase }}
          </option>

          </select>


        </div>

        <div class="xl:w-3/12 md:w-3/12 mt-1" >


          <nav class="text-[11px]">Responsable</nav>
          <select v-model="selectedResponsable" :disabled="!selectedProyecto" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
          <option value="" >Selecciona</option>
          <option v-for="responsable in responsables" :key="responsable.codresponsable" :value="responsable.codresponsable">
            {{ responsable.responsable }}
          </option>
          </select>


        </div>

      </div>


    </div>


    <div class="flex flex-row border border-[#D0D9F1] rounded-md md:hidden">

       <div class="w-4/12 flex xl:flex-row">

        <div class=" sm:w-4/12 md:w-full h-full" >
          <!-- h-8 px-2 py-2 w-[50px] -->
          <img
            src="../../assets/logo-black.png"
            class=" ml-1 mt-1"
            title="Volver a la pagina de Inicio."
        />

        </div>

        <div class=" sm:w-8/12  h-full" >

           <div class="text-sm font-bold"> Direktor Monitor <br>
            <nav class="text-[0.7em] text-gray-600">Empresa inarco</nav>
            <nav class="text-[0.7em] text-gray-600">Ultima Actualización {{getDate}}</nav>

           </div>
        </div>


       </div>

       <div class="w-8/12 flex xl:flex-row items-center justify-center">



        <div class="ml-10 border border-[#D0D9F1] rounded-[18px] w-[90px] h-[30px] text-center mt-3 bg-slate-700 text-white font-medium text-sm pt-1">
        Principal
        </div>

        <div class=" border border-[#D0D9F1] rounded-[18px] w-[90px] h-[30px] text-center mt-3 bg-gray-400 text-white font-medium text-sm pt-1">
        Operaciones
        </div>




       </div>

    </div>

    <div class="flex flex-row border border-[#D0D9F1] rounded-md md:hidden">


      <div class="sm:w-3/12  mt-1" >


        <nav class="text-[11px]">Proyecto</nav>
        <select v-model="selectedProyecto" @change="loadFrentes" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
        <option value="" > Selecciona </option>
        <option v-for="proyecto in rawDataProyecto" :key="proyecto.codProyecto" :value="proyecto.codProyecto">
          {{ proyecto.desNombreProyecto }}
        </option>
        </select>


        </div>

        <div class="sm:w-3/12 mt-1" >


        <nav class="text-[11px]">Frente</nav>
        <select :disabled="!selectedProyecto" v-model="selectedFrente" @change="loadFase" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
        <option value="" >Todos</option>
        <option v-for="frente in frentes" :key="frente.codAnaResFrente" :value="frente.codAnaResFrente">
          {{ frente.desAnaResFrente }}
        </option>
        </select>


        </div>


        <div class="sm:w-3/12   mt-1" >


        <nav class="text-[11px]">Fase</nav>
        <select :disabled="!selectedProyecto || !selectedFrente" v-model="selectedFase" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
        <option value="" >Todos</option>
        <option v-for="fase in fases" :key="fase.codAnaResFase" :value="fase.codAnaResFase">
        {{ fase.desAnaResFase }}
        </option>

        </select>


        </div>

        <div class="sm:w-3/12  mt-1" >


        <nav class="text-[11px]">Responsable</nav>
        <select v-model="selectedResponsable" :disabled="!selectedProyecto" id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-xs focus:ring-blue-500 focus:border-blue-500 block w-full p-1.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
        <option value="" >Selecciona</option>
        <option v-for="responsable in responsables" :key="responsable.codresponsable" :value="responsable.codresponsable">
        {{ responsable.responsable }}
        </option>
        </select>


        </div>


    </div>



    <div
      v-if="isLoadingProject == true"
      class="h-full flex justify-center sm:items-start"
      >
        <loading
          v-model:active="isLoadingTrue"
          :can-cancel="false"
          :is-full-page="true"
          loader="dots"
        />
    </div>

    <div class="flex xl:flex-row mt-2 text-center" v-if="!isLoadingProject && rawDataInicial.length > 0 ">

      <div class="flex flex-row xl:w-6/12 md:w-6/12 sm:w-8/12 gap-2 font-medium">


        <div class=" xl:w-3/12   md:w-6/12  sm:w-5/12 h-full border border-[#D0D9F1] rounded-md h-[60px] items-center justify-center" >
            <!-- 15  -->
            <div class="text-[1.4em] font-bold mt-1">{{indicadorCumplimiento}} <n class="text-xs">dias</n></div>
            <div class="text-xs"> # Promedio Cumplimiento</div>
        </div>


        <div @click="validamosdatos" class=" xl:w-3/12  md:w-6/12 sm:w-5/12 h-full border border-[#D0D9F1] rounded-md h-[60px] items-center justify-center" >
            <!-- 15  -->
            <div class="text-[1.4em] font-bold mt-1">{{indicadorAnticipacion}} <n class="text-xs">dias</n></div>
            <div class="text-xs"> # Promedio Anticipacion</div>
        </div>

      </div>




    </div>

    <div class="flex xl:flex-row md:flex-row sm:flex-col   flex-col  mt-2 text-center gap-2" v-if="!isLoadingProject && rawDataInicial.length > 0">


      <BarChart2
      :tipo = 2
      :chartData="barDataByState"
      :chartOptions="barOptionsByState"
      :periodos = []
      :filterHidden = filterHidden
      @emitFilters="updateFilters"
      @removeFilters="removeFilters"

      :height = "'200'"
      class =" xl:w-4/12 md:w-full sm:w-full  border border-[#D0D9F1] rounded-md h-[13em] md:hidden lg:block sm:block"
       />

       <BarChart2
      :tipo = 2
      :chartData="barDataByState"
      :chartOptions="barOptionsByState"
      :periodos = []
      :filterHidden = filterHidden
      @emitFilters="updateFilters"
      @removeFilters="removeFilters"

      :height = "'250'"
      class ="  md:w-3/12  border border-[#D0D9F1] rounded-md h-[14em] md:block lg:hidden sm:hidden"
       />


       <BarChart2
        :tipo = 1
        :chartData="barData"
        :chartOptions="barOptions"
        :periodos = graph2_data
        :filterHidden = filterHidden
        @emitFilters="updateFilters"
        @removeFilters="removeFilters"

        :height = "'240'"
        class ="xl:w-8/12 md:w-full  sm:w-full   border border-[#D0D9F1] rounded-md h-[13em] md:hidden lg:block sm:hidden"
       />

       <BarChart2
        :tipo = 1
        :chartData="barData"
        :chartOptions="barOptions"
        :periodos = graph2_data
        :filterHidden = filterHidden
        @emitFilters="updateFilters"
        @removeFilters="removeFilters"

        :height = "'250'"
        class ="md:w-9/12 sm:w-full   border border-[#D0D9F1] rounded-md h-[14em] md:block lg:hidden sm:block"
       />

    </div>

    <div class="flex xl:flex-row md:flex-row sm:flex-col flex-col   mt-2 text-center gap-2" v-if="!isLoadingProject && rawDataInicial.length > 0">

    <BarChart2
      :tipo = 3
      :chartData="barDatabyResponsable"
      :chartOptions="barOptions2"
      :periodos = graph2_data
      :filterHidden = filterHidden
      @emitFilters="updateFilters"
      @removeFilters="removeFilters"

      :height = "'220'"

      class ="xl:w-6/12 md:w-6/12  border border-[#D0D9F1] rounded-md h-[13em]  sm:hidden"

    />

    <BarChart2
      :tipo = 3
      :chartData="barDatabyResponsable"
      :chartOptions="barOptions2"
      :periodos = graph2_data
      :filterHidden = filterHidden
      @emitFilters="updateFilters"
      @removeFilters="removeFilters"

      :height = "'300'"

      class ="xl:w-full border border-[#D0D9F1] rounded-md h-[19em]  md:hidden lg:hidden sm:block"

    />

    <div class="xl:w-6/12 md:w-6/12 border border-[#D0D9F1] rounded-md h-[13em]">
    <div class="font-medium font-bold w-full text-[12px] mt-1 ml-[10px]" style="text-align: left;">
        Detalle de Restricciones
    </div>

    <table class="w-[96%] text-center ml-[2%]">
        <thead class="border-b border-gray-300 text-[12px]">
            <tr>
                <!-- Asegúrate de ajustar las clases de ancho (w-1/5) según tus necesidades -->
                <td v-for="value in headerCols" :id="value" class="w-1/5">{{ value }}</td>
            </tr>
        </thead>
    </table>

    <!-- Div con desplazamiento para el cuerpo de la tabla -->
    <div class="overflow-y-auto w-[96%] text-center ml-[2%]" style="max-height: calc(13em - 3rem);">
        <table class="w-full">
            <tbody>
                <tr v-for="(item, index) in rawData" :id="index">
                    <!-- Asegúrate de ajustar las clases de ancho (w-1/5) según tus necesidades -->
                    <td class="w-1/5">{{ item['desActividad'] }}</td>
                    <td class="w-1/5">{{ item['desRestriccion'] }}</td>
                    <td class="w-1/5">{{ item['responsable'] }}</td>
                    <td class="w-1/5">{{ formatDate(item['dayFechaConciliada'])  }}</td>
                    <td class="w-1/5">{{ formatDate(item['dayFechaRequerida']) }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>





    </div>

  </div>
</template>

<script>
import Breadcrumb from "../../components/Layout/Breadcrumb.vue";
import store from "../../store";
import Loading from 'vue-loading-overlay';
import BarChart2 from '../../components/barchart2.vue';

import { DateTime } from 'luxon';
import { mapState } from 'vuex';

export default {
  name: "restrictions-view",
  components: {
    Loading,
    Breadcrumb,
    BarChart2,
    DateTime
  },
  data: function () {
    return {

      projectloadflag:false,
      pageloadflag :true,
      rawDataProyecto :[
        {codProyecto : 10, desNombreProyecto : 'Proyecto 001'},
        {codProyecto : 11, desNombreProyecto : 'Proyecto Modificado 002'}
      ],
      rawDataInicial : [
        {id: 1, codProyecto: 10, codAnaResFrente : 1 , desAnaResFrente : 'Frente 001', codAnaResFase : 2, desAnaResFase : 'Fase 001' , dayFechaRequerida: '2023/01/01', dayFechaIdentificacion: '2023/01/01' ,codEstadoActividad:3, estado: 'completado', codresponsable : 1, responsable : 'Diego Warthon', desActividad : 'Encofrado', desTipoRestriccion: 'Arquitectura', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 2, codProyecto: 10, codAnaResFrente : 1 , desAnaResFrente : 'Frente 001', codAnaResFase : 2, desAnaResFase : 'Fase 001' , dayFechaRequerida: '2023/01/01', dayFechaIdentificacion: '2023/01/01' ,codEstadoActividad:3, estado: 'completado', codresponsable : 1, responsable : 'Diego Warthon', desActividad : 'Enchape', desTipoRestriccion: 'Arquitectura', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 3, codProyecto: 10, codAnaResFrente : 1 , desAnaResFrente : 'Frente 001', codAnaResFase : 2, desAnaResFase : 'Fase 001' , dayFechaRequerida: '2023/01/05', dayFechaIdentificacion: '2023/01/01' ,codEstadoActividad:2, estado: 'En proceso', codresponsable : 2, responsable : 'Javier Melendez', desActividad : 'Enchape', desTipoRestriccion: 'Arquitectura', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 4, codProyecto: 10, codAnaResFrente : 1 , desAnaResFrente : 'Frente 001', codAnaResFase : 2, desAnaResFase : 'Fase 001' , dayFechaRequerida: '2023/01/05', dayFechaIdentificacion: '2023/01/01' , codEstadoActividad:1 ,estado: 'Pendiente', codresponsable : 3, responsable : 'Juan Perez', desActividad : 'Encofrado 2', desTipoRestriccion: 'Arquitectura', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 5, codProyecto: 10, codAnaResFrente : 1 , desAnaResFrente : 'Frente 001', codAnaResFase : 2, desAnaResFase : 'Fase 001' , dayFechaRequerida: '2023/01/08', dayFechaIdentificacion: '2023/01/01' ,codEstadoActividad:1,  estado: 'Pendiente', codresponsable : 3, responsable : 'Juan Perez', desActividad : 'Cimentacion', desTipoRestriccion: 'Arquitectura', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},

        {id: 6, codProyecto: 10, codAnaResFrente : 2 , desAnaResFrente : 'Frente Nuevo 002', codAnaResFase : 3, desAnaResFase : 'Fase 002' , dayFechaRequerida: '2023/02/09', dayFechaIdentificacion: '2023/02/01' ,codEstadoActividad:1, estado: 'Pendiente', codresponsable : 1, responsable : 'Diego Warthon', desActividad : 'Cimentacion', desTipoRestriccion: 'Construccion', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 7, codProyecto: 10, codAnaResFrente : 2 , desAnaResFrente : 'Frente Nuevo 002', codAnaResFase : 3, desAnaResFase : 'Fase 002' , dayFechaRequerida: '2023/02/10', dayFechaIdentificacion: '2023/02/01' , codEstadoActividad:2,estado: 'En proceso', codresponsable : 3, responsable : 'Juan Perez', desActividad : 'Cimentacion', desTipoRestriccion: 'Construccion', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 8, codProyecto: 11, codAnaResFrente : 3 , desAnaResFrente : 'Frente Modificado', codAnaResFase : 4, desAnaResFase : 'Fase Modificado' , dayFechaRequerida: '2023/02/10', dayFechaIdentificacion: '2023/02/01' , codEstadoActividad:2, estado: 'En proceso', codresponsable : 2, responsable : 'Javier Melendez', desActividad : 'Cimentacion', desTipoRestriccion: 'Construccion', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 9, codProyecto: 11, codAnaResFrente : 3 , desAnaResFrente : 'Frente Modificado', codAnaResFase : 4, desAnaResFase : 'Fase Modificado' , dayFechaRequerida: '2023/02/11', dayFechaIdentificacion: '2023/02/01' , codEstadoActividad:3, estado: 'completado', codresponsable : 1, responsable : 'Diego Warthon', desActividad : 'Techo', desTipoRestriccion: 'Construccion', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'},
        {id: 10, codProyecto: 11, codAnaResFrente : 3 , desAnaResFrente : 'Frente Modificado', codAnaResFase : 4, desAnaResFase : 'Fase Modificado' , dayFechaRequerida: '2023/02/11', dayFechaIdentificacion: '2023/02/01' , codEstadoActividad:3, estado: 'completado', codresponsable : 2,responsable : 'Javier Melendez', desActividad : 'Techo', desTipoRestriccion: 'Construccion', dayFechaConciliada: '2020/10/12', dayFechaLevantamiento: '2020/10/12'}
      ],
      rawDataColor:{
        'Pendiente'   : "#cccccc",
        'Retrasado'   : "#d13f5a",
        'CompletadoR' : "#3ac189",
        'CompletadoS' : "#e56b37",

      },
      frentes: [],
      fases: [],
      responsables: [],
      selectedProyecto: "",
      selectedFrente: "",
      selectedFase: "",
      selectedResponsable: "",


      orderedColors: [],
      graph2_data : [],
      barData: {},
      barDataByState: {},
      filterEstado:undefined,
      filterPeriodo:undefined,
      filterResponsable:undefined,
      filterHidden:false,
      headerCols: {
        exercise: "Actividad",
        restriction: "Restricción",
        responsible: "Responsable",
        date_conciliad: "F.Conciliada",
        date_required: "D.Requerida",
      },


    };
  },

  watch: {
     selectedProyecto(newVal, oldVal) {
      // console.log(">>> entrando al watch")
      // console.log(newVal)
      // console.log(oldVal)
      if (newVal != oldVal) {

        this.responsables        = [];
        this.selectedResponsable = "";

      }
    }
  },

  methods: {
    formatDate(date) {
      const d = new Date(date);
      let day = d.getDate();
      let month = d.getMonth() + 1; // Los meses comienzan desde 0, por lo que añadimos 1.
      const year = d.getFullYear().toString().substr(-2); // Obtén solo los dos últimos dígitos del año.

      // Asegúrate de que tanto el día como el mes siempre tengan dos dígitos.
      day = day < 10 ? '0' + day : day;
      month = month < 10 ? '0' + month : month;

      return `${day}/${month}/${year}`;
    },

    validamosdatos(){

      console.log("proyecto :: "+this.selectedProyecto)
      console.log("frente :: "+this.selectedFrente)
      console.log("fase :: "+this.selectedFase)
      console.log("responsable :: "+this.selectedResponsable)


    },
    loadResponsables() {
      const filteredResponsables = this.rawDataInicial.filter(item => item.codProyecto === this.selectedProyecto);

      // Creamos un arreglo de objetos únicos
      const uniqueResponsables = [];
      const addedResponsables = new Set();

      for (const responsable of filteredResponsables) {
        if (!addedResponsables.has(responsable.responsable)) {
          uniqueResponsables.push({
            codresponsable: responsable.codresponsable,
            responsable: responsable.responsable
          });
          addedResponsables.add(responsable.responsable);
        }
      }

      this.responsables = uniqueResponsables;
    },

    async loadFrentes() {

      this.projectloadflag = true;
      await store.dispatch('get_data_restricciones_indicators', {codProyecto:this.selectedProyecto}).then(res => {
          // console.log(">>> impresion al cambiar codproyecto")

          console.log(res.data)
          this.rawDataInicial = res.data.restricciones
          // console.log(res.data)

      });

      this.loadResponsables();

      const filteredFrentes = this.rawDataInicial.filter(item => item.codProyecto === this.selectedProyecto);

      // Creamos un arreglo de objetos únicos
      const uniqueFrentes = [];
      const addedFrentes = new Set();

      for (const frente of filteredFrentes) {
        if (!addedFrentes.has(frente.desAnaResFrente)) {
          uniqueFrentes.push({
            codAnaResFrente: frente.codAnaResFrente,
            desAnaResFrente: frente.desAnaResFrente
          });
          addedFrentes.add(frente.desAnaResFrente);
        }
      }

      this.frentes = uniqueFrentes;
      this.fases = [];
      this.selectedFrente  = "";
      this.selectedFase    = "";
      this.projectloadflag = false;
    },

    loadFase() {
      const filteredFases = this.rawDataInicial.filter(item => item.codAnaResFrente === this.selectedFrente);

      // Creamos un arreglo de objetos únicos
      const uniqueFases = [];
      const addedFases = new Set();

      for (const fase of filteredFases) {
        if (!addedFases.has(fase.desAnaResFase)) {
          uniqueFases.push({
            codAnaResFase: fase.codAnaResFase,
            desAnaResFase: fase.desAnaResFase
          });
          addedFases.add(fase.desAnaResFase);
        }
      }

      this.fases = uniqueFases;
    },
    handleRedirect(path) {
      this.$router.push(path);
    },

    datatimeStyleChange(data) {
      if (data) {
        let datetime = new Date(data);
        let month = datetime.getMonth() + 1;
        let day = datetime.getDay() - 1;
        return day + '/' + month;
      }
    },
    orderColors() {
      // Obtener las claves y ordenarlas alfabéticamente
      const orderedKeys = Object.keys(this.rawDataColor);
      // Obtener los valores correspondientes a las claves ordenadas
      this.orderedColors = orderedKeys.map(key => this.rawDataColor[key]);
      // Ahora, this.orderedColors contendrá los colores en el orden alfabético de sus claves
      console.log('Colores ordenados:', this.orderedColors);
    },
    updateFilters(data){
      this.filterEstado       = data.estado;
      this.filterPeriodo      = data.periodo;
      this.filterResponsable  = data.responsable;
    },
    removeFilters(data){
      this.filterEstado   = undefined;
      this.filterPeriodo  = undefined;
      this.filterResponsable  = undefined;
    },
    updateCharts(label) {
      console.log(label);
      // Aquí va tu lógica para actualizar los gráficos
    },


  },
  computed: {
    ...mapState(['data']),

    getDate(){

      const ahoraLima = DateTime.now().setZone('America/Lima');
      // Formatea la fecha y hora como desees
      const fechaHoraLima = ahoraLima.toFormat('dd/MM/yyyy');

      return fechaHoraLima
    },

    isLoadingTrue(){
       return true
    },
    isLoading: function(){
      return this.pageloadflag
    },
    isLoadingProject: function(){
      return this.projectloadflag
    },
    indicadorCumplimiento: function (){

        let totalDias = 0;
        let contador = 0;

        this.rolProyecto
        // console.log(">>> empesamos a ver el cumplimiento")
        this.rawData.forEach((item) => {

                if (item.dayFechaLevantamiento != '' && item.dayFechaRequerida != '' && item.codEstadoActividad == 3){

                let partes_fl = item.dayFechaLevantamiento.split("/");
                let partes_fr = item.dayFechaRequerida.split("/");

                let fechaLevantamiento = new Date(partes_fl[0], partes_fl[1] - 1, partes_fl[2]);
                let dayFechaRequerida  = new Date(partes_fr[0], partes_fr[1] - 1, partes_fr[2]);
                let diferenciaDias = Math.round((dayFechaRequerida - fechaLevantamiento) / (1000 * 60 * 60 * 24));
                console.log(fechaLevantamiento)

                totalDias += diferenciaDias;
                contador++;

                }

        });

        let promedioDias = Math.round(totalDias / contador);
        return promedioDias;

    },
    indicadorAnticipacion: function (){

      let totalDias = 0;
      let contador = 0;

      this.rawData.forEach((item) => {


            if (item.dayFechaRequerida  !="" && item.dayFechaIdentificacion != "") {
              let dayFechaRequerida = new Date(item.dayFechaRequerida);
              let fechaIdentificacion = new Date(item.dayFechaIdentificacion);
              let diferenciaDias = Math.round((dayFechaRequerida - fechaIdentificacion) / (1000 * 60 * 60 * 24));
              totalDias += diferenciaDias;
              contador++;
            }


      });

      let promedioDias = Math.round(totalDias / contador);
      return promedioDias;


    },


    rawData() {
      let filtered = this.rawDataInicial;

      if (this.selectedProyecto != "") {
        filtered = filtered.filter(item => item.codProyecto === this.selectedProyecto);
      }
      if (this.selectedFrente != "") {
        filtered = filtered.filter(item => item.codAnaResFrente === this.selectedFrente);
      }
      if (this.selectedFase != "") {
        filtered = filtered.filter(item => item.codAnaResFase === this.selectedFase);
      }
      if (this.selectedResponsable != "") {
        filtered = filtered.filter(item => item.codresponsable === this.selectedResponsable);
      }



      if (this.filterEstado !== undefined) {
        filtered = filtered.filter(item => item.estado === this.filterEstado);
      }

      if (this.filterPeriodo !== undefined) {

        filtered = filtered.filter(item => {
          const date = new Date(item.dayFechaRequerida).getYearAndMonthNumber();
          return date == this.filterPeriodo
        });
      }


      if (this.filterResponsable !== undefined ) {
         filtered = filtered.filter(item => item.responsable.toLowerCase().includes(this.filterResponsable.toLowerCase()));
      }

      // console.log(filtered)

      return filtered;
    },

    uniqueResponsables() {
      const responsable = this.rawData.map(item => item.responsable);
      const uniqueResponsables = [...new Set(responsable)];
      return uniqueResponsables;
    },


    uniqueStates() {
      const states = this.rawData.map(item => item.estado);
      const uniqueStates = [...new Set(states)];
      return uniqueStates;
    },

    groupedByResponsable() {
    const groups    = {};
    const statesSet = new Set();

    this.rawData.forEach(row => {
      // Lógica para determinar la semana (esto es un ejemplo)
      const responsable  =  row.responsable; // `${new Date(row.responsable).getWeek()}`;
    //   const month = `${new Date(row.responsable).getYearAndMonthNumber()}`;

      if (!groups[responsable]) {
        groups[responsable]            = {};
        groups[responsable]['data']    = {};
        // groups[week]['periodo'] = month;
      }


      if (!groups[responsable]['data'][row.estado]) {
          groups[responsable]['data'][row.estado] = 0 // [row.estado] = 0;

      }

      groups[responsable]['data'][row.estado]++;
      statesSet.add(row.estado);
    });

    console.log(">>> vemos el final de las condiocoones")
    console.log(groups)

    for (const responsable in groups) {
      // console.log(`Semana ||| : ${semana}`);
      // console.log(groups[semana]['periodo'])
      // this.graph2_data.push(groups[responsable]['periodo'])

      this.uniqueStates.forEach((estado) => {
        if (groups[responsable]['data'][estado] == undefined){
          groups[responsable]['data'][estado] = 0
        }

      });

    }

    // this.availableStates = [...statesSet];


    const data = {}
    data['responsables']  = groups

    console.log('>>>>>>>>> aqui vemos que tal los responsables')
    console.log(groups)

    return data;
    },

    groupedByWeek() {
      const groups    = {};
      const groups_m  = {};
      const statesSet = new Set();

      this.rawData.forEach(row => {
        // Lógica para determinar la semana (esto es un ejemplo)
        const week = `Sem. ${new Date(row.dayFechaRequerida).getWeek()}`;
        const month = `${new Date(row.dayFechaRequerida).getYearAndMonthNumber()}`;

        if (!groups[week]) {
          groups[week]            = {};
          groups[week]['data']    = {};
          groups[week]['periodo'] = month;
        }
        if (!groups_m[month]) groups_m[month] = {};

        // if (!groups_m[month]){
          if (groups_m?.[month]?.[week] == undefined) {
            groups_m[month][week] = 1
            // groups_m[month][week]['mes'] = 1
            // groups_m[month][week]['anio'] = 1
          }

        // }

        if (!groups[week]['data'][row.estado]) {
            groups[week]['data'][row.estado] = 0 // [row.estado] = 0;

        }

        groups[week]['data'][row.estado]++;
        statesSet.add(row.estado);
      });

      // console.log(groups)

      for (const semana in groups) {
        // console.log(`Semana ||| : ${semana}`);
        // console.log(groups[semana]['periodo'])
        this.graph2_data.push(groups[semana]['periodo'])

        this.uniqueStates.forEach((estado) => {
          if (groups[semana]['data'][estado] == undefined){
            groups[semana]['data'][estado] = 0
          }

        });

      }

      this.availableStates = [...statesSet];

      const groups_months = Object.keys(groups_m).map(key => {
        return {
          title: key.convertToYearAndMonth(),
          ntitle : key,
          cols: Object.keys(groups_m[key]).length
        };
      });

      const data = {}
      data['weeks']  = groups
      data['groups'] = groups_months

      console.log('>>>>>>>>> aqui vemos que tal')
      console.log(groups)

      return data;
    },

    groupedByState() {
      const groups = {};

      this.rawData.forEach(row => {
        if (!groups[row.estado]) groups[row.estado] = 0;

        groups[row.estado]++;
      });

      const ordered = {};

      // Iteramos sobre cada clave en rawDataColor
      Object.keys(this.rawDataColor).forEach((key) => {
      if (groups.hasOwnProperty(key)) {
        ordered[key] = groups[key];
      }
      });

      return ordered;

    },
    barData() {
    const series = {};
    const labels = Object.keys(this.groupedByWeek['weeks']);

    labels.forEach(label => {
      const data = this.groupedByWeek['weeks'][label];

      Object.keys(data['data']).forEach(state => {
        if (!series[state]) {
          series[state] = [];
          series[state]['data']    = [];
          series[state]['periodo'] = data['periodo'];
        }

        series[state]['data'].push(data['data'][state]);
      });
    });

    const ordered = {};

     // Iteramos sobre cada clave en rawDataColor
     Object.keys(this.rawDataColor).forEach((key) => {
      if (series.hasOwnProperty(key)) {
        ordered[key] = series[key];
      }
    });

    const apexSeries = Object.keys(ordered).map(state => ({
      name: state,
      periodo : ordered[state]['periodo'],
      data: ordered[state]['data']
    }));

    console.log(">>>>>>> apexseries del primero ")
    console.log(apexSeries)

    return {
      labels,
      series: apexSeries
    };
    },
    barDataByState() {
      return {
        labels: Object.keys(this.groupedByState),
        datasets: [
          {
            data: Object.values(this.groupedByState),
          },
        ],
      };
    },
    barOptions() {
      return {
        chart: {
          type: 'bar',
          stacked: true,
          width: '100%',
        },

        colors: this.orderedColors,

        plotOptions: {
              bar: {
                borderRadius: 2,
                dataLabels: {
                  total: {
                    enabled: true,
                    style: {
                      fontSize: '11px',
                      fontWeight: 900
                    }
                  },
                  position: 'center'
                }
              }
        },
        dataLabels: {
          enabled: true
        },
        grid: {
          row: {
            colors: ["#fff", "#f2f2f2"]
          }
        },
        yaxis: {
          title: {
            text: 'Restricciones',
            style: {
                    fontSize: '11px',
                    fontWeight: 700
                  },
          },
        },
        xaxis: {
          categories: Object.keys(this.groupedByWeek['weeks']),
          group: {
                  style: {
                    fontSize: '11px',
                    fontWeight: 700
                  },
                  groups: this.groupedByWeek['groups']
                },
          // title: {
          //   text: 'Semana / Año-Mes',
          //   style: {
          //           fontSize: '12px',
          //           fontWeight: 700
          //         },
          // },

        },
        title: {
          text: "Estado y Cantidad de restricciones x corte de semana",
          style: {
                    fontSize: '12px',
                    position:'Absolute',
                    fontWeight: 700
                  },
        },
        legend: {
              show: true,
              position: 'top',
              offsetY: 10
        },

        // stroke: {
        //   width: [0, 2, 5],
        //   curve: "smooth"
        // },

        // tooltip: {
        //   shared: true,
        //   intersect: false,
        //   y: {
        //     formatter: function(y) {
        //       if (typeof y !== "undefined") {
        //         return y.toFixed(0) + " points";
        //       }
        //       return y;
        //     }
        //   }
        // }

      };
  },

  barOptionsByState() {
      return {
        chart: {
          type: 'bar',
          stacked: true,
          width: '100%',
          // events: {
          //   click: (event, chartContext, config) => {
          //     this.$emit('barClicked', config.dataPointIndex);
          //   },
          // },
        },

        title: {
          text: "Estado de Restricciones",
          style: {
                    fontSize: '12px',
                    position:'Absolute',
                    fontWeight: 700
                  },
        },

        plotOptions: {
          bar: {
            distributed: true  // Esto asegura que cada barra tenga un color diferente
          }
        },
        // grid: {
        //   row: {
        //     colors: ['#cccccc', '#e56b37', '#3ac189']
        //   }
        // },
        grid: {
          row: {
            colors: ["#fff", "#f2f2f2"]
          }
        },
        colors: this.orderedColors,
        xaxis: {
          categories: Object.keys(this.groupedByState),
          labels: {
            // style: {
            //   colors: ['#cccccc', '#e56b37', '#3ac189'],  // Y aquí también
            // },
          },
        },

        yaxis: {
          title: {
            text: 'Restricciones',
            style: {
                    fontSize: '11px',
                    fontWeight: 700
                  },
          },
        },
        legend: {
              show: true,
              position: 'top',
              offsetY: 10
        },
      };
    },


  barDatabyResponsable() {
    const series = {};
    const labels = Object.keys(this.groupedByResponsable['responsables']);

    labels.forEach(label => {
      const data = this.groupedByResponsable['responsables'][label];

      Object.keys(data['data']).forEach(state => {
        if (!series[state]) {
          series[state] = [];
          series[state]['data']    = [];
        //   series[state]['periodo'] = data['periodo'];
        }

        series[state]['data'].push(data['data'][state]);

      });
    });

    const ordered = {};

     // Iteramos sobre cada clave en rawDataColor
     Object.keys(this.rawDataColor).forEach((key) => {
      if (series.hasOwnProperty(key)) {
        ordered[key] = series[key];
      }
    });

    const apexSeries = Object.keys(ordered).map(state => ({
      name: state,
    //   periodo : ordered[state]['periodo'],
      data: ordered[state]['data']
    }));

    console.log(">> impresion del apexseries ::")
    console.log(apexSeries)

    return {
      labels,
      series: apexSeries
    };

  },


 barOptions2() {
    return {
        chart: {
          type: 'bar',
          stacked: true,
          width: '100%',
        },

        colors: this.orderedColors,

        plotOptions: {
              bar: {
                borderRadius: 2,
                horizontal: true,
                dataLabels: {
                  total: {
                    enabled: true,
                    style: {
                      fontSize: '11px',
                      fontWeight: 900
                    }
                  },
                  position: 'center'
                }
              }
        },
        dataLabels: {
          enabled: true
        },
        grid: {
          row: {
            colors: ["#fff", "#f2f2f2"]
          }
        },
        yaxis: {
          title: {
            text: 'Responsables',
            style: {
                    fontSize: '11px',
                    fontWeight: 700
                  },
          },
        },
        xaxis: {
          categories: Object.keys(this.groupedByResponsable['responsables']),
          title: {
            text: 'Restricciones',
            style: {
                    fontSize: '12px',
                    fontWeight: 700
                  },
          },

        },
        title: {
          text: "Cantidad de restricciones x Area y Responsable",
          style: {
                    fontSize: '12px',
                    position:'Absolute',
                    fontWeight: 700
                  },
        },
        legend: {
              show: true,
              position: 'top',
              offsetY: 10
        },

        // stroke: {
        //   width: [0, 2, 5],
        //   curve: "smooth"
        // },

        // tooltip: {
        //   shared: true,
        //   intersect: false,
        //   y: {
        //     formatter: function(y) {
        //       if (typeof y !== "undefined") {
        //         return y.toFixed(0) + " points";
        //       }
        //       return y;
        //     }
        //   }
        // }

      };
  },


  },
  mounted: async function(){

    this.rawDataInicial  = []
    await store.dispatch("get_datos_project_indicators").then(res => {
        this.rawDataProyecto = res.data

    });

    this.orderColors();
    this.pageloadflag = false;

  }
};
</script>
