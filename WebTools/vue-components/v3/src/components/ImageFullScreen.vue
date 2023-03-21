<template>
  <transition>
    <div class="image-container" v-show="states.visible" ref="elRef">
      <div class="image-control">
        <div class="image-control-body">
          <div class="image-info">
            {{ model.name }}
          </div>
          <div class="control-tool">
            <span @click="previous" :class="{ disabled: model.index <= 0 }">
              <svg
                viewBox="64 64 896 896"
                data-icon="left"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M724 218.3V141c0-6.7-7.7-10.4-12.9-6.3L260.3 486.8a31.86 31.86 0 0 0 0 50.3l450.8 352.1c5.3 4.1 12.9.4 12.9-6.3v-77.3c0-4.9-2.3-9.6-6.1-12.6l-360-281 360-281.1c3.8-3 6.1-7.7 6.1-12.6z"
                ></path>
              </svg>
            </span>
            <span
              @click="next"
              :class="{ disabled: model.index >= model.list.length - 1 }"
              ><svg
                viewBox="64 64 896 896"
                data-icon="right"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M765.7 486.8L314.9 134.7A7.97 7.97 0 0 0 302 141v77.3c0 4.9 2.3 9.6 6.1 12.6l360 281.1-360 281.1c-3.9 3-6.1 7.7-6.1 12.6V883c0 6.7 7.7 10.4 12.9 6.3l450.8-352.1a31.96 31.96 0 0 0 0-50.4z"
                ></path>
              </svg>
            </span>
            <span
              @click="reduce"
              :class="{ disabled: states.zoom < 0.6 || !props.allowZoom }"
              ><svg
                viewBox="64 64 896 896"
                data-icon="zoom-out"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M637 443H325c-4.4 0-8 3.6-8 8v60c0 4.4 3.6 8 8 8h312c4.4 0 8-3.6 8-8v-60c0-4.4-3.6-8-8-8zm284 424L775 721c122.1-148.9 113.6-369.5-26-509-148-148.1-388.4-148.1-537 0-148.1 148.6-148.1 389 0 537 139.5 139.6 360.1 148.1 509 26l146 146c3.2 2.8 8.3 2.8 11 0l43-43c2.8-2.7 2.8-7.8 0-11zM696 696c-118.8 118.7-311.2 118.7-430 0-118.7-118.8-118.7-311.2 0-430 118.8-118.7 311.2-118.7 430 0 118.7 118.8 118.7 311.2 0 430z"
                ></path>
              </svg>
            </span>
            <span
              @click="enlarge"
              :class="{ disabled: states.zoom > 1.4 || !props.allowZoom }"
              ><svg
                viewBox="64 64 896 896"
                data-icon="zoom-in"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M637 443H519V309c0-4.4-3.6-8-8-8h-60c-4.4 0-8 3.6-8 8v134H325c-4.4 0-8 3.6-8 8v60c0 4.4 3.6 8 8 8h118v134c0 4.4 3.6 8 8 8h60c4.4 0 8-3.6 8-8V519h118c4.4 0 8-3.6 8-8v-60c0-4.4-3.6-8-8-8zm284 424L775 721c122.1-148.9 113.6-369.5-26-509-148-148.1-388.4-148.1-537 0-148.1 148.6-148.1 389 0 537 139.5 139.6 360.1 148.1 509 26l146 146c3.2 2.8 8.3 2.8 11 0l43-43c2.8-2.7 2.8-7.8 0-11zM696 696c-118.8 118.7-311.2 118.7-430 0-118.7-118.8-118.7-311.2 0-430 118.8-118.7 311.2-118.7 430 0 118.7 118.8 118.7 311.2 0 430z"
                ></path>
              </svg>
            </span>
            <span @click="hide"
              ><svg
                viewBox="64 64 896 896"
                data-icon="close"
                width="1em"
                height="1em"
                fill="currentColor"
                aria-hidden="true"
                focusable="false"
                class=""
              >
                <path
                  d="M563.8 512l262.5-312.9c4.4-5.2.7-13.1-6.1-13.1h-79.8c-4.7 0-9.2 2.1-12.3 5.7L511.6 449.8 295.1 191.7c-3-3.6-7.5-5.7-12.3-5.7H203c-6.8 0-10.5 7.9-6.1 13.1L459.4 512 196.9 824.9A7.95 7.95 0 0 0 203 838h79.8c4.7 0 9.2-2.1 12.3-5.7l216.5-258.1 216.5 258.1c3 3.6 7.5 5.7 12.3 5.7h79.8c6.8 0 10.5-7.9 6.1-13.1L563.8 512z"
                ></path>
              </svg>
            </span>
          </div>
        </div>
      </div>
      <div class="image-body">
        <span v-show="states.isLoading" style="display: flex"
          >加载中...
          <div class="loading-icon"></div>
        </span>
        <img
          v-show="!states.isLoading"
          :src="model.src"
          :key="model.index"
          :alt="model.name"
          @load="handleImgLoad"
          :style="`zoom: ${states.zoom}`"
        />
      </div>
    </div>
  </transition>
