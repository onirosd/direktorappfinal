<template>
  <div class="w-full h-screen bg-modal flex items-center justify-center modal-background fixed top-0 left-0 z-40">
    <div class="w-[95%] sm:w-[296px] rounded-2xl bg-white absolute p-6 sm:px-3 sm:py-3 overflow-auto  justify-between">

      <div v-if="mostrarFlotante" class="fixed inset-0 bg-black bg-opacity-50 z-10"></div>

      <!-- Panel de justificacion de retrasados  - Final -->
      <justificacionRetrasoCliente

         :get_rolProyecto="get_rolProyecto"
         :mostrarFlotante="mostrarFlotante"
         :form_data="form_data"
         :motivosRetraso="motivosRetraso"
         @actualizarFlotante = "actualizarFlotante"
         @guardarFormulario = "guardarFormulario"
      >
      </justificacionRetrasoCliente>
      <!-- Panel de justificacion de retrasados  - Final -->

      <img
        src="../assets/modal-close.svg"
        alt=""
        class="absolute top-4 right-4 cursor-pointer"
        @click="$emit('closeModal')"
      />
      <div class="grid grid-cols-12 gap-2 items-end mb-3 border border-[#D0D9F1] rounded-md sm:hidden">
        <div class="flex xl:flex-row  col-span-2 ...">



           <div class="xl:w-3/12 md:w-3/12 sm:w-full md:w-full h-full" >
          <!-- h-8 px-2 py-2 w-[50px] -->
          <img
            src="../assets/logo-black.png"
            class=" ml-1 mt-1"
            title="Volver a la pagina de Inicio."
        />

        </div>

        <div class="xl:w-9/12 md:w-9/12 sm:w-full  h-full" >

           <div class="text-sm font-bold"> Direktor Calendario <br>
            <nav class="text-[0.7em] text-gray-600">Perfil :  <n class="font-bold"> {{get_rolUsuarioDesc}}</n> </nav>
            <nav class="text-[0.7em] text-gray-600">Empresa : INARCO</nav>

           </div>
        </div>

        </div>
        <div v-if="isloading == false" class="flex col-span-8 ... ">

          <div v-if="( get_rolProyecto == 3 || get_rolProyecto == 0 )" class="text-[#4b5563] mr-2 xl:w-1/12 md:w-6/12 sm:w-5/12 border border-[#D0D9F1] rounded-md grid justify-items-center text-center text-[0.7em]" >
            <!-- <i  class="fa fa-th cursor-pointer text-[2em] " aria-hidden="true"></i> -->
            <input type="checkbox" id="checkbox" v-model="get_verCalendarioTodasAct" @change="cambioVertodasmisactividades" class="mt-2">

            Ver mis actividades
          </div>

          <div v-if="ctdRetrasados > 0" class="mr-2 xl:w-2/12 md:w-6/12 sm:w-5/12 border border-[#D0D9F1] rounded-md grid justify-items-center" >

            <div class="text-[1.2em] font-bold text-[#d13f5a]">{{ctdRetrasados}} <n class="text-md"><i class="fa fa-warning "></i></n></div>
            <div class=" text-xs text-[#d13f5a]"> # Actividades Retrasadas</div>
          </div>

          <div  class=" xl:w-2/12 md:w-6/12 sm:w-5/12 border border-[#D0D9F1] rounded-md grid justify-items-center" >

            <div class="text-[1.2em] font-bold text-[#4b5563]">{{ctdpendDia}} <n class="text-md"><i class="fa fa-calendar"></i></n></div>
            <div class=" text-xs text-[#4b5563]"> # Actividades del Dia</div>
          </div>

        </div>
        <div v-if="isloading == false" class="col-span-2 ... grid justify-items-center">
          <button class="bg-gray-600 text-white w-[140px] text-xs rounded">Semana {{get_date_week_str}}</button>
          <div class="flex items-center text-xs text-gray-600">
             <i @click="cambiarSemana(1)" class="fa fa-caret-left text-gray-600 cursor-pointer text-[2em] hover:text-gray-800  transition duration-300" aria-hidden="true"></i>
             <div class = "text-xs">  {{get_day_init_week_str}} - {{get_day_fin_week_str}} </div>
             <i @click="cambiarSemana(2)"  class="fa fa-caret-right text-gray-600 cursor-pointer text-[2em] hover:text-gray-800  transition duration-300" aria-hidden="true"></i>
          </div>
        </div>
      </div>

      <div v-if="isloading == false" class="grid gap-1 grid-flow-col overflow-x-auto overflow-y-hidden border-double br-gray-600 border-b-4 border-t-4 h-[30em] text-base text">

        <div  v-for="(data, day) in listaSemana" :key="day" class="grid grid-cols-1 w-[220px] px-[0.1px] z-0">
          <!-- Si es reatrasados -->
          <div :ref="'ref_'+day" v-if="day == 'Retrasados'" class=" flex flex-col bg-red-100  h-full justify-between">

              <div :ref="'top_'+day" class="border-2 border-[#d13f5a] rounded grid items-center justify-center text-xs mb-2"><span class="w-full ">{{ 'Actividades Retrasadas ' }} <i class="fa fa-warning text-[#d13f5a] pl-2 text-[1.5em]"></i> </span></div>
              <!-- retrasado diferente de completado -->
              <div :ref="'body_'+day" class="h-[100%]">
                <div class="border border-[#d13f5a] hover:border-2 rounded text-xs mb-1 py-1 px-3" v-for="item in data.list.filter(el => el.isthisweek == 0 && el.isretrasado == 1 && el.cod_estado != 3)" :key="item.index">
                  <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                    <div>
                    <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                    <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                    <div class=" text-xs text-[0.9em]">Frente</div>
                    <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                    </div>

                    <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection"></SelectPer2>

                </div>
              </div>
              <div :ref="'footer_'+day"  class="mt-auto z-20"  v-if="get_buttonOverStatusDias[day] == true" @click="buttonOverChangeStatus(day)">
                 <button class="border-[#d13f5a] bg-[#d13f5a] text-white w-full rounded my-1 h-[30px] text-xs">
                  Ver mas...
                 </button>
              </div>
              <div :ref="'footer_'+day" v-else class="mt-auto z-20"  >
                <button disabled class="bg-gray-300 text-white w-full rounded my-1 h-[30px] text-xs">
                    (0) Registros adicionales
                </button>
              </div>

          </div>
          <!-- Si no es retrasados -->
          <div :ref="'ref_'+day"   v-else  :class="data.isthisday == 1 ? ' bg-[#e2e2e2]' : '   bg-[#fbfbfb]'" class=" flex flex-col justify-between z-10">

            <div
              :ref="'top_'+day"
              class="border rounded grid items-top justify-center  "
              :class="data.isthisday == 1 ? 'border-gray-700 border-2' : 'border-gray-600'"
            >
              <span class="w-full text-xs mt-[0.4em]"> {{ data.straNameDate }} {{ data.strDate }} {{overLunes}} <i v-if="data.isthisday == 1" class="fa fa-calendar font-bold text-[#4b5563] pl-2 text-[1.5em]"></i></span>

            </div>

            <div :ref="'body_'+day" class="h-[100%]">

            <!-- impresion de los pendiente a aprobar , siempre van primero -->
            <!-- <div class="border rounded text-xs mb-1 py-1 px-3 border-[#cd4fb2] " v-for="item in data.list.filter(el =>el.cod_estado == 4)" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                <div>
                  <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                  <div class=" text-xs text-[0.9em]">Frente</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                </div>
                <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection" class="z-20"></SelectPer2>

            </div> -->

            <div class="items-top" v-if="data.cantpAprobacion > 0 " >
              <div class="text-center border-[#cd4fb2] text-xs">
                <i class="fa fa-minus mx-2"></i>{{ 'Actividades por Aprobar' }}<i class="fa fa-minus mx-2"></i>
              </div>
              <div class="border rounded text-xs mb-1 py-1 px-3 border-[#cd4fb2] " v-for="item in data.list.filter(el => el.cod_estado == 4 )" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                <div>

                  <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                  <div class=" text-xs text-[0.9em]">Frente</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                </div>
                <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" :lectura = "1" @change="handleSelection"></SelectPer2>
              </div>
            </div>

            <!-- impresion de los pendientes , siempre van primero -->
            <div class="border rounded text-xs mb-1 py-1 px-3 border-gray-600 hover:border-2 hover:border-blue-500" v-for="item in data.list.filter(el => el.isretrasado == 0 && el.cod_estado == 1)" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                <div>
                  <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                  <div class=" text-xs text-[0.9em]">Frente</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                </div>
                <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection" class="z-20"></SelectPer2>

            </div>
            <!-- impresion de los en proceso, siempre van despues del primero -->
            <div class="border rounded text-xs mb-1 py-1 px-3 border-gray-600 hover:border-2 hover:border-blue-500" v-for="item in data.list.filter(el => el.isretrasado == 0 && el.cod_estado == 2)" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                <div>
                  <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                  <div class=" text-xs text-[0.9em]">Frente</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                </div>
                <SelectPer2 :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection"></SelectPer2>
            </div>
             <!-- si  tenemos mas de 1 retrasado en el dia -->
            <div class="items-top" v-if="data.cantRetrasados > 0 " >
              <div class="text-center border-[#d13f5a] text-xs">
                <i class="fa fa-minus mx-2"></i>{{ 'Actividades Retrasadas' }}<i class="fa fa-minus mx-2"></i>
              </div>
              <div class="border rounded text-xs mb-1 py-1 px-3 border-[#d13f5a] hover:border-2" v-for="item in data.list.filter(el => el.isretrasado == 1 && (el.cod_estado == 1 || el.cod_estado == 2 ))" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>
                <div>

                  <div class="text-xs mt-2 text-[0.9em]" >Actividad</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_actividad }}</div>
                  <div class=" text-xs text-[0.9em]">Frente</div>
                  <div class="text-gray-500 text-[0.8em]">{{ item.desc_frente }}</div>
                </div>
                <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection"></SelectPer2>
              </div>
            </div>
            <!-- si tenemos mas de  1 completados en el dia -->
            <div class="items-top" v-if="data.cantCompletados > 0 " >
              <div  class="text-center text-[#47ab24] text-xs">
                <i class="fa fa-minus mx-2"></i>{{ "Actividades Completadas" }}<i class="fa fa-minus mx-2"></i>
              </div>

              <div class="border rounded text-xs mb-1 py-1 px-3 border-[#47ab24] hover:border-2" v-for="item in data.list.filter(el => el.cod_estado == 3 )" :key="item.index">
                <div class="text-xs text-gray-800 leading-none">{{ item.desc_restriccion }}</div>

                <SelectPer2  :desc_restriccion = "item.desc_restriccion" :initialValue="item.cod_estado" :cod_restriccion="item.cod_restriccion" :isretrasado = "item.isretrasado" @change="handleSelection"></SelectPer2>

              </div>

            </div>
            </div>
            <div :ref="'footer_'+day"  class="mt-auto z-20"  v-if="get_buttonOverStatusDias[day] == true" @click="buttonOverChangeStatus(day)">
                 <button class="bg-gray-600 text-white w-full rounded my-1 h-[30px] text-xs">
                  Ver mas...
                 </button>
            </div>
            <div :ref="'footer_'+day"  v-else class="mt-auto z-20"  >
              <button disabled class="bg-gray-300 text-white w-full rounded my-1 h-[30px] text-xs">
                  (0) Registros adicionales
              </button>
            </div>

          </div>

        </div>
      </div>

      <div v-else  class="justify-center sm:items-start grid gap-1 grid-flow-col overflow-x-auto overflow-y-hidden border-double br-gray-600 border-b-4 border-t-4 h-[30em] text-base text">
        <loading
          v-model:active="isloading"
          :can-cancel="false"
          :is-full-page="true"
          loader="dots"
          :ref="'DIREKTOR'"
          class = "mt-[5em]"
        />
     </div>
    </div>
  </div>
