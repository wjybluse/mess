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
#can change
```

>3.创建一个内部服务
```yml
#docker-compose.yml
redis:
  image: redis
#rancher-compose.yml
redis:
  image: redis
  external_ips:
  - 10.42.134.135
  - 10.42.133.133
#very easy and simple to create external service
#maybe you add you tag or other things,now test redirect
```

>4.loadbalance默认使用了一个haproxy做为代理，所以部署的时候可以尽量的最大化使用，感觉非常赞的一个东西

>5.使用了rancher-net做为网络插件，达到了跨主机通讯的目的

>6.有自己的dns解析器

