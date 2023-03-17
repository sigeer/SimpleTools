<template>
  <div
    class="auto-complete-container"
    ref="elRef"
    :class="[props.disabled ? 'disabled' : '']"
  >
    <div>
      <input
        type="text"
        autocomplete="off"
        autofocus
        v-model="states.value"
        :disabled="props.disabled"
        @focus="handleFocus"
      />
    </div>
    <div
      :style="viewModel.dropdownStyle"
      :class="viewModel.direction"
      class="auto-complete-items"
      v-show="states.visible"
      v-if="filteredDataSource.length > 0"
    >
      <ul>
        <li
          v-for="x in filteredDataSource"
          :class="[x == props.modelValue ? 'selected ' : '']"
          @click="select(x)"
          :key="x.key"
          :data-val="x"
        >
          <slot name="item" :item="x">
            <a :title="x">{{ x }}</a>
          </slot>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, watch, nextTick, computed } from "vue";

const elRef = ref(null);
onMounted(() => {
  document.body.addEventListener("click", function (e) {
    if (elRef.value && !elRef.value.contains(e.target)) {
      toggleCore(false);
    }
  });

  setTimeout(() => {
    elRef.value.addEventListener("keydown", (event) => {
      switch (event.keyCode) {
        case 38: // Up arrow
          // 向上移动选中的li元素
          moveSelection("up");
          break;
        case 40: // Down arrow
          // 向下移动选中的li元素
          moveSelection("down");
          break;
        case 13:
          selectElement();
          break;
      }
    });
  }, 200);
});

const selectElement = () => {
  var current = elRef.value.querySelector("li.highlight"); // 获取当前选中的li元素
  if (current !== null) {
    select(current.getAttribute("data-val"));
  }
};

const moveSelection = (direction) => {
  var current = elRef.value.querySelector("li.highlight"); // 获取当前选中的li元素
  if (current === null) {
    elRef.value.querySelector("li").classList.add("highlight");
    return;
  }
  let next; // 定义下一个要选中的li元素
  if (direction === "up") {
    next =
      viewModel.direction === "down"
        ? current.previousElementSibling
        : current.nextElementSibling;
  } else if (direction === "down") {
    next =
      viewModel.direction === "down"
        ? current.nextElementSibling
        : current.previousElementSibling;
  }
  if (next !== null) {
    // 如果有下一个li元素
    current.classList.remove("highlight"); // 取消当前选中的样式
    next.classList.add("highlight"); // 添加下一个li元素的选中样式
    scrollInner(elRef.value.querySelector(".auto-complete-items"), current);
  }
};

const props = defineProps({
  modelValue: {
    type: String,
  },
  dataSource: {
    type: Array,
    default: () => [],
  },
  maxCount: {
    type: Number,
    default: 8,
  },
  disabled: {
    type: Boolean,
    default: false,
  },
});

const emits = defineEmits(["update:modelValue", "change", "search"]);

const states = reactive({
  value: "",
  visible: false,
  total: [],
});

watch(
  () => props.dataSource,
  () => {
    states.total = props.dataSource;
  },
  { deep: true, immediate: true }
);
watch(
  () => props.modelValue,
  () => {
    if (states.value !== props.modelValue) states.value = props.modelValue;
  },
  {
    immediate: true,
  }
);
watch(
  () => states.value,
  () => {
    emits("search", states.value);
    emits("update:modelValue", states.value);
    if (states.value !== props.modelValue) {
      showDropdown();
      emits("change", states.value);
    }
  },
  {
    immediate: true,
  }
);

const isFirstFocus = ref(true);
const handleFocus = () => {
  if (isFirstFocus.value && isStringNullOrEmpty(states.value)) {
    isFirstFocus.value = false;
  } else {
    showDropdown();
  }
};

const filteredDataSource = computed(() => {
  return states.total.filter((x) => x.indexOf(states.value) !== -1);
});

const viewModel = reactive({
  dropdownStyle: {},
  direction: "down",
});

const calcPosition = () => {
  if (!viewModel.dropdownStyle.display) {
    const rangeHight = 23;
    const maxZIndex = getMaxZIndex();
    const dropHeight = props.maxCount * rangeHight + 2;
    viewModel.dropdownStyle = {
      "max-height": dropHeight + "px",
      "z-index": maxZIndex + 1,
    };
    const distance = getElementBottomDistance(elRef.value);
    viewModel.direction = distance - dropHeight <= 10 ? "up" : "down";
  }
};

const toggleCore = (target) => {
  states.visible = target;
};

const select = (item) => {
  states.value = item;
  nextTick(() => {
    toggleCore(false);
  });
};

const showDropdown = () => {
  if ((states.value ?? "").length !== 0) {
    const obj = states.total.find((x) => x.indexOf(states.value) !== -1);
    if (!obj) {
      return;
    }
  } else {
    return;
  }
  calcPosition();

  toggleCore(true);
  if (states.visible) {
    nextTick(() => {
      scrollTo(props.modelValue);
    });
  }
};

