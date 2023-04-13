<template>
  <div
    class="dropdown-container"
    :style="style"
    :class="[props.disabled ? 'disabled' : '']"
    ref="elRef"
  >
    <div
      class="dropdown-outview"
      :class="{ 'dropdown-visible': states.visible }"
      :style="style"
      @click="toggleList()"
    >
      <span class="display-text">
        <span
          v-if="states.selectedItem[props.valuePropName] === undefined"
          class="place-holder"
        >
          {{ props.placeHolder }}
        </span>
        <slot name="display" :item="states.selectedItem">
          {{ states.selectedItem[props.textPropName] }}
        </slot>
      </span>
      <i class="arrow-icon">
        <svg
          viewBox="64 64 896 896"
          data-icon="down"
          width="1em"
          height="1em"
          fill="currentColor"
          aria-hidden="true"
          focusable="false"
          :style="states.visible ? 'transform: rotate(180deg)' : ''"
        >
          <path
            d="M884 256h-75c-5.1 0-9.9 2.5-12.9 6.6L512 654.2 227.9 262.6c-3-4.1-7.8-6.6-12.9-6.6h-75c-6.5 0-10.3 7.4-6.5 12.7l352.6 486.1c12.8 17.6 39 17.6 51.7 0l352.6-486.1c3.9-5.3.1-12.7-6.4-12.7z"
          ></path>
        </svg>
      </i>
    </div>
    <div
      v-show="states.visible"
      class="dropdown-inview"
      :class="viewModel.direction"
      :style="viewModel.inViewStyle"
    >
      <div
        class="dropdown-search"
        v-if="props.canSearch"
        :style="viewModel.searchStyle"
      >
        <e-input v-model="states.searchText" autocomplete="off" autofocus>
          <template #suffix>
            <i class="search-icon">
              <svg
                viewBox="64 64 896 896"
                data-icon="search"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M909.6 854.5L649.9 594.8C690.2 542.7 712 479 712 412c0-80.2-31.3-155.4-87.9-212.1-56.6-56.7-132-87.9-212.1-87.9s-155.5 31.3-212.1 87.9C143.2 256.5 112 331.8 112 412c0 80.1 31.3 155.5 87.9 212.1C256.5 680.8 331.8 712 412 712c67 0 130.6-21.8 182.7-62l259.7 259.6a8.2 8.2 0 0 0 11.6 0l43.6-43.5a8.2 8.2 0 0 0 0-11.6zM570.4 570.4C528 612.7 471.8 636 412 636s-116-23.3-158.4-65.6C211.3 528 188 471.8 188 412s23.3-116.1 65.6-158.4C296 211.3 352.2 188 412 188s116.1 23.2 158.4 65.6S636 352.2 636 412s-23.3 116.1-65.6 158.4z"
                ></path>
              </svg>
            </i>
          </template>
        </e-input>
      </div>
      <div :style="viewModel.dropdownPoistionStyle" class="dropdown-items">
        <ul>
          <li
            v-for="x in ds"
            :class="[
              x[props.valuePropName] == props.modelValue ? 'selected ' : '',
            ]"
            @click="select(x)"
            :key="x.key"
            :data-val="x[props.valuePropName]"
          >
            <slot name="item" :item="x">
              <a :title="x[props.textPropName]">{{ x[props.textPropName] }}</a>
            </slot>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, nextTick, onMounted, reactive, ref, watch } from "vue";
import EInput from "./EInput.vue";

