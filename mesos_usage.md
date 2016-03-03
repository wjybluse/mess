>1.mesos主要是一个资源管理器，可以支持各种形式的容器，docker或者是mesos，或者是compose等

>2.利用zookeeper作为高可用额集群管理工具，发现master，切换等工作

>3.如果需要使用ip前置特性的话需要给内核3.15打上补丁，补丁编号为[6a662719c9868b3d6c7d26b3a085f0cd3cc15e64,0d5edc68739f1c1e0519acbea1d3f0c1882a15d7,e374c618b1465f0292047a9f4c244bd71ab5f1f0,25f929fbff0d1bcebf2e92656d33025cd330cbf8]

>4.slave节点上需要依赖libnl3 >= 3.2.26，iproute >= 2.6.39 is advised for debugging purpose but not required

>5.配合任务调度器一起使用可以管理10w+的容器

>6.主要使用形式,一套完整的解决方案
>>1).HA -- run any number of Marathon schedulers, but only one gets elected as leader; if you access a non-leader, your request gets proxied >>to the current leader
>>2).Constraints - e.g., only one instance of an application per rack, node, etc.
>>3).Service Discovery & Load Balancing via HAProxy or the events API (see below).
>>4).Health Checks: check your application's health via HTTP or TCP checks.
>>5).Event Subscription lets you supply an HTTP endpoint to receive notifications, for example to integrate with an external load balancer.
>>6).Marathon UI
>>7).JSON/REST API for easy integration and scriptability
>>8).Basic Auth and SSL
>>9).Metrics: query them at /metrics in JSON format or push them to graphite/statsd/datadog.

>7.Marathon依赖libmesos,所以安装的时候需要先安装mesos



