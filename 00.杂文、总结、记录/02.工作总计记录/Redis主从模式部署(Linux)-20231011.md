# Redis主从模式部署(Linux)

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
