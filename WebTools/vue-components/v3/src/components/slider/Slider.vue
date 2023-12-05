<template>
  <div class="slider-container" ref="containerRef" @click="handleClick">
    <div class="slider-left" ref="leftRef"></div>
    <div class="slider-circle" ref="centerRef"></div>
    <div class="slider-right"></div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";

const props = defineProps({
  rate: {
    type: Number,
    default: 0,
  },
});

const dataEmits = defineEmits(["update:rate"]);

const containerRef = ref();
const leftRef = ref();
const centerRef = ref();
onMounted(() => {
  setValue(props.rate);

  let isDragging = false;

  const startDrag = (event) => {
    isDragging = true;
    document.addEventListener("mousemove", handleDrag);
    document.addEventListener("mouseup", stopDrag);
  };

  centerRef.value.addEventListener("mousedown", startDrag);

  const handleDrag = (event) => {
    if (isDragging) {
      const sliderRect = containerRef.value.getBoundingClientRect();
      if (sliderRect) {
        const offsetX = event.clientX - sliderRect.left;
        const newValue = (offsetX / sliderRect.width) * 100;

        // 限制值范围在 0 到 100 之间
        const value = +Math.max(Math.min(newValue, 100), 0).toFixed(4);
        setValue(value);
      }
    }
  };

  const stopDrag = () => {
    isDragging = false;
    document.removeEventListener("mousemove", handleDrag);
    document.removeEventListener("mouseup", stopDrag);
  };
});

const setValue = (value) => {
  leftRef.value.style.width = `${value}%`;
  centerRef.value.style.left = `${value}%`;
  dataEmits("update:rate", value);
};

const handleClick = (evt) => {
  const sliderRect = containerRef.value.getBoundingClientRect();
  const offsetX = evt.clientX - sliderRect.left;
  const newValue = (offsetX / sliderRect.width) * 100;
  const value = +Math.max(Math.min(newValue, 100), 0).toFixed(4);
  setValue(value);
};
</script>

<style lang="less" scoped>
.slider-container {
  position: relative;
  height: 4px;
  background-color: #d8d8d8;
  margin: 4px;
  cursor: pointer;

  .slider-left {
    height: 4px;
    background-color: #66ccff;
    width: 0%;
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
      width: 12px;
      height: 12px;
      transform: translate(-6px, -6px);
    }
  }
}
</style>
