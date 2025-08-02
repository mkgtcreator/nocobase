# Etapa de build
FROM node:20-bullseye AS builder

WORKDIR /app

# Instala dependências necessárias para compilar módulos nativos
RUN apt-get update && apt-get install -y \
  python3 \
  make \
  g++ \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Copia apenas arquivos de dependências primeiro (para aproveitar cache)
COPY package.json yarn.lock ./

# Instala dependências (com suporte a binários nativos)
RUN yarn install --frozen-lockfile --ignore-optional --ignore-scripts

# Copia o restante do projeto
COPY . .

# Compila o projeto
RUN yarn run build

# Etapa de produção
FROM node:20-bullseye-slim

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app /app

EXPOSE 13000
CMD ["yarn", "start"]
