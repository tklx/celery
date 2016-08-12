# tklx/celery - Distributed task queue
[![CircleCI](https://circleci.com/gh/tklx/celery.svg?style=shield)](https://circleci.com/gh/tklx/celery)

[Celery][celery] is an asynchronous task queue/job queue based on distributed message passing. It is focused on real-time operation, but supports scheduling as well. The execution units, called tasks, are executed concurrently on a single or more worker servers using multiprocessing, Eventlet, or gevent. Tasks can execute asynchronously (in the background) or synchronously (wait until ready). Celery is used in production systems to process millions of tasks a day.

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- Celery installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``ENV CELERY_BROKER_URL amqp://guest@rabbit`` so linking
  with a [RabbitMQ container][tklx-rabbitmq] works by default.

## Usage

### Start a celery worker utilizing RabbitMQ as broker
```console
$ docker run --name some-rabbitmq -d tklx/rabbitmq
$ docker run --link some-rabbitmq:rabbit --name some-celery -d tklx/celery
...

### Check the status of the cluster (RabbitMQ)
```console
$ docker run --link some-rabbitmq:rabbit --rm celery python -m celery status
```

### Start a celery worker utilizing Redis as broker
```console
$ docker run --name some-redis -d tklx/redis
$ docker run --link some-redis:redis -e CELERY_BROKER_URL=redis://redis --name some-celery -d tklx/celery
...

### Check the status of the cluster (Redis)
```console
$ docker run --link some-rabbitmq:rabbit -e CELERY_BROKER_URL=redis://redis --rm tklx/celery python -m celery status
```

## Automated builds

The [Docker image](https://hub.docker.com/r/tklx/celery/) is built, tested and pushed by [CircleCI](https://circleci.com/gh/tklx/celery) from source hosted on [GitHub](https://github.com/tklx/celery).

* Tag: ``x.y.z`` refers to a [release](https://github.com/tklx/celery/releases) (recommended).
* Tag: ``latest`` refers to the master branch.

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[celery]: http://www.celeryproject.org/
[tklx-rabbitmq]: https://github.com/tklx/rabbitmq
[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[gosu]: https://github.com/tianon/gosu
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues
