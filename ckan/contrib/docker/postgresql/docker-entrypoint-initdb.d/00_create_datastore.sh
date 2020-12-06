#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE datastore_ro NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD '$DS_RO_PASS';
    CREATE DATABASE datastore OWNER ckan ENCODING 'utf-8';
    GRANT ALL PRIVILEGES ON DATABASE datastore TO ckan;
EOSQL

psql -d datastore -c 'CREATE EXTENSION postgis;'
