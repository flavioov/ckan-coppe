FROM ubuntu:20.04

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
    apt-get install -y wget vim curl gnupg gnupg1 gnupg2

COPY FILES/postgres-entrypoint.sh /usr/local/bin

ENV PATH=${PATH}:/usr/lib/postgresql/12/bin \
    LANG=en_US.utf8

RUN groupadd -r -g 5000 postgres && \
    useradd -Mr -c "Postgres User" -g 5000 -u 5000 postgres && \
    echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql postgresql-contrib && \
    apt-get remove wget -y && \
    apt-get clean all && apt-get autoclean && apt-get autoremove -y && \
    chmod +x /usr/local/bin/postgres-entrypoint.sh && \
    mkdir -p /var/lib/postgresql/12/data && \
    chown -R postgres:postgres /var/lib/postgresql && \
    locale-gen ${LANG}

USER postgres

EXPOSE 5432

WORKDIR /var/lib/postgresql/12

VOLUME ["/var/lib/postgresql/12/data"]

ENTRYPOINT ["postgres-entrypoint.sh"]