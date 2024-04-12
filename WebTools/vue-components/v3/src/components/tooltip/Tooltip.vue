<script>
import { h, onMounted, ref, render, watch } from "vue";

export default {
  props: {
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
  },
  setup(props, { slots, ctx }) {
    const dRef = ref();

    const setLocation = (setShow) => {
      const containerEl = getTooltipContainerEle();
      const rect = dRef.value.getBoundingClientRect();
      const contentRect = containerEl.getBoundingClientRect();

      const centerX = rect.left + rect.width / 2;
      let styleStr = "";
      if (
        document.documentElement.scrollHeight - dRef.value.offsetTop - rect.height <
          contentRect.height + 16
      ) {
        containerEl.classList.remove("bottom");
        containerEl.classList.add("top");
        styleStr = `top: ${dRef.value.offsetTop - rect.height - contentRect.height + 8}px;`;
      } else {
        containerEl.classList.remove("top");
        containerEl.classList.add("bottom");
        styleStr = `top: ${window.scrollY + rect.top + rect.height + 8}px;`;
      }


      if (contentRect.width / 2 >= centerX) {
        styleStr += `left: 16px;`;
        const afterStyle = containerEl.querySelector(".tooltip-content-arrow");
        afterStyle.setAttribute("style", `left: ${centerX - 20}px`);
      } else {
        styleStr += `left: ${centerX}px; transform: translateX(-50%)`;
      }
      containerEl.setAttribute("style", styleStr);
      setShow && containerEl.classList.add("visible");
    };
    watch(
      () => props.content,
      () => {
        appendTooltipHtml(props.content);
      }
    );
    let container = document.createElement("div");

    const appendTooltipHtml = (content) => {
      if (document.body.contains(container))
        document.body.removeChild(container);

      if (!content) return;

      const vNode = h(
        "span",
        {
          class: "tooltip-content",
        },
        [h("span", { class: "tooltip-content-arrow" }), content]
      );
      render(vNode, container);
      document.body.append(container);

      setLocation();
    };
    const getTooltipContainerEle = () =>
      container.querySelector(`.tooltip-content`);
    let timeoutId;
    const triggerEvent = () => {
      const el = getTooltipContainerEle();
      if (props.trigger === "hover") {
        dRef.value.addEventListener("mouseenter", (evt) => {
          clearTimeout(timeoutId);
          setLocation(true);
        });

        dRef.value.addEventListener("mouseleave", (evt) => {
          timeoutId = setTimeout(() => {
            getTooltipContainerEle().classList.remove("visible");
          }, 200);
        });

        el.addEventListener("mouseenter", (evt) => {
          clearTimeout(timeoutId);
        });

        el.addEventListener("mouseleave", (evt) => {
          timeoutId = setTimeout(() => {
            const tooltipContentEle = getTooltipContainerEle();
            if (tooltipContentEle)
              tooltipContentEle.classList.remove("visible");
          }, 200);
        });
      } else if (props.trigger === "click") {
        dRef.value.addEventListener("click", (evt) => {
          setLocation(true);
        });

        document.addEventListener("click", (evt) => {
          const tooltipContentEle = getTooltipContainerEle();
          if (tooltipContentEle) {
            if (
              !dRef.value.contains(evt.target) &&
              !tooltipContentEle.contains(evt.target)
            ) {
              tooltipContentEle.classList.remove("visible");
            }
          }
        });
      }
    };
    onMounted(() => {
      appendTooltipHtml(props.content);
      triggerEvent();
    });
    const [defaultSlot] = slots.default();
    return () => h(defaultSlot, { ref: dRef });
  },
};
</script>

<style lang="less">
.tooltip-content.bottom > .tooltip-content-arrow {
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-bottom: 7px solid black;
  bottom: 100%;
  position: absolute;
  left: calc(50% - 5px);
  z-index: 998;
}

.tooltip-content.top > .tooltip-content-arrow {
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 7px solid black;
  bottom: -8px;
  position: absolute;
  left: calc(50% - 5px);
  z-index: 998;
}

.tooltip-content {
  background-color: #000;
  color: #fff;
  position: absolute;
  max-width: 450px;
  word-wrap: break-word;
  left: 50%;
  top: 0;
  opacity: 0;
  padding: 2px 4px;
  border-radius: 6px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5), 0 0 0 2px #000;
  z-index: 998;
  transition: ease-out 0.3s;

  &.visible {
    opacity: 1;
  }
}
</style>
