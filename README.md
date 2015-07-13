# Postgres Dockerfile

Docker image that adds WAL-E on top of [sameersbn/docker-postgresql:9.4-1](https://github.com/sameersbn/docker-postgresql)

## Basic usage

```
$ docker run -d --name postgres \
  -v /store/cargo/postgres:/var/lib/postgresql \
  -v /store/cargo/wal-e-conf/wal-e.d:/etc/wal-e.d \
  -d postgresql-wal-e
ecbe828beac2
$ docker exec -u postgres ec envdir /etc/wal-e.d/env wal-e backup-push /var/lib/postgresql
wal_e.main   INFO     MSG: starting WAL-E
(...)
NOTICE:  pg_stop_backup complete, all required WAL segments have been archived
```

## WAL-E usage

This image comes with [WAL-E][wal-e] for performing continuous archiving of PostgreSQL WAL files and base backups.  To use WAL-E, you need to do a few things:

1. Create a directory with your secret environment variables (e.g. your AWS secret keys) in [envdir][envdir] format (one variable per file) and mount it as a volume overwriting `/etc/wal-e.d/env` when calling `docker run`.

## License

MIT license.
