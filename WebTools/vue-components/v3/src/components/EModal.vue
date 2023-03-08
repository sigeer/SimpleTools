<template>
  <div class="e-modal" v-show="configs.visible" ref="instance">
    <div
      class="e-modal modal-content"
      :style="`width: ${props.width}px;height: ${props.height}px`"
    >
      <div class="header" v-if="props.showHeader">
        <slot name="header"></slot>
      </div>
      <div class="body">
        {{ props.content }}
        <slot name="body"></slot>
      </div>
      <div class="footer" v-if="props.showFooter">
        <slot name="footer"></slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import { nextTick, reactive, ref } from "vue";

const instance = ref(null);

const configs = reactive({
  visible: false,
});

const props = defineProps({
  width: {
    type: [String, Number],
    default: 800,
  },
  height: {
    type: [String, Number],
    default: 600,
  },
  showHeader: {
    type: Boolean,
    default: true,
  },
  content: {
    type: String,
  },
  showFooter: {
    type: Boolean,
    default: true,
  },
});

const show = () => {
  configs.visible = true;

  nextTick((_) => {
    document.body.style.overflow = "hidden";
  });
};

const hide = () => {
  configs.visible = false;
};

defineExpose({
  show,
  hide,
});
</script>

<style scoped>
.e-modal {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  display: flex;
  justify-content: left;
  align-items: left;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: 9999;
}

.e-modal.modal-content {
  background-color: white;
  display: flex;
  flex-direction: column;
  margin: auto;
  border-radius: 4px;
}

.e-modal.modal-content > .header {
  padding: 32px 32px 32px 32px;
}

.e-modal.modal-content > .body {
  padding: 0px 32px 32px 32px;
}

.e-modal.modal-content > .footer {
  padding: 0px 32px 30px 32px;
}
</style>
