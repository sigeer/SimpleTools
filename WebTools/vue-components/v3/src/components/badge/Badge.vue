<template>
  <span class="badge-container">
    <slot></slot>
    <div
      v-if="value > 0"
      :class="{
        'badge-value': true,
        '--circle': type === 'circle',
        '--dot': type === 'dot',
      }"
    >
      <span v-if="type !== 'dot'">{{ displayValue }}</span>
    </div>
  </span>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
  max: {
    type: Number,
    default: 9,
  },
  type: {
    type: String,
    default: "circle",
    validator: (val) => {
      return ["circle", "dot", "square"].includes(val);
    },
  },
  value: {
    type: Number,
    default: 1,
  },
});

const displayValue = computed(() => {
  if (props.value > props.max) return `${props.max}+`;
  else return props.value;
});
</script>

<style scoped>
.badge-container {
  position: relative;
  display: inline-block;
}

.badge-value {
  position: absolute;
  width: 20px;
  height: 20px;
  font-size: 0.75rem;
  line-height: 1.25rem;
  top: 0;
  right: 0;
  background-color: rgb(255, 85, 85);
  color: #fff;
  text-align: center;
  transform: translate(10px, -10px);
}

.badge-value.--circle {
  border-radius: 50%;
}

.badge-value.--dot {
  border-radius: 50%;
  width: 10px;
  height: 10px;
  transform: translate(5px, -5px);
}
</style>
