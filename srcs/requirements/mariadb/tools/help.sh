#!/bin/bash
set -e

echo "Initialisation de MariaDB en mode sécurisé..."

# 1. On lance MariaDB sans vérifier les permissions (indispensable si le socket bloque)
# On le lance en arrière-plan
mariadbd-safe --skip-grant-tables --skip-networking &

# 2. On attend que le processus soit prêt
until mariadb-admin ping >/dev/null 2>&1; do
    echo "Attente du démarrage du daemon..."
    sleep 1
done

echo "Configuration des accès pour : ${SQL_USER}"

# 3. Puisqu'on est en --skip-grant-tables, on utilise 'mariadb' sans user/pass
mariadb << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "Redémarrage de MariaDB en mode normal..."

# 4. On arrête le mode safe proprement
pkill mariadbd
sleep 2

# 5. On lance le vrai serveur (CMD)
echo "MariaDB est prêt !"
exec "$@"