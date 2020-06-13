FROM nginx:latest

RUN apt-get update && apt-get install -y \
    aptly \
    gnupg1 \
    supervisor \
  && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/gpg1 /usr/bin/gpg

COPY etc/nginx.conf /etc/nginx/nginx.conf.template
COPY etc/aptly.conf /etc/aptly.conf.template
COPY etc/supervisor.conf /etc/supervisor/conf.d/apt-repository.conf
COPY etc/gpg.conf /root/.gnupg/gpg.conf
COPY entrypoint.sh /entrypoint.sh

RUN ln -sf /opt/aptly/aptly.sec /root/.gnupg/secring.gpg && \
    ln -sf /opt/aptly/aptly.pub /root/.gnupg/pubring.gpg

RUN mkdir -p /opt/aptly/public

ENV NGINX_HOST=localhost
ENV NGINX_API_MAX_UPLOAD_SIZE=100M

ENV APTLY_DOWNLOAD_CONCURRENCY=4
ENV APTLY_DOWNLOAD_SPEED_LIMIT=0
ENV APTLY_PPA_DISTRIBUTOR_ID=localhost
ENV APTLY_PPA_CODENAME=

ENV APTLY_API_USER=root
ENV APTLY_API_PASSWORD=root

ENV GPG_REAL_NAME="Root Root"
ENV GPG_NAME_EMAIL=root@root
ENV GPG_PASSPHRASE=root

EXPOSE 80

VOLUME [ "/opt/aptly" ]

ENTRYPOINT [ "/entrypoint.sh" ]
