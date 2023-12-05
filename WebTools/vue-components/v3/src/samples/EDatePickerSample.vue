<template>
  <DatePicker v-model="model" :disable-date-func="disableDate"></DatePicker>
  {{ model }}
</template>

<script setup>
import { ref } from "vue";
import DatePicker from "../components/date-picker";

const model = ref();
const disableDate = (date) => {
  return date > new Date();
};
</script>
