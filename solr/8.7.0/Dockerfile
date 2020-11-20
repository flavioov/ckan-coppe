FROM java

COPY FILES/* /tmp/

ENV SOLR_VERSION=8.7.0 \
    SOLR_HOME=/opt/solr

# download https://downloads.apache.org/lucene/solr/8.7.0/solr-8.7.0.tgz
RUN groupadd -r -g 5000 solr && \
    useradd -Mr -c "Apache Solr User" -u 5000 -g 5000 solr && \
    mkdir -p ${SOLR_HOME} && \
    tar zxf /tmp/solr-${SOLR_VERSION}.tgz -C /tmp --strip-components=1 && \
    cp -Rf /tmp/example/* ${SOLR_HOME} && \
    rm -rf ${SOLR_HOME}/{example-DIH,exampledocs,work,multicore} && \
    mv /tmp/*.sh /usr/local/bin && chmod +x /usr/local/bin/*.sh && \
    rm -rf /tmp/* && \
    chown -R solr:solr ${SOLR_HOME}

USER solr

WORKDIR ${SOLR_HOME}

EXPOSE 8983

ENTRYPOINT ["solr-entrypoint.sh"]