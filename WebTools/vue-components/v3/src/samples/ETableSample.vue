<template>
  <button @click="toggleLoading">数据加载</button>
  <button @click="toggleBorder">是否显示边框{{ bordered }}</button>
  <button @click="addData">增加数据</button>
  <Table
    :columns="columns"
    :data-source="tableDs"
    :loading="dataLoading"
    :bordered="bordered"
    :scroll="{ height: 400 }"
  >
    <template #bodyCell="{ column }">
      <template v-if="column.dataPropName === 'action'">
        <a>操作</a>
      </template>
    </template>
  </Table>
  <Pagination v-model="paginationModel"></Pagination>
</template>

<script setup>
import { computed, ref } from "vue";
import Table from "../components/table";
import Pagination from "../components/pagination";

const columns = ref([
  { title: "测试列1", dataPropName: "t1", width: 250, ellipsis: true },
  { title: "测试列2", dataPropName: "t2" },
  { title: "操作", dataPropName: "action", width: 80 },
]);

const dataSource = ref([
  { t2: "111", t1: "aaabbbcccdddeeefffggghhhjjjkkk" },
  { t1: "222", t2: "aaa" },
  { t1: "222", t2: "aaa" },
]);
const addData = () => {
  dataLoading.value = true;
  setTimeout(() => {
    dataLoading.value = false;
  }, 3000);
  for (let index = 0; index < 10; index++) {
    dataSource.value.push({ t1: index, t2: "t2_" + index });
  }
  paginationModel.value.total = dataSource.value.length;
};
const tableDs = computed(() => {
  return dataSource.value.slice(
    (paginationModel.value.pageIndex - 1) * paginationModel.value.pageSize,
    paginationModel.value.pageIndex * paginationModel.value.pageSize
  );
});

const dataLoading = ref(false);
const toggleLoading = () => {
  dataLoading.value = !dataLoading.value;
};

const bordered = ref(true);
const toggleBorder = () => {
  bordered.value = !bordered.value;
};

const paginationModel = ref({
  pageIndex: 1,
  pageSize: 50,
  total: 3,
  change: (evt) => {
    dataLoading.value = true;
    setTimeout(() => {
      dataLoading.value = false;
    }, 3000);
  },
});
</script>
