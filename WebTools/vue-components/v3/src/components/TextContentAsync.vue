<template>
  <div ref="elRef" class="text-content-container">
    <div :style="states.style" :class="[states.overRange ? 'collapsed' : '']">
      {{ displayText }}
    </div>
    <template v-if="states.needOverRange">
      <transition>
        <span v-if="states.overRange" @click="toggle" class="show-more-tips">{{
          props.showMoreTips
        }}</span>
        <span v-else @click="toggle" class="show-more-tips">{{
          props.hideMoreTips
        }}</span>
      </transition>
    </template>
  </div>
</template>

<script setup>
import { nextTick, onMounted, reactive, ref } from "vue";
const props = defineProps({
  text: {
    type: String,
    default: "",
  },

  request: {
    type: Function,
  },

  maxRow: {
    type: Number,
    default: 3,
  },

  showMoreTips: {
    type: String,
    default: "查看全部",
  },

  hideMoreTips: {
    type: String,
    default: "收起",
  },
});

const elRef = ref(null);

const displayText = ref(null);
const fullStrCache = ref(null);
const cacheStr = ref(null);

const states = reactive({
  overRange: true,

  needOverRange: false,

  style: {},

  isLoading: false,
});

onMounted(() => {
  displayText.value = props.text;
  cacheStr.value = props.text;
  nextTick(() => {
    getContentHeight();
  });
});

const getContentHeight = () => {
  const style = window.getComputedStyle(elRef.value, null);
  const fontHeight = (
    style.lineHeight === "normal" ? style.fontSize : style.lineHeight
  ).replace("px", "");

  const totalHeight = style.height.replace("px", "");

  states.overRange = totalHeight / fontHeight > props.maxRow;
  states.needOverRange = states.overRange;
  syncView();
};

const syncView = () => {
  let style = window.getComputedStyle(elRef.value, null);
  let fontHeight = (
    style.lineHeight === "normal" ? style.fontSize : style.lineHeight
  ).replace("px", "");
  if (states.overRange) {
    states.style = {
      height: fontHeight * props.maxRow + "px",
      "-webkit-line-clamp": props.maxRow,
    };
  } else {
    states.style = {};
  }
};

const toggle = () => {
  if (states.overRange && !fullStrCache.value) {
    if (states.isLoading) return;
    states.isLoading = true;
    props
      .request()
      .then((res) => {
        fullStrCache.value = res;
        cacheStr.value = displayText.value;
        displayText.value = res;
        states.overRange = !states.overRange;
        syncView();
      })
      .finally(() => {
        states.isLoading = false;
      });
  } else {
    states.overRange = !states.overRange;
    const tmp = displayText.value;
    displayText.value = cacheStr.value;
    cacheStr.value = tmp;
    syncView();
  }
};
</script>

<style scoped>
.text-content-container {
  position: relative;
}
.text-content-container > div {
  word-break: break-all;
}
.collapsed {
  text-overflow: ellipsis;
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
}
.show-more-tips {
  color: #2776f9;
  cursor: pointer;
  bottom: 0px;
  position: absolute;
  right: 0px;
  background-color: white;
  padding-left: 5px;
}

.v-enter-active,
.v-leave-active {
  transition: opacity 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}
</style>
