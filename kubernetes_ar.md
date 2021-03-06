1.Kubernetes的机构图
![Kubernetes]()

2.Kubernetes各个组件的作用
> Pod,一组容器集合，容器为最小单元，一个pod里面最好是同种类型应用额容器
> Service ,管理一组Pod集，做负载均衡,关系应该如下:
```shell
Service->Kube-Proxy
                  |-pod1
                  |-pod2
                  .
                  .
                  |-podn
#做同一类型的loadbalance
```

3.Cluster，一组物理机或者是虚拟机的集合，有一个master和多个slave组成，对环境没有特别的要求，结构
```shell
Cluster-----master
              |
              |-node1(slave,minion(下属))
              |-node2(slave,minion(下属))
              |-..
              |-noden(slave,minion(下属))
```

4.ReplicationController(备份控制器？)，管理pod的生命周期，主要负责pod的启停创建及删除，还负责pod的弹性伸缩，目前支持的功能比较简单，\
主要是简单的伸缩组的设置和简单指标的数据采集(cpu，目前支持的唯一指标)

5.Node,Kubernetes的节点，可以是物理机或者虚拟机，主要是work node，创建和调度pod的

6.Labels，一个应用组的标示，主要用于区分不同的应用组，使用的形式为Key:Value,可以由多组key-value组成

7.如果Service需要对可见的需要制定LoadBalancerIP和NodePort，Services可以同过clusterIP和内部的Service进行通信\
如果不指定LoadbalancerIP的时候服务只对内可见

8.创建对外开放的服务，制定external ip(loadbalancerip)
```json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "my-service"
    },
    "spec": {
        "selector": {
            "app": "MyApp"
        },
        "ports": [
            {
                "protocol": "TCP",
                "port": 80,
                "targetPort": 9376,
                "nodePort": 30061
            }
        ],
        "clusterIP": "10.0.171.239",
        "loadBalancerIP": "78.11.24.19",
        "type": "LoadBalancer"
    },
    "status": {
        "loadBalancer": {
            "ingress": [
                {
                    "ip": "146.148.47.155"
                }
            ]
        }
    }
}
```
集群中不同节点可见
```json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "my-service"
    },
    "spec": {
        "selector": {
            "app": "MyApp"
        },
        "ports": [
            {
                "name": "http",
                "protocol": "TCP",
                "port": 80,
                "targetPort": 9376
            }
        ],
        "externalIPs" : [
            "80.11.12.10"
        ]
    }
}
```
9.缺点，不适合大型集群(包含成千上万的service的环境)做伸缩

10.Kube-proxy自动发现服务，发现EndPoint,在iptable注册相应的路由规则,能够和backend的pod通讯，其实就是一个service?




