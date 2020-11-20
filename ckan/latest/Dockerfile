FROM ubuntu:20.04

#LABEL maintainer="CAPGov-INFRA <capgov@cos.ufrj.br>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN echo "force-confold" >> /etc/dpkg/dpkg.cfg && \
    echo "force-confdef" >> /etc/dpkg/dpkg.cfg && \
    echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

COPY ckan-entrypoint.sh /usr/local/bin


# Install the recommended setuptools version and up-to-date pip:
#
# pip install setuptools==44.1.0
# pip install --upgrade pip

ARG ckanVersion="2.9.1"
ARG setupToolsVersion="44.1.0"
ARG html5libVersion="1.1"
ARG bleachVersion="3.2.1"

ENV CKAN_VERSION=${ckanVersion}   \
    CKAN_HOME=/usr/lib/ckan       \
    CKAN_CONFIG=/etc/ckan/default \
    CKAN_VIRTUALENV=default       \
    CKAN_DATA=/var/data/ckan      \
    CKAN_LOG=/var/log/ckan

USER root

# python-pip --> python3-pip
# python-virtualvenv --> python3-virtualvenv
# deleted python-virtualenv
# added python2.7
# modif python-dev --> python2.7-dev

# add pip to repository ubuntu 20.04
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe -y && apt update  && apt-get upgrade -y \
    && apt install -y python2 curl && curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && python2 get-pip.py


RUN groupadd -r -g 5000 ckan && \
    useradd -mr -c "CKAN User" -d ${CKAN_HOME} -g 5000 -u 5000 ckan && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y gcc git-core postgresql-client libpq-dev \
    python2-dev libmemcached-dev zlib1g-dev && \
    apt-get clean all && apt-get autoclean && \
    pip2 install --force-reinstall --upgrade pip PasteDeploy PasteScript testrepository psycopg2 virtualenv && \
    mkdir -p ${CKAN_CONFIG} ${CKAN_LOG} ${CKAN_DATA} && \
    chmod +x /usr/local/bin/ckan-entrypoint.sh && \
    chown -R ckan:ckan ${CKAN_HOME} ${CKAN_CONFIG} ${CKAN_LOG} ${CKAN_DATA}


USER ckan

WORKDIR ${CKAN_HOME}

# Instalação do ckan 'from sources'
# egg=ckan --> egg=ckan[requirements]
RUN virtualenv ${CKAN_VIRTUALENV} && \
    . ${CKAN_VIRTUALENV}/bin/activate && \
    pip2 install --upgrade pip PasteDeploy testrepository psycopg2 bleach && \
    pip2 install setuptools==${setupToolsVersion} && \
    pip2 install html5lib==${html5libVersion} && \
    pip2 install bleach==${bleachVersion} && \
    pip2 install -e "git+https://github.com/ckan/ckan.git@ckan-${CKAN_VERSION}#egg=ckan" && \
    pip2 install -r ${CKAN_VIRTUALENV}/src/ckan/pip-requirements-docs.txt && \
    deactivate

VOLUME [${CKAN_DATA}, ${CKAN_LOG}]

EXPOSE 5000

#default command to execute at runtime
ENTRYPOINT ["ckan-entrypoint.sh"]
