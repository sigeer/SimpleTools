<template>
  <div
    :class="{
      'e-table-container': true,
      '--border': bordered,
      '--scroll': !!containerScrollStyle,
    }"
    :style="containerScrollStyle"
  >
    <div class="e-table-header">
      <div class="e-table-header-row">
        <div
          :class="'e-table-header-cell text-' + (x.align ?? defaultAlign)"
          v-for="x in columns"
          :style="
            x.width
              ? `width: ${formatStyle(x.width)}; flex: 0 0 ${formatStyle(
                  x.width
                )}`
              : ''
          "
        >
          <slot name="headerCell" :column="x">
            {{ x.title }}
          </slot>
        </div>
      </div>
    </div>
    <Loading :loading="loading">
      <div class="e-table-body">
        <div class="e-table-body-row" v-for="row in dataSource">
          <div
            :class="'e-table-body-cell text-' + (col.align ?? defaultAlign)"
            v-for="col in columns"
            :style="
              col.width
                ? `width: ${formatStyle(col.width)}; flex: 0 0 ${formatStyle(
                    col.width
                  )}`
                : ''
            "
          >
            <slot name="bodyCell" :column="col" :row="row">
              {{ row[col.dataPropName] }}
            </slot>
          </div>
        </div>
      </div>
    </Loading>
  </div>
</template>

<script setup>
import Loading from "../loading";
import { computed, ref } from "vue";

const props = defineProps({
  columns: {
    type: Array,
    default: () => [],
  },
  dataSource: {
    type: Array,
    default: () => [],
  },
  bordered: {
    type: Boolean,
    default: true,
  },
  scroll: {
    type: Object,
  },
  loading: {
    type: Boolean,
    default: false,
  }
});

const defaultAlign = ref("center");

const containerScrollStyle = computed(() => {
  let obj = {};
  if (props.scroll) {
    if (props.scroll.width) {
      obj.width = formatStyle(props.scroll.width);
    }
    if (props.scroll.height) {
      obj.height = formatStyle(props.scroll.height);
    }
    return obj;
  }
  return null;
});

const formatStyle = (val) => {
  if (typeof val === "number") {
    return `${val}px`;
  } else if (typeof val === "string") {
    return val;
  }
  return null;
};
</script>

<style lang="less" scoped>
.e-table-container {
  &.--scroll {
    overflow: auto;
  }

  &.--border {
    .e-table-header-row {
      .e-table-header-cell {
        border: 1px solid #ddd;
        flex: 1;

        &:not(:last-child) {
          border-right: 0;
        }
      }
    }

    .e-table-body-row {
      .e-table-body-cell {
        border: 1px solid #ddd;
        flex: 1;
        border-top: 0;

        &:not(:last-child) {
          border-right: 0;
        }
      }
    }
  }

  .e-table-body-row {
    display: flex;
    .e-table-body-cell {
      background-color: #fcfcfc;
      padding: 4px 0;
    }

    &:hover .e-table-body-cell {
      background-color: #f0f0f0;
    }
  }

  .e-table-header-row {
    display: flex;

    .e-table-header-cell {
      background-color: #e3e3e3;
      padding: 4px 0;
    }
  }
}

.text {
  &-center {
    text-align: center;
  }

  &-left {
    text-align: left;
  }

  &-right {
    text-align: right;
  }
}
</style>
