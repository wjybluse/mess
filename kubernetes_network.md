# Kubernetes 网络部分
> 1.不同于传统的docker模型，每个container有一个自己的IP，container需要知道自己不能及的IP才能做通信

> 2.Kubernetes的一般模型为，每个pod的一个浮动的space，内部的container看到的都是同一个IP，内部container之间可以通过数据共享或者是进程间通信来完成

> 3.Kubernetes提供的模型叫做IP-per-pod-model模型，通过配置路由或者第三方的工具解决，解决方式如下

>> 1.GCE's advanced routing,在GCE使用的，google专属

>> 2.OpenVSwitch GRE/VxLAN,通过OpenVSwitch GRE/VxLAN tunnel来做，原理如下：
![VxLan Tunnel](https://github.com/kubernetes/kubernetes/blob/master/docs/admin/ovs-networking.png)

>> 3.Flannel,通过flannel来解决，模型如下，flannel就是一个简单的router?
![Flannel](https://github.com/coreos/flannel/blob/master/packet-01.png)

>> 4.Linux Bridge device(L2)

>>5.Calico
![Calico](http://www.projectcalico.org/wp-content/uploads/2015/03/why-bgp-networks.svg)
