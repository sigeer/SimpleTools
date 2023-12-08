<template>
  <Tooltip :content="tooltipContent" trigger="click">click触发</Tooltip>

  <Tooltip :content="tooltipContent" trigger="click">hover触发22</Tooltip>

  <input v-model="tooltipContent" />

  <Tooltip :content="tooltipContent" trigger="click">
    <div style="width: 100%; height: 24px; background-color: #66ccff;"></div>
  </Tooltip>

</template>

<script setup>
import { ref } from "vue";
import Tooltip from "../components/tooltip";

const tooltipContent = ref("123456789123456789123456789123456789123456789123456789");
</script>
