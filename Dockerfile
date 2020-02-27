FROM python:3.8-alpine3.10 AS python

FROM certbot/certbot AS certbot

FROM nginx:alpine

ENV STAGING=0 \
    EMAIL="email@mydomain.com" \
    DOMAINS="mydomain.com www.mydomain.com"

VOLUME /etc/letsencrypt
VOLUME /usr/share/nginx/certbot

RUN apk add --no-cache --virtual .certbot-deps \
    libffi \
    libssl1.1 \
    openssl \
    ca-certificates \
    binutils \
    expat

COPY --from=python /usr/local/bin/idle /usr/local/bin/idle
COPY --from=python /usr/local/bin/pydoc /usr/local/bin/pydoc
COPY --from=python /usr/local/bin/python /usr/local/bin/python
COPY --from=python /usr/local/bin/python-config /usr/local/bin/python-config

COPY --from=python /usr/local/lib/libpython3.so /usr/local/lib/libpython3.so
COPY --from=python /usr/local/lib/libpython3.8.so.1.0 /usr/local/lib/libpython3.8.so.1.0

COPY --from=certbot /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=certbot /opt/certbot /opt/certbot
COPY --from=certbot /usr/local/bin/certbot /usr/local/bin/certbot

COPY run.sh /run.sh

RUN chmod 500 /run.sh

CMD [ "/run.sh" ]
