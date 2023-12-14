<template>
  <div class="fast-edit-container">
    <div class="fast-edit-display" v-show="!isEditting">
      <div>{{ props.modelValue }}</div>
      <slot name="edit-control">
        <a @click="showEditor" class="fast-edit-control-item">
          <span style="width: 24px">
            <svg
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"
              ></path>
            </svg>
          </span>
        </a>
      </slot>
    </div>
    <div class="fast-edit-control" v-show="isEditting">
      <div :class="['fast-edit-form-item', dataErrorMsg ? 'data-invalid' : '']">
        <slot>
          <input v-model="innerInput" />
        </slot>

        <div class="error-message" v-if="dataErrorMsg">
          {{ dataErrorMsg }}
        </div>
      </div>

      <div class="fast-edit-form-control">
        <slot name="ok-control">
          <a @click="ok" class="fast-edit-control-item">
            <span>
              <svg
                fill="none"
                stroke="currentColor"
                stroke-width="1.5"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M4.5 12.75l6 6 9-13.5"
                ></path>
              </svg>
            </span>
          </a>
        </slot>
        <slot name="cancel-control">
          <a @click="cancel" class="fast-edit-control-item"
            ><svg
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M6 18L18 6M6 6l12 12"
              ></path>
            </svg>
          </a>
        </slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, useSlots, watch } from "vue";

const props = defineProps({
  modelValue: {
    type: [String, Number, Boolean],
  },
  rules: {
    type: Array,
    default: () => [],
  },
});

const backup = ref();
const innerInput = ref();

const slots = useSlots();
watch(
  () => props.modelValue,
  () => {
    if (!slots.default) {
      if (innerInput.value !== props.modelValue) {
        backup.value = props.modelValue;
        innerInput.value = props.modelValue;
      }
    }
  },
  {
    immediate: true,
  }
);

const isEditting = ref(false);

const showEditor = () => {
  isEditting.value = true;
};
const cancelEdit = () => {
  isEditting.value = false;
};

const emits = defineEmits(["submit", "update:modelValue"]);
const ok = () => {
  if (check()) {
    backup.value = innerInput.value;
    emits("submit", innerInput.value);
    emits("update:modelValue", innerInput.value);
    clearCheck();
    cancelEdit();
  }
};
const cancel = () => {
  innerInput.value = backup.value;
  clearCheck();
  cancelEdit();
};

const clearCheck = () => {
  dataErrorMsg.value = null;
};
const dataErrorMsg = ref();
const check = () => {
  const invalidRule = props.rules.find((x) => !x.check(innerInput.value));
  if (invalidRule) {
    dataErrorMsg.value = invalidRule.message;
    return false;
  }
  return true;
};
</script>

<style lang="less" scoped>
.fast-edit-container {
  .error-message {
    color: #fff;
    background-color: red;
    font-size: 14px;
  }

  .fast-edit-display {
    display: flex;
  }

  .fast-edit-control {
    display: flex;

    .fast-edit-form-item {
      &.data-invalid {
        box-shadow: 0 0 8px rgba(255, 0, 0, 0.5), 0 0 0 1px #f00;
        transition: all 0.3s;

        input {
          border: none;

          &:focus-within {
            border: none;
          }
        }
      }

      input {
        outline: none;
        line-height: 24px;
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        border: 1px solid #dee2e6;

        &:focus {
          outline: none;
        }

        &:focus-within {
          border: 1px solid #6bb5ff;
          box-shadow: 0px 0px 15px rgb(0 0 0 / 5%);
        }
      }
    }
  }

  .fast-edit-control-item {
    cursor: pointer;
    display: inline-block;
    padding: 0 6px;
    width: 24px;
    height: 24px;
  }
}
</style>
