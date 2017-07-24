# swarm-mesos-vagrant

## Setup

``` 
    vagrant up
```


## Play with it

> Exhibitor [192.168.100.2:8181](http://192.168.100.2:8181), Marathon [192.168.100.2:8080](http://192.168.100.2:8080)

Run the Swarm manager 

```
	vagrant ssh manager
```

```
docker info
docker node ls
```

Run the Swarm worker

```
    vagrant ssh worker-1
```

## Container in Overlay Network with Marathon

First run in the console

```
    vagrant ssh manager

    sudo -i

    docker network create --driver overlay --attachable proxy
```

Visit [192.168.100.2:8080](http://192.168.100.2:8080) and create a container with `BRIDGE` network and Docker parameter `network: proxy`. This can either be done via the GUI or with JSON Mode.

```json
{
  "id": "/nginx",
  "cmd": null,
  "cpus": 1,
  "mem": 128,
  "disk": 0,
  "instances": 0,
  "acceptedResourceRoles": [
    "*"
  ],
  "container": {
    "type": "DOCKER",
    "volumes": [],
    "docker": {
      "image": "nginx",
      "network": "BRIDGE",
      "portMappings": [],
      "privileged": false,
      "parameters": [
        {
          "key": "network",
          "value": "proxy"
        }
      ],
      "forcePullImage": false
    }
  },
  "portDefinitions": [
    {
      "port": 10000,
      "protocol": "tcp",
      "name": "default",
      "labels": {}
    }
  ]
}
```