</template>

<script>
import Loading from "vue-loading-overlay";
import SelectPer2 from "./SelectPer2.vue";
import justificacionRetrasoCliente from "./justificacionRetrasoCliente.vue";
import store      from "../store";
import moment from 'moment-timezone';
export default {
  name: "success-component",

  components: {
    Loading,
    SelectPer2,
    justificacionRetrasoCliente,
    moment

  },
  props: {
    rolProyecto:Number,
    verCalendarioTodasAct:Boolean,
    rolUsuarioDesc:String
  },
  data: function () {
    return {
      // verCalendarioTodasAct: false,
      fechaReferencia: "",
      isloading : true,
      mensajeError: '',
      mostrarError: false,
      form_data : {

        form_titulo: '',
        form_seleccion: '',
        form_comentario: '',
        form_cod_estado: 0,
        form_cod_restriccion : 0,

        mostrarError: false,
        mensajeError: '',

      },
      form_titulo: '',
      form_seleccion: '',
      form_comentario: '',
      form_cod_estado: 0,
      form_cod_restriccion : 0,
    // mostrarFlotante: false
      mostrarFlotante: false,
      estadoSeleccionado: 'pendiente',
      ctdRetrasados : 0,
      ctdpendDia    : 0,
      buttonOverStatusDias  :{
         Lunes: false,
         Martes: false,
         Miercoles: false,
         Jueves: false,
         Viernes: false,
         Sabado: false,
         Domingo: false
      },
      overPixelesInicial : 0,
      rawDataPrincipal : {
      isSemanaActual : 1,
      fechaFin    : null,
      fechaIni    : null,
      fechaActual : " - ",
      numSemana   : null,
      listaData   :        [
       {
            cod_restriccion: 171,
            desc_restriccion: "Definir datos de nuevos datos",
            desc_actividad: "Vaciado de losa",
            desc_frente: "TORRE",
            cod_frente: 3,
            fec_conciliada: "2023-09-11 12:00:00",
            fec_real: "2023-09-11 13:08:10",
            desc_estado: "Pendiente",
            cod_estado:  1,
            isretrasado: 0,
            isthisweek : 1,
            isthisday  : 0,
            weekIniDate: "2023-09-11",
            weekFinDate: "2023-09-17",
            weekYear: 37
        },
      ],
      listaMotivoRetraso:  [
        { id: 1, texto: "nada" },
        { id: 2, texto: "veremos" }
      ],
      }

    };
  },
  computed: {
  get_rolUsuarioDesc(){
    return this.rolUsuarioDesc.toUpperCase();
  },
  get_verCalendarioTodasAct(){
    return  (this.rolProyecto == 3 || this.rolProyecto == 0) ?  !this.verCalendarioTodasAct : this.verCalendarioTodasAct
  },

  get_rolProyecto(){
    return this.rolProyecto
  },
  get_buttonOverStatusDias(){

    return this.buttonOverStatusDias
  },

  motivosRetraso(){
      return this.$store.state.motivosSelecCalendar;
  },
  get_day_init_week_str(){
    return this.rawDataPrincipal.fechaIni == null ? '?' : new Date().getDayCorta(this.rawDataPrincipal.fechaIni);
  },
  get_day_fin_week_str(){
    return this.rawDataPrincipal.fechaFin == null ? '?' :  new Date().getDayCorta(this.rawDataPrincipal.fechaFin);
  },
  get_date_week_str(){
    return this.rawDataPrincipal.numSemana == null ? '?' :  this.rawDataPrincipal.numSemana
  },
  listaSemana() {
      // isSemanaActual
      const dataPrincipal  =   this.rawDataPrincipal;
      let isSemanaActual   = dataPrincipal.isSemanaActual
      let fechaInicio   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_lunes   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_martes   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_miercoles   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_jueves   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_viernes   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_sabado   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      let fecha_domingo   = moment.tz(dataPrincipal.fechaIni, "America/Lima");
      fecha_lunes.add(0, 'days');
      fecha_martes.add(1, 'days');
      fecha_miercoles.add(2, 'days');
      fecha_jueves.add(3, 'days');
      fecha_viernes.add(4, 'days');
      fecha_sabado.add(5, 'days');
      fecha_domingo.add(6, 'days');
        // let nuevaFecha = fechaObj.format('YYYY-MM-DD')
      // let fechaInicio      =   new Date(dataPrincipal.fechaIni);
      let fechaActual      =   this.rawDataPrincipal.fechaActual;
      let ctdRetrasados    =   0;
      let cantpendDia      =   0;
      let retrasados       =   [];
      let baseSemana       =   {
        'Lunes':     {straNameDate: 'Lunes', strDate  : fecha_lunes.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_lunes.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Martes':    {straNameDate: 'Martes', strDate  : fecha_martes.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_martes.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Miercoles': {straNameDate: 'Miercoles', strDate  : fecha_miercoles.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_miercoles.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Jueves':    {straNameDate: 'Jueves', strDate  : fecha_jueves.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_jueves.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Viernes':   {straNameDate: 'Viernes', strDate  : fecha_viernes.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_viernes.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Sabado':    {straNameDate: 'Sabado', strDate  : fecha_sabado.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_sabado.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
        'Domingo':   {straNameDate: 'Domingo', strDate  : fecha_domingo.format('YYYY-MM-DD'), list : [], isthisday: fechaActual == fecha_domingo.format('YYYY-MM-DD') && isSemanaActual == 1 ? 1 : 0, cantRetrasados: 0,cantCompletados: 0 , cantpAprobacion: 0},
      };


      for (let registro of dataPrincipal['listaData']) {
        let fecha = new Date(registro.fec_conciliada);

        if (registro.isretrasado == 1 && registro.isthisweek == 0) {
          console.log(">>> insertamos retrasados")
          registro.fec_conciliada = registro.fec_conciliada.split(' ')[0]
          retrasados.push(registro);
          continue;
        }

        let dia = fecha.getDayAdjusted();

        console.log(">>> impresion de dia")
        console.log(dia)

        registro.fec_real = registro.fec_real != null ? registro.fec_real.split(' ')[0] : null
        // if(registro.isthisday == 1 ){

        // }

        switch(dia) {

          case 0:
            baseSemana['Lunes']['list'].push(registro)
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Lunes']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Lunes']['cantCompletados']     = 1;}
            if (registro.cod_estado  == 4){ baseSemana['Lunes']['cantpAprobacion']     += 1;}
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }

            break;
          case 1:
            baseSemana['Martes']['list'].push(registro)
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Martes']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Martes']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Martes']['cantpAprobacion']     += 1;}
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }

            break;
          case 2:
            baseSemana['Miercoles']['list'].push(registro)
            // if (registro.isretrasado == 1){ baseSemana['Miercoles']['cantRetrasados'] = 1; }
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Miercoles']['cantRetrasados']    += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Miercoles']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Miercoles']['cantpAprobacion']     += 1; }
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }

            break;
          case 3:
            baseSemana['Jueves']['list'].push(registro)
            // if (registro.isretrasado == 1){ baseSemana['Jueves']['cantRetrasados']  = 1;}
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Jueves']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Jueves']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Jueves']['cantpAprobacion']     += 1;}
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }

            break;
          case 4:
            baseSemana['Viernes']['list'].push(registro)
            // if (registro.isretrasado == 1){ baseSemana['Viernes']['cantRetrasados']++; }
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Viernes']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Viernes']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Viernes']['cantpAprobacion']     += 1; }
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }

            break;
          case 5:
            baseSemana['Sabado']['list'].push(registro)
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Sabado']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Sabado']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Sabado']['cantpAprobacion']     += 1;}
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }
            // if (registro.isretrasado == 1){ baseSemana['Sabado']['cantRetrasados']++; }

            break;
          case 6:
            baseSemana['Domingo']['list'].push(registro)
            if (registro.isretrasado == 1 && (registro.cod_estado == 1 || registro.cod_estado == 2 )) { baseSemana['Domingo']['cantRetrasados']      += 1; ctdRetrasados++; }
            if (registro.cod_estado  == 3){ baseSemana['Domingo']['cantCompletados']     = 1; }
            if (registro.cod_estado  == 4){ baseSemana['Domingo']['cantpAprobacion']     += 1;}
            if (registro.isthisday   == 1 && registro.cod_estado != 3){ cantpendDia++; }
            // if (registro.isretrasado == 1){ baseSemana['Domingo']['cantRetrasados']++; }

            break;
        }
      }

      if (retrasados.length > 0) {
        var data   = this.insertarRetrasados(baseSemana, retrasados, fechaActual);
        baseSemana = data.nuevaSemana
        ctdRetrasados = ctdRetrasados + data.cant_retrasados;

      }

      // console.log(">>>>>>> impresion de la semana")
      // console.log(baseSemana)
      this.ctdRetrasados = ctdRetrasados;
      this.ctdpendDia    = cantpendDia;

      return baseSemana;
  }


  },
  watch: {

    buttonOverStatusDias : {
      handler(newValue, oldValue) {
        // Esta función se ejecutará cuando cualquier propiedad dentro de buttonOverStatusDias cambie
        console.log('Los estados de buttonOverStatusDias han cambiado:', newValue);
        // Aquí puedes añadir la lógica que necesites ejecutar cuando cambia cualquier día
      },
      deep: true // Esto habilita la observación profunda
    }

  },
  methods: {

    actualizarFlotante(data) {
      this.mostrarFlotante = data.valor;

    },


    callMountedTotal (fechaReferencia = ""){


      this.$nextTick(() => {
          this.checkOverflow(1, 'body_Lunes');
        });

        this.callMounted(fechaReferencia);

        this.$nextTick();

        setTimeout(() => {
           this.$nextTick(() => {
            if(this.$refs['body_Retrasados'] !== undefined){

              this.checkOverflow(2, 'body_Retrasados');

            }
            //
            this.checkOverflow(2, 'body_Lunes');
            this.checkOverflow(2, 'body_Martes');
            this.checkOverflow(2, 'body_Miercoles');
            this.checkOverflow(2, 'body_Jueves');
            this.checkOverflow(2, 'body_Viernes');
            this.checkOverflow(2, 'body_Sabado');
            this.checkOverflow(2, 'body_Domingo');


          });



        }, 500);

        this.isloading = false;


    },
    async cambioVertodasmisactividades(){

      await this.$emit('cambioVertodasmisactividades', {cambio: 1 });
      await this.limpiarCalendario()

      await this.$nextTick(() => {

      this.checkOverflow(1, 'body_Lunes');

      });

      await this.callMounted(this.rawDataPrincipal.fechaActual);

      await setTimeout(() => {
      // console.log(">>>>> entramos al timeout")
       this.$nextTick(() => {

        // this.checkOverflow(2, 'body_Retrasados');
        this.checkOverflow(2, 'body_Lunes');
        this.checkOverflow(2, 'body_Martes');
        this.checkOverflow(2, 'body_Miercoles');
        this.checkOverflow(2, 'body_Jueves');
        this.checkOverflow(2, 'body_Viernes');
        this.checkOverflow(2, 'body_Sabado');
        this.checkOverflow(2, 'body_Domingo');


      });

      }, 200);

      this.isloading = false;



    },

    sumarDiasAFecha(fecha, dias) {
      return moment(fecha).add(dias, 'days');
    },

    async callMounted(fecha_ejecucion) {

      console.log(">>> call inicio")

      this.isloading =  true;
      let fecha      =  fecha_ejecucion == "" ?  this.$store.state.fechasSelecCalendar :  fecha_ejecucion;
      let data_enviar= {fecha:fecha , verCalendarioTodasAct:this.verCalendarioTodasAct}
      // this.checkOverflow(1, 'body_Lunes');
      console.log(">>>>>> nina 1 vereoms")
      console.log(this.verCalendarioTodasAct)

      store.dispatch("get_datos_project_calendario", data_enviar).then((response) => {
        console.log(response)
        console.log(">>>mal")
        let data              = response.data
        this.rawDataPrincipal = data
      });


      // console.log(">>> call final")


    },

    async limpiarCalendario(){

      this.isloading = false;
      this.rawDataPrincipal.listaData = [{
            cod_restriccion: 171,
            desc_restriccion: "Definir datos de nuevos datos",
            desc_actividad: "Vaciado de losa",
            desc_frente: "TORRE",
            cod_frente: 3,
            fec_conciliada: "2023-09-11 12:00:00",
            fec_real: "2023-09-11 13:08:10",
            desc_estado: "Pendiente",
            cod_estado:  1,
            isretrasado: 0,
            isthisweek : 1,
            isthisday  : 0,
            weekIniDate: "2023-09-11",
            weekFinDate: "2023-09-17",
            weekYear: 37
        }];


      this.buttonOverStatusDias   = {
         Lunes: false,
         Martes: false,
         Miercoles: false,
         Jueves: false,
         Viernes: false,
         Sabado: false,
         Domingo: false
      };

    },

    async cambiarSemana(variable){


      await this.limpiarCalendario()

      await this.$nextTick(() => {

      this.checkOverflow(1, 'body_Lunes');

      });


      if(variable == 1){

        let fechaObj   = moment.tz(this.rawDataPrincipal.fechaActual, "America/Lima");
        fechaObj.add(-7, 'days');
        let nuevaFecha         = fechaObj.format('YYYY-MM-DD')
        this.fechaReferencia   = nuevaFecha
        await this.callMounted(nuevaFecha);


      }else{

        if(variable == 2){

          let fechaObj   = moment.tz(this.rawDataPrincipal.fechaActual, "America/Lima");
          fechaObj.add(7, 'days');
          let nuevaFecha         = fechaObj.format('YYYY-MM-DD')
          this.fechaReferencia   = nuevaFecha
          await this.callMounted(nuevaFecha);


        }
      }

      await setTimeout(() => {
      // console.log(">>>>> entramos al timeout")
       this.$nextTick(() => {

        // this.checkOverflow(2, 'body_Retrasados');
        this.checkOverflow(2, 'body_Lunes');
        this.checkOverflow(2, 'body_Martes');
        this.checkOverflow(2, 'body_Miercoles');
        this.checkOverflow(2, 'body_Jueves');
        this.checkOverflow(2, 'body_Viernes');
        this.checkOverflow(2, 'body_Sabado');
        this.checkOverflow(2, 'body_Domingo');


      });

      // await this.$nextTick();
      }, 200);

      this.isloading = false;


    },

    toggleFormulario() {
    this.mostrarFlotante = !this.mostrarFlotante;

    },

     async guardarFormulario(formulario) {

      this.form_data = formulario.data;
      // Aquí procesas los datos
      if (this.form_data.form_seleccion === '' || this.form_data.form_comentario.length < 20) {
        this.form_data.mensajeError = 'Por favor, elige una opción y escribe al menos 20 caracteres en el comentario.';
        this.form_data.mostrarError = true;

        setTimeout(() => {
          this.form_data.mostrarError = false;
        }, 10000); // Oculta el mensaje después de 10 segundos

        return;
      }


    const elemento = this.rawDataPrincipal.listaData.find(item => item.cod_restriccion === this.form_data.form_cod_restriccion);
    // Si el elemento existe, actualiza cod_estado
    if (elemento) {

      elemento.cod_estado             = this.form_data.form_cod_estado;
      elemento.cod_motivo_retraso     = this.form_data.form_seleccion;
      elemento.desc_comentario_retraso = this.form_data.form_comentario;


      let cambios = {
            rol_proyecto       : this.rolProyecto,
            cod_restriccion    : this.form_data.form_cod_restriccion,
            cod_estado         : this.form_data.form_cod_estado,
            cod_motivo_retraso : this.form_data.form_seleccion,
            desc_comentario_retraso : this.form_data.form_comentario
          }

      this.isloading = true
      this.$store.dispatch("update_restriction_state_calendar_retrasado", cambios).then( (response) => {

        this.$emit('recargarDesdecalendario', {cambio: 1 })
        this.callMountedTotal(this.fechaReferencia)

      })



    }


    // Ocultar el formulario
    this.mostrarFlotante = false;

    },

    ocultarDiv() {
    this.mostrarFlotante = false;
    },

    handleSelection(data){

      let isretrasado      = data.isretrasado
      let desc_restriccion = data.desc_restriccion

      if(isretrasado == 1 && data.cod_select == 3 ){

        this.mostrarFlotante      = !this.mostrarFlotante;
        this.form_data.form_titulo          = desc_restriccion;
        this.form_data.form_cod_estado      = data.cod_select;
        this.form_data.form_cod_restriccion = data.cod_restriccion;

      }else{

        const elemento = this.rawDataPrincipal.listaData.find(item => item.cod_restriccion === data.cod_restriccion);
        // Si el elemento existe, actualiza cod_estado
        if (elemento) {
          this.isloading = true

          let cambios    = {
            cod_restriccion : data.cod_restriccion,
            cod_estado      : data.cod_select
          }

          this.$store.dispatch("update_restriction_state_calendar", cambios).then((response) => {

              this.$emit('recargarDesdecalendario', {cambio: 1 })

              elemento.cod_estado = data.cod_select;
              this.isloading      = false

          }).catch({

          });

        }


      }


    },

    buttonOverChangeStatus(day){

      this.buttonOverStatusDias[day]  = !this.buttonOverStatusDias[day];
      const elements    = this.$refs['body_'+day];

            elements.forEach(element => {
              // element.classList.remove("h-[100%]");
              // element.style.height = this.overPixelesInicial + 'px';
              element.classList.add("overflow-y-auto");

            });

    },

    // prueba(){
    //   console.log(this.buttonOverStatusDias)

    // },

    load_data_calendario(){


      let info  = {
      fechaFin    : "2023-09-17",
      fechaIni    : "2023-09-11",
      fechaActual : "2023-09-12",
      listaData   :        [
        {
            cod_restriccion: 171,
            desc_restriccion: "Definir datos de nuevos datos",
            desc_actividad: "Vaciado de losa",
            desc_frente: "TORRE",
            cod_frente: 3,
            fec_conciliada: "2023-09-11 12:00:00",
            fec_real: "2023-09-11 13:08:10",
            desc_estado: "Pendiente",
            cod_estado:  1,
            isretrasado: 0,
            isthisweek : 1,
            isthisday  : 0,
            weekIniDate: "2023-09-11",
            weekFinDate: "2023-09-17",
            weekYear: 37
        },
      ],
      listaMotivoRetraso : [
        {
           id:1,
           texto:'Motivo de Terceros'
        },
      ]

      }

      this.rawDataPrincipal = info ;
    },
     calculateVerticalSizeDivHijos(refName) {
      let height = 0;

       // try {
      const element =  this.$refs[refName][0];
           // Asegúrate de que el elemento exista
          if (element && element.children && element.children.length > 0) {
            // Obtiene la altura del elemento
            // height = element[0].offsetHeight;

            for (const child of element.children) {
              height += child.offsetHeight; // offsetHeight incluye el padding y el border
            }
          }

      return height;
    },
    calculateVerticalSizeDiv(refName) {
      let height = 0;

      // Accede al elemento a través de la referencia
      const element =  this.$refs[refName];

      if (element) {
        // Obtiene la altura del elemento
        height = element[0].offsetHeight;

      }

      return height;
    },
     checkOverflow(flag , referencia) {

      // this.$nextTick(() => {
        let dia = referencia.split("_");
        let  overPixelesFinal = 0
        if (flag == 1) {

          // await this.calculateVerticalSizeDiv(referencia).then(result => {
            this.overPixelesInicial  = this.calculateVerticalSizeDiv(referencia);
          // });
          // this.overPixelesInicial =   this.calculateVerticalSizeDiv(referencia)
          console.log(">>> entrando al flag 1")
          console.log(this.overPixelesInicial)

        }

        if(flag == 2){

          console.log(">>> entrando al flag 2")
          console.log(referencia)

          // this.$nextTick(() => {
          // await this.calculateVerticalSizeDiv(referencia).then(result => {
          overPixelesFinal  =  this.calculateVerticalSizeDivHijos(referencia);
          // });

          // });

          console.log(">>>> obtenemos los tamaños iniciales - finales ")
          console.log(overPixelesFinal)
          console.log(this.overPixelesInicial)

          if (overPixelesFinal >  (this.overPixelesInicial + 10)){

            this.buttonOverStatusDias[dia[1]] = true;

            console.log(">>> entrando al validador final")
            console.log(referencia+"-----"+dia[1])

            const elements    = this.$refs[referencia];
            // const heightClass = `h-[${this.overPixelesInicial}px]`;

            // console.log(heightClass)
            elements.forEach(element => {
              element.classList.remove("h-[100%]");
              element.style.height = this.overPixelesInicial + 'px';
              // element.classList.add("overflow-y-auto");

            });

            console.log(">>> impresion de los estados del button ")
            console.log(this.buttonOverStatusDias)
            console.log(this.get_buttonOverStatusDias)
          }

          console.log(">>>> salio de aqui.")

        }


    },
    esDeEstaSemana(date) {
      const now = new Date();
      const weekStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay() + 1);
      const weekEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + (7 - now.getDay()));

      return date >= weekStart && date <= weekEnd;
    },
    insertarRetrasados(baseSemana , retrasados , fechaActual) {
      console.log(">>>>> armamos los retrasados")
    let resultado = {
      nuevaSemana    : {},
      cant_retrasados: 0
    }

    // let diaActual = new Date().getDayAdjustedforDate(fechaActual);
    // console.log(">>>>> dia :"+diaActual)
    let ordenDias = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'];

    // // Determinar la posición de inserción
    let posicionInsertar;
    // if (diaActual === 0) {  // Domingo
    //   diaActual        = 1;
    //   posicionInsertar = 0;  // Insertar antes del domingo
    // } else {
    //   posicionInsertar = diaActual;  // Insertar antes del día actual
    // }
    posicionInsertar = 0

    console.log(">>> posicion :"+posicionInsertar)

    let nuevaSemana    = {};
    let insertado      = false;
    let ctdretrasados  = 0;

    for (let i = 0; i < ordenDias.length; i++) {

      if (i === posicionInsertar && !insertado) {
        // nuevaSemana['Retrasados'] = retrasados;

        nuevaSemana['Retrasados'] = {
          strDate  : 'Retrasados',
          list     : []
        }
        // retrasados.fec_conciliada         = retrasados.fec_conciliada.split(' ')[0]
        ctdretrasados                     = retrasados.length;
        nuevaSemana['Retrasados']['list'] = retrasados
        insertado                         = true;
        // ctdretrasados++;
      }

      nuevaSemana[ordenDias[i]] = baseSemana[ordenDias[i]];
    }


    resultado.cant_retrasados = ctdretrasados;
    resultado.nuevaSemana     = nuevaSemana;

    return resultado;
}

  },
  async mounted(){
        // await if (this.get_rolProyecto == 3){
        //     this.verCalendarioTodasAct = true
        // }

        // this.isloading = false;
        this.callMountedTotal()


  }
};
</script>

<style scoped>
.modal-background {
  background: rgba(0, 12, 30, 0.7);
}
.modal-header {
  word-break: break-word;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active in <2.1.8 */ {
  opacity: 0;
}

</style>
