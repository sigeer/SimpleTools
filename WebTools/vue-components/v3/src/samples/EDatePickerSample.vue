<template>
    <DatePicker v-model="model"></DatePicker>
    {{ model }}
</template>

<script setup>
import { ref } from 'vue';
import DatePicker from '../components/date-picker';

const model = ref();
</script>