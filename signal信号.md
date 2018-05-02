**Xiang Wang @ 2017-05-24 16:32:47**

# [官方教程](https://docs.djangoproject.com/en/2.0/ref/signals/#)
# ModelSignals
## 示例
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

## post_save
* 参数:
    * sender: class的类
    * instance: 对象
    * created: 是否是刚创建的
    * `update_fields`: TODO 待完善


## post_delete
* 如果有外键关联到这个model，那这个外键被删除的时候，触发的联合删除也会触发,并且是先有依赖的外键的model被删除，这个instance本身是最后被删除的
* 参数:
    * sender
    * instance, 注意此时 instance.id 还是可以获取的
    * using

## m2m_changed
M2Mchanged有点复杂，因为他分为正向和反向的情况，可能是user.books.add(book) 也可能是 book.user_set.remove(user)
* 示例
```
from django.db.models.signals import m2m_changed
m2m_changed.connect(function, sender=ManyModel.texts.through)
```
* 参数
    * sender
    * instance
    * action: `pre_add|post_add|pre_remove|post_remove|pre_clear|post_clear`
    * reverse
    * model
    * pk_set
    * using

# to be continued
* [ ] Model_signals
    * [ ] pre_init
    * [ ] post_init
    * [ ] pre_save
    * [ ] post_save
    * [ ] pre_delete
    * [ ] class_prepared
* [ ] Management signals
* [ ] Request/response signals
* [ ] Test signals
* [ ] database wrappers
