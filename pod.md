1.Kubernetes创建pod的速度会很慢如果是本地没有相应的镜像缓存的话，如果从私服里面去拉镜像的话速度会好一点
2.测试一下创建一个scale group和
3.建议将需要使用到的image push到本地私服，不然速度很慢，还容易失败
4.或者自己重新做镜像，比如自研的组件或者集成修改过的第三方组件，比如nginx，rabbitmq还有mongodb等
<pre>
//controller
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-scale-test
  labels:
    app: nginx-scale
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx-scale
    spec:
      containers:
      - name: nginx-scale
        image: nginx
        ports:
        - containerPort: 80

//service
apiVersion: v1
kind: Service
metadata:
  name: nginx-scale
spec:
  type: LoadBalancer
  loadBalancerIP: "172.20.10.124"
  ports:
  - port: 8777 # the port that this service should serve on
    targetPort: 80
    protocol: TCP
  selector:
    app: nginx-scale
</pre>
5.创建loadbalance类型的service
6.scale命令
```shell
  kubectl scale rc redis --replicas=3
```
8.
