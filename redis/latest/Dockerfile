FROM redis:latest

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

ENV REDIS_LOG=/var/log/redis     \
    REDIS_CONF=/etc/redis        \
    REDIS_PID=/var/run/redis     \
    REDIS_DATA=/var/lib/redis

# groupadd -r -g 5000 redis && \
#    useradd -Mr -c "Redis User" -g 5000 -u 5000 redis && \
RUN    apt-get update && apt-get upgrade -y && \
    apt-get install -y redis-server && \
    apt-get clean all && apt-get autoclean && \
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf && \
    mkdir -p $REDIS_LOG $REDIS_CONF $REDIS_PID $REDIS_DATA && \
    chown -R redis:redis $REDIS_LOG $REDIS_CONF $REDIS_PID $REDIS_DATA

USER redis

WORKDIR ${REDIS_DATA}

VOLUME [${REDIS_DATA}, ${REDIS_LOG}]

EXPOSE 6379

ENTRYPOINT ["redis-server"]