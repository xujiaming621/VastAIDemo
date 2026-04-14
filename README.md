# VastAIDemo

Vastbase 智能数据库管理平台 — 一站式数据库全生命周期 AI 管理解决方案。

## 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Vue 3.5 + TypeScript |
| 构建 | Vite 6 |
| 路由 | Vue Router 4.5 |
| 状态管理 | Pinia 3 |
| 样式 | TailwindCSS 3.4 |
| 图表 | Chart.js 4.4 |
| Markdown | marked.js |
| 图标 | Font Awesome 4.7 |
| 后端 | Node.js（API 代理 + Dify SSE 流式对话） |

## 功能模块

| 路由 | 页面 | 说明 |
|------|------|------|
| `/` | HomePage | 平台首页，功能入口总览 |
| `/install` | InstallPage | 智能评估 — 数据库迁移评估与报告生成 |
| `/migrate` | MigratePage | 智能迁移 — 全量/增量数据迁移与校验 |
| `/chat` | SupportChatPage | AI 智能对话 — 量仔助手实时问答 |
| `/monitor` | MonitorPage | 运维监控 — 实时性能与告警 |

> `/support` 路由自动重定向到 `/chat`。

## 快速开始

### 环境要求

- Node.js ≥ 18
- pnpm（推荐）或 npm

### 安装依赖

```bash
pnpm install
```

### 开发模式

```bash
pnpm dev
```

启动后访问 http://localhost:3000，Vite 自动热更新。

> 开发模式下 `/api` 请求自动代理到 `http://127.0.0.1:8081`，需同时启动后端。

### 生产构建

```bash
pnpm build
```

输出到 `dist/` 目录。

### 启动后端服务

```bash
node server.js
```

从 `dist/` 目录提供静态文件（SPA 回退），同时代理 Dify API 请求，默认端口 8081。

### 环境变量

复制 `.env.example` 为 `.env` 并填写：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `PORT` | 后端服务端口 | `8081` |
| `PUBLIC_PORT` | 对外访问端口（反向代理场景） | 同 `PORT` |
| `LOCAL_IP` | 服务器 IP 或域名 | `localhost` |
| `DIFY_API_BASE` | Dify API 地址 | — |
| `DIFY_API_KEY` | Dify API 密钥（必填） | — |

## 项目结构

```
VastAIDemo/
├── public/
│   └── avatar.png              # 量仔头像
├── src/
│   ├── api/index.ts            # API 请求封装（SSE、对话、文件上传）
│   ├── assets/                 # 静态资源
│   ├── components/
│   │   ├── AppHeader.vue       # 全局导航栏
│   │   └── AppFooter.vue       # 全局页脚
│   ├── composables/
│   │   ├── useStreamChat.ts    # SSE 流式聊天（节流渲染）
│   │   ├── usePolling.ts       # 消息轮询（指数退避）
│   │   └── useLoading.ts       # 加载状态管理
│   ├── pages/                  # 页面组件
│   ├── router/index.ts         # 路由配置
│   ├── stores/chat.ts          # Pinia 聊天状态
│   ├── styles/main.css         # 全局样式 + TailwindCSS
│   ├── types/index.ts          # TypeScript 类型定义
│   ├── utils/index.ts          # 工具函数
│   ├── App.vue                 # 根组件
│   └── main.ts                 # 入口
├── server.js                   # Node.js 后端（dist 静态服务 + API 代理）
├── VastAIDemo.service          # systemd 服务单元文件
├── install.sh                  # 一键部署脚本
├── vite.config.ts              # Vite 配置
├── tailwind.config.js          # TailwindCSS 配置
├── tsconfig.json               # TypeScript 配置
└── package.json
```

## AI 对话功能

SupportChatPage 提供：

- **SSE 流式对话**：实时流式输出 AI 回复，节流渲染（~60fps）
- **对话管理**：侧边栏对话列表、新建/切换对话
- **文件上传**：最多 5 个文件，支持预览
- **Markdown 渲染**：代码高亮、表格、列表等
- **MVS 工单渲染**：自动检测 JSON 格式并渲染为结构化卡片
- **消息轮询**：指数退避策略（2s→5s→10s→30s→60s）

## Linux 生产环境部署

### 前置条件

```bash
# 确认 Node.js 版本 >= 18
node --version

# 确认 node 路径（service 文件中需要）
which node

# 如果 node 不在 /usr/bin/node，建立软链
sudo ln -s $(which node) /usr/bin/node
```

### 方式一：一键部署脚本（推荐）

脚本会自动完成依赖安装、文件复制、systemd 注册和服务启动。

**标准部署**（复制到 `/opt/VastAIDemo`）：

```bash
# 1. 本地构建（在开发机上执行）
pnpm install
pnpm build

# 2. 将项目传输到服务器（含 dist/ 目录）
scp -r . user@your-server:/tmp/VastAIDemo

# 3. 服务器上执行安装
sudo bash /tmp/VastAIDemo/install.sh
```

**原地部署**（直接在当前目录运行，不复制到 /opt）：

```bash
sudo bash install.sh --in-place
```

### 方式二：手动部署

```bash
# 1. 构建前端
pnpm install
pnpm build

# 2. 配置环境变量
cp .env.example .env
vi .env   # 填写 DIFY_API_BASE、DIFY_API_KEY、LOCAL_IP 等

# 3. 安装生产依赖
pnpm install --production

# 4. 注册 systemd 服务（将路径占位符替换为实际目录）
INSTALL_DIR=$(pwd)
sed "s|__INSTALL_DIR__|${INSTALL_DIR}|g" VastAIDemo.service \
  | sudo tee /etc/systemd/system/VastAIDemo.service

# 5. 启动服务
sudo systemctl daemon-reload
sudo systemctl enable --now VastAIDemo
```

### 方式三：直接运行（无 systemd）

适合临时测试或容器环境：

```bash
pnpm install
pnpm build
node server.js
# 或后台运行
nohup node server.js > /var/log/VastAIDemo.log 2>&1 &
```

### 服务管理

```bash
# 查看状态
systemctl status VastAIDemo

# 启动 / 停止 / 重启
systemctl start VastAIDemo
systemctl stop VastAIDemo
systemctl restart VastAIDemo

# 开机自启 / 取消自启
systemctl enable VastAIDemo
systemctl disable VastAIDemo

# 实时日志
journalctl -u VastAIDemo -f

# 最近 100 条日志
journalctl -u VastAIDemo -n 100
```

### 验证部署

```bash
# 健康检查
curl http://localhost:8081/api/health

# 检查端口占用
ss -tlnp | grep 8081

# 开放防火墙（如使用 ufw）
ufw allow 8081/tcp
```

## 许可证

ISC
