<template>


   <div style="position: relative;"  >
    <div class="custom-icon">
      <i class="fa-solid fa-filter-circle-xmark cursor-pointer" v-if="showIcon" @click="removerFiltros"></i>
    </div>

    <apexchart :width="width"  :height="height" type="bar" :options="chartOptions" :series="chartSeries" @dataPointSelection = "onClick" ></apexchart>
  </div>
</template>

<script>
import VueApexCharts from "vue3-apexcharts";

export default {
  components: {
    apexchart: VueApexCharts,
  },
  props: {
    filterHidden:Boolean,
    width:[Number,String],
    height:Number,
    periodos:Array,
    tipo:Number,
    chartData: {
      type: Object,
      required: true,
    },
    chartOptions: {
      type: Object,
      default: () => {},
    },
  },
  data() {
  return {
    showIcon: false,
    // tus otras variables
  };
  },
  computed: {
    chartSeries() {
      console.log('chartData', this.chartData);
      console.log('chartOptions', this.chartOptions);
      // Transforma los datos para que coincidan con el formato de ApexCharts
      // Asume que chartData tiene un campo 'datasets'
      if (this.tipo == 2){


        return this.chartData.datasets.map((dataset) => ({
          name: dataset.label,
          data: dataset.data,
        }));

      }else{


        const result = this.chartData && this.chartData.series
      ? this.chartData.series.map((dataset) => ({
          name: dataset.name,  // Aquí debería ir el nombre del estado
          periodo: dataset.periodo == undefined ? undefined : dataset.periodo,
          weekYear: dataset.weekYear == undefined ? undefined : dataset.weekYear,
          data: dataset.data,

        }))
      : [];

        console.log("Las series que se pasarán a ApexCharts son:", result);
        return result;



      }
    },
  },
  methods: {


    removerFiltros(){

      this.showIcon = false;
      this.$emit('removeFilters', {remover:true});

    },

    // toggleIcon() {
    //   this.showIcon = this.filterHidden;
    // },

    onClick(event, chartContext, config) {
      console.log('widh', this.width);
      this.showIcon = true;
      console.log("_>>> entrando")
      console.log('config.seriesIndex->', config.seriesIndex)
      console.log('config.dataPointIndex->', config.dataPointIndex)
      console.log('this.chartSeries[config.seriesIndex->', this.chartSeries[config.seriesIndex])

      const seriesIndex = config.seriesIndex;
      const dataPointIndex = config.dataPointIndex;

      var selectResponsable     = ''
      var selectState    = this.chartSeries[seriesIndex]['name'] == undefined ? undefined : this.chartSeries[seriesIndex]['name'];
      var selectPeriod   = this.periodos[dataPointIndex] == undefined ? undefined : this.periodos[dataPointIndex]
      var selectedValue  = this.chartSeries[seriesIndex].data[dataPointIndex] == undefined ? undefined : this.chartSeries[seriesIndex].data[dataPointIndex];


      if(this.tipo  == 2){

        selectState =  this.chartOptions.xaxis.categories[dataPointIndex] == undefined ? undefined : this.chartOptions.xaxis.categories[dataPointIndex] ;

      }

      if(this.tipo  == 3){

        selectResponsable =   this.chartOptions.xaxis.categories[dataPointIndex] == undefined ? undefined : this.chartOptions.xaxis.categories[dataPointIndex] ;
        selectPeriod      =   undefined
      }

      console.log(">>>> no llegamos aqui o queee")

      console.log(selectResponsable)
      console.log(selectState)
      console.log(selectPeriod)
      console.log(selectedValue)
      console.log('altura', this.height)
      console.log(">>>>>>> periodos")
      console.log(this.periodos)

      this.$emit('emitFilters', {estado:selectState , periodo:selectPeriod, responsable:selectResponsable});


    },
  },
  mounted() {

    this.showIcon = this.filterHidden
  }

};
</script>
<style>
/*
.chart-container {
  position: relative;
} */

.custom-icon {
  position: absolute;
  top: 0px;
  right: 30px;
  z-index:1;
}

</style>
