# Thrive 博客一键配置脚本

## 针对的用户

- 本地用户
  - 装了 mysql
  - 没装 mysql
- 远程用户
  - 装了 mysql
  - 没装 mysql
  - 1panel
  - 宝塔
  - nginx

> 用什么终端管理面板都无所谓，此仓库针对的是使用命令行部署服务，反向代理自己使用管理面板或本地 nginx 配置的

## 重点

> 远程环境：后端 api 改成公网 ip

## 针对远程用户

### 装了 mysql 的

1.请注释掉`docker-compose.yaml`中的`mysql`配置和`server`中的 depends_on 块

```yaml
mysql:
  image: mysql:8.0
  container_name: mysql
  environment:
    MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
  networks:
    - thrive_network
  ports:
    - 3306:3306
  volumes:
    - ./mysql/data/:/var/lib/mysql
    - ./mysql/conf/my.cnf:/etc/my.cnf
    - ./mysql/log:/var/log/mysql
    - /etc/timezone:/etc/timezone:ro
    - /etc/localtime:/etc/localtime:ro
  restart: always
server:
  ...
  # 只有mysql要自安装才开启
  # depends_on:
  #     - mysql
```

2.配置.env

将`DB_INFO`的前缀 mysql 改成自己的公网 ip（mysql 不在桥接网络中）

```bash
curl ip.sb
```

其他配置项按照文档配置

### 没装 mysql 的

不用改`docker-compose.yaml`

直接按照文档配置`.env`

## 初始化数据库

前往 [sql-init/init.sh](sql-init/init.sh)配置

## 后话

### 反向代理

#### 1panel

[看文档](https://bbs.fit2cloud.com/t/topic/1126/7)

#### 宝塔

[看文档](https://www.bt.cn/bbs/thread-136541-1-1.html)

#### nginx

`nginx.conf`

```conf
server {
    listen 80;
    server_name blog.example.com

    location / {
        proxy_pass  http://127.0.0.1:9001;
    }
}
server {
    listen 80;
    server_name admin.example.com

    location / {
        proxy_pass  http://127.0.0.1:9002;
    }
}
    listen 80;
server {
    server_name server.example.com

    location / {
        proxy_pass  http://127.0.0.1:9003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
