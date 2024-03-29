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

1. 将下面的内容保存到一个英文目录下，名称为 docker-compose.yml。
2. 编写好对应的配置以后，在目录下输入 `docker compose up -d` 启动。
3. 在目录下继续输入`docker compose exec baibackup bypy info` 进行百度网盘的登录，会让你访问一个url，然后获取授权码，填入按回车。
4. 这个时候 `docker compose down` 结束服务，再次输入 `docker compose up -d` 启动。
5. 下次换设备，携带上.bypy文件目录即可自动登录。

docker-compose.yml 文件内容：

```yml
version: '3.3'
services:
  baibackup:
    image: glwhappen/baibackup:latest
    volumes:
      - ./backup:/root/backup # 需要自动备份的本地目录
      - ./.bypy:/root/.bypy # 百度网盘授权文件夹，如果为空，需要自己进入容器，输入bypy info 进行授权登录
      - ./logs:/app/logs  # 挂载日志目录
    environment:
      - REMOTE_DIR=/baibackup/{TIME_FILE}/linux # 百度网盘远程的位置: 我的应用数据/bypy/baibackup/20230320/linux
      - CRON_SCHEDULE=* 2 * * * # 自动备份时间 每天晚上2点
      - TIME_FILE=+%Y%m%d # %Y%m%d%H%M%S 备份路径中的时间目录格式，分别是年月日时分秒，可以根据自己的情况修改，目前是年月日
      - ON_DUP=overwrite # overwrite skip
```


## 配置

通过环境变量可以自定义备份计划和行为：

- `CRON_SCHEDULE`：定义备份任务应何时运行。默认值为`"* 2 * * *"`，即每天凌晨2点执行任务。
- `REMOTE_DIR`：指定备份将存储的远程目录路径。进入百度网盘的 我的应用数据> bypy 即可看到
  ![](https://raw.githubusercontent.com/glwhappen/images/main/img/202403201901906.png)
- `TIME_FILE`：控制附加到备份目录上的时间戳格式，默认为`"+%Y%m%d-%H%M%S"`。
- `ON_DUP`：确定遇到重复文件时的行为，默认动作为`"overwrite"`（覆盖）。
