FROM node:20-bookworm

WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile

EXPOSE 13000

CMD ["yarn", "start"]
