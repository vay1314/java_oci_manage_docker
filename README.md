# java_oci_manage_docker
 R探长Bot docker版



## 简介

基于 [semicons/java_oci_manage](https://github.com/semicons/java_oci_manage) 项目的 docker 镜像.
本项目仅为方便 docker 容器化部署,相关使用教程及问题请参考官方项目.

## docker 部署

### 准备配置文件

- 参考官方项目,准备 oracle api key 私钥文件`key.pem`.
- 参考官方项目,配置 client_config 文件,注意 key 路径为`key_file=/app/key.pem`.

### 启动 docker 容器

在启动容器前，确保client_config和key.pem存在，并且内容正确。

```
docker run -d --name java_oci_manage_docker --restart always \
  -v /root/config/client_config:/app/client_config \
  -v /root/config/key.pem:/app/key.pem \
  -p 9527:9527 \
  yin26287903/java_oci_manage_docker
```

## docker compose 部署

参考完成上述配置后,下载 [docker-compose.yml](https://raw.githubusercontent.com/vay1314/java_oci_manage_docker/main/docker-compose.yml) 执行以下命令启动:

```
docker-compose up -d
```
