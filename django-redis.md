**Xiang Wang @ 2020-12-09 19:24:25**


## django-redis
### 直接使用`get_redis_connection`
* `get_redis_client(alias="default", write=True)`
    ```
    django_redis/__init__.py
    from django.core.cache import caches
    cache = caches[alias]
    return cache.client.get_client(write)  # django_redis.client.default.DefaultClient.get_client
    ```

* `django_redis.cache.client`
    ```
    @property
    def client(self):
        return self._client_cls(self._server, self._params, self)
        # self._params
        # {'OPTIONS': {'REDIS_CLIENT_KWARGS': {'decode_responses': True}}}
    ```

* `get_client(write)`
    ```
    # django_redis.client.default.DefaultClient.get_client
    return self.connect(index)
    ```

* `client.default.DefaultClient.connect(index)`
    ```
    return self.connection_factory.connect(self._server[index])
    return self.connection_factory.connect("redis://127.0.0.1:6379/0")
    ```

* `django_redis.pool.ConnectionFactory.connect(url)`
    ```
    params = self.make_connection_params(url)
    # params
    {
        'url': 'redis://127.0.0.1:6379/0',
        'parser_class': <class 'redis.connection.HiredisParser'>,
        'decode_responses': True
    }
    connection = self.get_connection(params)
    return connection
    ```

* `django_redis.pool.ConnectionFactory.get_connection(params)`
    ```
    pool = self.get_or_create_connection_pool(params)
    return self.redis_client_cls(
        connection_pool=pool, **self.redis_client_cls_kwargs
    )
    ```

* `redis_client_cls_kwargs`
    ```
    ```

### 使用cache流程
1. `django_redis.cache.get`
    ```
    return self.client.
    ```
