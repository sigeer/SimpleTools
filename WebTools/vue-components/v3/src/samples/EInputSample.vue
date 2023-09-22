<script lang="ts" setup>
import { ref } from 'vue';
import EInput from '../components/input/EInput.vue';

const s1 = ref('abc');

const s2 = ref(0);
</script>

<template>
    <div>
        <div>
            普通用法： {{ s1 }}
            <EInput v-model="s1"></EInput>
        </div>

        <hr />

        <div>
            number:  {{ s2 }}
            <EInput type="number" v-model="s2"></EInput>
        </div>
    </div>
</template>