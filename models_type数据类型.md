
## [方法](https://docs.djangoproject.com/en/2.0/ref/models/instances/)
### create...
### refresh_from_db
### validate objects..
### [save](https://docs.djangoproject.com/en/2.0/ref/models/instances/#saving-objects)
save的时候，会把model的所有数据全量更新一遍，所以两个线程来了，只会save最后一个的数据
* 主键有就是update，主键没有就是insert
* save的时候发生了什么
    1. 触发model的pre—save信号
    2. 处理数据，每个field触发`pre_save`，比如`auto_now_add`和`auto_now`
    3. 处理给数据库的数据，每个field触发`get_db_prep_save`
    4. 插入数据
    5. 触发post-save信号
* django怎么区分update和insert
* 指定更新哪些field: `product.save(update_fields=["name"])`
    * 更新后，并不会触发`refresh_from_db`

### delete...
### pickle...
### `__str__`
### `__eq__`
### `__hash__`
### `get_absolute_url`


## 待更新

# [Field类型](https://docs.djangoproject.com/en/2.0/ref/models/fields/#field-types)
## 字符串

```
    models.CharField(max_length=255)
    models.TextField()  # 默认会为""
        max_length  # 不是数据库底层支持的。
    models.EmailField()
        # 底层还是 CharField 只不过用 EmailValidator 去校验
```

* [EmailValidator](https://docs.djangoproject.com/en/1.10/ref/validators/#django.core.validators.EmailValidator)

## UUIDField
```
    import uuid
    models.UUIDField(default=uuid.uuid4)
```


## DateTimeField

* 参数
    * `auto_now_add = True`: 保存为当前时间，不再改变
    * `auto_now = True`: 保存未当前时间，每次保存时候会自动变更
* 示例
    * 如果`timezone = 'UTC'`
        ```
        DateTimeModel.objects.create(time=timezone.now())  # 没问题
        DateTimeModel.objects.create(time=datetime.now())  # 自动保存为当前时间, 因为datetime.now()会自动变化，所以这个时间也是正确的
        DateTimeModel.objects.create(time='2017-12-12 10:24:00')  # 保存为UTC的10点了，如果是客户直接上传的，就会到处差了8小时
        DateTimeModel.objects.create(time='2017-12-12T10:24:00+08:00')  # 这么精确，也没问题
        ```
    * 如果`timezone = 'Asia/Shanghai'
        ```
        DateTimeModel.objects.create(time=timezone.now())  # 没问题
        DateTimeModel.objects.create(time=datetime.now())  # 自动保存为当前时间, 因为datetime.now()会自动变化，所以这个时间也是正确的
        DateTimeModel.objects.create(time='2017-12-12 10:24:00')  # 保存为Asia/Shanghai的10点了，如果是客户直接上传的，因为恰好客户和我们的服务器是同一个时区，所以也没问题
        DateTimeModel.objects.create(time='2017-12-12T10:24:00+08:00')  # 这么精确，也没问题
        ```
    * 结论: 服务器端都用timezone，客户端都用带iso 8601


## 日期
## 对于日期,不存在时区的概念,都是直接存入的日期,没有转化成utc


## 数字
* 基础
    ```
    models.IntegerField()   # 整数 -2147483648 - -2147483648
    models.PositiveSmallIntegerField()  # 0 - 32767
    models.SmallIntegerField()  #  -32767 - 32767
    models.PositiveIntegerField() # 0 - 2147483647

    models.FloatField() # 小数
        如果设置了unique的话，就会在数据库层面设置unique。不过数据库显示的时候偶尔会看上去一样
        实际上二者的二进制数据有点区别，换成是十进制后显示不出来。在python内部可以显示
    models.DecimalField()   # 精确小数
    ```
* AutoField
    ```
    # 不使用原来的id，而是使用自定义的主键。注意一个model里面primary_key只能有一个，autofield也只能有一个
    models.AutoField(primary_key=True)
    ```

### 必须参数(decimal)

```
    decimal_places = 2  # 小数尾数
    max_digits = 3  # 数字的位数(包括小数)
```

### 保存

```
    integer:    1, '1', 不可以是 '2.9', 但是可以是 2.9(之后存入2), 调用的是int函数
    float:  '1.1', 1.1
    decimal:    '1.1', 1.1, decimal.Decimal('1.1')
```

## [SlugField](https://docs.djangoproject.com/en/2.0/ref/models/fields/#slugfield)
    * 包含`[a-zA-Z_-]`，可以用在一些变量名上面
    * max_length 默认50
    * allow_unicode: 默认False，是否允许非ascii的名字

## 布尔值
    models.BooleanField()   # 布尔值

## 关联
### 一对一

```
    models.ForeignKey(Model)    # 关联到另一个Model
    models.OneToOneField(Model, related_name="profile", db_index=True)
```

#### 参数

    def get_default_user():
        return User.objects.first()

    limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
    related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )
* [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  
    * models.CASCADE: `连带删除`
    * models.PROTECT: `报错`
    * models.SET_NULL: `设置为空`
    * models.SET_DEFAULT: `设置为默认`
    * models.SET(): `调用函数`



#### 使用
    
```
    user.profile
```

### 多对一
* 请使用ForeignKey [参考](https://docs.djangoproject.com/en/1.10/topics/db/examples/many_to_one/)

### 其他
* 如果调用了本身，可以使用 `models.ForeignKey('self', on_delete=models.CASCADE)`
* 如果单独的manytomany, 可以使用through获取那个隐藏的model
```
    school.students.through.objects.filter(school=school)
```


## 特殊
### Meta的作用
```
    class Meta:
        unique_together = ("user","date")   # 同一个用户同一个时间只允许一次(比如投票)
    如果不符合，会报错  django.db.utils.IntegrityError
        ordering = "-id"  # 指定默认排序方式
        db_table = "table"  # 指定表的名称
        abstract = True # 表不进行创建，只用来继承
        verbose_name = '显示名字'
        verbose_name_plural = '显示名字'
```
### property的作用
* views里面可以直接调用,不用加括号
**但是不能在aggregrate或者filter里面使用**

### str的作用
* 可以让shell里面查看model更加好看一点，但是要注意，尽量不要把id放在里面，
* 不然在model没有save的时候，会报错。就算放，也用 instance.pk or 0的形式


## 其他属性设置

### Meta
```
    db_table: "设置使用的表的名称"
    verbose_name: "在admin界面显示的内容"
    verbose_name_plural: "用于复数的时候显示的内容"
```

## Signal
**注意,model的signal不是异步的，而是同步的。如果有异步的需求，请使用celery**
