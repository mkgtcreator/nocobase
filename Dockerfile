# Etapa de build
FROM node:20-bookworm AS builder

WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile && yarn build

# Etapa de produção
FROM node:20-bookworm-slim

WORKDIR /app

COPY --from=builder /app ./

RUN yarn install --production --frozen-lockfile

EXPOSE 13000

CMD ["yarn", "start"]
