ARG NGINX_VERSION=${NGINX_VERSION}
FROM nginx:${NGINX_VERSION}-alpine

COPY nginx.conf /etc/nginx/
RUN apk update \
    && apk upgrade \
    && apk --update add logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash

RUN touch /var/log/messages
COPY logrotate/nginx /etc/logrotate.d/

EXPOSE 80 443
