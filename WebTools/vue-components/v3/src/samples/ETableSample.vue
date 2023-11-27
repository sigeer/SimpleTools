<template>
  <button @click="toggleLoading">数据加载</button>
  <Table :columns="columns" :data-source="dataSource" :loading="dataLoading">
    <template #bodyCell="{ column }">
      <template v-if="column.dataPropName === 'action'">
        <a>操作</a>
      </template>
    </template>
  </Table>
  <Pagination v-model="paginationModel"></Pagination>
</template>

<script setup>
import { ref } from "vue";
import Table from "../components/table";
import Pagination from "../components/pagination";


const columns = ref([
  { title: "测试列", dataPropName: "t1", width: 250 },
  { title: "测试列", dataPropName: "t2" },
  { title: "操作", dataPropName: "action", width: 80 },
]);

const dataSource = ref([
  { t1: "111", t2: "aaa" },
  { t1: "222", t2: "aaa" },
  { t1: "222", t2: "aaa" },
]);

const dataLoading = ref(false);
const toggleLoading = () => {
  dataLoading.value = !dataLoading.value;
};

const paginationModel = ref({
  pageIndex: 1,
  pageSize: 10,
  total: 1,
  change: (evt) => {
    console.log(evt);
  }
})
</script>
