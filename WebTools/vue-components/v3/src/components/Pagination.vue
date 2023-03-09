<template>
  <div class="center-row -bs">
    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
      <div aria-live="polite">
        显示第 {{ pageSize * (pageIndex - 1) + 1 }} 条到
        {{ pageSize * pageIndex }} 条数据，共 {{ total }} 条数据
        <a
          :class="[
            'cursor-pointer pagination-option',
            pageSize === size ? 'high-light' : '',
          ]"
          v-for="(size, index) in deaultSizeList"
          :key="index"
          @click="setSize(size)"
          >{{ size }}</a
        >
      </div>
    </div>
    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
      <div>
        <ul class="pagination page-ctrl-container">
          <li :class="{ disabled: pageIndex <= 1 }">
            <a href="javascript:;" @click="previous()" title="上一页"
              ><span class="glyphicon glyphicon-chevron-left"></span
            ></a>
          </li>
          <li>
            <input
              v-model="preIndex"
              @blur="jumpTo"
              @keyup.enter="jumpTo"
              class="page-numer-input"
            />
          </li>
          <li :class="{ disabled: pageIndex >= maxSize }">
            <a href="javascript:;" @click="next()">
              <span
                class="glyphicon glyphicon-chevron-right"
                title="下一页"
              ></span>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
const deaultSizeList = [10, 20, 50, 100, "全部"];
export default {
  props: {
    total: Number,
  },

  data() {
    return {
      preIndex: 1,
      pageIndex: 1,
      pageSize: 20,
      deaultSizeList,
    };
  },

  emits: ['loaded'],

  watch: {
    pageIndex() {
      this.$emit("loaded", this.paginationModel);
    },

    pageSize() {
      this.$emit("loaded", this.paginationModel);
    },
  },

  computed: {
    maxSize() {
      return parseInt(this.total / (this.pageSize + 1)) + 1;
    },

    paginationModel() {
      return {
        pageIndex: this.pageIndex,
        pageSize: this.pageSize,
      };
    },
  },

  methods: {
    next() {
      if (this.pageIndex >= this.maxSize) return;
      this.pageIndex++;
    },

    previous() {
      if (this.pageIndex <= 1) return;
      this.pageIndex--;
    },

    jumpTo(n) {
      if (this.preIndex > this.maxSize || this.preIndex < 1)
        this.preIndex = this.pageIndex;
      else this.pageIndex = this.preIndex;
    },

    setSize(size) {
      this.pageSize = size;
    },
  },
};
</script>

<style scoped>
.page-ctrl-container {
  margin: 0;
  display: flex;
  float: right;
}

.page-numer-input {
  border: 1px solid #ddd;
  width: 40px;
  height: 34px;
  text-align: center;
  margin-left: -1px;
}

.cursor-pointer {
  cursor: pointer;
}
</style>
