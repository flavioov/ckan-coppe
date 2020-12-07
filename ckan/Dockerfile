# docker build . -t ckan && docker run -d -p 80:5000 --link db:db --link redis:redis --link solr:solr ckan

FROM ubuntu:16.04
MAINTAINER Open Knowledge


# Define environment variables
ENV CKAN_USER_HOME /usr/lib/ckan
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_STORAGE_PATH /var/lib/ckan
ENV CKAN_SITE_URL http://localhost:5000
ENV CKAN_VENV $CKAN_USER_HOME/default

ENV GDAL_VERSION 2.4.4

# Install required packages
RUN apt-get -q -y update && apt-get -q -y upgrade \
      && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
      python-dev \
      python-lxml \
      python-pip \
      python-virtualenv \
      libffi-dev \
      libpq-dev \
      libssl-dev \
      libgeos-dev \
      libxml2-dev \
      git-core \
      wget \
#      build-dep \ #erro ...
      python-imaging \
      checkinstall \
      vim \
      && apt-get -q clean


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



# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Create ckan user
RUN useradd -r -u 900 -m -c "ckan account" -d $CKAN_USER_HOME -s /bin/false ckan


# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH && \
    virtualenv $CKAN_VENV && \
    ln -s $CKAN_VENV/bin/pip /usr/local/bin/ckan-pip &&\
    ln -s $CKAN_VENV/bin/paster /usr/local/bin/ckan-paster &&\
    ln -s $CKAN_VENV/bin/ckan /usr/local/bin/ckan


# Update pip version
RUN ckan-pip install -U pip

# SetUp Requirements
# https://github.com/ckan/ckan/pull/4197
ADD ./requirement-setuptools.txt $CKAN_VENV/src/ckan/requirement-setuptools.txt
RUN ckan-pip install --upgrade -r $CKAN_VENV/src/ckan/requirement-setuptools.txt
ADD ./requirements.txt $CKAN_HOME/src/ckan/requirements.txt
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/requirements.txt

# TMP-BUGFIX https://github.com/ckan/ckan/issues/3388
ADD ./dev-requirements.txt $CKAN_HOME/src/ckan/dev-requirements.txt
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/dev-requirements.txt

# TMP-BUGFIX https://github.com/ckan/ckan/issues/3594
RUN ckan-pip install --upgrade urllib3

# Setup CKAN
ADD . $CKAN_VENV/src/ckan/
RUN ckan-pip install -U pip && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirement-setuptools.txt && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirements.txt && \
    ckan-pip install -e $CKAN_VENV/src/ckan/ && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    cp -v $CKAN_VENV/src/ckan/contrib/docker/ckan-entrypoint.sh /ckan-entrypoint.sh && \
    chmod +x /ckan-entrypoint.sh && \
    chown -R ckan:ckan $CKAN_USER_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH /etc/ckan


RUN mkdir /var/tmp/GeoserverUpload && \
    chmod 777 -R /var/tmp && \
    chmod 777 -R /var/tmp/GeoserverUpload

ADD ./geoservice/* /var/tmp/GeoserverUpload/

# ckna config export path
RUN export CKAN_INI=/etc/ckan/default/ckan.ini

# SetUp EntryPoint
COPY ./contrib/docker/ckan-entrypoint.sh /
RUN chmod +x /ckan-entrypoint.sh
ENTRYPOINT ["/ckan-entrypoint.sh"]

USER ckan

# geoserver metadata spatial datastore usginmodels harvest
RUN . $CKAN_VENV/bin/activate && cd $CKAN_VENV/src/ \
    && pip install -U setuptools lxml pillow ndg-httpsclient usginmodels shapely \
    && git clone https://github.com/ngds/ckanext-metadata.git \
    && git clone https://github.com/ngds/ckanext-spatial.git \
    && git clone https://github.com/ngds/ckanext-geoserver.git \
    && git clone https://github.com/flavioov/ckanext-datastore.git \
    && git clone https://github.com/ngds/ckanext-harvest.git \
    && pip install -e git+https://github.com/REI-Systems/usginmodels.git@build#egg=usginmodels \
    && python ./usginmodels/setup.py build && python ./usginmodels/setup.py install \
    && pip install -e ckanext-metadata \
    && pip install -e ckanext-harvest \
    && pip install -e ckanext-spatial \
    && pip install -e ckanext-geoserver \
    && pip install -e ckanext-datastore \
    #geoserver
    && pip install gdal==$GDAL_VERSION gsconfig \
    #harvest
    && pip install SQLAlchemy==0.8.7 GeoAlchemy2 \
    && pip install -r ./ckanext-spatial/pip-requirements.txt && pip install -U requests \
    && cd ckanext-metadata && python setup.py install && python setup.py build  && cd .. \
    && cd ckanext-harvest && python setup.py install && python setup.py build  && cd .. \
    && cd ckanext-spatial && python setup.py install && python setup.py build  && cd .. \
    && cd ckanext-geoserver && python setup.py install && python setup.py build  && cd .. \
    && cd ckanext-datastore && python setup.py install && python setup.py build

EXPOSE 5000
CMD ["ckan-paster","serve","/etc/ckan/default/ckan.ini"]
