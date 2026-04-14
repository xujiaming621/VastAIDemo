<template>
  <footer class="app-footer">
    <div class="footer-inner">
      <div class="footer-brand">
        <div class="footer-logo">
          <img :src="haiLiangLogo" alt="海量" class="footer-logo-img" />
        </div>
        <div>
          <div class="footer-name">智能数据库管理平台</div>
          <div class="footer-sub">VastBase AI · 一站式智能数据库全生命周期管理</div>
        </div>
      </div>
      <div class="footer-copy">© 2026 VastBase AI. All rights reserved.</div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import haiLiangLogo from '@/assets/images/海量.png'
</script>

<style scoped>
.app-footer {
  background: white;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
  margin-top: 48px;
}

.footer-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.footer-brand {
  display: flex;
  align-items: center;
  gap: 10px;
}

.footer-logo {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.footer-logo-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.footer-name {
  font-size: 14px;
  font-weight: 600;
  color: #1D2129;
}

.footer-sub {
  font-size: 12px;
  color: #86909C;
  margin-top: 1px;
}

.footer-copy {
  font-size: 12px;
  color: #86909C;
}
</style>
