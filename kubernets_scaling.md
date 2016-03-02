# Kubernetes AutoScaling
> 1.Use Api or CMD create autoscaler pod

> 2.Setting max and min instances(container or vms),config metric data
> ```shell
>  kubectl autoscale rc foo --min=2 --max=5 --cpu-percent=80 #create autoscale pod with max ,min instance and threshold 
>  
> #get autoscale group 
> kubectl get hpa
>
>```

> 3.Horizontal pod autoscaler does not work with rolling update using direct manipulation of replication controllers, i.e.\
you cannot bind a horizontal pod autoscaler to a replication controller and do rolling update (e.g. using kubectl rolling-update).\
The reason this doesn't work is that when rolling update creates a new replication controller,\
the horizontal pod autoscaler will not be bound to the new replication controller.(scale cannot use in replication)

> 4.Support simple condition(like cpu usage),auto scale in when usage is small enough

> 5.Extenstion

> 6.Unspported more futrues in new version kubernetes,may be in next version can find more

> 7.Cannot scaling when update-roll or deploy

> 8.Create one autoscaling group 
```shell
kubectl autoscale -f pod_with_scale_controller.yaml --min=2 --max=5 --cpu-percent=10
```

> 9.AutoScaling主要是利用heapster做数据采集，然后存入influxdb里面，之后分析，然后做扩容或者缩容，必须保证数据采集能成功，现在环境报的错为Code: System error，Message: not a directory，不是一个目录，应该还挂在卷不成功，跟docker版本有关系吧

> 8.之前通过kubectl autoscale -f <filename> 应该也没问题，需要验证一下 



