# Etapa de build
FROM node:20-bookworm as builder

WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile && yarn build

# Etapa final (produção)
FROM node:20-bookworm-slim

ENV NODE_ENV=production

# Instala cliente do PostgreSQL (opcional)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app /app

# Instala apenas dependências de produção
RUN yarn install --production --frozen-lockfile

EXPOSE 13000

# (Opcional: segurança)
# RUN useradd -m appuser
# USER appuser

CMD ["yarn", "start"]
