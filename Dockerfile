FROM node:10-alpine as build-stage

WORKDIR /usr/src/app

COPY package*.json ./

RUN yarn install

COPY . .

RUN yarn build
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.18-alpine

COPY --from=build-stage /usr/src/app/build/ /usr/share/nginx/html
# Copy the default nginx.conf provided by tiangolo/node-frontend

COPY --from=build-stage /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf
