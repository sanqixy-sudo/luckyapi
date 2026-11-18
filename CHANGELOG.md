# 变更记录

## 1.0.1

- 锁文件使用可访问的 npm 官方包地址，保留依赖版本和完整性校验。
- Docker 构建统一使用 npm 锁文件与 Node.js 24。
- GitHub Actions 验证构建产物并发布带版本号的 GHCR 镜像。