const getMaxZIndex = () => {
  return Array.from(document.querySelectorAll("*")).reduce((a, x) => {
    let cs = window.getComputedStyle(x, null);
    let z = +(cs.zIndex || "1");
    z = cs.display == "none" || cs.opacity == "0" ? 1 : z;

    if (isNaN(z)) z = 1;
    else if (z > 10000000) z = 1;

    return Math.max(a, z);
  }, 1);
};

// 获取元素距离底部的距离
const getElementBottomDistance = (element) => {
  // 获取元素相对于视口的位置信息
  const rect = element.getBoundingClientRect();
  // 计算元素距离页面底部的距离
  const distanceToBottom = document.documentElement.clientHeight - rect.bottom;
  return distanceToBottom;
};

const scrollTo = (targetValue) => {
  var tags = Array.prototype.slice.call(
    elRef.value.querySelectorAll("[data-val]")
  );
  let rangeHight = 0;
  let targetIndex = -1;
  for (var i = 0; i < tags.length; i++) {
    if (tags[i].getAttribute("data-val") == targetValue) {
      targetIndex = i;
      break;
    } else {
      rangeHight += ((tags[i].getClientRects() || [])[0] || {}).height || 0;
    }
  }
  if (targetIndex !== -1) {
    if (viewModel.direction === "up")
      elRef.value.querySelector(".auto-complete-items").scrollBottom =
        rangeHight;
    else
      elRef.value.querySelector(".auto-complete-items").scrollTop = rangeHight;
  }
};

const scrollInner = (container, element) => {
  var containerRect = container.getBoundingClientRect(); // 获取div的显示区域
  var elementRect = element.getBoundingClientRect(); // 获取要调整位置的元素的区域
  var scrollTop = element.offsetTop - container.offsetTop;
  if (scrollTop + elementRect.height > containerRect.height) {
    // 如果元素顶部在显示区域之外，则将元素移到顶部
    scrollTop = container.scrollHeight - elementRect.height;
  }
  container.scrollTop = scrollTop; // 设置ul元素的scrollTop属性
};

const isStringNullOrEmpty = function (e) {
  return (e ?? "").toString().trim().length <= 0;
};
</script>

<style scoped>
.auto-complete-container {
  position: relative;
  line-height: 1.5em;
  width: 100%;
}

.auto-complete-container[disabled],
.auto-complete-container.disabled,
.auto-complete-container.disabled > * {
  cursor: not-allowed !important;
  background-color: #eee;
}

.auto-complete-container.disabled > * {
  pointer-events: none;
}

.dropdown-inview .dropdown-search {
  display: inline-flex;
  background-color: #fff;
  padding: 0.375em 0.75em;
  border-left: 1px solid #dee2e6;
  border-right: 1px solid #dee2e6;
}

.auto-complete-container input {
  border: 0px;
  outline: none;
  width: 100%;
  display: block;
  font-weight: 400;
  line-height: 1.5em;
  padding: 0.375em 0.75em;
  border: 1px solid #dee2e6;
  box-sizing: border-box;
  color: #212529;
  background-clip: padding-box;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.auto-complete-items {
  overflow: auto;
  border: 1px solid #dee2e6;
  box-sizing: border-box;
  display: block;
  background-color: #fff;
  position: absolute;
  width: 100%;
  display: flex;
  flex-direction: column;
}

.auto-complete-items.up {
  flex-direction: column-reverse;
  bottom: 2em;
}

.auto-complete-items > ul {
  margin: 0px;
  padding: 0px;
  display: flex;
  flex-direction: column;
}

.auto-complete-items ul > li {
  cursor: pointer;
  display: block;
  padding: 5px 10px;
}

.auto-complete-items ul > li:hover,
.auto-complete-items ul > li.highlight {
  color: #262626;
  text-decoration: none;
  background-color: #79b4d8;
}

.auto-complete-items ul > li,
.auto-complete-items ul > li > * {
  display: block;
  text-decoration: none;
  color: black;
  font-size: 12px;
  word-wrap: break-word;
}

.auto-complete-items ul > li.selected {
  color: #262626;
  text-decoration: none;
  background-color: #66afe9;
}
.dropdown-outview {
  display: flex;
  box-sizing: border-box;
  height: 2.25em;
  padding: 0.375rem 0.75em;
  font-weight: 400;
  color: #212529;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #dee2e6;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  cursor: pointer;
  position: relative;
}
.dropdown-outview > .display-text {
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}
.dropdown-outview > .display-text .place-holder {
  color: #8f8f8f;
}
.dropdown-outview .arrow-icon {
  flex: 0 0 1em;
  zoom: 0.8;
}

.dropdown-outview .arrow-icon > svg {
  transition: transform 0.3s;
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
