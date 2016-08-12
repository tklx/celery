## Install dependencies

```console
git clone https://github.com/tklx/bats.git
bats/install.sh /usr/local
```

## Run the tests

```console
IMAGE=tklx/celery bats --tap tests/basics.bats
init: running tklx/celery
init: waiting for tklx/rabbitmq to accept connections..
1..1
ok 1 celery cluster is online

