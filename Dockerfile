FROM alpine:3.9.4 AS build

RUN apk add --no-cache \
    && apk add --update nodejs npm

COPY app /app

WORKDIR /app

RUN npm install --no-optional

# RUN production build 
RUN npm run build

FROM alpine:3.9.4

EXPOSE 5000

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
    && apk add --update nodejs npm \
    && npm install -g serve

WORKDIR /home/node

COPY --from=build /app/build app

RUN chown -R node:node /home/node

USER node

CMD ["serve", "-s", "/home/node/app"]
