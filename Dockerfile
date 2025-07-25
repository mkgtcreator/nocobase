# Etapa de build
FROM node:20-bookworm as builder

WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile && yarn build

# Etapa final (produção)
FROM node:20-bookworm-slim

ENV NODE_ENV=production

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app /app

# ⚠️ Instalando TUDO (não só produção) pra evitar bugs do NocoBase
RUN yarn install --frozen-lockfile

EXPOSE 13000

CMD ["yarn", "start"]


