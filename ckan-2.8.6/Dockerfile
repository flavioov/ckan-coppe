# See CKAN docs on installation from Docker Compose on usage
FROM debian:jessie
MAINTAINER Open Knowledge

# Install required system packages
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install \
        python-dev \
        python-pip \
        python-virtualenv \
        python-wheel \
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
        iputils-ping \
        python-imaging \
        checkinstall \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

# GDAL - demorado... ~20-30min
RUN wget https://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz \
        && tar -xvzf gdal-$GDAL_VERSION.tar.gz \
        && cd gdal-$GDAL_VERSION \
        && ./configure --prefix=/usr \
        && make \
        && checkinstall \
        && rm -rf gdal-$GDAL_VERSION

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

RUN export CKAN_INI=/etc/ckan/default/production.ini

# Define environment variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/venv
ENV CKAN_CONFIG /etc/ckan
ENV CKAN_STORAGE_PATH=/var/lib/ckan
ENV GDAL_VERSION 2.4.4

ENV GDAL_VERSION 2.4.4

# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Create ckan user
RUN useradd -r -u 900 -m -c "ckan account" -d $CKAN_HOME -s /bin/false ckan

# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH && \
    virtualenv $CKAN_VENV && \
    ln -s $CKAN_VENV/bin/pip /usr/local/bin/ckan-pip &&\
    ln -s $CKAN_VENV/bin/paster /usr/local/bin/ckan-paster

# Setup CKAN
ADD . $CKAN_VENV/src/ckan/
RUN ckan-pip install -U pip && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirement-setuptools.txt && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirements.txt && \
    ckan-pip install -e $CKAN_VENV/src/ckan/ && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    cp -v $CKAN_VENV/src/ckan/contrib/docker/ckan-entrypoint.sh /ckan-entrypoint.sh && \
    chmod +x /ckan-entrypoint.sh && \
    chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

ENTRYPOINT ["/ckan-entrypoint.sh"]

USER ckan

# geoserver metadata spatial datastore usginmodels harvest
RUN . $CKAN_VENV/bin/activate && cd $CKAN_VENV/src/ \
    && pip install -U setuptools lxml pillow ndg-httpsclient usginmodels shapely \
    && git clone https://github.com/ngds/ckanext-geoserver.git \
    && git clone https://github.com/flavioov/ckanext-datastore.git \
    && pip install -e ckanext-geoserver \
    && pip install -e ckanext-datastore \
    #geoserver
#    && pip install gdal==$GDAL_VERSION gsconfig \
    && pip install SQLAlchemy==0.8.7 GeoAlchemy2 \
    && cd ckanext-geoserver && python setup.py install && python setup.py build  && cd .. \
    && cd ckanext-datastore && python setup.py install && python setup.py build

EXPOSE 5000

CMD ["ckan-paster","serve","/etc/ckan/production.ini"]
