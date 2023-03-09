<script setup>
import FileUploadSelector from "./components/FileUploadSelector.vue";
import EModal from "./components/EModal.vue";
import { ref } from "vue";


const afterSelected = (evt) => {
  console.log(evt);
};

const modalRef = ref(0);

const showEModal = (e) => {
  modalRef.value.show();
};

defineExpose({ afterSelected });
</script>

<template>
  <div>
    <div>
      <label>UploadFile组件</label>
      <file-upload-selector
        :multiple="true"
        container-class="up-container-div"
        @selected="afterSelected"
      >
      <a>选择</a>
    </file-upload-selector>
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
