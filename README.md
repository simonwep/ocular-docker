<br/>

<h3 align="center">
    <img src="https://github.com/simonwep/openvpn-pihole/assets/30767528/a965ecf1-696e-46ea-85ad-87ce4bdb8791" alt="Logo" width="350">
</h3>

<br/>

<div align="center">
  <h3>Ocular on Docker</h3>
  <h4>A ready-to-deploy docker compose setup for <a href="https://github.com/simonwep/ocular">ocular</a></h4>
</div>

<br/>

## Quick start

To download the latest release and start it via docker-compose, run:

```sh
bash <(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/simonwep/ocular-docker/refs/heads/main/setup.sh)
```

> [!NOTE]
> This will perform the same steps as described in the [manual setup](#manual-setup-and-migration) section and ask you questions if needed.
> You can always [take a look at the script](setup.sh) before running it, or perform [these steps manually](#manual-setup-and-migration).

## Manual setup and migration

### First time setup

This is the docker-compose setup for [ocular](https://github.com/simonwep/ocular).
To deploy it, follow these steps:

1. Download the [latest release](https://github.com/simonwep/ocular-docker/releases/latest) and extract it. Do not clone this repository!
2. Copy the `.env.example` to `.env`, if your app is only used locally make sure to set `GENESIS_JWT_COOKIE_ALLOW_HTTP` to `true` if you want to use it without https.
3. Run `./gen-passwords.sh` to generate secrets and an initial admin user.
4. Run `docker compose up -d`.
5. Ocular should be accessible under `http://localhost:3030` in your browser :)

### Migrating to a new version

To migrate to a newer version, follow these steps:

1. Backup the `./data` folder. The folder contains all the user-data.
2. Download the [latest release](https://github.com/simonwep/ocular-docker/releases/latest) and extract it.
3. Copy the `.env.example` to `.env`, adjust the values if needed. **You don't need to run `./gen-passwords.sh` again.**
4. Copy your old `./data` folder to the new location.
5. Run `docker compose up -d`.

## Admin controls

You can use [genesis's CLI](https://github.com/simonwep/genesis?tab=readme-ov-file#cli) to manage users.
For example, to change a user's password:

```sh
docker run --rm -v "$(pwd)/data:/app/.data" --env-file .env ghcr.io/simonwep/genesis:latest users update --password {new password} {username}
```

For help run:
```sh
docker run --rm -v "$(pwd)/data:/app/.data" --env-file .env ghcr.io/simonwep/genesis:latest help
```

## FAQ

### Where can I find the release notes?

For release notes, check out the [latest release](https://github.com/simonwep/ocular/releases/latest) in the [ocular](https://github.com/simonwep/ocular) repository.
This repo is just for production releases :)

### Help! I can't log in to the app over the network!

If you don't use https, make sure to set `GENESIS_JWT_COOKIE_ALLOW_HTTP` to `true` in your `.env` file.
Otherwise, run it behind a reverse proxy like [nginx](https://www.nginx.com/) and get a free certificate from [letsencrypt](https://letsencrypt.org/).

Make sure to restart the app after changing the `.env` file via `docker compose restart`.

### What kind of config do I need if I want to run it behind an nginx reverse proxy?

Here's an example of a basic nginx config (v1.25+):

```nginx
server {
    listen 443 quic reuseport;
    listen 443 ssl;

    server_name ocular.example.com;
    add_header Alt-Svc 'h3=":443"; ma=86400';

    location / {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_read_timeout 300s;
        proxy_pass http://127.0.0.1:3030$request_uri;
    }

    # Specify the path to your certificate and key, or use letsencrypt
    #ssl_certificate
    #ssl_certificate_key 
}
```
