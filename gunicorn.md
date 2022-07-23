### 用gunicorn部署django
[官网](https://docs.gunicorn.org/en/latest/signals.html)

```python
gunicorn project.wsgi \
    --workers 8  --threads 4 \
    --max-requests 10000 --max-requests-jitter 3000 \
    --bind unix:<socketfile> # \ 获取 --bind ip:port
```

#### 参数
* daemon
* pidfile  
* workers  
CPU-1/0  
* threads  
2-4  
* max-requests
* max-requests-jitter

#### 信号
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
