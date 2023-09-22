<script lang="ts" setup>
import { ref } from 'vue';
import EInput from '../components/input/EInput.vue';

const s1 = ref('abc');

const s2 = ref(0);

const model = ref({
    s1: 1
})

// s2非顶级不会自动解包
const obj = { s2: ref(3) }
</script>

<template>
    <div>
        <div>
            普通用法： {{ s1 }}
            <EInput v-model="s1"></EInput>
            {{  model.s1 }} - {{ obj.s2.value }}
        </div>

        <hr />

        <div>
            number:  {{ s2 }}
            <EInput type="number" v-model="s2"></EInput>
        </div>
    </div>
</template>