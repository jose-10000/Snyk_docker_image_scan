FROM node:18.15-alpine AS builder
WORKDIR /app
COPY . .
#RUN yarn install && yarn build
RUN npm install && npm run build

FROM node:18.15-alpine
WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./
COPY .env ./
ENV WEB_PORT=3000
EXPOSE 3000
RUN npm install
COPY --from=builder /app/dist ./dist
CMD [ "yarn", "start:prod" ]
