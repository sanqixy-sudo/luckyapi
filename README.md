<p align="center">
  <img src="docs/luckyapi-logo.png" width="112" height="112" alt="LuckyAPI 标识" />
</p>

<h1 align="center">LuckyAPI</h1>

<p align="center">
  自托管的社区 API 运营与互动平台
</p>

<p align="center">
  将 OpenAI 兼容网关、额度账务、运营控制、社区玩法与分类榜单整合在一个系统中。
</p>

<p align="center">
  <img alt="version" src="https://img.shields.io/badge/version-v1.0.0-8b5e16" />
  <img alt="deployment" src="https://img.shields.io/badge/deployment-Docker-2496ED?logo=docker&logoColor=white" />
  <img alt="platform" src="https://img.shields.io/badge/platform-Self--hosted-0f766e" />
  <img alt="stack" src="https://img.shields.io/badge/stack-React%20%2B%20TypeScript-3178C6" />
  <img alt="license" src="https://img.shields.io/badge/license-No%20open--source%20license-6b7280" />
</p>

<p align="center">
  <a href="#快速部署">快速部署</a>
  ·
  <a href="#功能全景">功能全景</a>
  ·
  <a href="#技术架构">技术架构</a>
  ·
  <a href="SECURITY.md">安全报告</a>
  ·
  <a href="https://linux.do">Linux.do 社区</a>
</p>

---

## 项目简介

LuckyAPI 面向需要自建社区 API 服务的个人或小型运营团队。它不只是一个接口转发层，还把用户登录、密钥管理、模型定价、额度结算、调用监控、金融互动、娱乐玩法和后台控制串成了一套完整流程。

项目采用单管理员、单上游架构，默认使用 SQLite，适合通过 Docker 在单台服务器快速部署和维护。

## 核心亮点

- **一体化运营**：API 网关、用户体系、账务、活动、榜单和管理后台使用同一套数据与权限模型。
- **OpenAI 兼容**：统一管理上游地址、模型价格、分组、API Key、额度和请求日志。
- **精确账务**：金额使用最小货币单位计算，支持转账、借贷、手续费、限制策略和规则快照。
- **社区互动**：内置签到、抽奖、视频红包、老虎机、举报、决斗和战队玩法。
- **数据可见**：提供调用量、成功率、Token、扣费、延迟、TTFT 以及分类榜单。
- **运营可控**：支持模块开关、用户策略、权限冻结、会话与密钥管理及操作审计。
- **响应式后台**：管理端支持深色/浅色主题、折叠侧栏和移动端布局。

## 功能全景

| 模块 | 主要能力 |
| --- | --- |
| 账户与认证 | Linux.do Connect OAuth、首次注册、账户合并、会话管理 |
| API 运营 | OpenAI 兼容网关、API Key、模型定价、分组、额度与并发限制 |
| 调用监控 | 请求/响应日志、Token、扣费、成功率、错误率、延迟与 TTFT |
| 金融运营 | 转账、借贷、手续费、每日限额、未偿上限与合同规则快照 |
| 娱乐运营 | 签到、抽奖、视频红包、老虎机、举报、决斗、战队 |
| 榜单中心 | 综合、API、金融、娱乐分类榜单及个人排名 |
| 管理后台 | 运营开关、用户策略、OAuth、金融规则、审计日志和主题切换 |

## 技术架构

```text
浏览器 / 移动端
       │
React + TypeScript + Vite
       │
Hono + tRPC API
       ├── SQLite + Drizzle ORM
       ├── Linux.do Connect OAuth
       └── OpenAI 兼容单上游
```

主要技术栈：

- React 19、TypeScript、Vite、Tailwind CSS
- Hono、tRPC、Zod
- Drizzle ORM、SQLite
- Vitest、ESLint、Docker Compose

## 快速部署

### 1. 准备环境变量

```bash
cp .env.example .env
```

编辑 `.env`，至少将 `ADMIN_PASSWORD` 改为独立的高强度随机密码。需要 Linux.do 登录时，再填写 OAuth 配置。

### 2. 构建并启动

```bash
docker compose up -d --build
```

也可设置 `.env` 中的 `LUCKYAPI_IMAGE=ghcr.io/sanqixy-sudo/luckyapi:v1.0.1`，然后用 `docker compose pull app` 和 `docker compose up -d --no-build app` 部署成品镜像。GHCR 包的访问范围取决于包设置。

版本发布使用与 `package.json` 一致的 `vX.Y.Z` Git 标签。GitHub Actions 在运行项目检查、构建镜像并验证服务启动后发布该版本，随后从 GHCR 回拉校验。

### 3. 访问服务

- 前台：`http://localhost:3000`
- 管理后台：`http://localhost:3000/admin`
- OAuth 回调：`https://你的域名/api/oauth/callback`

SQLite 数据保存在 Docker 卷 `luckydraw-data` 中。生产环境请配置 HTTPS 反向代理，并正确转发 `Host`、`X-Forwarded-Host` 和 `X-Forwarded-Proto`。

## 关键配置

| 变量 | 用途 | 必填 |
| --- | --- | --- |
| `ADMIN_USERNAME` | 初始管理员用户名 | 否，默认 `admin` |
| `ADMIN_PASSWORD` | 初始管理员密码 | **是** |
| `LINUXDO_CLIENT_ID` | Linux.do OAuth Client ID | 使用 OAuth 时 |
| `LINUXDO_CLIENT_SECRET` | Linux.do OAuth Client Secret | 使用 OAuth 时 |
| `LINUXDO_PRIMARY_ORIGIN` | 唯一可信站点 Origin | 使用 OAuth 时 |
| `SQLITE_PATH` | SQLite 数据文件路径 | 否 |
| `PORT` | 对外映射端口 | 否，默认 `3000` |

完整示例见 [`.env.example`](.env.example)。

## 本地开发

```bash
npm ci
npm run dev
```

提交前建议执行：

```bash
npm run check
npm test
npm run build
```

当前公开版本已通过 TypeScript 检查、30 个测试文件共 62 项测试和生产构建。

## 部署边界

- 当前版本为单管理员、单上游架构。
- 默认使用 SQLite，升级前请备份并验证数据可恢复。
- 不包含多角色、多上游、Webhook 或外部告警系统。
- 保留现有请求体与响应体日志行为，生产部署时应严格控制日志访问权限。

## 安全说明

- 不要提交 `.env`、数据库、日志、备份、Cookie、证书或生产密钥。
- 首次启动前必须修改管理员密码。
- 已经公开过的密钥必须立即撤销并轮换，不能只删除 Git 历史。
- 安全漏洞请按照 [SECURITY.md](SECURITY.md) 私下报告，不要发布包含利用细节的公开 Issue。

## 许可证

本仓库目前**未附带开源许可证**。公开可见不代表授予复制、修改、分发或商业使用许可。
