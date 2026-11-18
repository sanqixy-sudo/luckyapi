# 仓库协作

- `src/` 是 React 前端，`api/` 是 Hono 和 tRPC 入口，`db/` 维护 SQLite 模型与迁移。用 `package-lock.json` 复现依赖。
- Node.js 24 下运行 `npm ci`、`npm run check`、`npm test`、`npm run build`。修改鉴权、账本或迁移时用隔离 SQLite 数据验证事务和旧数据。
- 文件中的环境变量仅使用示例值。部署凭据由运行环境提供，数据库和日志与代码分开管理。
- 发布使用与 `package.json` 一致的 `vX.Y.Z`。镜像构建、启动检查和 GHCR 发布由版本工作流执行。
