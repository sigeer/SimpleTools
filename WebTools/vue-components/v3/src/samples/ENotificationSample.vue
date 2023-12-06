<template>
    <button @click="show('error')">error</button>
    <button @click="show('info')">info</button>
    <button @click="show('warning')">warning</button>

    <button @click="showHtml()">warning</button>
    <button @click="config">设置背景色</button>
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
        htmlContent: '<button>123</button>，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？，内容很多会怎么样？',
        icon: type,
        style:{
            'background-color': '#fff'
        },
        time: -1
    })
}

const config = () => {
    notification.setGlobalStyle({'background-color': "#66ccff"});
}
</script>