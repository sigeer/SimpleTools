<template>
  <FastEdit
    v-model="model"
    :rules="[{ check: (v) => !!v, message: '必须有值' }]"
  ></FastEdit>

  {{ model }}
</template>

<script setup>
import { ref } from "vue";
import FastEdit from "../components/FastEdit/FastEdit.vue";

const model = ref("demo");
</script>
