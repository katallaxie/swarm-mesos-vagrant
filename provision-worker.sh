#!/bin/bash

MANAGER_IP=$1
NODE_IP=$2
TOKEN=`cat /vagrant/worker_token`

if ! which docker >/dev/null 2>&1; then
	curl -sSL https://get.docker.com/ | sh
	gpasswd -a vagrant docker
	docker swarm join --listen-addr ${NODE_IP}:2377 --advertise-addr ${NODE_IP} --token=$TOKEN ${MANAGER_IP}:2377
fi



