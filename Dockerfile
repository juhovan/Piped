FROM node:current-alpine AS build

ARG PIPED_API="https://pipedapi.kavin.rocks"

WORKDIR /app/

COPY package.json yarn.lock ./

RUN yarn install --prefer-offline

COPY . .

RUN sed -i 's@https://pipedapi.kavin.rocks@'"$PIPED_API"'@' src/main.js src/components/Preferences.vue && \
    yarn build

FROM nginx:alpine

COPY --from=build /app/dist/ /usr/share/nginx/html/
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