const elRef = ref(0);
const props = defineProps({
  dataSource: {
    type: Array,
    default: () => [],
  },
  valuePropName: {
    type: String,
    default: "value",
  },
  textPropName: {
    type: String,
    default: "text",
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  style: {
    type: [String, Object],
    default: null,
  },
  containerStyle: {
    type: String,
    default: "",
  },
  textStyle: {
    type: String,
    default: "",
  },
  itemStyle: {
    type: String,
    default: "",
  },
  maxCount: {
    type: Number,
    default: 8,
  },
  canSearch: {
    type: Boolean,
    default: false,
  },
  modelValue: {
    type: [Number, String, Boolean],
    default: null,
  },
  placeHolder: {
    type: String,
  },
  autoFill: {
    type: Boolean,
    default: false,
  },
});

const states = reactive({
  total: [],
  visible: false,
  searchText: "",
  selectedItem: {},
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
  (newV, oldV) => {
    nextTick(() => {
      const obj = states.total.find(
        (x) => x[props.valuePropName] === props.modelValue
      );
      states.selectedItem = obj ?? {};
    });
  },
  {
    immediate: true,
  }
);
const ds = computed(() => {
  const filteredDs = states.total.filter(
    (x) => x[props.textPropName].indexOf(states.searchText) !== -1
  );
  if (filteredDs.length === 1 && props.autoFill) {
    select(filteredDs[0]);
  }
  return filteredDs;
});

onMounted(() => {
  document.body.addEventListener("click", function (e) {
    if (elRef.value && !elRef.value.contains(e.target)) {
      toggleCore(false);
    }
  });
});

const toggleCore = (target) => {
  states.visible = target;
  states.searchText = "";
};

const select = (item) => {
  toggleCore(false);
  if (props.modelValue !== item[props.valuePropName]) {
    emits("change", item);
  }
  emits("update:modelValue", item[props.valuePropName]);
};
const emits = defineEmits(["update:modelValue", "change"]);

const toggleList = () => {
  calcPosition();

  toggleCore(!states.visible);
  if (states.visible) {
    nextTick(() => {
      scrollTo(props.modelValue);
    });
  }
};

const viewModel = reactive({
  dropdownPoistionStyle: {},
  searchStyle: {},
  inViewStyle: {},
  direction: "down",
});
const calcPosition = () => {
  if (!viewModel.dropdownPoistionStyle.display) {
    const rangeHight = 16 * 2;
    const maxZIndex = getMaxZIndex();
    const dropHeight = props.maxCount * rangeHight + 2;
    viewModel.dropdownPoistionStyle = {
      "max-height": dropHeight + "px",
    };
    viewModel.inViewStyle = {
      "z-index": maxZIndex + 1,
    };
    const distance = getElementBottomDistance(elRef.value);
    viewModel.direction = distance - dropHeight <= 10 ? "up" : "down";
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
      elRef.value.querySelector(".dropdown-items").scrollBottom = rangeHight;
    else elRef.value.querySelector(".dropdown-items").scrollTop = rangeHight;
  }
};
</script>

<style scoped>
.dropdown-container {
  position: relative;
  line-height: 1.5em;
  width: 100%;
}

.dropdown-container[disabled],
.dropdown-container.disabled,
.dropdown-container.disabled > * {
  cursor: not-allowed !important;
  background-color: #eee;
}

.dropdown-container.disabled > * {
  pointer-events: none;
}

.dropdown-inview {
  position: absolute;
  width: 100%;
  display: flex;
  flex-direction: column;
}
.dropdown-inview.up {
  flex-direction: column-reverse;
  bottom: 2.25em;
}
.dropdown-inview .dropdown-search {
  border-top: none;
  border-bottom: none;
}

.dropdown-inview .dropdown-search > input {
  border: 0px;
  outline: none;
  cursor: text;
  width: 100%;
  display: block;
  font-weight: 400;
  color: #212529;
  background-color: #fff;
  background-clip: padding-box;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.dropdown-items {
  overflow: auto;
  border: 1px solid #dee2e6;
  display: block;
  background-color: #fff;
}

.dropdown-items > ul {
  margin: 0px;
  padding: 0px;
  display: flex;
  flex-direction: column;
}

.dropdown-inview.up .dropdown-items > ul {
  flex-direction: column-reverse;
}

.dropdown-items ul > li {
  cursor: pointer;
  display: block;
  padding: 5px 0.5em;
}

.dropdown-items ul > li:hover {
  color: #262626;
  text-decoration: none;
  background-color: #79b4d8;
}

.dropdown-items ul > li,
.dropdown-items ul > li > * {
  display: block;
  text-decoration: none;
  color: black;
  font-size: 12px;
  word-wrap: break-word;
}

.dropdown-items ul > li.selected {
  color: #262626;
  text-decoration: none;
  background-color: #66afe9;
}
.dropdown-outview {
  display: flex;
  box-sizing: border-box;
  height: 2.25em;
  padding: 0.375rem 0.5em;
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

.dropdown-outview.dropdown-visible {
  border: 1px solid #6bb5ff;
  box-shadow: 0px 0px 15px rgb(0 0 0 / 5%);
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

.dropdown-inview.up > .dropdown-items {
  border-bottom: none;
}

.dropdown-inview.down > .dropdown-items {
  border-top: none;
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
