<template>
  <div class="e-notification-item">
    <div class="e-notification-item-header">
      <div class="header">{{ value.title }}</div>
      <div class="control" @click="remove">
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
            d="M6 18L18 6M6 6l12 12"
          ></path>
        </svg>
      </div>
    </div>
    <div class="e-notification-item-body" v-if="value.description">
      <slot name="description">
        <span v-if="allowHtml" v-html="value.description"></span>
        <span v-else>{{ value.description }}</span>
      </slot>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  value: {
    type: Object,
    required: true,
  },
  allowHtml: {
    type: Boolean,
    default: false,
  },
});

const emits = defineEmits(["delete"]);
const remove = () => {
  emits("delete");
};
</script>

<style lang="less" scoped>
.e-notification-item {
  padding: 12px 20px;
  background-color: #fff;
  margin-bottom: 12px;
  border-radius: 12px;
  box-shadow: 0 6px 16px 0 rgba(0, 0, 0, 0.08),
    0 3px 6px -4px rgba(0, 0, 0, 0.12), 0 9px 28px 8px rgba(0, 0, 0, 0.05);
  opacity: 0;
  animation: fadeInFromLeft 0.4s ease-out forwards;

  .e-notification-item-header {
    margin-bottom: 8px;
    display: flex;

    & > .header {
      flex: 1;
    }

    & > .control {
      flex: 0 0 16px;
      cursor: pointer;
      height: 24px;
      line-height: 30px;
      transition: all 0.2s;

      &:hover,
      &:active {
        &:not(.disabled, [disabled]) {
          background-color: #e1e1e1;
        }
      }
    }
  }
}

@keyframes fadeInFromLeft {
  from {
    opacity: 0;
    transform: translateX(50%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}
</style>
