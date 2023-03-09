<template>
  <div :class="containerClass">
    <div :class="['up-container']">
      <input
        type="file"
        :disabled="disabled || isLoading"
        :accept="accept"
        @change="process"
        style="display: none"
        :multiple="multiple"
        ref="fileInput"
      />
      <span @click="showSelector">
        <slot>
          <button
            :class="['up-btn', defaultBtnClass]"
            :disabled="disabled || isLoading"
          >
            选择文件
          </button>
        </slot>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    disabled: false,
    accept: String,
    classNames: String,
    containerClass: String,
    defaultBtnClass: String,
    validator: Function,
    multiple: false,
    isLoading: false,
  },

  emits: ["selected"],

  methods: {
    showSelector() {
      this.$refs.fileInput.click();
    },

    process(evt) {
      if (evt.target.files.length === 0) return;

      if (this.validator) {
        if (evt.target.files.some((x) => !this.validator(x))) {
          this.$refs.fileInput.value = null;  
          return;
        }
      }

      const selectedFiles = [...evt.target.files];
      this.$emit("selected", { files: selectedFiles });
      this.$refs.fileInput.value = null;
    },
  },
};
</script>
