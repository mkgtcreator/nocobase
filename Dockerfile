# Etapa de build
FROM node:20-bookworm AS builder

WORKDIR /app

COPY . .

# Instala dependências (sem build ainda)
RUN yarn install --frozen-lockfile

# Etapa de produção
FROM node:20-bookworm-slim

# Instala cliente PostgreSQL (útil para alguns plugins)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia arquivos da etapa de build
COPY --from=builder /app /app

# Instala dependências no container de produção
RUN yarn install --frozen-lockfile

# ⚠️ Importante: instala o app base
RUN yarn nocobase install

EXPOSE 13000

# Comando final para iniciar o NocoBase (e aí sim ele faz o build interno, em runtime)
CMD ["yarn", "start"]
