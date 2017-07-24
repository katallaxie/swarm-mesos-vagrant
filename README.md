# swarm-mesos-vagrant

## Setup

``` 
    vagrant up
```


# Play with it

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

