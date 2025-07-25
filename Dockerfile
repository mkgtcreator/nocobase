# Etapa de build
FROM node:20-bookworm as builder

WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile && yarn build

# Etapa final (produção)
FROM node:20-bookworm-slim

# Variável de ambiente de produção
ENV NODE_ENV=production

# Instala cliente do PostgreSQL (opcional para migrações/debug)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 13000

CMD ["yarn", "start"]
