<script setup>
import UploadFile from "./components/UploadFile.vue";
import EModal from "./components/EModal.vue";
import { ref } from "vue";

const uploadApi = (evt) => {
  console.log(evt.file.getAll("files"));
  return Promise.resolve({ a: 1 });
};

const afterUpload = (evt) => {
  console.log(evt);
};

const modalRef = ref(0);

const showEModal = (e) => {
  modalRef.value.show();
};

defineExpose({ uploadApi, afterUpload });
</script>

<template>
  <div>
    <div>
      <label>UploadFile组件</label>
      <upload-file
        :uploader="uploadApi"
        :multiple="true"
        container-class="up-container-div"
        @uploaded="afterUpload"
      ></upload-file>
    </div>

    <hr />

    <div>
      <label>EModal组件</label>
      <button @click="showEModal">弹窗</button>
      <e-modal ref="modalRef">
        <template #body>111</template>
      </e-modal>
    </div>

    <hr />

    
  </div>
</template>

<style scoped>
.up-container-div {
  display: inline-flex;
}
</style>
