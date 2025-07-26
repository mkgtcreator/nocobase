# Etapa de build
FROM node:20-bookworm AS builder

WORKDIR /app
COPY . .

# Instala dependências e faz o build
RUN yarn install --frozen-lockfile && yarn build

# Etapa de produção
FROM node:20-bookworm-slim

# Instala cliente PostgreSQL (útil para alguns plugins)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia arquivos da etapa de build
COPY --from=builder /app /app

# ⚠️ NÃO use --production porque o NocoBase usa workspaces
RUN yarn install --frozen-lockfile

EXPOSE 13000

# Comando final para iniciar o NocoBase
CMD ["yarn", "start"]
