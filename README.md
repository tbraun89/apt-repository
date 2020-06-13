# APT Repository

Docker image to create a private APT repository with aptly and nginx.

## Usage

Create a volume `repository-data` before you start the container.

    docker run -d --restart=always --publish 8080:80 --volume repository-data:/opt/aptly hex00r/apt-repository

Don't forget to set all the environment variables, especially usernames and passwords.

### API access

The aptly API will be exposed at `http://localhost:8080/api`, see the documentation for details: https://www.aptly.info/doc/api/

### Use the repository

Add the signing public key of the repository

    wget -qO - http://localhost:8080/signing.key | sudo apt-key add -

Then you can add your repository to your sources, e.g. `/etc/apt/sources.d/my-repository.list` and install your published packages.

## Environment variables

|Name|Default|
|---|---|
|NGINX_HOST|**localhost**|
|NGINX_API_MAX_UPLOAD_SIZE|**100M**|
|APTLY_DOWNLOAD_CONCURRENCY|**4**|
|APTLY_DOWNLOAD_SPEED_LIMIT|**0**|
|APTLY_PPA_DISTRIBUTOR_ID|**localhost**|
|APTLY_PPA_CODENAME||
|APTLY_API_USER|**root**|
|APTLY_API_PASSWORD|**root**|
|GPG_REAL_NAME|**"Root Root"**|
|GPG_NAME_EMAIL|**root@root**|
|GPG_PASSPHRASE|**root**|
