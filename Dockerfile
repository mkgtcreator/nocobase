# Etapa de build
FROM node:20-bookworm AS builder

WORKDIR /app
COPY . .

RUN yarn install --frozen-lockfile

# Etapa de produção
FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app /app

RUN yarn build

EXPOSE 13000

CMD ["sh", "-c", "yarn nocobase install && yarn start"]
