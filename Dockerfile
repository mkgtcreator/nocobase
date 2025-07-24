# Etapa de build
FROM node:20-bookworm as builder

WORKDIR /app

# Copia o código-fonte
COPY . .

# Instala dependências e compila a aplicação
RUN yarn install --frozen-lockfile && yarn build

# Etapa final: imagem leve para produção
FROM node:20-bookworm-slim

# Instala o cliente do PostgreSQL (opcional, mas útil para debug/migrations)
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia os arquivos da etapa anterior
COPY --from=builder /app /app

# Expõe a porta padrão do NocoBase
EXPOSE 13000

# Inicia o servidor
CMD ["yarn", "start"]
