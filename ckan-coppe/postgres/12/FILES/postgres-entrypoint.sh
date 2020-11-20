#!/bin/bash

PG_MAJOR="12"
PGDATA="/var/lib/postgresql/$PG_MAJOR/data"

function CreateInitialDatabase {
  local INITDB_ARGS=$1

  initdb -D $PGDATA $INITDB_ARGS

  if [ $? -ne 0 ]; then
    echo "ERROR: Could not create an initial database."
    echo "HINT: Verify the permissions to user and group 5000 outside of this container."
    exit -1
  fi

}

function FlushAccessRoles {
  echo -e \
  "# TYPE       DATABASE     USER    ADDRESS     METHOD
  local      all          postgres                 peer"  > $PGDATA/pg_hba.conf
}

function CreateSuperuser {
  local USER=$1
  local PASS=$2
  local DATABASE=$3

  if [ "$USER" = "postgres" ]; then
    echo "You can't use the postgres account." > /dev/stderr
    echo "HINT: Use -e POSTGRES_USER=my_superuser -e POSTGRES_PASSWORD=my_secret params to docker run."
    exit -1
  fi

  if [ -z "$USER" ] || [ -z "$PASS" ]; then
    echo "POSTGRES_USER and/or POSTGRES_PASSWORD cannot be empty." > /dev/stderr
    echo "HINT: Use -e POSTGRES_USER=my_superuser -e POSTGRES_PASSWORD=my_secret params to docker run."
    exit -1
  fi

  psql -c "CREATE USER $USER WITH SUPERUSER ENCRYPTED PASSWORD '$PASS' VALID UNTIL 'infinity';"

  if [ -n "$DATABASE" ]; then
    psql -c "CREATE DATABASE $DATABASE WITH OWNER $USER;"
  else
    psql -c "CREATE DATABASE $USER WITH OWNER $USER;"
  fi

  echo -e \
  "# Default User
   local      all     all               trust
   host       all     all   0.0.0.0/0   md5" >> $PGDATA/pg_hba.conf

  echo "listen_addresses='*'" >> $PGDATA/postgresql.conf
}

function StartDatabase {
  pg_ctl -D $PGDATA -w start
}

function StopDatabase {
  pg_ctl -D $PGDATA -m smart -w stop
}

function ReloadDatabase {
  pg_ctl -D $PGDATA -m smart -w reload
}

function ChangePermissionsIfNecessary {

  local PERMISSION=`stat -c "%a" $PGDATA`

  if [[ $PERMISSION != "700" ]]; then
    echo "[WARNING] Modificando permissão do diretório $PGDATA para 700." > /dev/stderr
    chmod 700 $PGDATA
  fi

}

function Main {

  ChangePermissionsIfNecessary

  if [ ! -f "$PGDATA/PG_BEGIN" ]; then
    CreateInitialDatabase $POSTGRES_INITDB_ARGS
    FlushAccessRoles
    StartDatabase
    CreateSuperuser $POSTGRES_USER $POSTGRES_PASSWORD $POSTGRES_DATABASE
    ReloadDatabase
    StopDatabase

    echo `date +"%Y-%m-%d"` > $PGDATA/PG_BEGIN
  fi

  exec postgres -D $PGDATA
}

Main