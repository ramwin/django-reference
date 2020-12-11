**Xiang Wang @ 2018-08-07 15:25:20**

### [Introduction简介][models]

### [Options][options]
* null = True,    # 是否可以是NULL
* blank=True      # admin界面是不是可以不填写。不填写的话就是NULL, 但是不影响model的创建
* [ ] `db_tablespace`
* [ ] choices
* db_column 数据库内的字段名. django会封装的,所以不用担心有特殊字符. 默认就是field的name
* default = '0',  # 默认的数值
* editable  
如果是False, 那么这个字段就不会在ModelForm里面显示
* [ ] `error_messages`
* related_name = 'table'  # 设置反向查找的功能
* verbose_name = '名字'   # admin界面用来给人看的名称,账号，而不是username
* help_text = ''  # 在每个model的form下面有一小行字符串。显示帮助信息。账号必须多于6个字符等等
* through = ''
* choices = TUPLE
* unique (False)
    1. 是否允许重复, 如果设置了True，并且一个model里面有2个True，get_or_create就必须把每个这样的字段设置好，不然就会报错
    2. [关于null和unique同时存在的问题][unique-fields-allow-null], unique校验只对非null的进行唯一校验，包括空字符串，也不能重复
* primary_key = True # 是否为主键。最多一个，并且会自动加上null=False, unique=True
* unique
* null 和 blank  
如果是其他field，空值会变成null。但是如果是charfield和textfield，因为form的缺陷，无法传递null，所以会导致永远不可能insertnull，只会insert空字符串。
    * 测试代码
    ```
    can_null_blank = models.TextField(null=True, blank=True)
    can_null = models.TextField(null=True)  # 可以不填或填None，不能填 ""
    can_blank = models.TextField(blank=True)  # 可以不填或填"", 不能填 None
    can_default = models.TextField(default="")  # 可以不填, 但是不能为空或者None
    can = models.TextField()  # 必填, 不能为空
    # 如果是integer，不填的话就会变成None
    can_null_blank_integer = models.IntegerField(null=True, blank=True)
    ```
    * [null和blank的问题](https://stackoverflow.com/questions/8609192/differentiate-null-true-blank-true-in-django/50015717#50015717)

### [Field Types 字段类型](https://docs.djangoproject.com/en/3.1/ref/models/fields/#field-types)
* AutoField, BigAutoField, BigIntegerField, BinaryField
* [BooleanField](https://docs.djangoproject.com/en/3.1/ref/models/fields/#booleanfield)  
> before 1.11 version: use NullBooleanField  
> after 2.0 version: user BooleanField(null=True)
* CharField
```
models.CharField(max_length=255)
models.TextField()  # 默认会为""
    max_length  # 不是数据库底层支持的。
models.EmailField()
# 底层还是 CharField 只不过用 EmailValidator 去校验
```
* #### [DateField](https://docs.djangoproject.com/en/3.1/ref/models/fields/#datefield)
对于日期,不存在时区的概念,都是直接存入的日期,没有转化成utc
    * [`auto_now`](https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.DateField.auto_now)
    自动保存为当前时间。当调用Model.save()的时候，这个字段会自动更新。如果你不希望更新，就使用QuerySet.update()
    * [`auto_now_add`](https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.DateField.auto_now_add)
    只有当model第一次创建的时候，自动设置为当前时间。所以后续可以更改。

* #### DateTimeField
    * 参数
        * `auto_now_add = True`: 保存为当前时间，不再改变 见DateField
        * `auto_now = True`: 保存未当前时间，每次保存时候会自动变更 见DateField
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

#### DecimalField
[官网](https://docs.djangoproject.com/en/2.2/ref/models/fields/#decimalfield)  
* decimal:    '1.1', 1.1, decimal.Decimal('1.1')
    * required 参数
    ```
    max_digits = 3  # 数字的位数(包括小数), >= decimal_places
    decimal_places = 2  # 小数尾数
    ```
    * 注意事项
        * 整数部分的最大长度就是 max_digits - decimal_places, 不会因为某个数字小数部分没有而导致整数部分可以变得更长
        * 小数部分的最大长度就是 decimal_places, 不会因为整数部分短了这个就长
        * 不能传"", 或者None
        * 有了default就可以不传
        * 如果设置了blank=True, admin页面就能传递None(就算有default也不会设置成default, 而是这是成None), 后台不支持null=True的话就会报错
* DurationField  
[官网](https://docs.djangoproject.com/en/3.1/ref/models/fields/#durationfield)
时间字段, 返回python里的timedelta. 如果是PostgreSQL, 使用的是interval类型.  
如果是其他的，一般都是存bigint表明要多少microseconds  

* [ ] EmailField

#### [FileField](https://docs.djangoproject.com/en/3.0/ref/models/fields/)
`class FileField(upload_to="uploads/%Y/%m/%d")`
* [ ] FilePathField
* [FloatField](https://docs.djangoproject.com/en/2.2/ref/models/fields/#floatfield)
* [ ] ImageField
* #### IntegerField
[官网](https://docs.djangoproject.com/en/2.2/ref/models/fields/#integerfield)
integer:    1, '1', 不可以是 '2.9', 但是可以是 2.9(之后存入2), 调用的是int函数
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
* GenericIPAddressField
* NullBooleanField
> Like BooleanField with null=True. Use that instead of this field as it’s likely to be deprecated in a future version of Django.
* PositiveIntegerField, PositiveSmallIntegerField,
* [SlugField][slugfield]
    * 包含`[a-zA-Z_-]`，可以用在一些变量名上面
    * max_length 默认50
    * allow_unicode: 默认False，是否允许非ascii的名字
* SmallIntegerField
* TextField
TextField如果定义了max_length, 会影响view和form. 但是在数据库底层实现上没有max_length这个说法.
* TimeField
#### URLField  
其实就是CharField加上了URLValidator,  默认是200个字符长度

#### UUIDField
```
import uuid
models.UUIDField(default=uuid.uuid4)
```

### [Relationship fields 关联字段][relation]
#### [ForeignKey](https://docs.djangoproject.com/en/3.1/ref/models/fields/#foreignkey)
* Example 例子  
    ```
    def get_default_user():
        return User.objects.first()
    
    limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
    related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )
    ```
* [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  
    * models.CASCADE: `连带删除`
    * models.PROTECT: `报错`
    * models.SET_NULL: `设置为空`
    * models.SET_DEFAULT: `设置为默认`
    * models.SET(): `调用函数`
    * models.DO_NOTHING: `什么都不做,但是数据库如果限制会有报错`

#### [OneToOneField][onetoone]
```
models.ForeignKey(Model)    # 关联到另一个Model
models.OneToOneField(Model, related_name="profile", db_index=True)
```
* 参数
    * limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
    * related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
    * 设置被删除后，设置成一个其他用户
    ```
    def get_default_user():
        return User.objects.first()
    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )
    ```

#### ManyToManyField
[官网](https://docs.djangoproject.com/en/1.10/ref/models/fields/#manytomanyfield)

##### 参数
* [ ] `related_name, related_query_name, limit_choices_to`
* symmetrical
[官网](https://docs.djangoproject.com/en/2.0/ref/models/fields/#django.db.models.ManyToManyField.symmetrical)
```
class Person(models.Model):
    friends = models.ManyToManyField("self")
```
默认为`True`, 代表如果personA的friends有personB, 那么personB的friends也就有A了, 所以也不存在~~`friends_set`~~ `person_set`属性
如果需要分别计算, 需要设置symmetrical为`False`, 这样A把B当朋友, B就可以不把A当朋友了, 此时

* through = "ModelRefName"  *可以把中间关联的表拿出来写成model加参数*
* `through_fields`
[官网](https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.ManyToManyField.through_fields)
`through_fields = ("source_field_name", "target_field_name")`
当through定义的时候才有效, 如果through的表里面有多个field外键到同一张表, 第一个字段代表那个field代表了自己这个model, 第二个字段代表哪个field代表了manytomany的field

* `db_table` = "关联的表名"  *关联的数据库的表名称*
* [ ] `db_constraint`
* [ ] swappable
* null对于ManyToManyField没有任何效果

##### api
[官网](https://docs.djangoproject.com/en/1.11/topics/db/examples/many_to_many/)
* 基础
    ```
    label = models.ManyToManyField(Label, verbose_name=u'标签', null=True)
    todos = models.ManyToManyField(TodoList, through="WeeklyPaperTodoRef")
    ```
* add:
[官网](https://docs.djangoproject.com/en/1.11/ref/models/relations/#django.db.models.fields.related.RelatedManager.add)
    ```
    model.todos.add('1','2')  # 可以是数字，可以是字符串，可以是对象。只要是一个一个传入的即可，add以后就立刻添加进入了数据库
    1. return None, 无法通过结果来判断是否有添加
    2. 如果已经在里面了，不会二次添加
    3. 如果不再这个里面，就会直接加进去
    return None
    ```
* remove:
    ```
    model.label.remove(label1, label2)  # 可以重复，可以多个
    ```
* set:
    ```
    model.label.set([label1, label2])
    ```
* clear:
    ```
    model.label.clear()
    ```

#### 其他
* 如果调用了本身，可以使用 `models.ForeignKey('self', on_delete=models.CASCADE)`
* 如果单独的manytomany, 可以使用through获取那个隐藏的model
```
school.students.through.objects.filter(school=school)
```

### [ ] Field attribute reference
[官网](https://docs.djangoproject.com/en/3.1/ref/models/fields/#field-attribute-reference)

### [Field API reference](https://docs.djangoproject.com/en/3.1/ref/models/fields/#field-api-reference)


### Meta
[官网](https://docs.djangoproject.com/en/3.1/ref/models/options/)
```
class Meta:
    unique_together = ("user","date")   # 同一个用户同一个时间只允许一次(比如投票)
如果不符合，会报错  django.db.utils.IntegrityError
    ordering = "-id"  # 指定默认排序方式
    db_table = "table"  # 指定表的名称
    abstract = True # 表不进行创建，只用来继承
    proxy = True  # 用来给已有的表添加其他功能
    verbose_name = '显示名字'
    verbose_name_plural = '显示名字'
```
#### [API](https://docs.djangoproject.com/en/3.1/ref/models/meta/)
* `get_field`
获取某个Field
```
>>> User._meta.get_field("username")
<django.db.models.fields.CharField: username>
```
* `get_fields(include_parents=True, include_hidden=False`
```
User._meta.get_fields()
(
    <ManyToOneRel: admin.logentry>,
    <django.db.models.fields.AutoField: id>,
    ...
)
```

### [Instance methods 实例方法][method]
#### Refreshing objects from database
```
obj = MyModel.objects.first()
del obj.field
obj.field  # loads the only field from database 会重载这个field, 不会重载其他的field
obj.refresh_from_db()  # reload all the fields
```

#### [save][save]
save的时候，会把model的所有数据全量更新一遍，所以两个线程来了，只会save最后一个的数据
* 主键有就是update，主键没有就是insert
* [save的时候发生了什么](https://docs.djangoproject.com/en/3.1/ref/models/instances/#what-happens-when-you-save)
    ```
    django.db.models.Model
        def save(self, force_insert=False, force_update=False, using=None, update_fields=None):
            # 保证所有的外键field都有PK
            for field in self._meta.concrete_fields:
               [ ] 待研究 
            [ ] 待研究
            self.save_base(using=using, force_insert=force_insert,
                           force_update=force_update, update_fields=update_fields)
        def save_base(self, raw=False, force_insert=False,
                      force_update=False, using=None, update_fields=None):
            [ ] 待研究
            if not meta.auto_created:
                pre_save.send(
                    sender=origin, instance=self, raw=raw, using=using,
                    update_fields=update_fields
                )
            # with transaction.atomic(using=using, savepoint=False):
            #     if not raw:
            #         self._save_parents(cls, using, update_fields)
            #         updated = self._save_table(raw, cls, force_insert, force_update, using, update_fields)
            context_manager = ...
            with context_manager:
                updated = self._save_table(
                )
            if not meta.auto_created:
                post_save.send(
                    sender=origin, instance=self, created=(not updated),
                    update_fields=update_fields, raw=raw, using=using,)
        def _save_table(self, raw=False, force_insert=False,
                        force_update=False, using=None, update_fields=None):
            meta = cls._meta
            non_pks = [f for f in meta.local_concrete_fields if not f.primary_key]
            [ ] 待研究
            if not updated:
                result = self._do_insert(cls._base_manager, using, fields, update_pk, raw)
            [ ] 待研究
        @property
        def _base_manager(cls):
            return cls._meta.base_manager
        def _do_insert(self, manager, using, fields, update_pk, raw):
            return manager._insert([self], fields=fields, return_id=update_pk,
                                   using=using, raw=raw)
    django.db.models.
    ```
    1. 触发model的pre—save信号
    2. 处理数据，每个field触发`pre_save`，比如`auto_now_add`和`auto_now`
    3. 处理给数据库的数据，每个field触发`get_db_prep_save`
    4. 插入数据
    5. 触发post-save信号
* django怎么区分update和insert
* 指定更新哪些field: `product.save(update_fields=["name"])`
    * 更新后，并不会触发`refresh_from_db`
* 如果是queryset的update操作，不会触发自定义的save方法。比如save的时候计算总分，如果update某个分数，总分并不会自动更新 `python3 manage.py test testapp.test_queries.TestMethodTestCase`

#### to be continued
* [ ] creating objects 创建数据
* [ ] validating objects 数据校验
* [ ] deleting objects 删除数据
* [ ] pickling objects 序列化数据
* [ ] other instance methods 其他方法
* [ ] extra instance methods 额外方法
* [ ] other attributes 其他属性

[models]: https://docs.djangoproject.com/en/3.1/topics/db/models/
[options]: http://ramwin.com:8888/ref/models/fields.html#field-options
[unique-fields-allow-null]: https://stackoverflow.com/questions/454436/unique-fields-that-allow-nulls-in-django
[method]: https://docs.djangoproject.com/en/3.1/ref/models/instances/
[save]: https://docs.djangoproject.com/en/3.1/ref/models/instances/#django.db.models.Model.save
[slugfield]: https://docs.djangoproject.com/en/2.2/ref/models/fields/#slugfield
[relation]: https://docs.djangoproject.com/en/3.1/ref/models/fields/#module-django.db.models.fields.related
[onetoone]: https://docs.djangoproject.com/en/3.1/ref/models/fields/#onetoonefield
