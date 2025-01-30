#!/bin/bash

# 第一次初始化使用（重复使用会覆盖原有tables）
# chmod 777 init.sh && ./init.sh（执行该脚本）
# 本地使用，保证本地装了mysql，使用git bash执行该脚本，更换MYSQL_HOST
# 远程使用，请确保配置了mysql环境变量

##########################################################
                                                         #
# 配置 MySQL 连接信息                                     #
MYSQL_USER="root"          # MySQL 用户名                #
MYSQL_PASSWORD="123456"    # MySQL 密码                  #
MYSQL_HOST="mysql"         # MySQL 容器名（docker 内部网络）#
MYSQL_DB="ThriveX"         # 数据库名                    #
                                                         #
##########################################################

# 远程 SQL 文件的 URL
SQL_FILE_URL="https://gh-proxy.com/raw.githubusercontent.com/LiuYuYang01/ThriveX-Server/refs/heads/master/ThriveX.sql"

# 临时存储 SQL 文件的位置
TEMP_SQL_FILE="./ThriveX.sql"

# 下载 SQL 文件
echo "从 $SQL_FILE_URL 下载 SQL 文件..."
curl -L "$SQL_FILE_URL" -o "$TEMP_SQL_FILE"

# 检查文件是否下载成功
if [[ ! -f "$TEMP_SQL_FILE" ]]; then
  echo "错误: SQL 文件下载失败！"
  exit 1
fi

# 检查数据库是否存在，如果不存在则创建
echo "检查数据库 $MYSQL_DB 是否存在..."
DB_EXISTS=$(docker exec mysql mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES LIKE '$MYSQL_DB';" | grep "$MYSQL_DB")

if [[ -z "$DB_EXISTS" ]]; then
  echo "数据库 $MYSQL_DB 不存在，正在创建..."
  docker exec mysql mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE $MYSQL_DB;"
  if [[ $? -eq 0 ]]; then
    echo "数据库 $MYSQL_DB 创建成功！"
  else
    echo "错误: 创建数据库 $MYSQL_DB 失败！"
    exit 1
  fi
else
  echo "数据库 $MYSQL_DB 已经存在！"
fi

# 导入 SQL 文件到 MySQL
echo "开始导入 SQL 文件 $TEMP_SQL_FILE 到数据库 $MYSQL_DB..."

docker exec -i mysql mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DB" < "$TEMP_SQL_FILE"

# 检查导入结果
if [[ $? -eq 0 ]]; then
  echo "SQL 文件导入成功！"
  # 输出所有表
  echo "输出数据库 $MYSQL_DB 中的所有表..."
  docker exec mysql mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW TABLES IN $MYSQL_DB;"
else
  echo "错误: SQL 文件导入失败！"
  exit 1
fi

# 删除临时 SQL 文件
rm "$TEMP_SQL_FILE"
echo "已删除临时 SQL 文件 $TEMP_SQL_FILE"
