**Xiang Wang @ 2018-09-12 18:45:11**


# [Time Zones时区](https://docs.djangoproject.com/en/2.0/topics/i18n/timezones/)
* 把时间戳变成timezone的时间
```
    timezone.make_aware(timezone.datetime.fromtimestamp(1536747609))
```
* 获得当前时间
```
    from django.utils import timezone
    timezone.now()  # utf的时间
    timezone.timedelta(days, seconds)
    timezone.localtime()  # 服务器的时间
```
* 把datetime变成timezone
```
    timezone.now().isoformat()
    timezone.timedelta(days, seconds, microseconds)

    import pytz
    tz = pytz.timezone('Asia/Shanghai')
    model_instance.createtime.astimezone(tz)
```
