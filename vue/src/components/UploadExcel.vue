<template>
  <Modal :header="'Cargar Restricciones'" :modalType="'deleteRow'" :paragraphs="paragraphs">
      <!-- <span class="text-center leading-6 mb-2 w-full"> Suba un archivo excel con el formato correcto  o descargue el formato desde Aqui.</span> -->
      <button class="h-14 sm:w-full rounded px-8 text-base leading-4 mt-10 bg-white text-black d-flex border" @click="selectFile">
        <img src="/src/assets/images/icons/upload.svg" class="inverted" alt="">
        Subir Archivo Excel
      </button>
      <div class="alert alert-success" v-if="response.success">{{response.successMessage}}</div>
      <div class="alert alert-danger" v-if="response.error">{{response.errorMessage}}</div>
      <div class="mt-10 mb-2 w-full">
        <label>Log Messages</label>
      </div>
      <textarea
        style="background: #8080801a"
        rows="4"
        class="w-full px-4 rounded border border-[#8A9CC9] font-normal text-base text-activeText mb-4 textarea"
        placeholder=""
        v-model="logs"
        disabled></textarea>
      <input type="file" @change="onFileChange" ref="fileInput" style="display:none">
      <div class="bottom">
        <div class="col-md-6">
          <button class="h-14 sm:w-full rounded px-8 text-base leading-4 mt-10 bg-white text-black"  @click="this.$emit('closeModal')">
            Close
          </button>
        </div>
        <div class="col-md-6">
          <button class="h-14 sm:w-full rounded px-8 text-base leading-4 mt-10 bg-orange text-white" @click="uploadExcel">
            Subir Excel
          </button>
        </div>
      </div>
  </Modal>
</template>

<script>
import Modal from "./Modal.vue"
import axiosClient from "../axios"

export default {
  name: "uploadexcel-row-component",
  components: {
    Modal,
  },
  data: function () {
    return {
      paragraphs: [],
      logs: '',
      file_url : null,
      file : null,
      response : {
        success: false,
        error: false,
        successMessage: '',
        errorMessage: ''
      }
    };
  },
  methods:{
    selectFile(){
      this.$refs.fileInput.click()
    },
    onFileChange(e) {
      const file = e.target.files[0]
      this.addLog(` > selected file - ${file.name}`)
      this.file = file
      this.file_url = URL.createObjectURL(file)
    },
    addLog(val){
      const logs = this.logs
      this.logs = logs ? `${logs}\n${val}` : val
    },
    async uploadExcel(){
      let formData = new FormData()
      formData.append('excelFile',this.file)
      this.addLog(` > uploading file - ${this.file.name}`)
      this.response.error = false
      this.response.success = false
      await axiosClient.post(`/uploadExcel/${sessionStorage.getItem('Id')}/${sessionStorage.getItem("constraintid")}`,formData).then(res => {
        if(res.data.success){
          this.response.success = true
          this.response.successMessage = res.data.successMessage
          this.addLog(` > "exited with success" \n message - ${res.data.successMessage}`)
          // this.$emit('closeModal')
        }
        if(res.data.error){
          this.response.error = true
          this.response.errorMessage = res.data.errorMessage
          const errors = res.data.errors
          for (let index = 0; index < errors.length; index++) {
            this.addLog(` ${errors[index].row} \n message - ${errors[index].value}`)
          }
        }
      }).catch(err => console.log(err))
    }
  }
};
</script>
<style>
  .d-flex{
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .border{
    border: 2px solid #80808061;
  }
  .inverted{
    /* filter: invert(1); */
    height: 30px;
    margin-right: 10px;
  }
  .textarea{
    background: rgba(128, 128, 128, 0.1);
    color: #747474;
    font-size: 14px;
    font-family: monospace;
  }
  .bottom{
    flex-direction: row;
    display: flex;
    width: 100%;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid #80808057;
  }
  .alert{
    margin-top: 20px;
    width: 100%;
    padding: 20px;
    border-radius: 5px;
    color: white;
  }
  .alert-danger{
    background-color: #c41515e6;
  }
  .alert-success{
    background-color: #008000de;
  }
</style>
