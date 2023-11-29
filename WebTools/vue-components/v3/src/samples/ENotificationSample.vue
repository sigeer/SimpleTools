<template>
    <button @click="show">notfication</button>
</template>

<script setup>
import useNotification from '../components/notification/useNotification';
const notification = useNotification();

const show = () => {
    notification.show({
        title: '这是title',
        description: '这是description',
        time: -1,
        icon: 'warning'
    })
}
</script>