</template>

<script setup>
import { nextTick, reactive, ref } from "vue";
const props = defineProps({
  allowZoom: {
    type: Boolean,
    default: true,
  },
});

const elRef = ref(null);

const handleImgLoad = () => {
  states.isLoading = false;
};

const states = reactive({
  visible: false,
  zoom: 1,
  isLoading: false,
});

const model = reactive({
  name: null,
  src: null,
  index: -1,
  list: [],
});
const resetModel = () => {
  model.index = -1;
  model.name = null;
  model.src = null;
};
const enlarge = () => {
  if (states.zoom <= 1.4) {
    states.zoom = +(states.zoom + 0.2).toFixed(2);
  }
};
const reduce = () => {
  if (states.zoom >= 0.6) {
    states.zoom = +(states.zoom - 0.2).toFixed(2);
  }
};

const next = () => {
  if (model.index >= model.list.length - 1) {
    return;
  }
  model.index += 1;
  readList();
};
const previous = () => {
  if (model.index <= 0) {
    return;
  }
  model.index -= 1;
  readList();
};

const readList = () => {
  const item = model.list[model.index];
  model.name = item.name;
  model.src = item.src;
  states.isLoading = true;
};

let bodyOverflow = null;

/**
 *
 * @param {String} name fileName or list
 * @param {String} src url or index of list
 */
const show = (name, src) => {
  bodyOverflow = document.body.style.overflow;
  states.visible = true;
  document.body.style.overflow = "hidden";

  resetModel();
  nextTick(() => {
    if (name instanceof Array) {
      model.index = src ?? 0;
      model.list = name;
      readList();
    } else {
      model.index = 0;
      model.name = name;
      model.src = src;
      model.zoom = 1;
      states.isLoading = true;
    }
    setTimeout(() => {
      elRef.value.querySelector(".image-control-body").classList.add("hide");
    }, 5000);
  });
};

const hide = () => {
  states.visible = false;
  document.body.style.overflow = bodyOverflow;

  elRef.value.querySelector(".image-control-body").classList.remove("hide");
};

defineExpose({
  show,
  hide,
});
</script>

<style scoped>
.image-container {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  display: block;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: 9999;
}

.image-control {
  position: absolute;
  bottom: 0px;
  padding: 40px 0;
  width: 100%;
  z-index: 1;
}

.image-control-body {
  width: 50%;
  padding: 2px 5px;
  font-size: 1.5rem;
  margin: auto;
  display: flex;
  background-color: #242424;
  color: rgb(188, 188, 188);
  border-radius: 10px;
  box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.5);
  opacity: 1;
  transition: all 0.5s;
}

.image-control-body.hide {
  opacity: 0.05;
}

.image-control:hover .image-control-body {
  opacity: 1 !important;
}

.image-info {
  flex: 1;
  text-align: center;
}

.control-tool {
  flex: 0 0 250px;
  display: flex;
}

.control-tool span {
  width: 20%;
  flex: 0 0 20%;
  text-align: center;
  cursor: pointer;
  padding-top: 2px;
}
.control-tool span:hover {
  color: #fff;
}

.control-tool span:not(.disabled):active {
  background: #000;
}

.control-tool span.disabled {
  color: gray;
  cursor: not-allowed;
}

.image-body {
  position: relative;
  text-align: center;
  overflow: auto;
  height: 100%;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.image-body > * {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.v-enter-active,
.v-leave-active {
  transition: opacity 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}

.loading-icon {
  width: 1em;
  height: 1em;
  border-radius: 50%;
  border: 2px solid #ccc;
  border-top-color: #333;
  animation: spin 0.8s linear infinite;
  margin-top: 2px;
}
</style>
