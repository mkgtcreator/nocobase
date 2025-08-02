# -------------------------
# Etapa de build
# -------------------------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copia apenas arquivos de dependências primeiro (aproveita cache)
COPY package.json yarn.lock ./

# Dependências para compilar binários nativos
RUN apt-get update && apt-get install -y \
  python3 \
  make \
  g++ \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Instala dependências sem rodar postinstall (que quebra no nocobase)
RUN yarn install --frozen-lockfile --ignore-optional --ignore-scripts

# Instala nocobase CLI somente no build
RUN yarn add nocobase --dev

# Copia o restante do código
COPY . .

# Compila o projeto
RUN yarn run build

# -------------------------
# Etapa de produção
# -------------------------
FROM node:20-bullseye-slim AS production
WORKDIR /app

# Instala apenas cliente PostgreSQL (mínimo necessário)
RUN apt-get update && apt-get install -y --no-install-recommends \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Copia app buildado
COPY --from=builder /app /app

# Remove dependências de desenvolvimento para deixar mais leve
RUN yarn install --production --ignore-optional --frozen-lockfile

EXPOSE 13000
CMD ["yarn", "start"]

