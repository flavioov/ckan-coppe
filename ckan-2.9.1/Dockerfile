# See CKAN docs on installation from Docker Compose on usage
#FROM debian:stretch
FROM ubuntu:16.04
MAINTAINER Open Knowledge

# Define environment variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/venv
ENV CKAN_CONFIG /etc/ckan
ENV CKAN_STORAGE_PATH=/var/lib/ckan

# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Install required system packages
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install \
        python-dev \
        python-pip \
        python-virtualenv \
        python-wheel \
        python3-dev \
        python3-pip \
        python3-virtualenv \
        python3-wheel \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        postgresql-client \
        build-essential \
        git-core \
        vim \
        wget \
        checkinstall \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*


# Install required spatial extension/plugin packages
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
        libxslt1-dev \
        libgeos-dev \
        libgeos-c1v5 \
        python-geojson \
        #geos \
#        geopy \
#        libgeos-3.8.0 \
        #geoalchemy2 \
    && apt-get -q clean

# GDAL - demorado... ~20-30min
#RUN wget http://download.osgeo.org/geos/geos-3.8.1.tar.bz2 \
#        && tar -xf geos-3.8.1.tar.bz2 \
#        && cd geos-3.8.1 \
#        && ./configure --prefix=/usr \
#        && make \
#        && checkinstall && cd ..\
#        && rm -rf geos-3.8.1 && rm -rf geos-3.8.1.tar.bz2

#RUN export CPLUS_INCLUDE_PATH=/usr/include/geos
#RUN export C_INCLUDE_PATH=/usr/include/geos


# for not having to use the full command ckan -config=/etc/ckan/ckan.ini <command>
RUN export CKAN_INI=/etc/ckan/production.ini

# Create ckan user
RUN useradd -r -u 900 -m -c "ckan account" -d $CKAN_HOME -s /bin/false ckan

# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH && \
    virtualenv $CKAN_VENV && \
    ln -s $CKAN_VENV/bin/pip /usr/local/bin/ckan-pip &&\
    ln -s $CKAN_VENV/bin/paster /usr/local/bin/ckan-paster &&\
    ln -s $CKAN_VENV/bin/ckan /usr/local/bin/ckan

# Setup CKAN
ADD .. $CKAN_VENV/src/ckan/
RUN ckan-pip install -U pip && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirement-setuptools.txt && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirements-py2.txt && \
    ckan-pip install -e $CKAN_VENV/src/ckan/ && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    cp -v $CKAN_VENV/src/ckan/contrib/docker/ckan-entrypoint.sh /ckan-entrypoint.sh && \
    chmod +x /ckan-entrypoint.sh && \
    chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

ENTRYPOINT ["/ckan-entrypoint.sh"]
#RUN export CKAN_INI=/etc/ckan/venv/production.ini

USER ckan

# geoserver metadata spatial datastore usginmodels harvest
RUN . $CKAN_VENV/bin/activate && cd $CKAN_VENV/src/ \
    && git clone https://github.com/ngds/ckanext-spatial.git \
    && git clone https://github.com/ckan/ckanext-geoview.git \
    && pip install -e ckanext-spatial \
    && pip install -r ckanext-spatial/pip-requirements.txt \
    && pip install -e ckanext-geoview \
    && pip install -r ckanext-geoview/pip-requirements.txt
#    && pip install geos \
#    && pip install SQLAlchemy==0.8.7 GeoAlchemy2 \
#    && cd ckanext-spatial && python setup.py install && python setup.py build  && cd .. \


EXPOSE 5000

CMD ["ckan","-c","/etc/ckan/production.ini", "run", "--host", "0.0.0.0"]
