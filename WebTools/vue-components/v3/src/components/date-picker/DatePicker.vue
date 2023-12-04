<template>
  <div class="date-picker" ref="dRef">
    <input
      type="text"
      class="date-input"
      :value="selectedDate"
      @focus="showSelector"
      readonly
    />
    <div class="picker-container" v-show="showPicker" :style="panelStyle">
      <div class="picker-header">
        <span class="prev-month" @click="prevMonth">&lt;</span>
        <span class="current-month">{{ currentMonth }}</span>
        <span class="next-month" @click="nextMonth">&gt;</span>
      </div>
      <div class="picker-body">
        <div class="weekdays">
          <span v-for="day in daysOfWeek" :key="day">{{ day }}</span>
        </div>
        <div class="days">
          <span
            v-for="day in daysOfMonth"
            :key="day"
            :class="{
              today: isToday(day),
              selected: isSelected(day),
              inMonth: isInMonth(day),
            }"
            @click="selectDate(day)"
          >
            {{ day.getDate() }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import dayjs from "dayjs";
import { watch, computed, ref, onMounted } from "vue";

const props = defineProps({
  modelValue: {
    type: [Date, dayjs],
  },
});

const emits = defineEmits(["update:modelValue"]);

const selectedDate = ref("");
const showPicker = ref(false);

watch(
  () => props.modelValue,
  () => {
    if (selectedDate.value !== dayjs(props.modelValue).format("YYYY-MM-DD")) {
      selectedDate.value = dayjs(props.modelValue).format("YYYY-MM-DD");
    }
  }
);

onMounted(() => {
  document.body.addEventListener("click", (e) => {
    if (!dRef.value.contains(e.target)) {
      showPicker.value = false;
    }
  });
});

// 计算选中日期所在的月份和年份
const selectedMonth = computed(() => {
  return selectedDate.value
    ? new Date(selectedDate.value).getMonth()
    : new Date().getMonth();
});
const selectedYear = computed(() => {
  return selectedDate.value
    ? new Date(selectedDate.value).getFullYear()
    : new Date().getFullYear();
});

// 计算当前月份的日期数组
const daysOfMonth = computed(() => {
  const days = [];
  let firstDayOfMonth = new Date(
    selectedYear.value,
    selectedMonth.value,
    1
  ).getDay();
  firstDayOfMonth = (firstDayOfMonth === 0 ? 7 : firstDayOfMonth) - 1;

  for (let j = 0; j < firstDayOfMonth; j++) {
    days.push(
      new Date(selectedYear.value, selectedMonth.value, j - firstDayOfMonth + 1)
    );
  }

  for (let m = 0; m < 6; m++) {
    for (let n = 0; n < 7; n++) {
      days.push(
        new Date(selectedYear.value, selectedMonth.value, m * 7 + n + 1)
      );
    }
  }

  days.splice(days.length - firstDayOfMonth, firstDayOfMonth);

  return days;
});

// 计算当前月份的字符串表示
const currentMonth = computed(() => {
  const months = Array.from({ length: 12 }, (_, index) => index + 1);
  return `${selectedYear.value} - ${months[selectedMonth.value]}`;
});

const dRef = ref();
const getBottomDistance = () => {
  const rect = dRef.value.getBoundingClientRect();

  return window.innerHeight - rect.bottom;
};
const panelStyle = ref({});
const showSelector = () => {
  const dis = getBottomDistance();
  if (dis < 200) {
    panelStyle.value = { bottom: "100%" };
  } else {
    panelStyle.value = { top: "100%" };
  }
  showPicker.value = true;
};

// 选中日期并隐藏日期选择器
const selectDate = (date) => {
  selectedDate.value = dayjs(date).format("YYYY-MM-DD");
  emits("update:modelValue", date);
  showPicker.value = false;
};

// 判断日期是否为今天
const isToday = (date) => {
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
};

const isInMonth = (date) => {
  return date.getMonth() === selectedMonth.value;
};

// 判断日期是否被选中
const isSelected = (date) => {
  if (!selectedDate.value) {
    return false;
  }
  return dayjs(date).format("YYYY-MM-DD") === selectedDate.value;
};

// 上一个月
const prevMonth = () => {
  if (selectedMonth.value === 0) {
    selectedDate.value = `${selectedYear.value - 1}-12-01`;
  } else {
    selectedDate.value = `${selectedYear.value}-${selectedMonth.value
      .toString()
      .padStart(2, "0")}-01`;
  }
};

// 下一个月
const nextMonth = () => {
  if (selectedMonth.value === 11) {
    selectedDate.value = `${selectedYear.value + 1}-01-01`;
  } else {
    selectedDate.value = `${selectedYear.value}-${(selectedMonth.value + 2)
      .toString()
      .padStart(2, "0")}-01`;
  }
};

// 一周的天数
const daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"];
</script>

<style lang="less" scoped>
.date-picker {
  position: relative;
  display: inline-block;
}

.date-input {
  border: 1px solid #ccc;
  border-radius: 3px;
  padding: 5px;
  font-size: 16px;
  width: 200px;
  cursor: pointer;
  outline: none;
}

.picker-container {
  position: absolute;
  left: 0;
  z-index: 10;
  background-color: #fff;
  border: 1px solid #ccc;
  border-top: none;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.picker-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f0f0f0;
}

.picker-body {
  display: flex;
  flex-direction: column;
}

.weekdays {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 5px;
  font-weight: bold;
  text-align: center;

  span {
    width: 30px;
  }
}

.days {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 5px;
  padding: 5px;
  text-align: center;

  span {
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;

    &:hover {
      background-color: #e4e4e4;
    }

    &.selected,
    &:active {
      background-color: #ccc;
    }

    &:not(.inMonth) {
      opacity: 0.6;
    }
  }
}

.days span.today {
  font-weight: bold;
}
.prev-month,
.next-month {
  cursor: pointer;
  padding: 4px 8px;
  &:hover {
    background-color: #ccc;
  }
}
</style>
