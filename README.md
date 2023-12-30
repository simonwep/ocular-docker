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

> [!NOTE]  
> For release notes, check out the [latest release](https://github.com/simonwep/ocular/releases/latest) in the [ocular](https://github.com/simonwep/ocular) repository.
> This repo is just for production releases :)

### Setup

This is the docker-compose setup for [ocular](https://github.com/simonwep/ocular).
To deploy it, follow these steps:

1. Download the [latest release](https://github.com/simonwep/ocular-docker/releases/latest) and extract it. Do not clone this repository!
2. Copy the `.env.example` to `.env`, for normal usage you can leave the values as they are.
3. Run `./gen-passwords.sh` to generate secrets and an initial admin user.
4. Run `docker compose up -d`.
5. Ocular should be accessible under `http://localhost:3030` in your browser :)
