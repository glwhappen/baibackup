#!/bin/bash

# 从环境变量读取CRON_SCHEDULE，如果未设置，则使用默认值
CRON_SCHEDULE=${CRON_SCHEDULE:-"* 2 * * *"}
echo $CRON_SCHEDULE

TIME_FILE=${TIME_FILE:-"+%Y%m%d-%H%M%S"}

ON_DUP=${ON_DUP:-"overwrite"}

# 为cron任务准备环境变量字符串
env_str="REMOTE_DIR='$REMOTE_DIR' TIME_FILE='$TIME_FILE' ON_DUP='$ON_DUP'"
# 确保环境变量字符串正确无误
echo "Environment string for cron: $env_str"

# 构建/etc/cron.d/backup-task文件
{
    echo "REMOTE_DIR='$REMOTE_DIR'"
    echo "TIME_FILE='$TIME_FILE'"
    echo "ON_DUP='$ON_DUP'"
    echo "$CRON_SCHEDULE root /bin/bash /app/backup.sh >> /app/logs/cron.log 2>&1"
} > /etc/cron.d/backup-task

echo "next"
# 确保cron任务文件的权限正确
chmod 0644 /etc/cron.d/backup-task

# 应用cron任务
crontab /etc/cron.d/backup-task

# 重启cron服务以应用新的cron任务
# /etc/init.d/cron restart
