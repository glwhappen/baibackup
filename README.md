# 文件夹备份到百度网盘

此设置提供了一个Docker容器，用于使用crontab在预定时间执行备份任务。它配置了将文件备份到远程目录的功能，并通过环境变量提供调整计划和备份参数的灵活性。

## 先决条件

- 你的机器上安装了Docker和docker-compose。
- 一个可用于备份的远程目录。

## 配置

通过环境变量可以自定义备份计划和行为：

- `CRON_SCHEDULE`：定义备份任务应何时运行。默认值为`"* 2 * * *"`，即每天凌晨2点执行任务。
- `REMOTE_DIR`：指定备份将存储的远程目录路径。
- `TIME_FILE`：控制附加到备份目录上的时间戳格式，默认为`"+%Y%m%d-%H%M%S"`。
- `ON_DUP`：确定遇到重复文件时的行为，默认动作为`"overwrite"`（覆盖）。


## 快速使用

```yml
version: '3.8'
services:
  bypy_backup:
    image: glwhappen/baibackup:latest
    volumes:
      - ./backup:/root/backup # 需要自动备份的本地目录
      - ./.bypy:/root/.bypy # 百度网盘授权文件夹，如果为空，需要自己进入容器，输入bypy info 进行授权登录
      - ./logs:/app/logs  # 挂载日志目录
    environment:
      - REMOTE_DIR=/remote/linux/test1 # 百度网盘远程的位置
      - CRON_SCHEDULE=* 2 * * * # 自动备份时间 每天晚上2点
      - TIME_FILE=+%Y%m%d%H%M%S # +%Y%m%d-%H%M%S
      - ON_DUP=overwrite # overwrite skip
```