### Skydns的简单使用
1.安装，官方没有提供安装二进制包，所以需要自己编译,编译的过程很简单
>1)安装新版的golang，不能低于1.5，目前用来编译的为1·6
```shell
wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
tar -xvf go1.6.linux-amd64.tar.gz
cd go
export GOROOT=`pwd`
export PATH=$PATH:$GOROOT/bin
cd ..
mkdir gobuild
cd gobuild
export GOPATH=`pwd`
```
>2).下载skydns的源码进行编译
```shell
go get github.com/skynetservices/skydns
cd $GOPATH/src/github.com/skynetservices/skydns
go build -v .
```

>3).配置环境变量
```shell
export ETCD_MACHINE=xxx:4001
export SKYDNS_ADDR=0.0.0.0:53
```

>4).安装etcd,etcd最好做集群安装
```shell
#download binary package from repo
wget https://github.com/coreos/etcd/releases/download/v2.3.0/etcd-v2.3.0-linux-amd64.tar.gz
tar -xvf etcd-v2.3.0-linux-amd64.tar.gz
mv etcd-v2.3.0-linux-amd64 etcd
cd etcd
./etcd &
```

>5).配置域名映射
>> **skydns 默认生成域名的方式为rails.production.east.skydns.local** skydns.local为默认后缀，可以修改试试

>> 配置一个域名
```shell
#可以指定具体的添加对象
curl -XPUT http://127.0.0.1:4001/v2/keys/skydns/local/skydns/east/production/rails/1 \
    -d value='{"host":"service1.example.com","port":8080}'
curl -XPUT http://127.0.0.1:4001/v2/keys/skydns/local/skydns/west/production/rails/2 \
    -d value='{"host":"service2.example.com","port":8080}'
curl -XPUT http://127.0.0.1:4001/v2/keys/skydns/local/skydns/east/staging/rails/4 \
    -d value='{"host":"10.0.1.125","port":8080}'
curl -XPUT http://127.0.0.1:4001/v2/keys/skydns/local/skydns/east/staging/rails/6 \
    -d value='{"host":"2003::8:1","port":8080}'
```

>6).测试，添加dns解析器到/etc/resov.conf,配置在最前面的位置
```shell
#this is testing
search kingdee.rancher.internal wordpress.kingdee.rancher.internal rancher.internal
nameserver 172.20.200.175
nameserver 169.254.169.250
#ping unknown server register in dns
curl voice.p.kingdee.skydns.local:8778
#every work good
```

2.在容器里面运行的，做自动发现
> 好像作用并不明显，现在需要的只是在容器里面感知到其他服务是OK的
