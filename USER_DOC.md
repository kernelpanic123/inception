# User Documentation

## Services provided
- **Website**: a WordPress site at `https://<DOMAIN_NAME>`.
- **Administration panel**: WordPress admin at `https://<DOMAIN_NAME>/wp-admin`.
- **Database**: MariaDB, internal only (not reachable from outside the Docker network).

## Start / stop the project
From the repository root:
```bash
make        # build images and start all services
make down   # stop and remove the containers
make clean  # down + prune docker images/cache + wipe data folders
```

## Accessing the website and admin panel
- Website: `https://<DOMAIN_NAME>` (e.g. `https://abtouait.42.fr`)
- Admin panel: `https://<DOMAIN_NAME>/wp-admin`

The certificate is self-signed, so the browser will show a security warning on first visit — accept/continue to proceed. Make sure `<DOMAIN_NAME>` resolves to your machine's IP (see `/etc/hosts` if running locally).

## Credentials
All credentials are defined in `srcs/.env` (not committed to git):
| Variable | Purpose |
|---|---|
| `ADMIN_USER` / `ADMIN_PASSWORD` | WordPress administrator login |
| `USER1_LOGIN` / `USER1_PASS` | Second WordPress user (author role) |
| `SQL_USER` / `SQL_PASSWORD` | Database user used by WordPress |
| `SQL_ROOT_PASSWORD` | Database root password |

Never commit `.env` or share these values publicly.

## Checking that services are running
```bash
docker compose -f ./srcs/docker-compose.yml ps
```
All three containers (`nginx`, `wordpress`, `mariadb`) should show as `Up`/`running`. To inspect logs of a specific service:
```bash
docker compose -f ./srcs/docker-compose.yml logs <nginx|wordpress|mariadb>
```
If the website doesn't load, check `logs wordpress` (php-fpm/wp-cli errors) and `logs mariadb` first.
