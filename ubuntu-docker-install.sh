#!/bin/bash
#!/bin/sh
#
remove() {
    echo "--------------------------"
    echo "- Uninstall old versions -"
    echo "--------------------------"

	sudo apt-get remove docker docker-engine docker.io containerd runc
}
init() {
    echo "--------------------------"
    echo "- Set up the repository  -"
    echo "--------------------------"

	sudo apt-get -y update
	sudo apt-get -y install \
	    ca-certificates \
	    curl \
	    gnupg \
	    lsb-release
}
install() {
    echo "----------------------------------"
    echo "- Add Docker’s official GPG key. -"
    echo "----------------------------------"

    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "--------------------------"
    echo "- docker install         -"
    echo "--------------------------"

    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
    sudo apt-get -y install docker-compose
    
    sudo apt-get -y update
    
    echo "docker -v"
    docker -v

#    sudo groupadd docker
    
    sudo usermod -aG docker ubuntu
    
    sudo service docker restart
}
uninstall() {
    if [ "$1" == "yes" ]; then
	    echo "--------------------------"
	    echo "- docker uninstall       -"
	    echo "--------------------------"

		sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
	
		sudo rm -rf /var/lib/docker
		sudo rm -rf /var/lib/containerd
    fi
}
docker_logs() {
    sudo du -h $(docker inspect --format='{{.LogPath}}' $(docker ps -qa))
}
remove_logs() {
    sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
}
case "$1" in
    remove)
        remove
        ;;
    init)
        init
        ;;
    install)
        install
        ;;
    uninstall)
        uninstall $2
        ;;
    auto)
        remove
        init
        install
        ;;
    logs)
        docker_logs
        ;;
    logs_remove)
        remove_logs
        ;;
    *)
    echo "Usage : $0 { remove | init | install | uninstall(yes) | auto | logs | logs_remove }"
    exit 1
esac
exit 0
