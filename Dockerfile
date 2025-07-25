# Etapa de build
FROM node:20-bookworm as builder

WORKDIR /app
COPY . .

# Instala todas dependências e builda
RUN yarn install --frozen-lockfile && yarn build

# Etapa final (produção)
FROM node:20-bookworm-slim

# PostgreSQL client (opcional, mas ajuda em alguns plugins)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app /app

# ⚠️ NÃO use --production porque você usa workspaces
RUN yarn install --frozen-lockfile

EXPOSE 13000

ENV NODE_ENV=production
CMD ["yarn", "start"]

