#!/bin/bash
#!/bin/sh
#clear-docker-log.sh
#
docker_logs() {
    sudo du -h $(docker inspect --format='{{.LogPath}}' $(docker ps -qa))
}
remove_logs() {
    sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
}
case "$1" in
    logs)
        docker_logs
        ;;
    logs_remove)
        remove_logs
        ;;
    *)
    echo "Usage : $0 { logs | logs_remove }"
    exit 1
esac
exit 0

