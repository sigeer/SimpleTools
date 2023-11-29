import { getCurrentInstance, ref, createApp } from "vue";
import Notification from ".";
export default function useNotification() {

  const componentRef = ref(); // 组件实例的引用

  function addComponent() {
    if (!componentRef.value) {
      const app = createApp(Notification);
      // 如果子组件还未被挂载，先进行挂载操作
      const container = document.createElement('div');
      document.body.appendChild(container);
      componentRef.value = app.mount(container);
    }
  }

  const show = (item) => {
    addComponent();
    componentRef.value.push(item);
  };

  return { show };
}
