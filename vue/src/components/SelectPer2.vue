<template>
  <div class="relative text-[0.9em] w-[11em]" ref="dropdown">
    <!-- Selector personalizado -->
    <div class="p-1" :class="lectura == 1 ? ' ' : ' cursor-pointer '" @click="toggleDropdown">
      <div class="flex items-center justify-between">
        <!-- Muestra la opción seleccionada con el ícono -->
        <div class="pt-1">
          <span class=" px-2 py-[2px] mr-2" :class="iconColorClass(selectedOption.iconColor)"><i class="fa fa-flag text-white"></i></span>
          <span :class="textColorClass(selectedOption.iconColor)">{{ selectedOption.label }}</span>
        </div>
        <i v-if="lectura == 0" class="fa fa-chevron-down"></i>
      </div>
    </div>

    <!-- Opciones desplegables -->
    <div v-if="showDropdown && lectura == 0" class="absolute z-10 w-full bg-white border border-gray-300 rounded mt-1">
      <div
        v-for="option in options"

        :key="option.value"
        class="p-2 hover:bg-gray-100 cursor-pointer "
        @click="selectOption(option)"
      >
        <div class="pt-1" v-if="option.value !== 4">
          <!-- Ícono para cada opción -->
          <!-- <span class="bg-gray-300 px-2 py-1 mr-2"><i class="fa fa-flag text-white"></i></span> -->
          <span class=" px-2 py-[2px] mr-2" :class="iconColorClass(option.iconColor)">
            <i class="fa fa-flag text-white"></i>
          </span>
          <span>{{ option.label }}</span>
        </div>
      </div>
    </div>
    <!-- <div v-if="showDropdown && lectura == 1" class="absolute z-10 w-full bg-white border border-gray-300 rounded mt-1">

    </div> -->


  </div>
</template>

<script>
import store      from "../store";
export default {
  props: {
    lectura: {
      type: Number,
      default:0
    },
    initialValue: {
      type: Number,
      required: true
    },
    cod_restriccion :{
      type: Number,
      required: true
    },
    isretrasado : {
      type: Number,
      required: true
    },
    desc_restriccion :{
      type:String,
      required: true
    },
    // array_data_estados :{
    //   type:Array,
    //   required: true
    // }
  },
  data() {
    return {
      showDropdown: false,
      selectedValue: null, // Valor seleccionado internamente
      // options: [{ label: 'Pendiente', value: 1, iconColor: 'red' }]
      // options: []
    };
  },
  // beforeMount(){
  //       console.log(">>> impresion de los estados")
  //     this.options =  this.array_data_estados;
  //     //  console.log(this.options)
  // },
  computed: {
    selectedOption() {
      // this.options = this.array_data_estados;
      // Encuentra la opción que corresponde al valor inicial
      return this.options.find(option => option.value === this.initialValue) || {};
    },
    options(){
      return this.$store.state.estadosSelecCalendar;
    }
  },
  methods: {
    toggleDropdown() {
      this.showDropdown = !this.showDropdown;
      if (this.showDropdown) {
        window.addEventListener('click', this.handleClickOutside);
      } else {
        window.removeEventListener('click', this.handleClickOutside);
      }
    },
    selectOption(option) {
      this.selectedValue = option.value;
      // Emitir el evento personalizado con el valor seleccionado
      this.$emit('change', {cod_select : this.selectedValue , cod_restriccion : this.cod_restriccion , isretrasado : this.isretrasado , desc_restriccion : this.desc_restriccion});
      this.closeDropdown();
    },
    handleClickOutside(event) {
      if (!this.$refs.dropdown.contains(event.target)) {
        this.closeDropdown();
      }
    },
    closeDropdown() {
      this.showDropdown = false;
      window.removeEventListener('click', this.handleClickOutside);
    },
    iconColorClass(color) {
      // Define un objeto con las clases de colores posibles
      const colorClasses = {
        red: 'bg-gray-500',
        yellow: 'bg-[#e5690e]',
        green: 'bg-[#47ab24]',
        blue: 'bg-[#cd4fb2]',
        // ... Añadir más colores si es necesario
      };
      // Retorna la clase correspondiente o una clase por defecto
      return colorClasses[color] || 'bg-gray-500';
    },
    textColorClass(color) {
      // Define un objeto con las clases de colores posibles
      const colorClasses = {
        red: 'text-gray-500',
        yellow: 'text-[#e5690e]',
        green: 'text-[#47ab24]',
        blue: 'text-[#cd4fb2]',
        // ... Añadir más colores si es necesario
      };
      // Retorna la clase correspondiente o una clase por defecto
      return colorClasses[color] || 'text-gray-500';
    },
  },
  beforeDestroy() {
    // Limpieza para asegurarse de que el controlador de eventos se elimina
    window.removeEventListener('click', this.handleClickOutside);
  },

};
</script>

<style scoped>
/* Aquí puedes añadir estilos adicionales si es necesario */
</style>
