# 使用官方的Node.js镜像作为基础镜像
FROM node:20-alpine

# 设置工作目录
WORKDIR /thrive

RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories && apk add --no-cache git
RUN git clone https://gh-proxy.com/https://github.com/LiuYuYang01/ThriveX-Blog.git .

# 覆盖配置文件
COPY .env .

# 配置 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

# 安装依赖
RUN npm install

# 构建Next.js应用
RUN npm run build

# 暴露应用运行的端口
EXPOSE 9001

# 启动Next.js应用
CMD ["npm", "start"]