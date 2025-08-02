# Base de build
FROM node:18-bullseye AS builder

WORKDIR /app

# Copia tudo (não só package.json), pois o postinstall precisa dos arquivos do projeto
COPY . .

# Instala dependências
RUN yarn install --frozen-lockfile --ignore-optional

# Build do projeto
RUN yarn build

# Imagem final
FROM node:18-bullseye-slim

# Instala cliente Postgres
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia a build do builder
COPY --from=builder /app /app

EXPOSE 13000

CMD ["yarn", "start"]

