# Etapa de build
FROM node:20-bullseye AS builder

WORKDIR /app
COPY package.json yarn.lock ./

# Usa cache para dependências
ENV YARN_CACHE_FOLDER=/tmp/.yarn-cache

# Instala dependências e o NocoBase CLI
RUN yarn install --frozen-lockfile --ignore-optional
RUN yarn add nocobase --dev

# Copia o restante do projeto
COPY . .

# Compila o projeto
RUN yarn run build

# Etapa de produção
FROM node:20-bullseye-slim

WORKDIR /app

# Copia somente o necessário da etapa de build
COPY --from=builder /app /app

# Instala client do Postgres (se precisar no runtime)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

EXPOSE 13000
CMD ["yarn", "start"]

