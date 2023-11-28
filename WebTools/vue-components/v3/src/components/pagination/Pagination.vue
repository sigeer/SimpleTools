<template>
  <div class="pagination-container">
    <div class="pagination-info">
      当前第{{ localModel.pageIndex }}页，每页最多{{
        localModel.pageSize
      }}条数据，共有{{ localModel.total }}条数据
    </div>
    <button
      class="pagination-control-previous"
      @click="previous"
      :disabled="!canPrevious"
    >
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
          d="M15.75 19.5L8.25 12l7.5-7.5"
        ></path>
      </svg>
    </button>
    <input
      type="number"
      class="pagination-edit"
      v-model="current"
      @keyup.enter="jump"
      @blur="jump"
      title="回车跳转目标页"
    />
    <span class="pagination-span">/ {{ totalPageSize }}</span>
    <button class="pagination-control-next" :disabled="!canNext" @click="next">
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
          d="M8.25 4.5l7.5 7.5-7.5 7.5"
        ></path>
      </svg>
    </button>
  </div>
</template>

<script setup>
import { computed, ref, unref, watch } from "vue";
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => {
      return { pageIndex: 1, pageSize: 10, total: 0 };
    },
  },
});

const localModel = ref({ pageIndex: 0, pageSize: 0, total: 0 });
const current = ref(1);

watch(
  () => props.modelValue,
  () => {
    if (
      props.modelValue.pageIndex !== localModel.value.pageIndex ||
      props.modelValue.pageSize !== localModel.value.pageSize
    ) {
      localModel.value.pageIndex = props.modelValue.pageIndex;
      localModel.value.pageSize = props.modelValue.pageSize;
      localModel.value.total = props.modelValue.total;
      current.value = props.modelValue.pageIndex;
    }
  },
  {
    deep: true,
    immediate: true,
  }
);

const totalPageSize = computed(() => {
  return Math.ceil(props.modelValue.total / localModel.value.pageSize);
});

const dataEmits = defineEmits(["update:modelValue"]);
const canNext = computed(() => {
  return localModel.value.pageIndex < totalPageSize.value;
});
const next = () => {
  if (unref(canNext)) {
    current.value++;
    localModel.value.pageIndex = current.value;
    props.modelValue.change && props.modelValue.change(localModel.value);
    dataEmits("update:modelValue", localModel.value);
  }
};
const canPrevious = computed(() => {
  return localModel.value.pageIndex > 1;
});
const previous = () => {
  if (unref(canPrevious)) {
    current.value--;
    localModel.value.pageIndex = current.value;
    props.modelValue.change && props.modelValue.change(localModel.value);
    dataEmits("update:modelValue", localModel.value);
  }
};

const jump = () => {
  if (!current.value) current.value = 1;
  current.value = +current.value.toFixed(0);
  if (!current.value) current.value = 1;
  if (current.value > totalPageSize.value) current.value = totalPageSize.value;
  localModel.value.pageIndex = current.value;
  props.modelValue.change && props.modelValue.change(localModel.value);
  dataEmits("update:modelValue", localModel.value);
};
</script>

<style lang="less" scoped>
input,
button,
select,
textarea {
  outline: none;
}
input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type="number"] {
  -moz-appearance: textfield;
}
@backgroundColor: #f3f3f3;
.pagination-container {
  font-size: 0.75rem;
  display: flex;
  height: 32px;
  line-height: 32px;
  background-color: @backgroundColor;
}

.pagination-info {
  padding: 0 4px;
}

.pagination-edit {
  min-width: 24px;
  max-width: 48px;
  border: none;
  border-bottom: 1px solid #787878;
  background-color: @backgroundColor;
}

.pagination-span {
  padding: 0 6px;
}

.pagination-control-previous {
  margin-left: auto;
}

.pagination-control-previous,
.pagination-control-next {
  font-size: 0.75rem;
  padding: 8px 0;
  border: 0;
  border-radius: 25px;
  background-color: @backgroundColor;
  width: 32px;

  &:hover,
  &:active {
    &:not(.disabled, [disabled]) {
      background-color: #e1e1e1;
    }
  }

  svg {
    width: 18px;
    height: 18px;
  }
}
</style>
