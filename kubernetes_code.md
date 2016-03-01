1.Kubelet发送消息给master负责创建pod，pod里面包含了container，创建的pod成文件的形式保存在/var/lib/kubelet/pods下面
2.kubernetes创建的容器命名有一套规范，<prefix>_<container_name.hash>_<container_fullname>_<container_id>
3.可以适配不同的cloud创建container，包括简单的vagrant平台,fake,aws,rackspace等
4.通过iptables设置路由，主要是让容器之间能互通，默认使用用户空间代理(userspace proxy)
5.负载均衡支持session亲和策略，使用iptable自身来做负载均衡(这个绝)
