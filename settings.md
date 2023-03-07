## [Settings配置](https://docs.djangoproject.com/en/4.1/ref/settings/)
我的常用设置
```python3
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.db.DatabaseCache",
    },
}
```

* [ ] overview

### [Full list of settings 所有配置](https://docs.djangoproject.com/en/4.1/ref/settings/#caches)

#### Core Settings

    * [ ] CSRF_TRUSTED_ORIGINS

#### CACHES
* [BACKEND](https://docs.djangoproject.com/en/4.1/ref/settings/#backend)
```
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.db.DatabaseCache",
    },
}
```

* [Databases](http://ramwin.com:8888/ref/settings.html#databases)
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'mydatabase',
    }
}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

* Auth
    * AUTH_USER_MODEL
* Sessions
    * SESSION_COOKIE_AGE
    默认1209600(2 weeks), 当session过期的时候，就会直接变成not authenticated了。但是这个session的过期时间是看上次生成的日期的。更改后，以前登录过的人，还是一直在登录状态。麻烦.
    * [ ] [如何根据不活跃时间来计算expire](https://stackoverflow.com/questions/3024153/how-to-expire-session-due-to-inactivity-in-django)
    * [ ] 如何处理之前登录过，有个很长的cookie的人
