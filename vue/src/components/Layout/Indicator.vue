<template>
  <div class="flex justify-between sm:flex-col mb-9 sm:mb-6">
    <div class="flex flex-col tracking-tight">
      <span class="text-xl text-activeText mb-2">{{ header }}</span>
      <span class="text-xs leading-6 text-activeText font-medium sm:mb-4">
        {{ paragraph }}
      </span>
    </div>
    <div class="flex items-end">
      <button
        title=" Crea un nuevo proyecto , asigne personal y asigne reportes."
        class="h-10 sm:w-full bg-orange text-white text-xs leading-4 px-4 rounded"
        @click="$emit('createNewProject')"
      >
        {{ buttonText }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: "indicator-component",
  props: {
    header: String,
    paragraph: String,
    buttonText: String,

  },
};
</script>
