# logging
[官网](https://docs.djangoproject.com/en/5.0/topics/logging/)

## 基础
* 配置日志
```
LOG_DIR = BASE_DIR / 'log'
LOG_DIR.mkdir(exist_ok=True)
DEFAULT_HANDLERS = [
    'debug_file', 'info_file',
    'warning_file', 'error_file', 'color'
]
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': ('[%(levelname)5s] %(asctime)s %(pathname)s '
                       '%(funcName)s (line: %(lineno)d)'
                       '    %(message)s'),
        },
        'simple': {
            'format': '[%(levelname)s] %(message)s ',
        },
        'color': {
            '()': 'colorlog.ColoredFormatter',
            'format': ('%(log_color)s[%(levelname)5s] %(asctime)s %(process)d %(name)s '
                       '%(funcName)s (line: %(lineno)d)'
                       '    %(message)s'),
        },
    },
    'handlers': {
        'error_file': {
            'level': "ERROR",
            'class': 'logging.FileHandler',
            'filename': LOG_DIR / 'error.log',
            'formatter': 'verbose',
        },
        'warning_file': {
            'level': "WARNING",
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': LOG_DIR / 'warning.log',
            'maxBytes': 1024 * 1024 * 10,
            'backupCount': 20,
            'formatter': 'verbose',
        },
        'info_file': {
            'level': "INFO",
            'class': 'logging.handlers.RotatingFileHandler',
            'maxBytes': 1024 * 1024 * 10,
            'backupCount': 20,
            'filename': LOG_DIR / 'info.log',
            'formatter': 'verbose',
        },
        'debug_file': {
            'level': "DEBUG",
            'class': 'logging.handlers.RotatingFileHandler',
            'maxBytes': 1024 * 1024 * 10,
            'backupCount': 20,
            'filename': LOG_DIR / 'debug.log',
            'formatter': 'verbose',
        },
        # 'console': {
        #     'class': 'logging.StreamHandler',
        #     'formatter': 'verbose',
        # },
        'color': {
            'class': 'colorlog.StreamHandler',
            'level': "INFO",
            'formatter': 'color',
        },
    },
    'loggers': {
        'default': {
            'handlers': DEFAULT_HANDLERS,
            'level': "INFO",
        },
        'django': {
            'handlers': DEFAULT_HANDLERS,
            'level': "INFO",
        },
        'testapp': {
            'handlers': DEFAULT_HANDLERS,
            'level': "INFO",
        },
    },
}
```
* 调用日志
```
log = logging.getLogger(__name__)  # 这样不同的app就会用logging里面不同的配置，而不需要把logger重新定义了
```

## Handlers
* MemoryHandler
Memory不方便close

## formatters
如果要使用自定义的类，需要用`()`
