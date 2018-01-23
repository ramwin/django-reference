#### Xiang Wang @ 2016-08-23 15:49:48

## 23兼容
    from django.utils.encoding import python_2_unicode_compatible
    from __future__ import unicode_literals
## 生成随机字符串
    from django.utils.crypto import get_random_string
    get_random_string(length=6)

## 获取查询语句
    from django.db import connection
    print connection.queries


## url
    from django.utils.six.moves.urllib.parse import urlparse, urlunparse


## global
* ### [时区](https://docs.djangoproject.com/en/2.0/topics/i18n/timezones/)
```
    from django.utils import timezone
    timezone.now()  # utf的时间
    timezone.timedelta(days, secon
    timezone.localtime()  # 服务器的时间
    timezone.now().isoformat()
    timezone.timedelta(days, seconds, microseconds)
```
