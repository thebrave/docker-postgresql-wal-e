FROM thebrave/postgresql:latest
MAINTAINER Jean Berniolles <jean@berniolles.fr>

# Install WAL-E dependencies
RUN apt-get update
RUN apt-get install -y \
  libxml2-dev \
  libxslt1-dev \
  python-all-dev \
  python-pip \
  daemontools \
  libevent-dev python-gevent python-netifaces \
  lzop \
  pv \
  postgresql-client

RUN apt-get install -y python-gevent autotools-dev python-all-dev libevent-dev \
  python-greenlet python-sphinx python-all-dbg

RUN echo -n > /var/lib/apt/extended_states

RUN pip install virtualenv

# Install WAL-E into a virtualenv
RUN virtualenv /var/lib/wal-e && \
  . /var/lib/wal-e/bin/activate && \
  pip install wal-e && \
  ln -s /var/lib/wal-e/bin/wal-e /usr/local/bin/wal-e

# Create directory for storing secret WAL-E environment variables
RUN umask u=rwx,g=rx,o= && \
  mkdir -p /etc/wal-e.d/env && \
  chown -R root:postgres /etc/wal-e.d

# Configure WAL-E
RUN echo "wal_level = archive # hot_standby is also acceptable (will log more)" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "archive_mode = on" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "archive_command = 'envdir /etc/wal-e.d/env wal-e wal-push %p'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "archive_timeout = 60" >> /etc/postgresql/9.4/main/postgresql.conf

# Remove build dependencies and clean up APT and temporary files
RUN apt-get remove --purge -y wget && \
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
