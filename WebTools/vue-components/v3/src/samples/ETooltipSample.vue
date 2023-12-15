<template>
  <Tooltip :content="tooltipContent" trigger="click"
    ><span>click触发</span></Tooltip
  >

  <Tooltip :content="tooltipContent" trigger="click"
    ><span> hover触发22 </span></Tooltip
  >

  <Tooltip :content="tooltipContent">
    <input v-model="tooltipContent" />
  </Tooltip>

  <Tooltip :content="tooltipContent" trigger="click">
    <div style="width: 100%; height: 24px; background-color: #66ccff">123</div>
  </Tooltip>

</template>

<script setup>
import { ref } from "vue";
import Tooltip from "../components/tooltip/Tooltip.vue";

const tooltipContent = ref(
  "123"
);

const tooltipContent1 = ref(
  "123"
);
</script>
