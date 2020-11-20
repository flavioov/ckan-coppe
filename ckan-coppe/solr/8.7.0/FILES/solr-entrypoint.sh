#!/bin/bash
set -e

serverArguments=(
    -jar
    -server
    -Dfile.encoding=UTF8
    -Djava.headless=True
)

userArgs=${@}

exec java ${serverArguments[@]} ${userArgs} ${SOLR_HOME}/start.jar
