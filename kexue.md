### 如何使用shadowsocks科学上网
### 1. 准备工作
>你得有一台vps,如果不知道怎么去找好的vps可以看下面的推荐:
>1).[linode](http://linnode.com/ "linode"),速度还不错,如果运气好选到日本数据中心的话,其他数据中心速度一般
> 
>2).[vultr](http://www.vultr.com/?ref=6828826 "vultr"),现在正在用,速度不错,当然也是选日本数据中心,最大的好处是便宜,价格是linode额一半左右,科学上网流量一般是没问题,200G
>
>3).[digitalocean](https://www.digitalocean.com "digitalocean"),之前在github上看到的,不知道速度咋样,价格比linode便宜是真的

### 2.配置server端(即你购买的vps)
>首先登陆你的机器,根据你先的操作系统检查一下你相关软件的版本,shadowsocks提供了不同版本的server端,选择适合你自己的即可,下面给大家介绍**python**版和**c**版
>
1. python版本的[shadowsocks](https://github.com/shadowsocks/shadowsocks.git "shadowsocks"),如果使用习惯git的话直接git clone [https://github.com/shadowsocks/shadowsocks.git](https://github.com/shadowsocks/shadowsocks.git)即可。如果机器上没有安装git的,yum -y install git /apt-get install git,如果不习惯可以直接wget [https://github.com/shadowsocks/shadowsocks/archive/master.zip](https://github.com/shadowsocks/shadowsocks/archive/master.zip)即可
2. 解压,在这之前确认你的python版本2.6及以上,还有附加的巩固python-pip等,python3不知道支持咋样,大家可以自行尝试,执行sudo python setup.py install即可
3. 如果一切正常的话可以进行可以查看到ssserver命令,直接输入ssserver,然后tab键看一下是否能联想,如果没问题就说明一切正常
4. 增加配置文件config.json,格式如下,启动server,启动命令ssserver -c config.json &
1. c版本的和python的差不多,下载[shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev.git "shadowsocks-libev")--->解压--->make(依赖了openssl,所以需要安装openssl和openssl-devel)--->make install,编译完了在src下面有一个	ss-server可执行文件,执行./ss-server -c config.json &即可


### 3.客户端配置
>
1. Windows机器上面需要下载一个客户端工具,Shadowsocks-gui,下载地址[client](http://sourceforge.net/projects/shadowsocksgui/files/dist/Shadowsocks-win-2.3.1.zip/download "client"),希望你还能正常访问,使用chrome需要用一个插件[SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.3.11/SwitchyOmega.crx "SwitchyOmega"),安装方式:在chrome地址栏输入chrome://extensions/---->将插件网页拖拽即可
2. 配置SwitchyOmega,点击插件-->选项-->情景名随便--->选择手动配置--->http代理---->输入127.0.0.1--->端口1080--->选上对所有生效的勾-->保存--->点击插件--->选择刚才设置的情景名![proxy](/proxy.png) ![mode](/mode.png)
3. 启动Shadowsocks-gui,输入虚拟机的ip-->你设置的端口-->密码,点击确定即可
4. 访问[google](https://google.com),如果能访问说明生效,不行的话看一下哪里出问题了,祝大家好运

### 4.上述备注
#####*python版安装代码*
```shell
    #install dependency
    sudo apt-get install python-pip/sudo yum -y install python-pip
	#install git	
	sudo apt-get install git/sudo yum -y install git
	
	#clone shadowsocks
	git clone https://github.com/shadowsocks/shadowsocks.git
	cd shadowsocks
	sudo python setup.py install
	
	#start server in deamon
	sudo ssserver -c /path/to/config/json &
```
#####*c版安装代码*
```shell
    #install dependency
    sudo apt-get install openssl openssl-dev/sudo yum -y install openssl openssl-devel
	#install git	
	sudo apt-get install git/sudo yum -y install git
	
	#clone shadowsocks
	git clone https://github.com/shadowsocks/shadowsocks-libev.git
	cd shadowsocks-libev
	make && make install
	
	#start server in deamon
	./src/ss-server -c /path/to/config/json &
```
#####*config.json文件如下*
```javascript
//config.json
 {
    "server":"0.0.0.0",
    "server_port":12345,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"yourpass",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
```
如果有什么可以联系我[@wjybluse](https://github.com/wjybluse)

