<template>
  <auto-complete
    v-model="proxyValue"
    @search="handleSearch"
    :data-source="states.processedDs"
    :disabled="props.disabled"
  >
  </auto-complete>
</template>

<script setup>
import { reactive, ref, watch } from "vue";
import AutoComplete from "./AutoComplete.vue";

const props = defineProps({
  modelValue: {
    type: String,
    default: null,
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  extraSuffix: {
    type: Array,
    default: () => []
  }
});
const emits = defineEmits(["update:modelValue", "change"]);
const proxyValue = ref("");
watch(
  () => props.modelValue,
  () => {
    if (proxyValue.value !== props.modelValue) {
      proxyValue.value = props.modelValue;
      emits("change", proxyValue.value);
    }
  },
  {
    immediate: true,
  }
);
watch(proxyValue, () => {
  emits("update:modelValue", proxyValue.value);
})

const states = reactive({
  processedDs: [],
});

const emailSuffix = [
  "@qq.com",
  "@gmail.com",
  "@163.com",
  "@yahoo.com",
  "@hotmail.com",
  "@msn.com",
  "@163.net",
  "@sina.com",
].concat(props.extraSuffix);
const handleSearch = (evt) => {
  const index = evt.indexOf("@");
  if (index === 0) {
    states.processedDs = [];
    return;
  }
  if (index === -1) {
    states.processedDs = emailSuffix.map((x) => evt + x);
    return;
  }
  const body = evt.substring(0, index);
  const suffix = evt.substr(index);
  const validDS = emailSuffix.filter((x) => x.indexOf(suffix) !== -1);
  states.processedDs = validDS.map((x) => body + x);
};
</script>
