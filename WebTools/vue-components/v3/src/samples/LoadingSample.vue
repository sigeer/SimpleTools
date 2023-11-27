<template>
  <div>
    <p>
      <button @click="toggleLoading">切换loading</button>
      isLoading: {{ isLoading }}
    </p>
    <Loading :loading="isLoading" style="border: 1px solid">
      <button @click="loadingEvent">eloading组件</button>
    </Loading>
    <Loading
      :loading="isLoading"
      :hide-main-body="true"
      style="border: 1px solid"
    >
      <template #loadingTips> 正在加载... </template>
      <button @click="loadingEvent">eloading组件 隐藏原内容</button>
    </Loading>
    <Loading
      :loading="isLoading"
      :hide-main-body="true"
      :show-icon="false"
      style="border: 1px solid"
    >
      <template #loadingTips> 正在加载... </template>
      <button @click="loadingEvent">
        eloading组件 隐藏原内容 隐藏默认图标
      </button>
    </Loading>
  </div>
</template>

<script setup>
import Loading from "../components/loading";

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
