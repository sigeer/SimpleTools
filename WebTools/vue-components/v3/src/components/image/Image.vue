<template>
  <img :src="formatUrl" v-bind="$attrs" />
</template>

<script setup>
import { computed, getCurrentInstance, inject, ref, watch } from "vue";

const srcLocal = ref(props.defaultImage);

const props = defineProps({
  defaultImage: {
    type: String,
  },

  src: {
    type: String,
    required: true,
  },

  width: {
    type: Number,
  },

  height: {
    type: Number,
  },

  quality: {
    type: Number,
    default: 1,
  },

  useDefault: {
    type: Boolean,
    default: true,
  },
});

watch(
  () => props.src,
  () => {
    srcLocal.value = props.src;
  },
  {
    deep: true,
    immediate: true,
  }
);

const formatUrl = computed(() => {
  if (srcLocal.value === props.defaultImage) {
    return props.defaultImage;
  }
  let b = {};
  if (props.quality > 0 && props.quality < 1) b.quality = props.quality;
  if (props.width && props.width > 0) b.width = props.width;
  if (props.height && props.height > 0) b.height = props.height;

  const final = setFormatUrl(srcLocal.value, b, props.useDefault);
  if (!final) return null;
  checkImage(final);
  return final;
});

const setFormatUrl = (url, processObj, useDefault = true) => {
  if (!url) {
    return useDefault ? props.defaultImage : null;
  }
  let totalUrl = getTotalCDNUrl(url);
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
    if (queryParams.length > 0) totalUrl += "@" + queryParams.join("_");
  }
  return totalUrl;
};

const app = getCurrentInstance();
const cdnUrl = inject("cdnUrl");
const getTotalCDNUrl = (url) => {
  if (!url) return null;

  if (url.startsWith("http")) {
    return url;
  } else {
    const fUrl = cdnUrl
      ? cdnUrl
      : app.appContext.config.globalProperties.cdnUrl;
    return (
      fUrl.trimEnd().replace(/\/+$/, "") +
      "/" +
      url.trimStart().replace(/^\/+/, "")
    );
  }
};

const checkImage = (url) => {
  return new Promise((resolve, reject) => {
    let imgObj = new Image();
    imgObj.src = url;
    imgObj.onload = (res) => {
      resolve(res);
    };
    imgObj.onerror = (err) => {
      if (srcLocal.value !== props.defaultImage)
        srcLocal.value = props.defaultImage;
    };
  });
};
</script>
