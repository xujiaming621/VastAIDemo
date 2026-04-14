<template>
  <div class="workflow-panel">
    <button class="workflow-header" @click="expanded = !expanded">
      <span class="status-dot" :class="running ? 'running' : 'done'" />
      <span class="workflow-label">{{ running ? '工作流执行中' : '工作流已完成' }}</span>
      <span class="node-count">{{ nodes.length }} 个节点</span>
      <i class="fa chevron" :class="expanded ? 'fa-chevron-up' : 'fa-chevron-down'" />
    </button>
    <transition name="wf-expand">
      <div v-if="expanded" class="workflow-nodes">
        <div v-for="(node, idx) in nodes" :key="node.nodeId" class="workflow-node">
          <div class="node-line" v-if="idx < nodes.length - 1" />
          <div class="node-info">
            <span class="node-title">{{ node.title }}</span>
            <span class="node-meta" v-if="node.elapsedTime || node.totalTokens">
              <template v-if="node.totalTokens">{{ formatTokens(node.totalTokens) }} tokens</template>
              <template v-if="node.totalTokens && node.elapsedTime"> · </template>
              <template v-if="node.elapsedTime">{{ formatTime(node.elapsedTime) }}</template>
            </span>
          </div>
          <div class="node-status" :class="node.status">
            <i v-if="node.status === 'running'" class="fa fa-spinner fa-spin" />
            <i v-else-if="node.status === 'succeeded'" class="fa fa-check" />
            <i v-else class="fa fa-times" />
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { WorkflowNode } from '@/types'

defineProps<{ nodes: WorkflowNode[]; running: boolean }>()
const expanded = ref(false)

function nodeIcon(type: string) {
  const map: Record<string, string> = {
    start: 'fa-play', agent: 'fa-android', answer: 'fa-comment',
    llm: 'fa-bolt', tool: 'fa-wrench',
  }
  return map[type] || 'fa-circle'
}

function nodeIconClass(type: string) {
  const map: Record<string, string> = {
    start: 'ni-start', agent: 'ni-agent', answer: 'ni-answer', llm: 'ni-llm',
  }
  return map[type] || 'ni-default'
}

function formatTokens(n: number) {
  return n >= 1000 ? (n / 1000).toFixed(1) + 'K' : String(n)
}

function formatTime(s: number) {
  if (s < 0.001) return `${(s * 1000000).toFixed(0)}μs`
  if (s < 1) return `${(s * 1000).toFixed(0)}ms`
  return `${s.toFixed(2)}s`
}
</script>

<style scoped>
.workflow-panel {
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #d1fae5;
  background: #f0fdf4;
  font-size: 13px;
}

.workflow-header {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 9px 12px;
  cursor: pointer;
  user-select: none;
  background: none;
  border: none;
  text-align: left;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.status-dot.done { background: #10b981; }
.status-dot.running {
  background: #3b82f6;
  animation: pulse 1.2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; box-shadow: 0 0 0 0 rgba(59,130,246,0.4); }
  50% { opacity: 0.7; box-shadow: 0 0 0 4px rgba(59,130,246,0); }
}

.workflow-label {
  font-size: 12px;
  font-weight: 600;
  color: #065f46;
  flex: 1;
}

.node-count {
  font-size: 11px;
  color: #6b7280;
  background: rgba(0,0,0,0.05);
  padding: 1px 7px;
  border-radius: 100px;
}

.chevron {
  font-size: 10px;
  color: #9ca3af;
}

.workflow-nodes {
  padding: 4px 10px 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.workflow-node {
  position: relative;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 10px;
  background: white;
  border-radius: 9px;
  border: 1px solid rgba(0,0,0,0.06);
}

.node-line {
  display: none;
}

.node-icon-wrap {
  width: 26px;
  height: 26px;
  border-radius: 7px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  flex-shrink: 0;
}

.ni-start { background: #dbeafe; color: #2563eb; }
.ni-agent { background: #ede9fe; color: #7c3aed; }
.ni-answer { background: #fef3c7; color: #d97706; }
.ni-llm { background: #fce7f3; color: #db2777; }
.ni-default { background: #f3f4f6; color: #6b7280; }

.node-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.node-title {
  font-size: 12px;
  font-weight: 600;
  color: #374151;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.node-meta {
  font-size: 11px;
  color: #9ca3af;
}

.node-status {
  font-size: 13px;
  flex-shrink: 0;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
}

.node-status.succeeded { background: #d1fae5; color: #10b981; }
.node-status.failed { background: #fee2e2; color: #ef4444; }
.node-status.running { background: #dbeafe; color: #3b82f6; }

/* Transition */
.wf-expand-enter-active,
.wf-expand-leave-active {
  transition: all 0.2s ease;
  overflow: hidden;
}
.wf-expand-enter-from,
.wf-expand-leave-to { max-height: 0; opacity: 0; }
.wf-expand-enter-to,
.wf-expand-leave-from { max-height: 800px; opacity: 1; }
</style>
