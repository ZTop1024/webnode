# Redis主从模式部署(Linux)

## 部署模式
> 一主一从
> > 192.168.1.11 master
> >
> > 192.168.1.17 slave

## 主要配置
```shell
# 以守护进程的方式运行
daemonize yes   # 309行

# master节点：设置密码(也可以不设置)
requirepass 123456  # 1036行

# slave节点：当本机为slave节点时，设置master的IP地址及端口
replicaof <masterip> <masterport>   # 527行

# slave节点：当master节点设置了密码时，配置登陆密码
masterauth <master-password>  #  534行
```

## 验证主从模式启动成功
使用`info replication`指令，`connected_slaves:1`说明已经连接上一个从节点
```shell
192.168.1.11:6379> info replication
# Replication
role:master
connected_slaves:1
slave0:ip=192.168.1.17,port=6379,state=online,offset=85650,lag=1
master_failover_state:no-failover
master_replid:989a39c9a119eeadd83dc5caedb56cec66efff9e
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:85650
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:85650
```