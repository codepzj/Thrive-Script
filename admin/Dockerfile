# 使用官方的 Node.js 镜像作为基础镜像
FROM node:20-alpine AS builder

# 设置工作目录
WORKDIR /thrive

# 配置国内镜像源，并安装 git
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories && apk add --no-cache git

# 克隆项目代码
RUN git clone https://gh-proxy.com/https://github.com/LiuYuYang01/ThriveX-Admin.git .

# 覆盖配置文件
COPY .env .

# 配置 npm 镜像源
RUN npm config set registry https://registry.npmmirror.com

# 安装依赖
RUN npm install

# 构建项目
RUN npm run build

# 使用 Nginx 作为生产环境的基础镜像
FROM nginx:alpine

# 复制构建输出到 Nginx 的默认静态文件目录
COPY --from=builder /thrive/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
