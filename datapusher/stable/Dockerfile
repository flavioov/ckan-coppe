FROM ubuntu:18.04

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

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget vim curl


ARG datapusherBranch="stable"

COPY ./FILES/datapusher-entrypoint.sh /usr/local/bin

ENV CKAN_HOME="/usr/lib/ckan" \
    DATAPUSHER_HOME="/usr/lib/ckan/default/src/datapusher"

RUN groupadd -r -g 5000 ckan && \
    useradd -mr -c "CKAN User" -d ${CKAN_HOME} -g 5000 -u 5000 ckan && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y python-dev python-virtualenv build-essential libxslt1-dev libxml2-dev zlib1g-dev git && \
    apt-get clean all && apt-get autoclean && \
    mkdir -p ${CKAN_HOME} && \
    chmod +x /usr/local/bin/*.sh && \
    chown -R ckan:ckan ${CKAN_HOME}

USER ckan

WORKDIR ${CKAN_HOME}

RUN virtualenv default && \
    . default/bin/activate && \
    pip install --upgrade pip setuptools && \
    pip install -e "git+https://github.com/ckan/datapusher.git@${datapusherBranch}#egg=datapusher" && \
    pip install -r ${DATAPUSHER_HOME}/requirements.txt

EXPOSE 8800

ENTRYPOINT ["datapusher-entrypoint.sh"]
