<template>
  <div class="fixed top-16 sm:top-14 left-64 sm:left-0 right-0 flex-col ">
    <div class="flex h-16 sm:h-14 bg-side relative items-center justify-center">
      <div class="flex text-sm">
        <div class="flex mr-20 sm:mr-[25.5px]">
          <img :src="step === 1 ? path+'/first-black.svg' : path+'/first.svg'" class="mr-2"  v-bind:alt="'first'" >
          <span :class="{'text-[#002B6B]': step === 1, 'text-[#8A9CC9]': step !== 1}">Proyecto</span>
        </div>
        <div class="flex mr-20 sm:mr-[25.5px]">
          <img :src="step === 2 ? path+'/second-black.svg' : path+'/second.svg'" class="mr-2" alt="second">
          <span :class="{'text-[#002B6B]': step === 2, 'text-[#8A9CC9]': step !== 2}">Equipo</span>
        </div>
        <div class="flex">
          <img :src="step === 3 ? path+'/third-black.svg': path+'/third.svg'" class="mr-2" alt="third">
          <span :class="{'text-[#002B6B]': step === 3, 'text-[#8A9CC9]': step !== 3}">Reporte</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'project-bar-component',
  props: {
    step: Number,
  },
  data: function () {
    return {
      path : import.meta.env.VITE_WEB_FIN_BASE_URL,
    }
  }
}
</script>
