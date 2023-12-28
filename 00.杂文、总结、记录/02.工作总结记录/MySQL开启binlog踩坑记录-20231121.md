---
tags:
  - MySQL
---
# MySQL开启binlog踩坑记录

___

> 最近想要在个人服务器上玩一下MySQL的binlog和同步，在第一步开启MySQL的binlog日志时，就遇到了坑。在此记录一下。

## 配置开启binlog日志

主要的两种方法

```shell
#第一种方式:
#开启binlog日志
log_bin=ON
#binlog日志的基本文件名
log_bin_basename=/var/lib/mysql/mysql-bin
#binlog文件的索引文件，管理所有binlog文件
log_bin_index=/var/lib/mysql/mysql-bin.index
#配置serverid
server-id=1

#第二种方式:
#此一行等同于上面log_bin三行
log-bin=/var/lib/mysql/mysql-bin
#配置serverid
server-id=1
```

我的配置文件如下(错误的配置)

```shell
[mysqld]
user=mysql
basedir=/mysql/database/mysql
datadir=/mysql/data/mysql
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock

# bin_log配置
log-bin=mysql-bin
server-id=1
binlog_format=row
```

重启后登录出现报错
```bash
[root@192.168.1.11 23:00 mysql] mysql -u root -p
mysql: [ERROR] unknown variable 'log-bin=mysql-bin'
```

## 解决

MySQL配置需要区分挂在`[mysqld]`下还是在`[mysql]`

调整后的配置文件(正确的配置)

```shell
[mysqld]
user=mysql
basedir=/mysql/database/mysql
datadir=/mysql/data/mysql
port=3306
socket=/tmp/mysql.sock
log-bin=/mysql/binlog/mysql-bin  # bin-log日志的地址(最后是bin-log日志文件名)
server-id=1
binlog_format=row
lower_case_table_names = 1
[mysql]
socket=/tmp/mysql.sock
```

检验

```bash
mysql> show variables like '%log_bin%';
+---------------------------------+-----------------------------------+
| Variable_name                   | Value                             |
+---------------------------------+-----------------------------------+
| log_bin                         | ON                                |
| log_bin_basename                | /mysql/data/mysql/mysql-bin       |
| log_bin_index                   | /mysql/data/mysql/mysql-bin.index |
| log_bin_trust_function_creators | OFF                               |
| log_bin_use_v1_row_events       | OFF                               |
| sql_log_bin                     | ON                                |
+---------------------------------+-----------------------------------+
6 rows in set (0.00 sec)
```