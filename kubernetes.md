# Kubernets的安装
### 1.先安装docker，配置linux的信息
```shell
    CONFIG_RESOURCE_COUNTERS=y
    CONFIG_MEMCG=y
    CONFIG_MEMCG_SWAP=y
    CONFIG_MEMCG_SWAP_ENABLED=y
    CONFIG_MEMCG_KMEM=y
  
  #install docker for redhat series
  yum -y install docker
  
  
  #for debian series
  apt-get install docker?docker-io
  
  #enable cgroup when start OS 
  GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
  
  #install etcd
  docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
  
  #run master node
  docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    gcr.io/google_containers/hyperkube:v1.0.1 \
    /hyperkube kubelet --containerized --hostname-override="127.0.0.1" --address="0.0.0.0" --api-servers=http://localhost:8080 --config=/etc/kubernetes/manifests
    
    
  #run service proxy
  docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
  
  #config common node,ubuntu
  #config file cluster/ubuntu/config-default.sh
  
  export nodes="vcap@10.10.103.250 vcap@10.10.103.162 vcap@10.10.103.223"

  export role="ai i i"
  
  export NUM_NODES=${NUM_NODES:-3}
  
  export SERVICE_CLUSTER_IP_RANGE=192.168.3.0/24
  
  export FLANNEL_NET=172.16.0.0/16
  
  #config other os
  # all the same
```

### 2.构建自己镜像
### 3.部署
```shell
sudo cp kubernetes/platforms/linux/amd64/kubectl /usr/local/bin/kubectl #add kubetctl to path
sudo chmod +x /usr/local/bin/kubectl #change permission

#create file 
touch ~/.kube/config
```

Yml file 
```yml
apiVersion: v1
clusters:
- cluster:
    server: http://localhost:8080
  name: local-server
contexts:
- context:
    cluster: local-server
    namespace: the-right-prefix
    user: myself
  name: default-context
current-context: default-context
kind: Config
preferences: {}
users:
- name: myself
  user:
    password: secret
    username: admin
```

创建应用
```shell
kubectl run my-nginx --image=nginx --replicas=2 --port=80
#query pod
kubectl get po

#loadbalance type
kubectl expose rc my-nginx --port=80 --type=LoadBalancer
```
