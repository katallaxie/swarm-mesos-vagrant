#!/bin/bash

MANAGER_IP=$1

if ! which docker >/dev/null 2>&1; then
	curl -sSL https://get.docker.com/ | sh
	gpasswd -a vagrant docker
	docker swarm init --listen-addr ${MANAGER_IP}:2377 --advertise-addr ${MANAGER_IP}
	docker swarm join-token -q worker > /vagrant/worker_token
    docker network create --driver overlay --opt encrypted mesos
	docker service create --detach=false --restart-delay 30s --restart-condition on-failure --name watchtower --mode global --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock centurylink/watchtower --cleanup
	docker service create  --container-label mesos=master -d -u root -p 8181:8181 --constraint 'node.role == manager' --network mesos --name exhibitor --mode global --restart-delay 30s --restart-condition any pixelmilk/exhibitor:1.5.6-3.4.10
    docker service create --container-label mesos=master -d -e MESOS_PORT=5050 -e MESOS_ZK=zk://exhibitor:2181/mesos -e MESOS_QUORUM=1 -e MESOS_REGISTRY=in_memory --restart-delay 30s --constraint 'node.role == manager' --network mesos --name mesos-master --mode global --restart-condition any pixelmilk/mesos-master:1.3.0-2.0.3
	docker service create -d -e MESOS_PORT=5051 -e MESOS_MASTER=zk://exhibitor:2181/mesos -e MESOS_SWITCH_USER=0 -e MESOS_CONTAINERIZERS=docker,mesos -e MESOS_WORK_DIR=/var/tmp/mesos -e MESOS_SYSTEMD_ENABLE_SUPPORT=false --mount type=bind,src=/sys/fs/cgroup,dst=/sys/fs/cgroup --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock --constraint 'node.role == worker' --network mesos --name mesos-agent --mode global --restart-condition any pixelmilk/mesos-agent:1.3.0-2.0.3
    sleep 5s; docker service create -d -p 8080:8080 --constraint 'node.role == worker' --network mesos --name marathon --mode replicated mesosphere/marathon --master zk://exhibitor:2181/mesos --zk zk://exhibitor:2181/marathon
fi

