1.mesos主要是一个资源管理器，可以支持各种形式的容器，docker或者是mesos，或者是compose等
2.利用zookeeper作为高可用额集群管理工具，发现master，切换等工作
3.如果需要使用ip前置特性的话需要给内核3.15打上补丁，补丁编号为[6a662719c9868b3d6c7d26b3a085f0cd3cc15e64,0d5edc68739f1c1e0519acbea1d3f0c1882a15d7,e374c618b1465f0292047a9f4c244bd71ab5f1f0,25f929fbff0d1bcebf2e92656d33025cd330cbf8]
4.slave节点上需要依赖libnl3 >= 3.2.26，iproute >= 2.6.39 is advised for debugging purpose but not required
5.配合任务调度器一起使用可以管理10w+的容器
