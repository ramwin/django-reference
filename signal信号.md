# Signal
**Xiang Wang @ 2017-05-24 16:32:47**

[官方教程](https://docs.djangoproject.com/en/5.0/topics/signals/) [参考](https://docs.djangoproject.com/en/3.0/ref/signals/)

## 源码剖析
注册一个`post_save`后,就会在receivers里面添加对应的key和函数. 如果下次sender来了,就根据`_make_id`来判断是否要执行. 这会导致dispatch无法处理proxy的model. [想解决?12年前就提出来了,没采纳](https://code.djangoproject.com/attachment/ticket/9318/0001-Propagate-message-to-parent-s-handler-sender-is-chil.patch)

```python3
def _make_id(target):
    if hasattr(target, "__func__"):
        return (id(target.__self__), id(target.__function__))
    return id(target)
class Signal:

    def send(self, sender, **named):
        return [
            (receiver, receiver(signal=self, sender=sender, **named)
            for receiver in self._live_receivers(sender)
        ]

    def _live_receivers(self, sender):
        senderkey = _make_id(sender)
        for (receiverkey, r_senderkey), receiver in self.receivers:
            if r_senderkey == NONE_ID or r_senderkey = senderkey:
                receivers.append(receiver)
```

## Listening to signals
* preventing duplicate signals
每次绑定的时候，同样的函数只会绑定一次。多个函数会按照绑定的顺序依次执行。 如果你希望一个函数绑定2次，需要添加`dispatch_uid`参数
```
from django.core.signals import request_finished  
request_finished.connect(my_callback, dispatch_uid="my_unique_identifier")
```

## [定义signal](https://docs.djangoproject.com/en/5.0/topics/signals/#defining-and-sending-signals)
### Defining signals
```
import django.dispatch

pizza_done = django.dispatch.Signal()
pizza_done.connect(function, sender)
```

### Sending signals
```
pizza_done.send(sender=self.__class__, toppings=toppings, size=size)
```

## ModelSignals
### 示例
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

### `pre_init`
### `post_init`

### `pre_save`
[官方文档](http://ramwin.com:8888/ref/signals.html#pre-save)

### post_save
再用django-rest-framework的ModelSerializer的时候, 因为ModelSerializer的create, 是先创建model,然后设置manytomany的, 所以会导致如果通过post_save来创建, 会导致拿不到关联的manytomany的情况
```
def create(self, validated_data):
    for field in info.relations.items():
        many_to_many[field_name] = validated_data.pop(field_name)
    instance = create(**validated_data)
    for field_name, value in many_to_many.items():
        getattr(instance, field_name).set(value)
```
* 参数:
    * sender: class的类
    * instance: 对象
    * created: 是否是刚创建的
    * `update_fields`:
        * 这个是Model.save的时候传入的. 不传就是None了
        * 如果是**update_or_create**,更新时有update_fields


### post_delete
* 如果有外键关联到这个model，那这个外键被删除的时候，触发的联合删除也会触发,并且是先有依赖的外键的model被删除，这个instance本身是最后被删除的
* 参数:
    * sender
    * instance, 注意此时 instance.id 还是可以获取的
    * using
```{note}
批量删除的时候每条数据都会触发信号, 但是DELETE语句是只有一句(用的id__in)。所以会导致第一个model的post_delete里面去查询返回的数字是0
```

### m2m_changed
M2Mchanged有点复杂，因为他分为正向和反向的情况，可能是user.books.add(book) 也可能是 book.user_set.remove(user)  
每次保存reverse只会触发一个  
每次新增pre_add, post_add都会触发一次  
直接set也会给每个触发pre_add,post_add,pre_remove,post_remove。但是不变的不会触发  
无法拿到被添加的child，因为只有pk_set  
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

## to be continued
* [ ] Model_signals
    * [ ] pre_init
    * [ ] post_init
    * [ ] post_save
    * [ ] pre_delete
    * [ ] class_prepared
* [ ] Management signals
* [ ] Request/response signals
* [ ] Test signals
* [ ] database wrappers
