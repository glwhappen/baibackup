#!/bin/bash
echo "run backup.sh"
# 定义日志文件的路径
LOG_FILE="/app/logs/backup.log"

# 获取当前的日期和时间
current_time=$(date "+%Y-%m-%d %H:%M:%S")

# 在日志文件中记录备份开始的时间
echo "Backup started at $current_time" >> $LOG_FILE



# 获取当前日期和时间，格式为YYYYMMDD-HHMMSS +%Y%m%d-%H%M%S
current_time_file=$(date "$TIME_FILE")

# 构造包含日期时间的远程目录路径
target_dir=${REMOTE_DIR/\{TIME_FILE\}/$current_time_file}
echo "Backup target $target_dir" >> $LOG_FILE


# 执行备份命令，并将输出重定向到日志文件 overwrite skip
/usr/local/bin/bypy syncup /root/backup "$target_dir" --on-dup $ON_DUP >> $LOG_FILE 2>&1
# 再次获取当前的日期和时间
current_time=$(date "+%Y-%m-%d %H:%M:%S")

# 在日志文件中记录备份完成的时间
echo "Backup completed at $current_time" >> $LOG_FILE
echo "----------------------------------------" >> $LOG_FILE
