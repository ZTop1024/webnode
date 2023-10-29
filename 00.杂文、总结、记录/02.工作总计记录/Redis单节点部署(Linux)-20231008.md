# Redis单节点部署(Linux)

> **环境准备**
> 
> > Linux系统：Centos-7-x86_64-Minimal-2009
> 
> > Redis: redis-7.0.11

## 1. 解压 & 编译
```shell
# 解压
tar -xzvf redis-7.0.11.tar.gz
```
编译需要用到`gcc`，现在安装的`redis7.0`，使用Linux自带的版本是不够的，所以需要对`gcc`进行升级

```shell
# 升级gcc
yum -y install gcc-c++
```

需要在`Makefile`文件的当前目录执行
```shell
# 编译 & 安装
make & make install
```
出现`It's a good idea to run make test`就是完成啦

### 可能出现的问题
![编译可能出现的问题](file/Redis单节点部署(Linux)-图片/编译可能出现的问题.png)

**解决：**
```shell
make MALLOC=libc
```
出现`Hint: It's a good idea to run 'make test' ;)`就是完成啦

## 2. 安装
### 2.1 整理文件
新建`bin`文件夹，把编译后出现的执行文件和配置文件放到`bin`里
`mkreleasehdr.sh`  `redis-benchmark`  `redis-check-aof`  `redis-check-rdb`  `redis-cli`  `redis-sentinel`  `redis-server`  `redis-trib.rb`
```shell
pwd
# /redis
mkdir bin
```

把`redis-server`和`redis-cli`放到`/usr/local/bin`目录下，让redis-cli指令可以在任意目录下直接使用

### 2.2 修改redis.conf文件
```shell
port 6379 # 138行
logfile "" # 354行
#第 309  行
daemonize no #改为  daemonize yes；yes表示启用守护进程，默认是no即不以守护进程方式运行。其中Windows系统下不支持启用守护进程方式运行
# 87 行
bind 127.0.0.1 #改为 直接注释掉（默认 bind 127.0.0.1 只能本机访问）或改为本机IP地址，或者改为 0.0.0.0 (允许任何人连接)
# 111 行
protected-mode yes # 改为 protected-mode no；保护模式，该模式控制外部网是否可以连接redis服务，默认是yes,所以默认我们外网是无法访问的，如需外网连接redis服务则需要将此属性改为no。
#  1036 行 添加Redis 密码 
requirepass 123456
```

### 2.3 启动
指定配置文件启动redis服务
```shell
redis-server /redis/bin/redis.conf
```

### 2.4 防火墙放行
```shell
firewall-cmd --permanent --zone=public --add-port=6379/tcp #永久添加6379端口放行
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --remove-port=80/tcp --permanent #永久移除80端口放行
```

### 2.5 连接
使用`redis-cli`连接
```shell
redis-cli -h 127.0.0.1 -a 123456 -p 6379
# 当前主机和默认端口6379可以省略
redis-cli -a 123456
```

出现不安全提示
```shell
[root@192 bin]# redis-cli -a 123456 -p 6379
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
```

也可以不在登陆时使用-a输入密码，在进入redis命令行后使用`auth`来输入密码登陆
```shell
[root@192 bin]# redis
-bash: redis: command not found
[root@192 bin]# redis-cli
127.0.0.1:6379> auth 123456
OK
```

## 2.6 关闭和卸载redis
### 2.6.1 关闭redis服务
在redis中关闭
```shell
127.0.0.1:6379> shutdown
not connected> exit
```

或者直接使用`redis-cli`关闭
```shell
redis-cli -a 123456 -p 6379 shutdown
```
### 2.6.2 卸载redis服务
删除`/usr/local/bin`下关于redis的文件