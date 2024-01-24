<template>
  <div :class="claseEstado">
    {{ textoEstado }}
  </div>
</template>

<script>
export default {
  props: {
    codEstado: {
      type: Number,
      required: true
    }
  },
  computed: {
    claseEstado() {
      let baseClases = ' rounded p-1 text-center ';
      switch (this.codEstado) {
        case 0:
          return baseClases + 'bg-gray-400 text-white';
        case 1:
          return baseClases + 'bg-green-500 text-white';
        case 2:
          return baseClases + 'bg-red-500 text-white';
        default:
          return baseClases + 'bg-black-100 text-white-800';
      }
    },
    textoEstado() {
      switch (this.codEstado) {
        case 0:
          return 'Pendiente';
        case 1:
          return 'Aprobado';
        case 2:
          return 'Desaprobado';
        default:
          return 'Estado Desconocido';
      }
    }
  }
};
</script>
