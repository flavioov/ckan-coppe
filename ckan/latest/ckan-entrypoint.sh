#!/bin/bash
set -e

CKAN_VIRTUALENV_HOME="$CKAN_HOME/$CKAN_VIRTUALENV"

CKAN_CONFIG_PRODUCTION="$CKAN_CONFIG/production.ini"

CKAN_SOURCE_HOME="$CKAN_HOME/default/src/ckan"

function ValidateParameters
{
  if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DATABASE" ] ; then
    echo "[ERROR] POSTGRES_USER, POSTGRES_PASSWORD and POSTGRES_DATABASE could not be empty." > /dev/stderr
    exit 1
  fi

  if [ -z "$POSTGRES_DATASTORE_DATABASE" ] || [ -z "$POSTGRES_DATASTORE_READONLY_USER" ] || [ -z "$POSTGRES_DATASTORE_READONLY_PASSWORD" ] ; then
    echo "[ERROR] POSTGRES_DATASTORE_DATABASE, POSTGRES_DATASTORE_READONLY_USER and POSTGRES_DATASTORE_READONLY_PASSWORD could not be empty." > /dev/stderr
    exit 1
  fi

  if [ -z "$CKAN_OFICIAL_SITE_URL" ]; then
    echo "[WARN] CKAN_OFICIAL_SITE_URL is empty. Assuming as CKAN_OFICIAL_SITE_URL=localhost." > /dev/stderr
    CKAN_OFICIAL_SITE_URL='locahost'
  fi
}

function ActivatePythonVirtualEnvironment
{
  . "$CKAN_VIRTUALENV_HOME/bin/activate"
}

function CreateInitialConfiguration
{
  paster make-config ckan "$CKAN_CONFIG_PRODUCTION"
}

function EditCKANConfiguration
{
  sed -i "s|sqlalchemy.url =.*|sqlalchemy.url = postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@ckan-database/$POSTGRES_DATABASE|g" "$CKAN_CONFIG_PRODUCTION"

  sed -i "s|ckan.datastore.write_url =.*|ckan.datastore.write_url = postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@ckan-database/$POSTGRES_DATASTORE_DATABASE|g" "$CKAN_CONFIG_PRODUCTION"

  sed -i "s|ckan.datastore.read_url =.*|ckan.datastore.read_url = postgresql://$POSTGRES_DATASTORE_READONLY_USER:$POSTGRES_DATASTORE_READONLY_PASSWORD@ckan-database/$POSTGRES_DATASTORE_DATABASE|g" "$CKAN_CONFIG_PRODUCTION"

  sed -i "s|#solr_url =.*|solr_url = http://ckan-solr:8983/solr|g" "$CKAN_CONFIG_PRODUCTION"

  sed -i "s|ckan.site_url =.*|ckan.site_url = http://$CKAN_OFICIAL_SITE_URL|g" "$CKAN_CONFIG_PRODUCTION"

  sed -i "s|#ckan.storage_path =.*|ckan.storage_path = $CKAN_DATA|g" "$CKAN_CONFIG_PRODUCTION"
}

function InitializeDatabase
{
  paster db init -c "$CKAN_CONFIG_PRODUCTION"
}

function InitializeServer
{
  exec paster serve $CKAN_CONFIG_PRODUCTION 2>&1 | tee "$CKAN_LOG/$HOSTNAME.log"
}

function Main
{
  ValidateParameters

  if [ ! -f "$CKAN_CONFIG/who.ini" ]; then
    cp "$CKAN_SOURCE_HOME/who.ini" "$CKAN_CONFIG/who.ini"
  fi

  ActivatePythonVirtualEnvironment

  cd "$CKAN_SOURCE_HOME"

  if [ ! -f "$CKAN_CONFIG_PRODUCTION" ]; then
    CreateInitialConfiguration

    InitializeDatabase
  fi

  EditCKANConfiguration

  InitializeServer
}

Main
