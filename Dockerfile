FROM scratch AS build

ADD ./alpine-minirootfs-3.19.1-x86_64.tar.gz /

RUN apk add --no-cache npm

WORKDIR /app

COPY ./src .

RUN npm install

ARG VERSION

RUN npm version ${VERSION:-"1.0.0"}

FROM nginx:stable-alpine3.17-slim

RUN apk add --no-cache npm curl

WORKDIR /app

COPY --from=build /app .

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY ./start.sh /usr/local/bin/

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=5s \
	CMD curl -f http://localhost:80 || exit 1

CMD ["start.sh"]
