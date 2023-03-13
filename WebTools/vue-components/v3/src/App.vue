<script setup>
import FileUploadSelector from "./components/FileUploadSelector.vue";
import EModal from "./components/EModal.vue";
import WaitTag from "./components/WaitTag.vue";

import { ref } from "vue";


const afterSelected = (evt) => {
  console.log(evt);
};

const modalRef = ref(0);

const showEModal = (e) => {
  modalRef.value.show();
};

const printFFF = () => {
  console.log("FFF");
}

const click3 = (ppp) => {
ppp.startWaiting();
console.log(111);
}


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
      <e-modal ref="modalRef" @shown="printFFF" @hidden="printFFF">
        <template #header>Header</template>
        <template #body>
          Body
          <button @click="printFFF()">11</button>
        </template>
        <template #footer>Footer</template>
      </e-modal>
    </div>

    <hr />

    <div>
      <label>WaitTag组件</label>
      <wait-tag :time="-1" @stop-waiting="printFFF" @start-waiting="printFFF">
        <template #default="ppp">
          <button @click="click3(ppp)">
          倒计时<span v-if="ppp.time > 0">{{ ppp.time }}</span>
        </button>
        </template>
      </wait-tag>
    </div>    
  </div>
</template>

