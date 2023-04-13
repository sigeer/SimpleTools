export default {
  mounted(el, binding) {
    let startX = 0,
      startY = 0,
      x = 0,
      y = 0;
    el.style.position = "relative";
    el.style.cursor = "move";

    const mousemove = (event) => {
      y = event.pageY - startY;
      x = event.pageX - startX;
    
      el.style.top = y + "px";
      el.style.left = x + "px";
    };

    const mouseup = () => {
      document.removeEventListener("mousemove", mousemove);
      document.removeEventListener("mouseup", mouseup);
    };
    el.addEventListener("mousedown", (e) => {
      e.preventDefault();
      startX = e.pageX - x;
      startY = e.pageY - y;

      document.addEventListener("mousemove", mousemove);
      document.addEventListener("mouseup", mouseup);
    });
  },
};
