# Redis哨兵模式-Linux存储空间占满问题排查

___

> 192.168.1.11

## 发现

一开始是发现部署redis的Node节点存储空间被占满了，创建文件时出现`No space left on device`的错误提示

使用df命令查看，当时是已经占满空间了

```shell
[root@192.168.1.11 20:38 redis] df -h
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 908M     0  908M   0% /dev
tmpfs                    920M     0  920M   0% /dev/shm
tmpfs                    920M   63M  857M   7% /run
tmpfs                    920M     0  920M   0% /sys/fs/cgroup
/dev/mapper/centos-root   47G   17G   31G  35% /
/dev/sda1               1014M  150M  865M  15% /boot
tmpfs                    184M     0  184M   0% /run/user/0
```

刚好最近把Prometheus的监控搭建起来了，就用监控看下(图示为后续复原原因的截图，中间CPU降下去是把redis停了解决了问题)

![CPU监控](./file/Redis哨兵模式-CPU占用过高问题排查/CPU监控-before.png)

![文件读写监控](./file/Redis哨兵模式-CPU占用过高问题排查/文件读写监控-before.png)

## 查找Linux大文件

查找超过1G的大文件

```shell
[root@192.168.1.11 20:36 redis] find / -type f -size +1024M -print
/proc/kcore
find: ‘/proc/28214/task/28214/fdinfo/6’: No such file or directory
find: ‘/proc/28214/fdinfo/5’: No such file or directory
/redis/6379.log.bak
```

发现是在redis相关的路径中，是redis的日志文件

```shell
[root@192.168.1.11 20:38 redis] ls -lh
total 11G
-rw-r--r--  1 root root 523M Nov 11 20:38 6379.log
-rw-r--r--  1 root root  10G Nov 11 20:09 6379.log.bak
drwxr-xr-x. 3 root root  189 Nov 11 20:38 bin
-rw-r--r--  1 root root  205 Oct 16 23:02 dump.rdb
-rw-r--r--. 1 root root  332 May 20 18:01 readme.md
lrwxrwxrwx. 1 root root   12 May 20 17:40 redis -> redis-7.0.11
drwxrwxr-x. 8 root root 4.0K Oct 10 23:14 redis-7.0.11
-rw-r--r--. 1 root root 2.9M May 20 17:38 redis-7.0.11.tar.gz
```

然后打开日志文件，发现一直在刷同步错误日志

```shell
12034:S 11 Nov 2023 20:09:19.382 * MASTER <-> REPLICA sync started
12034:S 11 Nov 2023 20:09:19.382 * Non blocking connect for SYNC fired the event.
12034:S 11 Nov 2023 20:09:19.382 * Master replied to PING, replication can continue...
12034:S 11 Nov 2023 20:09:19.382 * (Non critical) Master does not understand REPLCONF listening-port: -NOAUTH Authentication required.
12034:S 11 Nov 2023 20:09:19.383 * (Non critical) Master does not understand REPLCONF capa: -NOAUTH Authentication required.
12034:S 11 Nov 2023 20:09:19.383 * Trying a partial resynchronization (request b607dbce2192690541ad42a4fb72dfbf5aab1949:12784319).
12034:S 11 Nov 2023 20:09:19.383 # Unexpected reply to PSYNC from master: -NOAUTH Authentication required.
12034:S 11 Nov 2023 20:09:19.383 * Retrying with SYNC...
12034:S 11 Nov 2023 20:09:19.383 # MASTER aborted replication with an error: NOAUTH Authentication required.
12034:S 11 Nov 2023 20:09:19.383 * Reconnecting to MASTER 192.168.1.17:6379 after failure
```

发现报错`-NOAUTH Authentication required.`

## 排查

查看192.168.1.11节点角色，是slaver

查看192.168.1.17节点角色和从节点个数，是master，但是从节点中没有192.168.1.11

所以是当前node的从节点没有连接上master，然后就一直在重试连接，不断打印日志，导致CPU问文件读写IO过高，甚至会写满存储

根据报错是密码不正确，忽然想起之前这个节点启动时就当作mater节点，在本地测试了哨兵模式切换后，主节点改为了192.168.1.17，
但是当前这个配置没有加上master节点的登录密码，所以报错了

然后更改当前节点的配置文件，重启redis。

打开日志文件，启动正常

```shell
28995:S 11 Nov 2023 20:52:11.689 * Connecting to MASTER 192.168.1.17:6379
28995:S 11 Nov 2023 20:52:11.689 * MASTER <-> REPLICA sync started
28995:S 11 Nov 2023 20:52:11.689 * Non blocking connect for SYNC fired the event.
28995:S 11 Nov 2023 20:52:11.690 * Master replied to PING, replication can continue...
28995:S 11 Nov 2023 20:52:11.690 * Trying a partial resynchronization (request 6e19d46dcecff8b4852f1d2480c1cff188cbb221:73770900).
28995:S 11 Nov 2023 20:52:11.690 * Successful partial resynchronization with master.
28995:S 11 Nov 2023 20:52:11.690 * MASTER <-> REPLICA sync: Master accepted a Partial Resynchronization.
```

查看监控，CPU占用和文件IO读写正常

![CPU监控-after](./file/Redis哨兵模式-CPU占用过高问题排查/CPU监控-after.png)

![文件读写监控-after](./file/Redis哨兵模式-CPU占用过高问题排查/文件读写监控-after.png)