# Docker的简单配置
> 1.配置镜像仓库
```shell
    git clone https://github.com/dotcloud/docker-registry.git
    cd docker-registry
    cp config_sample.yml config.yml
    pip install -r requirements.txt
    gunicorn --access-logfile - --log-level debug --debug 
    -b 0.0.0.0:5000 -w 1 wsgi:application
    
    #cannot find any image repo config?
    #use gloab setting
```

> 2.不需要设置全局的一个变量？做镜像仓库的配置
