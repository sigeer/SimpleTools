<template>
  <span :class="['loading-up-c', props.isLoading ? 'loading' : '']" ref="elRef">
    <span
      :class="['loading-body', props.hideMainBody && props.isLoading ? 'hidden' : '']"
    >
      <slot></slot>
    </span>

    <span class="loading-control">
      <span class="loading-spining">
        <slot name="loading-tips"> </slot>
        <div v-if="showIcon" class="loading-icon" :style="iconStyle"></div>
      </span>
    </span>
  </span>
</template>

<script setup>
const props = defineProps({
  isLoading: {
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
.loading-up-c {
  position: relative;
  display: inline-flex;
}
.loading-up-c span.loading-control {
  display: none;
}
.loading-up-c span.loading-spining {
  position: absolute;
  top: 50%;
  left: 50%;
  display: inline-flex;
  transform: translate(-50%, -50%);
}
.loading-up-c div.loading-icon {
  width: 1em;
  height: 1em;
  border-radius: 50%;
  border: 2px solid #ccc;
  border-top-color: #333;
  animation: spin 0.8s linear infinite;
  margin-top: 2px;
}

.loading-up-c.loading {
  pointer-events: none;
}
.loading-up-c.loading .loading-body {
  opacity: 0.1;
}
.loading-up-c.loading span.loading-control {
  display: block;
}

.loading-up-c.loading .loading-body.hidden {
  visibility: hidden;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
