#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

# Forcer la propriété du dossier data
chown -R mysql:mysql "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
  echo "Initialisation de la base de données..."
  mariadb-install-db --user=mysql --datadir="$DATADIR"

  mysqld_safe --skip-networking --skip-grant-tables &

  until mysqladmin ping --silent; do
    sleep 1
  done

  mysql <<-EOSQL
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

  mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
  echo "Initialisation terminée"
fi

exec mysqld_safe
