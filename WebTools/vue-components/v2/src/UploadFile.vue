<template>
  <div>
    <div :class="['up-container', containerClass]">
      <input
        type="file"
        :disabled="disabled || state.isUploading"
        :accept="accept"
        :id="fileTag"
        @change="_process"
      />
      <slot>
        <button
          @click="_showSelector"
          :class="['up-btn', innerClass]"
          :disabled="disabled || state.isUploading"
        >
          选择文件
        </button>
      </slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    disabled: false,
    accept: {
      type: String,
      default: "image/*,application/pdf",
    },
    classNames: String,
    containerClass: String,
    innerClass: String,
    validator: Function,
    uploader: Function,
  },

  data() {
    return {
      fileTag: this.guid(),

      state: {
        isUploading: false,
      },
    };
  },

  mounted() {
    this.fileTag = this.guid();
  },

  methods: {
    _showSelector() {
      document.getElementById(this.fileTag).click();
    },

    _process(evt) {
      const file = evt.file;
      if (!file) return;

      if (this.validator && !this.validator(file)) return;

      this.state.isUploading = true;
      var fd = new FormData();
      fd.append("file", file);
      this.uploader({
        url: this.url,
        file: fd,
      })
        .then((res) => {
          if (res.status === "Success")
            this.$emit("uploaded", { ...res.data, fileStream: file });
          console.log({ ...res.data, fileStream: file });
        })
        .finally(() => {
          this.state.isUploading = false;
        });
    },

    guid() {
      const S4 = () => {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
      };
      return (
        S4() +
        S4() +
        "-" +
        S4() +
        "-" +
        S4() +
        "-" +
        S4() +
        "-" +
        S4() +
        S4() +
        S4()
      );
    },

    triggerFileSelector() {
      document.getElementById;
    },
  },
};
</script>

<style lang="less">
.block {
  & > .ant-upload.ant-upload-select {
    width: 100%;
    display: block;
  }
}
</style>
