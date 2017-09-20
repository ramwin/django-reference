#### Xiang Wang @ 2017-05-24 16:32:47

### 基础
* [官方教程](https://docs.djangoproject.com/en/1.11/ref/signals/#pre-save)
* 示例

```
    def my_callback(sender, **kwargs):
        log.info("Request finished!")


    def my_signal(sender, *args, **kwargs):
        print(kwargs['instance'])
        print("calling my_signal")


    from django.core.signals import request_finished
    request_finished.connect(my_callback)


    from django.db.models.signals import pre_init
    pre_init.connect(my_signal, sender=TestSignal)
```

### API
* `post_save`
    * 参数:
        * sender: class的类
        * instance: 对象
        * created: 是否是刚创建的
        * `update_fields`: TODO 待完善


* `post_delete`
    * 如果有外键关联到这个model，那这个外键被删除的时候，触发的联合删除也会触发,并且是先有依赖的外键的model被删除，这个instance本身是最后被删除的
    * 参数:
        * sender
        * instance
        * using
