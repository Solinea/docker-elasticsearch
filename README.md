solinea/elasticsearch
---

Elasticsearch running on OpenJDK JRE 7 and stable Debian.

`solinea/elasticsearch` is a Docker image based on `solinea/openjdk`.

# Usage

Create a Dockerfile with the following content:

    FROM solinea/elasticsearch

    ADD config /usr/share/elasticsearch/config

This overlay any configuration files you have placed in the config directory
(including subdirectories). This config overlay is useful if you want to provide
any custom templates for your index.

In addition, environment variables can be set for any properties supported by
Elasticsearch.

    FROM solinea/elasticsearch

    ENV ES_HEAP_SIZE 256M
    ENV ES_JAVA_OPTS="-Des.cluster.name=docker"

# Connecting

## Ports

Port     | Use
---------|-----------------
tcp/9200 | RESTful API
tcp/9300 | Cluster Transport