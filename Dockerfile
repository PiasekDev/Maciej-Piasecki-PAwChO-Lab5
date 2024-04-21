FROM scratch

ADD ./alpine-minirootfs-3.19.1-x86_64.tar.gz /

RUN apk add --no-cache npm

WORKDIR /app

COPY ./src .

RUN npm install

ARG VERSION

RUN npm version ${VERSION:-"1.0.0"}

CMD ["npm", "start"]
