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
### 观察slave节点日志
```shell
[root@192 redis]# tail -30 6379.log
15442:C 12 Oct 2023 11:46:36.241 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
15442:C 12 Oct 2023 11:46:36.241 # Redis version=7.0.11, bits=64, commit=00000000, modified=0, pid=15442, just started
15442:C 12 Oct 2023 11:46:36.241 # Configuration loaded
15442:S 12 Oct 2023 11:46:36.243 * Increased maximum number of open files to 10032 (it was originally set to 1024).
15442:S 12 Oct 2023 11:46:36.243 * monotonic clock: POSIX clock_gettime
15442:S 12 Oct 2023 11:46:36.244 * Running mode=standalone, port=6379.
15442:S 12 Oct 2023 11:46:36.245 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
15442:S 12 Oct 2023 11:46:36.245 # Server initialized
15442:S 12 Oct 2023 11:46:36.245 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
15442:S 12 Oct 2023 11:46:36.246 * Ready to accept connections
15442:S 12 Oct 2023 11:46:36.246 * Connecting to MASTER 192.168.1.11:6379
15442:S 12 Oct 2023 11:46:36.247 * MASTER <-> REPLICA sync started
15442:S 12 Oct 2023 11:46:36.247 * Non blocking connect for SYNC fired the event.
15442:S 12 Oct 2023 11:46:36.247 * Master replied to PING, replication can continue...
15442:S 12 Oct 2023 11:46:36.248 * Partial resynchronization not possible (no cached master)
15442:S 12 Oct 2023 11:46:41.018 * Full resync from master: 15a2d8f062c5307d5b255731f4e71edf1a31a59c:0
15442:S 12 Oct 2023 11:46:41.019 * MASTER <-> REPLICA sync: receiving streamed RDB from master with EOF to disk
15442:S 12 Oct 2023 11:46:41.020 * MASTER <-> REPLICA sync: Flushing old data
15442:S 12 Oct 2023 11:46:41.020 * MASTER <-> REPLICA sync: Loading DB in memory
15442:S 12 Oct 2023 11:46:41.020 * Loading RDB produced by version 7.0.11
15442:S 12 Oct 2023 11:46:41.021 * RDB age 0 seconds
15442:S 12 Oct 2023 11:46:41.021 * RDB memory usage when created 0.89 Mb
15442:S 12 Oct 2023 11:46:41.021 * Done loading RDB, keys loaded: 0, keys expired: 0.
15442:S 12 Oct 2023 11:46:41.021 * MASTER <-> REPLICA sync: Finished with success
```

### 观察master节点日志
```shell
[root@192 redis]# tail -30 6379.log
10698:C 12 Oct 2023 11:45:45.861 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
10698:C 12 Oct 2023 11:45:45.861 # Redis version=7.0.11, bits=64, commit=00000000, modified=0, pid=10698, just started
10698:C 12 Oct 2023 11:45:45.861 # Configuration loaded
10698:M 12 Oct 2023 11:45:45.861 * Increased maximum number of open files to 10032 (it was originally set to 1024).
10698:M 12 Oct 2023 11:45:45.861 * monotonic clock: POSIX clock_gettime
10698:M 12 Oct 2023 11:45:45.862 * Running mode=standalone, port=6379.
10698:M 12 Oct 2023 11:45:45.862 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
10698:M 12 Oct 2023 11:45:45.862 # Server initialized
10698:M 12 Oct 2023 11:45:45.862 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
10698:M 12 Oct 2023 11:45:45.863 * Ready to accept connections
10698:M 12 Oct 2023 11:46:36.245 * Replica 192.168.1.17:6379 asks for synchronization
10698:M 12 Oct 2023 11:46:36.245 * Full resync requested by replica 192.168.1.17:6379
10698:M 12 Oct 2023 11:46:36.245 * Replication backlog created, my new replication IDs are '15a2d8f062c5307d5b255731f4e71edf1a31a59c' and '0000000000000000000000000000000000000000'
10698:M 12 Oct 2023 11:46:36.245 * Delay next BGSAVE for diskless SYNC
10698:M 12 Oct 2023 11:46:41.015 * Starting BGSAVE for SYNC with target: replicas sockets
10698:M 12 Oct 2023 11:46:41.015 * Background RDB transfer started by pid 10706
10706:C 12 Oct 2023 11:46:41.016 * Fork CoW for RDB: current 0 MB, peak 0 MB, average 0 MB
10698:M 12 Oct 2023 11:46:41.016 # Diskless rdb transfer, done reading from pipe, 1 replicas still up.
10698:M 12 Oct 2023 11:46:41.018 * Background RDB transfer terminated with success
10698:M 12 Oct 2023 11:46:41.018 * Streamed RDB transfer with replica 192.168.1.17:6379 succeeded (socket). Waiting for REPLCONF ACK from slave to enable streaming
10698:M 12 Oct 2023 11:46:41.018 * Synchronization with replica 192.168.1.17:6379 succeeded
```

### 使用命令查看
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