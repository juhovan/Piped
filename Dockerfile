FROM node:current-alpine AS build

WORKDIR /app/

COPY package.json yarn.lock ./

RUN yarn install --prefer-offline

COPY . .

RUN yarn build

FROM nginx:alpine

COPY --from=build /app/dist/ /usr/share/nginx/html/
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
