>1.如果升级docker，kubelete会挂掉，kube-proxy会挂掉，尼玛master也会挂掉吗？哈哈

>2.systemctl start kube-proxy,kubelet，需要启动服务，记住，尼玛被坑

>3.如果是master挂了的话可以直接启动kube-apiserver,kube-controller-manager,kube-scheduler

>4.如果是里面的容器挂了直接启动或者删除，容错性还是不错的

>5.可以给registry做一个缓存，感觉速度是快了点，但是不知道是不是很耗内存，这个对内存是一个挑战,具体实现
```shell
docker run -d -it --link reg-redis:redis \
   -e REGISTRY_STORAGE_CACHE_BLOBDESCRIPTOR=redis \
   -e REGISTRY_REDIS_ADDR=REDIS_PORT_6379_TCP_ADDR:6379 \
   -e CACHE_LRU_REDIS_HOST=REDIS_PORT_6379_TCP_ADDR\
   -e CACHE_LRU_REDIS_PORT=6379\
   -e CACHE_REDIS_HOST=REDIS_PORT_6379_TCP_ADDR\
   -e CACHE_REDIS_PORT=6379 \
   -v /tmp/data:/var/lib/registry \
   -e STORAGE_PATH=/tmp/data/repo \
   -p 5000:5000 \
   --name=private-reg daocloud.io/registry
```

>6.前端工具可以使用下面几种:docker-registry-ui,docker-registry-web,docker-registry-frontend

>7.升级的时候出现各种版本问题，现在还没想到好招来解决，需要后续继续查找资料

>8.今天任务算是比较完美完成，需要把registry集成到kubernetes里面额
