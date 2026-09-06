*This project has been created as part of the 42 curriculum by abtouait.*

# Inception

## Description
Small system administration project: a virtualized infrastructure built with Docker Compose, composed of three custom Docker images (NGINX, WordPress+php-fpm, MariaDB), each running in its own dedicated container, connected through a single Docker network. WordPress data and the database are persisted through named volumes bound to `/home/<login>/data` on the host.

## Instructions
```bash
# build and start everything
make

# stop containers
make down

# stop, prune docker system, wipe data folders
make clean
```
Requirements before running:
- Docker Engine + `docker compose` plugin installed.
- `srcs/.env` filled in (see [DEV_DOC.md](DEV_DOC.md)).
- `<DOMAIN_NAME>` resolving to `127.0.0.1` (via `/etc/hosts` on a local setup, or DNS on a real VM).

Access: `https://<DOMAIN_NAME>` (self-signed certificate, browser warning expected).

## Project description
- **NGINX**: sole entrypoint, port 443 only, TLSv1.2/1.3 only, reverse-proxies PHP requests to `wordpress:9000` (fastcgi).
- **WordPress + php-fpm**: no web server bundled, installed/configured via `wp-cli` on first boot (`tools/setup.sh`), talks to `mariadb:3306`.
- **MariaDB**: dedicated container, DB persisted in a named volume.
- **Network**: one bridge network (`inception`) connects the three containers; no `network: host`, no `links`.
- **Volumes**: two named volumes (`db_data`, `wp_data`) bound to `/home/<login>/data/mariadb` and `/home/<login>/data/wordpress` on the host.

**Virtual Machines vs Docker**: a VM virtualizes a full OS and kernel (heavier, slower start, strong isolation); a container shares the host kernel and only isolates the process/userland (lightweight, fast start, less isolation). Docker is preferred here for reproducibility and speed when running several independent services.

**Secrets vs Environment Variables**: `.env` variables are readable in plaintext by anyone with shell/inspect access to the container or host; Docker secrets are mounted as files, only accessible to the processes that need them, and not stored in `docker inspect`/`ps` output. Secrets are the safer choice for credentials; `.env` is used here for convenience per project requirements.

**Docker Network vs Host Network**: a custom bridge network isolates container-to-container traffic and only exposes what's explicitly published (here, only NGINX's 443); host networking removes that isolation and exposes every container port directly on the host, which is forbidden by the subject.

**Docker Volumes vs Bind Mounts**: named volumes are managed by Docker (lifecycle independent of the host path layout, portable, addressable by name); bind mounts point directly at a host path chosen by the user. The subject requires named volumes for the two persistent stores, configured to physically store data under `/home/<login>/data`.

## Resources
- [Docker docs](https://docs.docker.com/)
- [Docker Compose docs](https://docs.docker.com/compose/)
- [WP-CLI documentation](https://wp-cli.org/)
- [NGINX docs](https://nginx.org/en/docs/)
- [MariaDB docs](https://mariadb.com/kb/en/documentation/)

**AI usage**: Claude (Anthropic) was used to debug OS-migration issues (macOS → Debian: docker group permissions, hardcoded host paths, `/etc/hosts` domain resolution) and to fix shell-quoting bugs in `setup.sh` (unquoted variables breaking `wp-cli` argument parsing). All fixes were reviewed and understood before being applied; AI was not used to generate the Dockerfiles or the core docker-compose architecture.
