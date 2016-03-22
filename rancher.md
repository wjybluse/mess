>1.创建一个service的yml文件描述
```yml
#docker-compose.yml
kcsn:
  tty: true
  image: daocloud.io/nginx
  stdin_open: true

#rancher-compose.yml
kcsn:
  scale: 2
```

>2.创建一个loadbalance，简单的用例描述
```yml
#docker-compose.yml
slb:
  labels:
    io.rancher.scheduler.global: 'true'
  tty: true
  image: rancher/load-balancer-service
  ports:
  - 8778:80
  external_links:
  - kingdee/kcsn

#rancher-compose.yml

lb:
  scale: 1
  load_balancer_config:
    name: simple sonfig
kingdee/kcsn:
  scale: 1
```

