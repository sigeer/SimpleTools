<template>
  <div class="slider-container" ref="containerRef" @click="handleClick">
    <div class="slider-left"></div>
    <div class="slider-center" ref="centerRef"></div>
    <div class="slider-right"></div>
    <div class="slider-circle" ref="coreRef1" :data-rate="0"></div>
    <div class="slider-circle" ref="coreRef2" :data-rate="0"></div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";

const props = defineProps({
  range: {
    type: Array,
    default: () => [0, 0],
  },
});

const dataEmits = defineEmits(["update:range"]);

const containerRef = ref();
const coreRef1 = ref();
const coreRef2 = ref();
const centerRef = ref();
onMounted(() => {
  setRangeValue(props.range[0], props.range[1]);

  let isDragging1 = false;
  let isDragging2 = false;

  const startDrag1 = (event) => {
    isDragging1 = true;
    document.addEventListener("mousemove", handleDrag1);
    document.addEventListener("mouseup", stopDrag1);
  };

  const startDrag2 = (event) => {
    isDragging2 = true;
    document.addEventListener("mousemove", handleDrag2);
    document.addEventListener("mouseup", stopDrag2);
  };

  coreRef1.value.addEventListener("mousedown", startDrag1);
  coreRef2.value.addEventListener("mousedown", startDrag2);

  const handleDrag1 = (event) => {
    if (isDragging1) {
      const sliderRect = containerRef.value.getBoundingClientRect();
      if (sliderRect) {
        const offsetX = event.clientX - sliderRect.left;
        const newValue = (offsetX / sliderRect.width) * 100;

        // 限制值范围在 0 到 100 之间
        const value = Math.max(Math.min(newValue, 100), 0);
        const another = +coreRef2.value.dataset.rate;
        if (value < another) {
          setRangeValue(value, another);
        } else {
          stopDrag1(event);
          startDrag2(event)
        }
      }
    }
  };

  const handleDrag2 = (event) => {
    if (isDragging2) {
      const sliderRect = containerRef.value.getBoundingClientRect();
      if (sliderRect) {
        const offsetX = event.clientX - sliderRect.left;
        const newValue = (offsetX / sliderRect.width) * 100;

        // 限制值范围在 0 到 100 之间
        const value = Math.max(Math.min(newValue, 100), 0);
        const another = +coreRef1.value.dataset.rate;
        if (value < another) {
          stopDrag2(event);
          startDrag1(event)
        } else {
          setRangeValue(another, value);
        }
      }
    }
  };

  const stopDrag1 = () => {
    isDragging1 = false;
    document.removeEventListener("mousemove", handleDrag1);
    document.removeEventListener("mouseup", stopDrag1);
  };

  const stopDrag2 = () => {
    isDragging2 = false;
    document.removeEventListener("mousemove", handleDrag2);
    document.removeEventListener("mouseup", stopDrag2);
  };
});

const localRange = ref([0, 0]);
const leftCore = computed(() => {
  return +coreRef1.value.dataset.rate <= +coreRef2.value.dataset.rate
    ? coreRef1.value
    : coreRef2.value;
});

const rightCore = computed(() => {
  return +coreRef1.value.dataset.rate > +coreRef2.value.dataset.rate
    ? coreRef1.value
    : coreRef2.value;
});

const setRangeValue = (left, right) => {
  localRange.value[0] = left;
  leftCore.value.dataset.rate = left;
  leftCore.value.style.left = `${left}%`;

  localRange.value[1] = right;
  rightCore.value.dataset.rate = right;
  rightCore.value.style.left = `${right}%`;

  setRangeStyle();
  dataEmits("update:range", localRange.value);
};
const setRangeStyle = () => {
  centerRef.value.style.left = `${localRange.value[0]}%`;
  centerRef.value.style.width = `${Math.abs(
    localRange.value[1] - localRange.value[0]
  )}%`;
};

const handleClick = (evt) => {
  const sliderRect = containerRef.value.getBoundingClientRect();
  const offsetX = evt.clientX - sliderRect.left;
  const newValue = (offsetX / sliderRect.width) * 100;
  const value = Math.max(Math.min(newValue, 100), 0);

  const d1 = +coreRef1.value.dataset.rate;
  const d2 = +coreRef2.value.dataset.rate;

  if (value < d1) setRangeValue(value, d2);
  else if (value > d2) setRangeValue(d1, value);
  else if (d2 - value < value - d1) setRangeValue(d1, value);
  else setRangeValue(value, d2);
};
</script>

<style lang="less" scoped>
.slider-container {
  position: relative;
  height: 4px;
  background-color: #d8d8d8;
  margin: 4px;
  cursor: pointer;

  .slider-left,
  .slider-right {
    height: 4px;
    background-color: #d8d8d8;
    width: 0%;
  }

  .slider-center {
    position: absolute;
    height: 4px;
    background-color: #66ccff;
    width: 0%;
    top: 0%;
  }

  .slider-circle {
    border-radius: 50%;
    border: 3px solid #66ccff;
    background-color: #fff;
    position: absolute;
    top: 0;
    height: 8px;
    width: 8px;
    transform: translate(-4px, -4px);
    cursor: pointer;

    &:active {
      border: 3px solid #27acee;
    }
  }
}
</style>
