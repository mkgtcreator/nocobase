# Base de build
FROM node:20-bullseye AS builder

WORKDIR /app

# Copia tudo
COPY . .

# Instala dependências
RUN yarn install --frozen-lockfile --ignore-optional

# Build do projeto
RUN yarn build

# Imagem final
FROM node:20-bullseye-slim

# Instala cliente Postgres
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia a build do builder
COPY --from=builder /app /app

EXPOSE 13000

CMD ["yarn", "start"]


