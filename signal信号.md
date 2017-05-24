#### Xiang Wang @ 2017-05-24 16:32:47

# 基础
* [官方教程](https://docs.djangoproject.com/en/1.11/ref/signals/#pre-save)
* 示例
```
    def my_callback(sender, **kwargs):
        log.info("Request finished!")


    def my_signal(sender, *args, **kwargs):
        print("calling my_signal")


    from django.core.signals import request_finished
    request_finished.connect(my_callback)


    from django.db.models.signals import pre_init
    pre_init.connect(my_signal, sender=TestSignal)
```
