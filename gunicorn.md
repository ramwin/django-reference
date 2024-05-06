# gunicorn

用来部署django

[官网](https://docs.gunicorn.org/en/latest/signals.html)

* 命令行配置
```python
gunicorn project.wsgi \
    --workers 8  --threads 4 \
    --max-requests 10000 --max-requests-jitter 3000 \
    --bind unix:<socketfile> # \ 获取 --bind ip:port
```

* 快速配置
```
cat config.py

daemon = True
workers = 2
threads = 4
pidfile = gunicorn.pid
bind = "0.0.0.0:8000"
accesslog = "log/gunicorn.access.log"
errorlog = "log/gunicorn.error.log"

gunicorn project.wsgi -c config.py
```

## 参数
[官网](https://docs.gunicorn.org/en/latest/settings.html)  
* daemon  是否当做放在后台运行
* pid  pid保存路径
如果是py文件的配置就是pidfile
* workers  多少个进城
CPU-1/0  
* threads  每个进城多少线程
2-4  
* max-requests  处理多少次请求后,重新载入进程
* max-requests-jitter  避免所有进程一起失效，建议jitter设置为max-requests的一半

## 信号
```shell
kill -TERM pid
kill -HUP `cat pidfile`
```
* TERM
graceful 终止进程

* HUP
重新载入配置

* TTIN/TTOU
增加/减少进程数量
