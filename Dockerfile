FROM node:24-bookworm-slim AS builder

WORKDIR /app

# better-sqlite3 falls back to a source build when no matching prebuilt binary
# is available, so keep the native build toolchain in the disposable stage.
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

COPY . .
RUN npm run build \
    && npm prune --omit=dev --ignore-scripts --no-audit --no-fund

FROM node:24-bookworm-slim AS runtime

WORKDIR /app

COPY package.json package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
ENV PORT=3000
ENV APP_ID=self-hosted
ENV APP_SECRET=self-hosted
ENV DATABASE_URL=local
ENV SQLITE_PATH=/app/data/luckydraw.db

EXPOSE 3000
VOLUME ["/app/data"]

CMD ["node", "dist/boot.js"]
