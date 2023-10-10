# MySQL单节点部署(Linux)
___

## 1. 环境准备
提前下载好Centos-7镜像和mysql镜像

> **Linux系统**：Centos-7-x86_64-Minimal-2009
> 
> **Mysql**：mysql-5.7.36-el7-x86_64

## 2. 安装MySQL5.7
### 2.1 删除mariadb，清理历史环境
```shell
rpm -qa | grep marisdb
yum -y remove mariadb-libs
```

### 2.2 创建用户
```shell
useradd mysql -s /sbin/nologin
```

### 2.3 创建相关目录
```shell
mkdir /database/ # 软件目录
mkdir -p /data/mysql/ # 数据目录
mkdir -p /binlog/mysql # 日志目录
```

### 2.4 设置目录所有者和所属组
```shell
chown -R mysql:mysql /database/ /data/ /binlog/
```

### 2.5 把准备好的MySQL5.7包放到database文件夹中

### 2.6 解压tar包
```shell
tar -zxvf mysql-5.7.36-el7-x86_64.tar.gz
```

### 2.7 创建软连接，避免使用太长的文件名
```shell
ln -s mysql-5.7.36-el7-x86_64 mysql
```

### 2.8 更改MySQL目录主和属组
```shell
chown -R mysql:mysql ./
```

更改环境变量 `vim /etc/profile` 在最后一行添加
```shell
......
export PATH=/database/mysql/bin:$PATH
```

生效
```shell
source /etc/profile
```

验证
```shell
mysql -V
```

### 2.9 初始化
```shell
rpm -qa|grep libaio
mysqld --initialize-insecure --user=mysql --basedir=/database/mysql --datadir=/data/mysql/
```

### 2.10 配置文件设置
```shell
vim /etc/my.cnf
```
内容
```shell
[mysqld]
user=mysql
basedir=/database/mysql
datadir=/data/mysql
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock
```

准备MySQL启动脚本
```shell
cd /database/mysql/suport-files/
cp mysql.server /etc/init.d/mysqld
```

启动
```shell
chkconfig --add mysqld
chkconfig mysqld on
service mysqld start
```

注意：MySQL初始化时并没有密码，初次登陆需要设置密码
```shell
set password for root@% = password('123456');
```

## 3. 其它配置
### 3.1 防火墙放行
```shell
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-port=3306/tcp #永久添加3306端口放行
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --remove-port=80/tcp --permanent #永久移除80端口放行
```

### 3.2 设置root用户密码
```shell
show databases;
use mysql;
```