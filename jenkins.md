1.jenkins的部署
```shell
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

2.修改配文件
```shell
/etc/default/jenkins
```

3.支持分布式构建
```shell
 java -jar slave.jar -jnlpUrl http://yourserver:port/computer/slave-name/slave-agent.jnlp
 #启动slave节点
```

