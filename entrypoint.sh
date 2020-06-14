#!/bin/bash

export DOLLAR='$'

echo "${APTLY_API_USER}:$(echo ${APTLY_API_PASSWORD} | openssl passwd -apr1 -stdin)" > /opt/aptly/api.htpasswd

if [[ ! -f /opt/aptly/aptly.sec ]] || [[ ! -f /opt/aptly/aptly.pub ]]; then
    cp -a /dev/urandom /dev/random

cat << EOF > /tmp/apt_repository_gpg_batch
    %echo Generating a basic OpenPGP key
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Length: 4096
    Name-Real: ${GPG_REAL_NAME}
    Name-Email: ${GPG_NAME_EMAIL}
    Expire-Date: 0
    Passphrase: ${GPG_PASSPHRASE}
    %pubring /opt/aptly/aptly.pub
    %secring /opt/aptly/aptly.sec
    %commit
    %echo done
EOF

    gpg --batch --gen-key /tmp/apt_repository_gpg_batch
    rm /tmp/apt_repository_gpg_batch
fi

if [[ ! -d /opt/aptly/public ]] || [[ ! -f /opt/aptly/public/signing.key ]]; then
    gpg --export --armor > /opt/aptly/public/signing.key
fi

envsubst < /etc/aptly.conf.template > /etc/aptly.conf
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
