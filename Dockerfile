# Base de build (mais leve e rápida)
FROM node:18-bullseye AS builder

WORKDIR /app

# Copia apenas arquivos de dependência primeiro (aproveita cache do Render)
COPY package.json yarn.lock ./

# Instala dependências (com cache)
RUN yarn install --frozen-lockfile --ignore-optional

# Copia o restante do projeto
COPY . .

# Build do projeto
RUN yarn build

# Imagem final
FROM node:18-bullseye-slim

# Instala cliente Postgres (necessário pro NocoBase conectar no DB)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia apenas o necessário do builder
COPY --from=builder /app /app

EXPOSE 13000

CMD ["yarn", "start"]
