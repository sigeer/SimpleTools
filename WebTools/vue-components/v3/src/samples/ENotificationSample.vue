<template>
    <button @click="show('error')">error</button>
    <button @click="show('info')">info</button>
    <button @click="show('warning')">warning</button>

    <button @click="showHtml()">warning</button>
</template>

<script setup>
import useNotification from '../components/notification/useNotification';
const notification = useNotification();

const show = (type) => {
    notification.show({
        title: '这是title',
        description: '这是description',
        icon: type
    })
}

const showHtml = (type) => {
    notification.show({
        title: '这是title',
        htmlContent: '<button>123</button>',
        icon: type
    })
}
</script>