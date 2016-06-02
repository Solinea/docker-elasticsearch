#!/bin/bash

set -e

chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/config

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
  shift
  exec /usr/local/bin/gosu elasticsearch elasticsearch "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
