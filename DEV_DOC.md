# Developer Documentation

## Prerequisites
- Docker Engine + `docker compose` plugin (v2, not the standalone `docker-compose`).
- Your user in the `docker` group (`sudo usermod -aG docker $USER`, then relog).
- `<login>.42.fr` resolving to `127.0.0.1` (add to `/etc/hosts` on a local setup).

## Configuration files / secrets
- `srcs/.env` — all environment variables (DB names/credentials, domain, WordPress admin/user credentials). Gitignored (see `.gitignore`, pattern `.env`) — must be recreated manually on any new machine/clone, it will **not** come from git.
- `secrets/` — reserved for Docker secrets files if used; currently unused, project relies on `.env` per the mandatory requirements.

To set up from scratch:
1. Clone the repo.
2. Create `srcs/.env` with the required variables (see `README.md` project description / the variable table in `USER_DOC.md`).
3. Add the domain to `/etc/hosts`.
4. Run `make`.

## Build and launch
```bash
make          # mkdir data dirs + docker compose up --build
make down     # docker compose down
make clean    # down + docker system prune -a + wipe data dirs
```
The Makefile targets `srcs/docker-compose.yml`, which builds one Dockerfile per service (`srcs/requirements/<service>/Dockerfile`) — no pre-built images are pulled except the base `debian:bookworm`.

## Managing containers and volumes
```bash
docker compose -f ./srcs/docker-compose.yml ps          # container status
docker compose -f ./srcs/docker-compose.yml logs -f <service>
docker compose -f ./srcs/docker-compose.yml exec <service> sh
docker compose -f ./srcs/docker-compose.yml build --no-cache <service>  # rebuild one image
docker volume ls                                          # list named volumes (srcs_db_data, srcs_wp_data)
```

## Data persistence
- `db_data` (named volume) → bound to `/home/<login>/data/mariadb` on the host, contains MariaDB's `/var/lib/mysql`.
- `wp_data` (named volume) → bound to `/home/<login>/data/wordpress` on the host, contains WordPress's `/var/www/wordpress`.

Both are declared as Docker named volumes with `driver_opts: type: none, o: bind` pointing at those host paths (see `srcs/docker-compose.yml`), so data survives `make down` but is wiped by `make clean`. WordPress install/config runs once on first boot via `srcs/requirements/wordpress/tools/setup.sh`, skipped on subsequent restarts if `wp-config.php` already exists in the volume.
