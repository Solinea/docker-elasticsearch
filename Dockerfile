# vim:set ft=dockerfile:

# Adapted from https://github.com/docker-library/elasticsearch

FROM solinea/openjdk:jre7

MAINTAINER Luke Heidecke <luke@solinea.com>

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net \
                --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ELASTICSEARCH_MAJOR 2.x
ENV ELASTICSEARCH_VERSION 2.3.3
ENV GOSU_VERSION 1.7

RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true 


RUN groupadd -g 9010 elasticsearch \
  && useradd -d /home/elasticsearch -m -s /bin/false -u 9010 -g 9010 elasticsearch

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/$ELASTICSEARCH_MAJOR/debian stable main" \
  > /etc/apt/sources.list.d/elasticsearch.list

RUN pkgList=' \
   elasticsearch=$ELASTICSEARCH_VERSION \
  ' \
  && apt-get update -y -q -q \
  && apt-get install --no-install-recommends -y -q elasticsearch=$ELASTICSEARCH_VERSION \
  && apt-get purge -y --auto-remove wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

COPY config /usr/share/elasticsearch/config

COPY docker-entrypoint.sh /

RUN mkdir -p /usr/share/elasticsearch/data \
  && mkdir -p /usr/share/elasticsearch/logs \
  && chown elasticsearch:elasticsearch /docker-entrypoint.sh \
  && chmod 755 /docker-entrypoint.sh \ 
  && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

VOLUME /usr/share/elasticsearch/data

EXPOSE 9200 9300

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
