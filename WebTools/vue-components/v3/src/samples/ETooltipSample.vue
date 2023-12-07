<template>
  <Tooltip :content="tooltipContent" trigger="click">click触发</Tooltip>

  <Tooltip :content="tooltipContent">hover触发</Tooltip>

  <input v-model="tooltipContent" />
</template>

<script setup>
import { ref } from "vue";
import Tooltip from "../components/tooltip";

const tooltipContent = ref("123456789123456789123456789123456789123456789123456789");
</script>
