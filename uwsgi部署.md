**Xiang Wang @ 2017-01-23 14:05:03**


# 基础
## 安装
```
    pip3 install uwsgi
```

## 启动服务

```
# 直接用http启动
sudo uwsgi --chdir=/home/wangx/proj \
    --module=proj.wsgi:application \
    --env DJANGO_SETTINGS_MODULE=proj.settings \
    --master --pidfile=/home/wangx/proj/project-master.pid \
    --http=0.0.0.0:49159 --processes=5 \
    --uid=1000 --gid=2000 \
    --harakiri=20 \
    --max-requests=50000 \
    --vacuum \
    --daemonize=/home/wangx/proj/yourproject.log

# 使用socket启动
sudo uwsgi --chdir=/home/wangx/proj \
    --module=proj.wsgi:application \
    --env DJANGO_SETTINGS_MODULE=proj.settings \
    --master --pidfile=/tmp/project-master.pid \
    --http=127.0.0.1:49160 --processes=5 \
    --uid=1000 --gid=2000 \
    --harakiri=20 \
    --max-requests=50000 \
    --vacuum \
    --daemonize=/home/wangx/proj/yourproject.log
```

## 服务器管理
* 重启服务器
```
# using kill to send the signal
kill -HUP `cat /tmp/project-master.pid`
# or the convenience option --reload
uwsgi --reload /tmp/project-master.pid
```

* 停止服务器
```
kill -INT `cat /tmp/project-master.pid`
# or for convenience...
uwsgi --stop /tmp/project-master.pid
```


## 设置守护进程
[文档](http://uwsgi-docs.readthedocs.io/en/latest/Systemd.html)

