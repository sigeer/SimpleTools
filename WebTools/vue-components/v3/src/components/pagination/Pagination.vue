<template>
  <div class="pagination-container">
    <button
      class="pagination-control-previous"
      @click="previous"
      :disabled="!canPrevious"
    >
      &lt;
    </button>
    <input
      type="number"
      class="pagination-edit"
      v-model="localModel.pageIndex"
      @keyup.enter="jump"
      @blur="jump"
    />
    <span class="pagination-span">/ {{ totalPageSize }}</span>
    <button class="pagination-control-next" :disabled="!canNext" @click="next">
      >
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
  return localModel.value.pageIndex < localModel.value.total;
});
const next = () => {
  if (unref(canNext)) {
    localModel.value.pageIndex++;
    props.modelValue.change && props.modelValue.change(localModel.value);
    dataEmits("update:modelValue", localModel.value);
  }
};
const canPrevious = computed(() => {
  return localModel.value.pageIndex > 1;
});
const previous = () => {
  if (unref(canPrevious)) {
    localModel.value.pageIndex--;
    props.modelValue.change && props.modelValue.change(localModel.value);
    dataEmits("update:modelValue", localModel.value);
  }
};
const backUp = ref(1);
const jump = () => {
  if (!localModel.value.pageIndex) localModel.value.pageIndex = 1;
  if (localModel.value.pageIndex > localModel.value.total)
    localModel.value.pageIndex = localModel.value.total;
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

.pagination-container {
  display: flex;
  height: 28px;
  line-height: 28px;
  background-color: #f3f3f3;
}

.pagination-edit {
  min-width: 24px;
  max-width: 48px;
  border: none;
  border-bottom: 1px solid #e2e2e2;
}

.pagination-span {
  font-size: 0.75rem;
  padding: 0 6px;
}

.pagination-control-previous {
  margin-left: auto;
  font-size: 0.75rem;
  padding: 6px 8px;
  border-radius: 0;
}

.pagination-control-next {
  font-size: 0.75rem;
  padding: 6px 8px;
  border-radius: 0;
}
</style>
