## 分流策略方案
#### 一.为了更好的实现灰度发布，可以使用sina的动态分流工具，开源项目(ABTestingGateway),支持一下几种分流方式
>1.iprange，通过指定ip区间实现分流，比如说不同城市，不同国家测试不同版本

>2.uidrange，这个应该是根项目结构强相关的，如果用户ID是数字的并且有一定的结构性的可以使用，用户ID通过制定http消息头的形式
    来做，新浪制定的消息头key为X-Uid

>3.UID后缀的方式，这个里面也是写死的，uid必须为数字的形式，不同数字结尾的分发到不同的版本

>4.扩展，可以扩展成通过session里面关键信息来做(自己写脚本,lua脚本，应该不会太多脚本)，\
   或者加一个消息头，里面有自己需要的信息\
   ABTestingGateway的有点在于可以动态实现分流，不需要重启服务，能够动态添加和删除策略，\
   提供了简单的rest api接口，可以自己动态修改配置策略或者删除添加策略等，做到动态生效 \
   看了官方给的压测报告基本上没有性能上的损失 \
   ABTesting的地址[ABTesting](https://github.com/WEIBOMSRE/ABTestingGateway)
#### 二.依赖组件：
>1.tengine-2.1.0(没有使用官方默认的nginx，使用了淘宝的引擎)

>2.LuaJIT-2.1-20141128(LuaJIT及时编译工具)

>3.ngx_lua-0.9.13(nginx lua模块)

>4.lua-cjson-2.1.0.2(nginx json 解析工具)

>5.redis-2.8.19依赖了redis

#### 三.自己做一个分流方案，通过写lua脚本来实现，但是可能不好做到动态分流，需要手动去修改信息什么的

## ABTesting的安装和使用
#### 一.如果是在container里面，首先需要装构建工具，以ubuntu14.04为例
```shell
#update dependency tools,modify source.list if needed
apt-get update
#install gcc g++
apt-get install gcc g++

#install pcre and openssl
apt-get install libpcre3 libpcre-dev

#install LuaJIT
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
tar -xvf  LuaJIT-2.0.4.tar.gz
cd LuaJIT-2.0.4
make && make install
export  LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0

#install lua-cjson,if compile failed,you should change make file
git clone https://github.com/mpx/lua-cjson.git
cd lua-cjson
make && make install


#install nginx,sina recommand to use tengine for loading lua script dynamic
wget http://tengine.taobao.org/download/tengine-2.1.2.tar.gz
tar -xvf tengine-2.1.2.tar.gz
cd tengine-2.1.2

#compile nginx,before compile,download ngx_devel_kit
git clone https://github.com/simpl/ngx_devel_kit.git
 ./configure --prefix=/opt/nginx \
         --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
         --add-module=../ngx_devel_kit \
         --add-module=../lua-nginx-module
 make -j2
 make install
 
#modify your sites,can support some nginx server in one docker
/opt/nginx/sbin/nginx -p `pwd` -c conf/stable.conf
/opt/nginx/sbin/nginx -p `pwd` -c conf/beta1.conf
/opt/nginx/sbin/nginx -p `pwd` -c conf/beta2.conf
/opt/nginx/sbin/nginx -p `pwd` -c conf/beta3.conf
/opt/nginx/sbin/nginx -p `pwd` -c conf/beta4.conf
    
#start nginx server
/opt/nginx/sbin/nginx -p `pwd` -c conf/nginx.conf


#setting policy and testting
curl 127.0.0.1/admin/runtime/get
->{"errcode":200,"errinfo":"success ","data":{"divModulename":null,"divDataKey":null,"userInfoModulename":null}}

#set policy
curl 127.0.0.1/admin/policy/set -d '{"divtype":"uidsuffix","divdata":[{"suffix":"1","upstream":"beta1"},{"suffix":"3","upstream":"beta2"},{"suffix":"5","upstream":"beta1"},{"suffix":"0","upstream":"beta3"}]}'
 
#use policy
url 127.0.0.1/admin/runtime/set?policyid=0

#test
curl localhost/ -H 'X-Uid:23'
->this is beta2 server

#current support uidrange,iprange and uidsuffix,we can add type we wanted
```

#### 二.如果是在虚拟机或者物理机部署，不是裸机的话可以省去安装工具的步骤，其他同上

#### 三.写简单的扩展，需要增加两个文件和修改一个配置文件
> Step 1.在lib/abtesting/utils的init.lua里面增加如下代码
```lua
--增加解析器
_M.divtypes = {
    ["iprange"]     = 'ipParser',
    ["uidrange"]    = 'uidParser',
    ["uidsuffix"]   = 'uidParser',
    ["uidappoint"]  = 'uidParser',
    ["arg_city"]    = 'cityParser',
    --token parser
    ["tokensuffix"] = 'tokenParser'
}
```

>2.Step 2.在lib/abtesting/diversion里面添加一个文件，文件名和上述初始化的时候key相同，即tokensuffix.lua
里面实现一个接口的各种方法签名，方法有(new,check,get,set,getUpstream),大致代码如下：
```lua
local modulename="abtestingDiversionTokenSuffix"
local _M    = {}
local mt    = { __index = _M }
_M._VERSION = "0.0.1"

local ERRORINFO	= require('abtesting.error.errcode').info

local k_token     = 'tokensuffix'
local k_upstream = 'upstream'

_M.new = function(self, database, policyLib)
    if not database then
        error{ERRORINFO.PARAMETER_NONE, 'need avaliable redis db'}
    end if not policyLib then
        error{ERRORINFO.PARAMETER_NONE, 'need avaliable policy lib'}
    end

    self.database = database
    self.policyLib = policyLib
    return setmetatable(self, mt)
end

--check the message
local isNULL = function(v)
    return v and v ~= ngx.null
end

--check method ,policy format as {{"tokensuffix"="test","upstream"="beta1"}}
_M.check = function(self, policy)
  for _,value in pairs(policy) do
    local suffix = value[k_token]
    local upstream = value[k_upstream]
    -- check the suffix and upstream is null or not
    if not suffix or not upstream then
      local desc = "invalid suffix or upstream"
      local info = ERRORINFO.POLICY_INVALID_ERROR
      -- invalid policy,pls check the value of policy
      return {false,info,desc}
    end
  end
  -- if it is ok ,return true
  return {true}
end

--use suffix parser set method
_M.set = function(self, policy)
    local database  = self.database
    local policyLib = self.policyLib

    database:init_pipeline()
    for _, v in pairs(policy) do
        database:hset(policyLib, v[k_token], v[k_upstream])
    end
    local ok, err = database:commit_pipeline()
    if not ok then
        error{ERRORINFO.REDIS_ERROR, err}
    end
end

--use default get method
_M.get = function(self)
    local database  = self.database
    local policyLib = self.policyLib

    local data, err = database:hgetall(policyLib)
    if not data then
        error{ERRORINFO.REDIS_ERROR, err}
    end

    return data
end

--upstream method
_M.getUpstream = function(self, tokensuffix)
    local database	= self.database
    local policyLib = self.policyLib
    --find upstream,if not find ,return error information
    local upstream, err = database:hget(policyLib , tokensuffix)
    if not upstream then error{ERRORINFO.REDIS_ERROR, err} end
    if upstream == ngx.null then
        return nil
    else
        return upstream
    end
end

return _M
```

> Step 3.在lib/abtesting/userinfo里面增加一个解析器tokenParser.lua,大致代码如下，非常简单
```lua
local _M = {
    _VERSION = '0.01'
}

_M.get = function()
  --create local varibale to store the value of token suffix
	local token = ngx.req.get_headers()["X-token"]
  if not token then
    return ""
  end
	_,suffix = token:match("([^-]+)-([^-]+)")
  if not suffix then
    -- if suffix is empty ,return enmpty string else return suffix
    return ""
  end
  return suffix
end
return _M
```

>Step 4.上述为插件的简单生成模式，测试过了之后即可使用


