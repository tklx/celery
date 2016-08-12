fatal() { echo "fatal [$(basename $BATS_TEST_FILENAME)]: $@" 1>&2; exit 1; }

_in_cache() {
    IFS=":"; img=($1); unset IFS
    [[ ${#img[@]} -eq 1 ]] && img=("${img[@]}" "latest")
    [ "$(docker images ${img[0]} | grep ${img[1]} | wc -l)" = "1" ] || return 1
}

APPNAME=celery

IMAGE_MQ=tklx/rabbitmq
APPNAME_MQ=rabbitmq

[ "$IMAGE" ] || fatal "IMAGE envvar not set"
_in_cache "$IMAGE" || fatal "$IMAGE not in cache"

celery_eval() {
    docker run --rm -i \
        --link "$CNAME_MQ":rabbit \
        "$IMAGE" \
        "$@"
}

_init() {
    export TEST_SUITE_INITIALIZED=y

    echo >&2 "init: running $IMAGE"
    export CNAME_MQ="$APPNAME_MQ-$RANDOM-$RANDOM"
    export CID_MQ="$(docker run -d --name "$CNAME_MQ" "$IMAGE_MQ")"
    export CNAME="$APPNAME-$RANDOM-$RANDOM"
    export CID="$(docker run -d --link "$CNAME_MQ":rabbit --name "$CNAME" "$IMAGE")"
    [ "$CIRCLECI" = "true" ] || trap "docker rm -vf $CID > /dev/null" EXIT
    [ "$CIRCLECI" = "true" ] || trap "docker rm -vf $CID_MQ > /dev/null" EXIT

    echo -n >&2 "init: waiting for $IMAGE_MQ to accept connections"
    tries=10
    while ! celery_eval python -m celery status &> /dev/null; do
        (( tries-- ))
        if [ $tries -le 0 ]; then
            echo >&2 "$IMAGE failed to accept connections in wait window!"
            ( set -x && docker logs "$CID_MQ" ) >&2 || true
            false
        fi
        echo >&2 -n .
        sleep 2
    done
    echo
}
[ -n "$TEST_SUITE_INITIALIZED" ] || _init

@test "celery cluster is online" {
    celery_eval python -m celery status
    [ $? -eq 0 ]
}

