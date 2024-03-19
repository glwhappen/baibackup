# 使用官方Python镜像作为基础镜像
FROM python:3.8-slim

# 安装cron和bypy
RUN apt-get update && apt-get install -y cron && pip install bypy

# 设置工作目录
WORKDIR /app

# 复制脚本到容器
COPY start.sh /app/
COPY backup.sh /app/
COPY entrypoint.sh /app/

# 给脚本执行权限
RUN chmod +x /app/start.sh
RUN chmod +x /app/backup.sh
RUN chmod +x /app/entrypoint.sh

# 创建日志文件以便能够运行tail
RUN touch /var/log/cron.log

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# 设置入口点
ENTRYPOINT ["/app/entrypoint.sh"]
