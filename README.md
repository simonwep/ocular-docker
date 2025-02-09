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
> This will perform the same steps as described in the [manual setup](#manual-setup) section and ask you questions if needed.
> You can always [take a look at the script](setup.sh) before running it, or perform [these steps manually](#manual-setup).

## Manual setup

This is the docker-compose setup for [ocular](https://github.com/simonwep/ocular).
To deploy it, follow these steps:

1. Download the [latest release](https://github.com/simonwep/ocular-docker/releases/latest) and extract it. Do not clone this repository!
2. Copy the `.env.example` to `.env`, if your app is only used locally make sure to set `GENESIS_JWT_COOKIE_ALLOW_HTTP` to `true` if you want to use it without https, for example in an isolated network.
3. Run `./gen-passwords.sh` to generate secrets and an initial admin user.
4. Run `docker compose up -d`.
5. Ocular should be accessible under `http://localhost:3030` in your browser :)

## Migrating to a new version

> [!NOTE]
> Usually it's sufficient to just bump the version inside the `docker-compose.yml` file.
> However, sometimes new versions require new `.env`-variables or changes in the [config](config) folder.
> This guide is to be 100%-sure that everything works as expected - but it's not always necessary.

To migrate to a newer version, follow these steps:

1. Stop all containers with `docker compose down`.
2. Backup the `./data` folder and your `.env` file.
3. Download the [latest release](https://github.com/simonwep/ocular-docker/releases/latest) and extract it.
4. Copy your old `./data` folder and `.env` to the new directory, compare the `.env.example` with your `.env` and copy default values if needed.
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

Head over to the [FAQs](FAQs.md) for more information.
