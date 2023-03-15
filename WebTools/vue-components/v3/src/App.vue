<script setup>
import { reactive, ref } from "vue";

import FileUploadSelector from "./components/FileUploadSelector.vue";
import EModal from "./components/EModal.vue";
import WaitTag from "./components/WaitTag.vue";
import ELoading from "./components/ELoading.vue";

import Dropdown from "./components/Dropdown.vue";

import Loading from "./directives/Loading/Loading";
const vLoading = Loading;

const isDisabled = ref(false);
const toggleDisabled = () => {
  isDisabled.value = !isDisabled.value;
};

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

const dropdown = reactive({
  ds: [
    { text: "111", value: 1 },
    { text: "222", value: 2 },
    { text: "333", value: 3 },
    { text: "444", value: 4 },
    { text: "555", value: 5 },
    { text: "666", value: 6 },
    { text: "777", value: 7 },
    { text: "8881111111111111111111111111", value: 8 },
  ],
  ds1: [
    { key: "key111", value: 1 },
    { key: "key222", value: 2 },
    { key: "key333", value: 3 },
    { key: "key444", value: 4 },
    { key: "key555", value: 5 },
    { key: "key666", value: 6 },
    { key: "key777", value: 7 },
    { key: "key888", value: 8 },
  ],
});

const dModel = ref(8);
const dropDownChange = (evt) => {
  console.log(evt);
};
const setdModel = () => {
  dModel.value = (dModel.value + 1) % 8 || 8;
};
</script>

<template>
  <div>
    <div>
      <button @click="toggleDisabled">toggle disable</button>
    </div>
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
      <p>
        <button @click="toggleLoading">切换loading</button>
        isLoading: {{ isLoading }}
      </p>

      <div>
        <button
          v-loading="isLoading"
          @click="loadingEvent"
          style="border: 1px solid"
        >
          button v-loading
        </button>

        <span
          v-loading="isLoading"
          @click="loadingEvent"
          style="border: 1px solid"
          >span v-loading</span
        >
      </div>

      <div>
        <e-loading :is-loading="isLoading" style="border: 1px solid">
          <button @click="loadingEvent">eloading组件</button>
        </e-loading>
        <e-loading
          :is-loading="isLoading"
          :hide-main-body="true"
          style="border: 1px solid"
        >
          <template #loading-tips> 正在加载... </template>
          <button @click="loadingEvent">eloading组件 隐藏原内容</button>
        </e-loading>
        <e-loading
          :is-loading="isLoading"
          :hide-main-body="true"
          :show-icon="false"
          style="border: 1px solid"
        >
          <template #loading-tips> 正在加载... </template>
          <button @click="loadingEvent">
            eloading组件 隐藏原内容 隐藏默认图标
          </button>
        </e-loading>
      </div>
    </div>

    <hr />
    <div>
      简单用法：
      <div>
        <dropdown
          style="width: 200px"
          :disabled="isDisabled"
          v-model="dModel"
          :data-source="dropdown.ds"
          @change="dropDownChange"
        ></dropdown>
      </div>
      dModel.value: {{ dModel }}
      <button @click="setdModel">修改dModel值</button>
      <div>
        进阶用法：
        <div style="width: 200px">
          <dropdown
            place-holder="请选择"
            :disabled="isDisabled"
            :data-source="dropdown.ds"
            @change="dropDownChange"
            can-search
          >
            <template #item="x">
              {{ x.item.text }} - {{ x.item.value }}
            </template>
          </dropdown>
          11111111111111111111111111111111111111111111111111
        </div>
      </div>
      <div>
        自动计算direction，结合loading
        <div>
          <dropdown
            v-model="dModel"
            :disabled="isDisabled"
            v-loading="isLoading"
            :data-source="dropdown.ds1"
            style="width: 200px"
            text-prop-name="key"
            @change="dropDownChange"
            can-search
          >
            <template #display="x">
              {{ x.item.key }} - {{ x.item.value }}
            </template>
            <template #item="x">
              {{ x.item.key }} - {{ x.item.value }}
            </template>
          </dropdown>
          11111111111111111111111111111111111111111111111111
        </div>
      </div>
      <br />
      <br />
      <br />

      <hr />
    </div>
  </div>
</template>
