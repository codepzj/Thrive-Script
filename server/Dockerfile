# 设置基础镜像
FROM openjdk:11.0-jre-buster

# 设置工作目录
WORKDIR /thrive

# 使用国内代理下载最新版本的 blog.jar
RUN curl -L https://gh-proxy.com/github.com/LiuYuYang01/ThriveX-Server/releases/latest/download/blog.jar -o /thrive/app.jar

# 容器启动时运行的命令
ENTRYPOINT ["java", "-jar", "app.jar"]
