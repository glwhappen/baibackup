#!/bin/bash

# 调用start.sh来设置cron任务
/app/start.sh

# 启动cron服务并保持在前台运行，以保持容器活跃
cron -f
