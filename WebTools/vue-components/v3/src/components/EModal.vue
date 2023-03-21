<template>
  <Transition name="fade">
    <div
      class="e-modal"
      v-show="configs.visible"
      ref="instance"
      @click="handlerModalClick"
    >
      <div
        class="e-modal modal-content"
        :style="`width: ${formatStyle(props.width)};height: ${formatStyle(
          props.height
        )}; margin-top:${formatStyle(props.top)}`"
        ref="modalContentRef"
      >
        <div class="header" v-if="props.showHeader">
          <div class="header-content">
            <slot name="header"></slot>
          </div>
          <span class="header-control" @click="hide" aria-label="Close">
            X
          </span>
        </div>
        <div class="border" v-if="props.showDivider"></div>
        <div class="body">
          {{ props.content }}
          <slot name="body"></slot>
        </div>
        <div class="border" v-if="props.showDivider"></div>
        <div class="footer" v-if="props.showFooter">
          <slot name="footer">
            <button>确定</button>
          </slot>
        </div>
      </div>
    </div>
  </Transition>
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
    default: "fit-content",
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
  showDivider: {
    type: Boolean,
    default: true,
  },
  static: {
    type: Boolean,
    default: false,
  },
  top: {
    type: [Object, Number],
    default: undefined,
  },
});

const emits = defineEmits(["shown", "hidden"]);

let bodyOverflow = null;
const show = () => {
  bodyOverflow = document.body.style.overflow;
  configs.visible = true;
  emits("shown");
  nextTick((_) => {
    document.body.style.overflow = "hidden";
  });
};

const hide = () => {
  configs.visible = false;
  emits("hidden");
  nextTick((_) => {
    document.body.style.overflow = bodyOverflow;
  });
};

const modalContentRef = ref(null);

const handlerModalClick = (evt) => {
  if (!props.static && !modalContentRef.value.contains(evt.target)) {
    hide();
  }
};

const isNumber = (input) => {
  return /^[0-9]+\.?[0-9]*$/.test(input);
};

const formatStyle = (input) => {
  return isNumber(input) ? `${input}px` : input;
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
  padding: 12px 12px 12px 12px;
  display: flex;
  line-height: 24px;
}

.e-modal.modal-content > .header > .header-content {
  flex: 1;
}
.e-modal.modal-content > .header > .header-control {
  cursor: pointer;
}

.e-modal.modal-content > .body {
  padding: 0px 12px 12px 12px;
}

.e-modal.modal-content > .footer {
  padding: 0px 12px 12px 12px;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.border {
  border-bottom: 1px solid #e8e8e8;
}
</style>
