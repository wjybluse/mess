1.Create Service without cluster ip
>Sometimes you don't need or want load-balancing and a single service IP. In this case, you can create "headless" services by specifying "None" for the cluster IP (spec.clusterIP).

2.Service Type contains (ClusterIP,NodePort,LoadBalancer),create cmd
```javascript
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "my-service"
    },
    "spec": {
        "selector": {
            //selector lable of pod?
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

3.Controller指定containerPort，就是导出端口，指定hostPort的话就是做端口映射到相应的主机，一般应该需要导出端口把，然后做一个service层的负载均衡

4.测试一下
