如果说是mysql没部署，用该脚本部署，要新建两个文件夹（git提交记录不识别空文件夹）
- data
- log

初始化密码为123456

因为我之前构建过了，有缓存，实际应该得15-20分钟左右，如果卡住，ctrl+c,重新执行docker-compose up -d

可以看见mysql正常启动了

发现mysql没连接上，可能是权限不够

我们查找一下资料

果然是权限问题，解决方法就是进入mysql容器，手动配置一下权限

```sql
GRANT ALL ON *.* TO 'root'@'%';
flush privileges;
```

然后又报错了Unknown database 'ThriveX'
因为没初始化数据库
导入成功了，查看一下后端日志

服务已启动: 欢迎使用 ThriveX 博客管理系统 
接口地址:       http://localhost:9003/api
API文档:        http://localhost:9003/doc.html
加入项目交流群: liuyuyang2023

出现这行说明成功了

查看blog和admin日志，都是成功的

浏览器访问一下吧
部署成功了，但是登录还是有逻辑错误，作者在登录界面jwt校验逻辑没考虑周全，明天我问问作者，看看能不能修复这个bug

脚本是ok的，如果服务器因为资源问题无法构建，可以尝试在本地构建好，docker打包镜像成tar包，再scp传到服务器解压。欢迎大家star和fork这个脚本。
