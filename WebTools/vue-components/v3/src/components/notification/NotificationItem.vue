<template>
  <div class="e-notification-item" :style="{ ...containerStyle, ...value.style}">
    <div class="e-notification-item-header">
      <div v-if="value.icon" class="icon">
        <span v-if="value.icon === 'warning'" class="warning">
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
              d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z"
            ></path>
          </svg>
        </span>
        <span v-if="value.icon === 'info'" class="info">
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
              d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z"
            ></path>
          </svg>
        </span>
        <span v-if="value.icon === 'error'" class="error">
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
              d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
            ></path>
          </svg>
        </span>
      </div>
      <div class="header">
        {{ value.title }}
      </div>
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
    <div
      class="e-notification-item-body"
      v-if="value.description || value.htmlContent"
    >
      <span v-if="value.htmlContent" v-html="value.htmlContent"></span>
      <span v-else>{{ value.description }}</span>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  value: {
    type: Object,
    required: true,
  },

  containerStyle: {
    type: Object
  }
});

const emits = defineEmits(["delete"]);
const remove = () => {
  emits("delete");
};
</script>

<style lang="less" scoped>
.e-notification-item {
  padding: 16px 24px;
  background-color: #fff;
  margin-bottom: 16px;
  border-radius: 12px;
  box-shadow: 0 6px 16px 0 rgba(0, 0, 0, 0.08),
    0 3px 6px -4px rgba(0, 0, 0, 0.12), 0 9px 28px 8px rgba(0, 0, 0, 0.05);
  opacity: 0;
  animation: fadeInFromLeft 0.4s ease-out forwards;

  .e-notification-item-header {
    margin-bottom: 8px;
    display: flex;
    height: 24px;

    & > .icon {
      flex: 0 0 24px;
      margin-right: 4px;

      .warning {
        color: #efae35;
      }

      .info {
        color: #5679ff;
      }

      .error {
        color: red;
      }
    }

    & > .header {
      flex: 1;
    }

    & > .control {
      flex: 0 0 16px;
      cursor: pointer;
      height: 24px;
      transition: all 0.2s;

      &:hover,
      &:active {
        &:not(.disabled, [disabled]) {
          color: #000;
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
