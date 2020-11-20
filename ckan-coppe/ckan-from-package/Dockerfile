FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

COPY ckan-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/ckan-entrypoint.sh

RUN echo "force-confold" >> /etc/dpkg/dpkg.cfg && \
    echo "force-confdef" >> /etc/dpkg/dpkg.cfg && \
    echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo wget vim curl libpq5 redis-server nginx supervisor python3-dev python3-pip

RUN wget http://packaging.ckan.org/python-ckan_2.9-py3-focal_amd64.deb && dpkg -i python-ckan_2.9-py3-focal_amd64.deb

USER ckan
EXPOSE 5000
ENTRYPOINT ["ckan-entrypoint.sh"]

CMD ["ckan","-c","/etc/ckan/ckan.ini", "run", "--host", "0.0.0.0"]
