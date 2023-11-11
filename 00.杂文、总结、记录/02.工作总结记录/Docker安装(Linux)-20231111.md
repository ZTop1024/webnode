# Docker安装(Linux)

___

## 查看Docker及系统版本

Docker从17.03版本之后分为CE（Community Edition: 社区版）和EE（Enterprise Edition: 企业版）。相对于社区版本，企业版本强调安全性，但需付费使用。这里我们使用社区版本即可。

Docker支持64位版本的CentOS 7和CentOS 8及更高版本，它要求Linux内核版本不低于3.10。

**查看Docker版本**
```shell
[root@192.168.1.20 17:57 prometheus] cat /etc/redhat-release
CentOS Linux release 7.9.2009 (Core)
```

**查看内核版本**
```shell
[root@192.168.1.20 17:58 prometheus] cat /proc/version
Linux version 3.10.0-1160.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) ) #1 SMP Mon Oct 19 16:18:59 UTC 2020

# or
[root@192.168.1.20 17:59 prometheus] uname -r
3.10.0-1160.el7.x86_64
```

## Docker自动化安装

**使用官方一键安装指令**

```shell
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

**验证安装Docker成功**

```shell
[root@192.168.1.20 18:00 prometheus] docker -v
Docker version 24.0.7, build afdd53b
```