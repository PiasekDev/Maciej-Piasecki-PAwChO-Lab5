# syntax=docker/dockerfile:1

FROM alpine:3.19.1 AS build

RUN apk add --no-cache npm openssh-client git

# download the public key for github.com (prevents the prompt to add the host to known_hosts)
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:PiasekDev/Maciej-Piasecki-PAwChO-Lab5.git /repository

WORKDIR /repository/src

RUN npm install

ARG VERSION

RUN npm version ${VERSION:-"1.0.0"}

FROM nginx:stable-alpine3.17-slim

RUN apk add --no-cache npm curl

WORKDIR /app

COPY --from=build /repository/src .

COPY --from=build /repository/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /repository/start.sh /usr/local/bin/

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=5s \
	CMD curl -f http://localhost:80 || exit 1

CMD ["start.sh"]

LABEL org.opencontainers.image.source=https://github.com/PiasekDev/pawcho6
