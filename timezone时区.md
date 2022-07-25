**Xiang Wang @ 2018-09-12 18:45:11**


## [Time Zones时区](https://docs.djangoproject.com/zh-hans/4.0/topics/i18n/timezones/)

### utils
* 获取当前的timezone
`get_default_timezone` 获取默认的timezone(我的项目就是返回上海的时区了)

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

    model_instance.createtime.astimezone(timezone.get_default_timezone())

    model_instance.createtime  # datetime.datetime(2020, 2, 27, 23, 25, 46, 845967, tzinfo=<UTC>)
    model_instance.createtime.date()  # 2020-02-27
    model_instance.createtime.astimezone(timezone.get_default_timezone())
    # datetime.datetime(2020, 2, 28, 7, 25, 46, 845967, tzinfo=<DstTzInfo 'Asia/Shanghai' CST+8:00:00 STD>)
    model_instance.createtime.astimezone(timezone.get_default_timezone()).date()  # datetime.date(2020, 2, 28)
    Model.objects.filter(id=model_instance.id, createtime__date='2020-02-27')  # None
    Model.objects.filter(id=model_instance.id, createtime__date='2020-02-28')  # [model_instance]
```

### 概念
* Default time zone and current time zone

### 在model中使用
* 默认获取的时间都是UTC的
* 如果你要获取date, time需要先`astimezone(timezone.get_default_timezone())`
* 但是在利用date或者hour过滤时，直接用local的时间就可以
