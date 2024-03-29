<template>
  <div class="e-input-container">
    <span class="e-input-prefix" v-if="props.prefix || slots.prefix">
      <slot name="prefix">
        {{ props.prefix }}
      </slot>
    </span>
    <input
      v-if="isDisplay"
      type="text"
      ref="displayRef"
      key="1"
      tag="display"
      class="e-input-form"
      :value="displayText"
      :class="$attrs.class"
      :style="$attrs.style"
      :placeholder="$attrs.placeholder"
      @focus="handleFocus"
    />
    <input
      v-else
      ref="inputRef"
      key="2"
      tag="input"
      class="e-input-form"
      v-model="model"
      v-bind="$attrs"
      @focus="handleFocus"
      @blur="handleBlur"
    />
    <span class="e-input-suffix" v-if="props.suffix || slots.suffix">
      <slot name="suffix">
        {{ props.suffix }}
      </slot>
    </span>
  </div>
</template>

<script setup>
import { nextTick, ref, watch, useSlots } from "vue";

const props = defineProps({
  modelValue: {
    type: [String, Number],
  },
  prefix: {
    type: String,
  },
  suffix: {
    type: String,
  },
  format: {
    type: Function,
  },
});
const slots = useSlots();
const isDisplay = ref(true);
const model = ref(null);
const inputRef = ref(null);
const displayText = ref(null);
const displayRef = ref(null);
watch(
  () => props.modelValue,
  () => {
    if (model.value !== props.modelValue) model.value = props.modelValue;
  },
  { immediate: true }
);
const emits = defineEmits(["update:modelValue", "blur", "focus"]);
watch(() => model.value, () => {
  emits("update:modelValue", model.value);
  displayText.value = props.format ? props.format(model.value) : model.value;
}, { immediate: true });

const handleFocus = (evt) => {
  emits("focus", evt);
  isDisplay.value = false;
  nextTick(() => {
    inputRef.value.focus();
  });
};
const handleBlur = (evt) => {
  emits("blur", evt);
  isDisplay.value = true;
};
</script>

<style scoped>
.e-input-container {
  width: 100%;
  border: 1px solid #dee2e6;
  padding: 0.25rem 0.5em;
  display: inline-flex;
  box-sizing: border-box;
  cursor: text;
  font-weight: 400;
  color: #212529;
  background-color: #fff;
  background-clip: padding-box;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.e-input-container:focus-within {
  border: 1px solid #6bb5ff;
  box-shadow: 0px 0px 15px rgb(0 0 0 / 5%);
}

.e-input-form {
  border: none;
  outline: none;
  padding: 0px;
  margin: 0px;
  width: 100%;
  line-height: inherit;
}

.e-input-prefix,
.e-input-suffix {
  padding: 0px 6px;
}
</style>
