<template>
  <div class="think-block" :class="{ streaming }">
    <button class="think-header" @click="expanded = !expanded">
      <span class="think-label">{{ streaming ? '深度思考中...' : '已深度思考' }}</span>
      <i class="fa think-chevron" :class="expanded ? 'fa-chevron-up' : 'fa-chevron-down'" />
    </button>
    <transition name="think-expand">
      <div v-if="expanded" class="think-body">
        <div class="think-content">{{ content }}</div>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{ content: string; streaming?: boolean }>()
const expanded = ref(!!props.streaming)

watch(() => props.streaming, (val, prev) => {
  if (prev === true && val === false) expanded.value = false
})
</script>

<style scoped>
.think-block {
  border-radius: 10px;
  overflow: hidden;
  background: rgba(114, 46, 209, 0.04);
  border: 1px solid rgba(114, 46, 209, 0.12);
  transition: border-color 0.2s;
}

.think-block.streaming {
  border-color: rgba(114, 46, 209, 0.2);
  background: rgba(114, 46, 209, 0.06);
}

.think-header {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  user-select: none;
  padding: 8px 12px;
  background: none;
  border: none;
  text-align: left;
}

.think-icon-wrap {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  background: rgba(114, 46, 209, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #722ED1;
  font-size: 11px;
  flex-shrink: 0;
}

.think-label {
  font-size: 12px;
  font-weight: 600;
  color: #722ED1;
  flex: 1;
}

.think-chevron {
  font-size: 10px;
  color: #9ca3af;
  transition: transform 0.2s;
}

.think-body {
  border-top: 1px solid rgba(114, 46, 209, 0.1);
  padding: 10px 12px;
}

.think-content {
  font-size: 12px;
  line-height: 1.65;
  color: #6b7280;
  white-space: pre-wrap;
  word-break: break-word;
}

/* Transition */
.think-expand-enter-active,
.think-expand-leave-active {
  transition: all 0.2s ease;
  overflow: hidden;
}
.think-expand-enter-from,
.think-expand-leave-to {
  max-height: 0;
  opacity: 0;
}
.think-expand-enter-to,
.think-expand-leave-from {
  max-height: 600px;
  opacity: 1;
}
</style>
