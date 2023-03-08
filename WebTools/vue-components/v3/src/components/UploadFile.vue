<template>
  <div :class="containerClass">
    <div :class="['up-container']">
      <input
        type="file"
        :disabled="disabled || state.isUploading"
        :accept="accept"
        :id="fileTag"
        @change="process"
        style="display: none"
        :multiple="multiple"
      />
      <span @click="showSelector">
        <slot>
          <button
            :class="['up-btn', defaultBtnClass]"
            :disabled="disabled || state.isUploading"
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
    uploader: Function,
    multiple: false,
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

  emits: ["uploaded"],

  methods: {
    showSelector() {
      document.getElementById(this.fileTag).click();
    },

    process(evt) {
      if (evt.target.files.length === 0) return;

      if (this.validator) {
        if (evt.target.files.some((x) => !this.validator(x))) return;
      }

      const selectedFiles = [...evt.target.files];

      var fd = new FormData();
      for (let index = 0; index < selectedFiles.length; index++) {
        const file = selectedFiles[index];
        fd.append("files", file, file.name);
      }

      this.state.isUploading = true;
      this.uploader({
        url: this.url,
        file: fd,
      })
        .then((res) => {
          this.$emit("uploaded", { ...res, files: selectedFiles });
          document.getElementById(this.fileTag).value = null;
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
  },
};
</script>
