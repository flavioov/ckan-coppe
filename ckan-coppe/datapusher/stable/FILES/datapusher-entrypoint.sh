#!/bin/bash
set -e

source "${CKAN_HOME}/default/bin/activate"

exec python \
    "${DATAPUSHER_HOME}/datapusher/main.py" \
    "${DATAPUSHER_HOME}/deployment/datapusher_settings.py"