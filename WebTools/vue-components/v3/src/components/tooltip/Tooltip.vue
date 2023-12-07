<template>
  <span class="tooltip-container" ref="dRef">
    <slot></slot>
    <span
      :class="'tooltip-content ' + placement_vertical"
      :style="placementStyle"
      v-if="content"
      ref="contentRef"
    >
      {{ content }}
    </span>
  </span>
</template>

<script setup>
import { onMounted, ref, watch } from "vue";

const props = defineProps({
  content: {
    type: [String, Number],
  },

  trigger: {
    type: String,
    default: "hover",
    validator: (value) => {
      return ["hover", "click"].includes(value);
    },
  },
});

const dRef = ref();
const contentRef = ref();
const placementStyle = ref({});
const placement_vertical = ref("bottom");
const setLocation = () => {
  const rect = dRef.value.getBoundingClientRect();
  if (window.innerHeight - rect.bottom < 20) {
    placement_vertical.value = "top";
    placementStyle.value.top = null;
    placementStyle.value.bottom = "calc(100% + 7px)";
  } else {
    placement_vertical.value = "bottom";
    placementStyle.value.top = "calc(100% + 7px)";
    placementStyle.value.bottom = null;
  }
  if (rect.left < 225) {
    placementStyle.value.left = `${225-rect.left + (225-rect.left) / 2}px`;
  }
};
watch(
  () => props.content,
  () => {
    setLocation();
  }
);
onMounted(() => {
  if (props.trigger === "hover") {
    dRef.value.addEventListener("mouseenter", (evt) => {
      setLocation();
      dRef.value.classList.add("visible");
    });

    dRef.value.addEventListener("mouseleave", (evt) => {
      dRef.value.classList.remove("visible");
    });
  } else if (props.trigger === "click") {
    dRef.value.addEventListener("click", (evt) => {
      setLocation();
      dRef.value.classList.add("visible");
    });

    document.addEventListener("click", (evt) => {
      if (!dRef.value.contains(evt.target)) {
        dRef.value.classList.remove("visible");
      }
    });
  }
});
</script>

<style lang="less" scoped>
.tooltip-container {
  position: relative;

  &.visible  {
    .tooltip-content,
    &:has(.tooltip-content.bottom)&::before,
    &:has(.tooltip-content.top)&::before {
        display: block;
    }

  }

  &:has(.tooltip-content.bottom)&::before {
    display: none;
    content: "";
    width: 0;
    height: 0;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-bottom: 7px solid black;
    bottom: -5px;
    position: absolute;
    left: calc(50% - 5px);
  }

  &:has(.tooltip-content.top)&::before {
    display: none;
    content: "";
    width: 0;
    height: 0;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 7px solid black;
    top: -5px;
    position: absolute;
    left: calc(50% - 5px);
  }

  .tooltip-content {
    background-color: #000;
    color: #fff;
    position: absolute;
    max-width: 450px;
    word-wrap: break-word;
    left: 50%;
    display: none;
    padding: 2px 4px;
    border-radius: 6px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5), 0 0 0 2px #000;
    transform: translateX(-50%);
  }
}
</style>
