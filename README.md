# baibackup 本地文件备份到百度网盘

使用docker快速将本地文件夹备份，定时自动备份到百度网盘。

## 特点

- 一次登录处处备份。
- 备份linux下的重要文件。
- 可以按照时间进行文件夹的管理。

## 先决条件

- 你的机器上安装了Docker和docker-compose。
- 有个百度网盘账号。
- 会docker和docker-compose的基础操作。



## 快速使用

第一次运行以后，需要在docker-compose.yml 所在文件输入`docker compose exec baibackup bypy info` 然后就可以进行百度网盘的登录。

下次移动的时候，包含.bypy文件目录就可以自动登录

docker-compose.yml 文件内容：

```yml
version: '3.8'
services:
  baibackup:
    image: glwhappen/baibackup:latest
    volumes:
      - ./backup:/root/backup # 需要自动备份的本地目录
      - ./.bypy:/root/.bypy # 百度网盘授权文件夹，如果为空，需要自己进入容器，输入bypy info 进行授权登录
      - ./logs:/app/logs  # 挂载日志目录
    environment:
      - REMOTE_DIR=/remote/linux/test1 # 百度网盘远程的位置: 我的应用数据/bypy/remote/linux/test1
      - CRON_SCHEDULE=* 2 * * * # 自动备份时间 每天晚上2点
      - TIME_FILE=+%Y%m%d%H%M%S # +%Y%m%d-%H%M%S
      - ON_DUP=overwrite # overwrite skip
```


## 配置

通过环境变量可以自定义备份计划和行为：

- `CRON_SCHEDULE`：定义备份任务应何时运行。默认值为`"* 2 * * *"`，即每天凌晨2点执行任务。
- `REMOTE_DIR`：指定备份将存储的远程目录路径。进入百度网盘的 我的应用数据> bypy 即可看到
  ![](https://raw.githubusercontent.com/glwhappen/images/main/img/202403201901906.png)
- `TIME_FILE`：控制附加到备份目录上的时间戳格式，默认为`"+%Y%m%d-%H%M%S"`。
- `ON_DUP`：确定遇到重复文件时的行为，默认动作为`"overwrite"`（覆盖）。
