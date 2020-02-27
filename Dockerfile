FROM certbot/certbot

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
    python3

COPY --from=0 /usr/local/lib/python3.7/site-packages /usr/lib/python3.7/site-packages
COPY --from=0 /opt/certbot /opt/certbot
COPY --from=0 /usr/local/bin/certbot /usr/bin/certbot

COPY run.sh /run.sh

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    sed -i -e "s/local\/bin\/python/bin\/python/g" /usr/bin/certbot && \
    chmod 500 /run.sh

CMD [ "/run.sh" ]
