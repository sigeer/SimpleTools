<template>
  <img :src="formatUrl" />
</template>

<script>
const defaultImg = "/logo.png";
export default {
  props: {
    src: {
      type: String,
      default: defaultImg,
    },

    width: Number,

    height: Number,

    quality: 1,

    useDefault: true,
  },

  data() {
    return {
      srcLocal: defaultImg,
    };
  },

  watch: {
    src: {
      deep: true,
      immediate: true,
      handler() {
        this.srcLocal = this.src;
      },
    },
  },

  computed: {
    formatUrl() {
      if (this.srcLocal === defaultImg) return this.srcLocal;
      let obj = {};
      if (this.quality && this.quality > 0 && this.quality < 1) {
        obj.quality = this.quality;
      }
      if (this.width && this.width > 0) {
        obj.width = this.width;
      }
      if (this.height && this.height > 0) {
        obj.height = this.height;
      }

      const final = this.formatCDN(this.srcLocal, obj, this.useDefault);
      if (!final) return null;
      this.checkImg(final);
      return final;
    },
  },

  methods: {
    formatCDN(url, processObj, useDefault = true) {
      if (!url) {
        return useDefault ? defaultImg : null;
      }
      let totalUrl = this.getTotalCDNUrl(url);
      if (processObj) {
        let queryParams = [];
        if (processObj.width) {
          queryParams.push("w" + processObj.width);
        }
        if (processObj.height) {
          queryParams.push("h" + processObj.height);
        }
        if (processObj.quality) {
          queryParams.push("q" + processObj.quality);
        }
        totalUrl += "@" + queryParams.join("_");
      }
      return totalUrl;
    },

    getTotalCDNUrl(url) {
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
      } else {
        return (
          process.env.VUE_APP_Upload_BASE_URL.trimEnd().replace(/\/+$/, "") +
          "/" +
          url.trimStart().replace(/^\/+/, "")
        );
      }
    },

    checkImg(url) {
      return new Promise((resolve, reject) => {
        let imgObj = new Image();
        imgObj.src = url;
        imgObj.onload = (res) => {
          console.log(res);
          resolve(res);
        };
        imgObj.onerror = (err) => {
          if (this.srcLocal !== defaultImg) this.srcLocal = defaultImg;
        };
      });
    },

    onError() {
      this.srcLocal = defaultImg;
    },
  },
};
</script>
