<template>
  <span
    :class="['wait-tag', isWaiting ? `waiting ${props.waitingClass}` : '']"
    @click="handleClick"
  >
    <slot :time="configs.time" :startWaiting="reset"></slot>
  </span>
</template>

<script setup>
import { computed, reactive, watch } from "vue";

const props = defineProps({
  time: {
    type: Number,
    default: 60,
    validator(value) {
      return value > 0;
    },
  },

  waitingClass: {
    type: String,
    default: "",
  },
});

const isWaiting = computed(() => {
  return configs.time > 0;
});

const handleClick = (evt) => {
  if (isWaiting.value) {
    evt.stopPropagation();
    return;
  }
};

const configs = reactive({
  time: 0,
});

const emits = defineEmits(["startWaiting", "stopWaiting"]);

watch(
  () => props.time,
  () => {
    configs.time = props.time;
  }
);

const reset = (evt) => {
  if (isWaiting.value) {
    evt.stopPropagation();
    return;
  }

  emits("startWaiting");
  configs.time = props.time;

  configs.time--;
  const interFlag = setInterval(() => {
    configs.time--;

    if (configs.time <= 0) {
      emits("stopWaiting");
      clearInterval(interFlag);
    }
  }, 1000);
};
</script>

<style scoped>
.wait-tag.waiting {
  color: gray;
  pointer-events: none;
}

.wait-tag.waiting > * {
  color: gray;
  pointer-events: none;
}
</style>
