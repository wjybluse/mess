GNU parallel的简单使用心得
1.命令感觉有点怪怪的，使用的方式parallel docker ::: build ::: -t ::: $application ::: $file_path
```shell
#每个参数可以是很多参数组成，执行的时候是一个正交的矩阵
parallel cmd ::: param1 ::: params2 :::.... :::paramsn
```
2.不知道具体在多核cpu上能不能提高性能，单核的肯定没用

3.可以通过ssh的配置将任务分配到不同的机器上去执行，真正的并行任务

4.build image的时候需要增加一个总的脚本，没测试过大镜像的build速度
