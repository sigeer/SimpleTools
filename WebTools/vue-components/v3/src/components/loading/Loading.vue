<template>
  <div :class="['loading-container', props.loading ? 'loading' : '']">
    <div
      :class="[
        'loading-body',
        props.hideMainBody && props.loading ? 'hidden' : '',
      ]"
    >
      <slot></slot>
    </div>

    <div class="loading-control" v-if="props.loading">
      <div class="loading-spining">
        <slot name="loadingTips"> </slot>
        <slot name="loadingIcon" v-if="showIcon">
          <div class="loading-icon" :style="iconStyle"></div>
        </slot>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  loading: {
    type: Boolean,
    default: false,
  },
  iconStyle: {
    type: String,
    default: "",
  },
  /**
   * loading时隐藏原内容
   */
  hideMainBody: {
    type: Boolean,
    default: false,
  },
  /**
   * 显示默认的loading
   */
  showIcon: {
    type: Boolean,
    default: true,
  },
});
</script>

<style scoped>
.loading-container {
  position: relative;
}

.loading-spining {
  position: absolute;
  top: 50%;
  left: 50%;
  display: inline-flex;
  transform: translate(-50%, -50%);
}
div.loading-icon {
  width: 1em;
  height: 1em;
  border-radius: 50%;
  border: 2px solid #ccc;
  border-top-color: #333;
  animation: spin 0.8s linear infinite;
  margin-top: 2px;
}

.loading-container.loading {
  pointer-events: none;
  user-select: none;
}
.loading-container.loading .loading-body {
  opacity: 0.2;
}

.loading-container.loading .loading-body.hidden {
  visibility: hidden;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
