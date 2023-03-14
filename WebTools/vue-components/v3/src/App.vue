<script setup>
import { ref } from "vue";

import FileUploadSelector from "./components/FileUploadSelector.vue";
import EModal from "./components/EModal.vue";
import WaitTag from "./components/WaitTag.vue";
import ELoading from "./components/ELoading.vue";

import Loading from "./directives/Loading/Loading";
const vLoading = Loading;

const afterSelected = (evt) => {
  console.log(evt);
};

const modalRef = ref(0);

const showEModal = (e) => {
  modalRef.value.show();
};

const printFFF = () => {
  console.log("FFF");
};

const click3 = (ppp) => {
  ppp.startWaiting();
  console.log(111);
};

const isLoading = ref(false);
const toggleLoading = () => {
  isLoading.value = !isLoading.value;
};

const loadingEvent = () => {
  isLoading.value = true;
  console.log("loadingEvent");
  setTimeout(() => {
    isLoading.value = false;
  }, 1000);
};
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
      <wait-tag :time="10" @stop-waiting="printFFF" @start-waiting="printFFF">
        <template #default="ppp">
          <button @click="click3(ppp)" v-loading="ppp.time > 0">
            倒计时<span v-if="ppp.time > 0">{{ ppp.time }}</span>
          </button>
        </template>
      </wait-tag>
    </div>

    <hr />
    <div>
      <button v-loading="isLoading" @click="loadingEvent" style="border: 1px solid">v-loading</button>

      <span v-loading="isLoading" @click="loadingEvent" style="border: 1px solid">v-loading</span>
    </div>

    <hr />
    <div>
      <p>
        <button @click="toggleLoading">切换loading</button>
        isLoading: {{ isLoading }}
      </p>
      <e-loading :is-loading="isLoading" style="border: 1px solid">
        <button @click="loadingEvent">eloading组件</button>
      </e-loading>
      <br />
      <e-loading :is-loading="isLoading" style="border: 1px solid">
        <template #loading-tips>
          正在加载...
        </template>
        <button @click="loadingEvent">eloading组件 隐藏原内容</button>
      </e-loading>
    </div>

    <hr />
    <div>

    </div>
  </div>
</template>
