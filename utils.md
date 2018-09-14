#### Xiang Wang @ 2016-08-23 15:49:48

## 生成随机字符串
    from django.utils.crypto import get_random_string
    get_random_string(length=6)

## 获取查询语句
    from django.db import connection
    print connection.queries

## url
    from django.utils.six.moves.urllib.parse import urlparse, urlunparse
