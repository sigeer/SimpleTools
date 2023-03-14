import './Loading.css'
const reset = (el, binding) => {
  if (binding.value) {
    el.classList.add("loading");
  } else {
    el.classList.remove("loading");
  }
};

export default {
  mounted(el, binding) {
    const loading = document.createElement("div");
    loading.className = "loading-icon";
    el.appendChild(loading);

    el.classList.add("loading-up");
    reset(el, binding);
  },
  updated(el, binding) {
    reset(el, binding);
  },
};
