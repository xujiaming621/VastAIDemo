<template>
  <header class="app-header">
    <div class="header-inner">
      <router-link to="/" class="brand">
        <div class="brand-icon">
          <img src="/海量.png" alt="logo" class="brand-logo-img" />
        </div>
        <div class="brand-text">
          <span class="brand-name">智能数据库管理平台</span>
          <span class="brand-sub">VastBase AI</span>
        </div>
      </router-link>

      <nav class="nav-desktop">
        <router-link
          v-for="item in navItems"
          :key="item.route"
          :to="item.route"
          class="nav-item"
          :class="{ active: isActive(item.route) }"
        >
          <i class="fa" :class="item.icon"></i>
          <span>{{ item.label }}</span>
        </router-link>
      </nav>

      <button class="mobile-menu-btn" @click="showMobile = !showMobile" aria-label="菜单">
        <i class="fa" :class="showMobile ? 'fa-times' : 'fa-bars'"></i>
      </button>
    </div>
  </header>

  <div v-if="showMobile" class="mobile-nav">
    <router-link
      v-for="item in navItems"
      :key="item.route"
      :to="item.route"
      class="mobile-nav-item"
      :class="{ active: isActive(item.route) }"
      @click="showMobile = false"
    >
      <i class="fa" :class="item.icon"></i>
      <span>{{ item.label }}</span>
    </router-link>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const showMobile = ref(false)

const navItems = [
  { label: '智能评估', route: '/install', icon: 'fa-cogs' },
  { label: '智能迁移', route: '/migrate', icon: 'fa-exchange' },
  { label: '报错答疑', route: '/support', icon: 'fa-comments' },
  { label: '运维监控', route: '/monitor', icon: 'fa-line-chart' },
]

function isActive(path: string): boolean {
  return route.path === path || route.path.startsWith(path + '/')
}
</script>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 50;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(22, 93, 255, 0.08);
  box-shadow: 0 1px 20px rgba(0, 0, 0, 0.06);
}

.header-inner {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 40px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 32px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
  flex-shrink: 0;
}

.brand-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  flex-shrink: 0;
}

.brand-logo-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.brand-text {
  display: flex;
  flex-direction: column;
  line-height: 1.2;
}

.brand-name {
  font-size: 15px;
  font-weight: 700;
  color: #1D2129;
  letter-spacing: -0.2px;
}

.brand-sub {
  font-size: 11px;
  color: #165DFF;
  font-weight: 500;
  opacity: 0.8;
}

.nav-desktop {
  display: flex;
  align-items: center;
  gap: 4px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 8px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  color: #4E5969;
  text-decoration: none;
  transition: all 0.2s;
  white-space: nowrap;
}

.nav-item i {
  font-size: 13px;
  opacity: 0.7;
}

.nav-item:hover {
  background: #F2F6FF;
  color: #165DFF;
}

.nav-item:hover i {
  opacity: 1;
}

.nav-item.active {
  background: linear-gradient(135deg, #165DFF, #4080FF);
  color: white;
  box-shadow: 0 4px 12px rgba(22, 93, 255, 0.25);
}

.nav-item.active i {
  opacity: 1;
}

.mobile-menu-btn {
  display: none;
  background: none;
  border: none;
  padding: 8px;
  cursor: pointer;
  color: #165DFF;
  font-size: 18px;
  border-radius: 8px;
  transition: background 0.2s;
}

.mobile-menu-btn:hover {
  background: #F2F6FF;
}

.mobile-nav {
  background: white;
  border-bottom: 1px solid #e5e7eb;
  padding: 8px 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 2px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.mobile-nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  color: #4E5969;
  text-decoration: none;
  transition: all 0.2s;
}

.mobile-nav-item.active {
  background: #F2F6FF;
  color: #165DFF;
}

@media (max-width: 768px) {
  .nav-desktop {
    display: none;
  }

  .mobile-menu-btn {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .brand-sub {
    display: none;
  }
}
</style>
