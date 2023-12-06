<template>
  <div class="e-notification-box" v-if="dataSource.length > 0">
    <div class="e-notification-container">
      <NotificationItem
        v-for="x in dataSource"
        :value="x"
        @delete="handleDelete(x)"
        :container-style="containerStyle"
      ></NotificationItem>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import NotificationItem from "./NotificationItem.vue";

const dataSource = ref([]);
const push = (item) => {
  const currentKey = generateGuid();
  dataSource.value.push({ ...item, key: currentKey });
  if (item.time < 0) {
    return;
  }
  setTimeout(() => {
    const index = dataSource.value.findIndex((x) => x.key === currentKey);
    if (index !== -1) dataSource.value.splice(index, 1);
  }, item.time ?? 5000);
};

const handleDelete = (item) => {
  dataSource.value = dataSource.value.filter((x) => x.key !== item.key);
};

function generateGuid() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

const containerStyle = ref({});
const setGlobalStyle = (style) => {
  if (style && Object.keys(style).length) containerStyle.value = style;
};

defineExpose({ push, setGlobalStyle });
</script>

<style lang="less" scoped>
.e-notification-box {
  width: 360px;
  height: 80vh;
  position: fixed;
  right: 24px;
  top: 24px;
  z-index: 999;
  transition: all 0.8s;
}
</style>
