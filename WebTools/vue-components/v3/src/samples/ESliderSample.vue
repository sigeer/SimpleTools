<template>
    <Slider v-model:rate="rate" style="margin-bottom: 24px;"></Slider>
    <RangeSlider v-model:range="range"></RangeSlider>
    {{ rate }} - {{ range }}
</template>

<script setup>
import { ref } from 'vue';
import Slider from '../components/slider';
import RangeSlider from '../components/range-slider/RangeSlider.vue';

const rate = ref(20)
const range = ref([0, 30]);
</script>