# Build stage

FROM node:21-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Production stage

FROM node:21-alpine as production

WORKDIR /app

COPY --from=build /app .

RUN npm install --only=production

EXPOSE 8003

CMD ["node", "src/index.js"]